-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Tool to create Lua tables representing the Code12 API (methods, param types, etc.)
-- based on the "API Summary.txt" file.
--
-- Copyright (c) 2018-2019 Code12
-----------------------------------------------------------------------------------------


-- Code12 modules
package.path = package.path .. ';../Code12/?.lua'
local source = require( "source" )
local javaTypes = require( "javaTypes" )
local javalex = require( "javalex" )
local parseJava = require( "parseJava" )
local err = require( "err" )


-- Input and output files
local apiSummaryFile = "../../Doc/API Summary.txt"
local apiTablesFile = "../Code12/apiTables.lua"
local outFile           -- output Lua file

-- Data structures used
local parseTrees   -- array of parse trees
local classes      -- api information for all classes found


-- Parse the input file and build the parseTrees
local function parseFile()
	err.initProgram()
	parseTrees = {}
	for lineNum = 1, #source.strLines do
		local lineRec = { iLine = lineNum, str = source.strLines[lineNum] }
		source.lines[lineNum] = lineRec
		local tree = parseJava.parseLine( lineRec )
		if tree == nil then
			error( "*** Error error on line " .. lineNum )
		end
		parseTrees[lineNum] = tree
	end
	return true
end

-- Make the Lua output file from the parseTrees. Return true if successful.
local function buildTables()
	-- Init the table state for the classes
	classes = {}
	local class = nil

	-- Process all the Code12 main functions
	for i = 1, #parseTrees do
		local tree = parseTrees[i]
		local p = tree.p
		local nodes = tree.nodes
		if p == "class" then
			-- Begin a new class table
			local name = nodes[3].str
			if name == "CT" then
				name = "ct"
			elseif name == "MATH" then
				name = "Math"
			end
			classes[#classes + 1] = { name = name, fields = {}, methods = {} }
			class = classes[#classes]
		elseif p == "func" then
			-- Get the method name and return type
			if nodes[3].tt ~= "ID" then
				print( "*** Invalid function on line ", i )
				return false
			end
			local methodName = nodes[3].str
			local retType = nodes[2]
			local vtReturn
			if retType.p == "void" then
				vtReturn = false
			else
				vtReturn = javaTypes.vtFromType( retType.nodes[1] )
			end

			-- Build the parameter table
			local paramTable = {}
			local paramList = nodes[5]
			if paramList then
				local params = paramList.nodes
				for j = 1, #params do
					local param = params[j]
					if param.p == "array" then
						local vtParam = javaTypes.vtFromVarType( param.nodes[1], true )
						paramTable[#paramTable + 1] = { name = param.nodes[4].str, vt = vtParam }
					else
						local typeNode = param.nodes[1]
						local vtParam
						if typeNode.str == "Object" then
							vtParam = nil
						else
							vtParam = javaTypes.vtFromVarType( typeNode )
						end
						paramTable[#paramTable + 1] = { name = param.nodes[2].str, vt = vtParam }
					end
				end
			end

			-- Add the method record
			class.methods[#class.methods + 1] = { name = methodName, vt = vtReturn, params = paramTable }
		elseif p == "varDecl" then
			-- Add field record(s)
			local vt = javaTypes.vtFromVarType( tree.nodes[2] )
			local idList = nodes[3].nodes
			for j = 1, #idList do
				local idNode = idList[j]
				class.fields[#class.fields + 1] = { name = idNode.str, vt = vt }
			end
		end
	end
	return true
end

-- Make a Lua source string to print from a vt value
local function vtStr( vt )
	if vt == 0 then
		return "0"
	elseif vt == 1 then
		return "1"
	elseif vt == false then
		return "false"
	elseif vt == true then
		return "true"
	elseif type(vt) == "string" then
		return "\"" .. vt .. "\""
	elseif type(vt) == "table" then
		return "{ vt = " .. vtStr( vt.vt ) .. " }"
	else
		return "nil"  -- might be "Object"
	end
end

-- Remove duplicate methods and mark them as overloaded as necessary.
-- Also mark variadic functions.
local function fixOverloads()
	for iClass = 1, #classes do
		local class = classes[iClass]

		local prevMethod = nil
		local i = 1
		while i <= #class.methods do
			local method = class.methods[i]

			-- The special functions ct.log and ct.logm are variadic.
			if class.name == "ct" then
				if method.name == "log" or method.name == "logm" then 
					print( string.format( "ct.%s is variadic", method.name ) )
					method.variadic = true
				end
			end

			-- Does this method have the same name as the previous one?
			if prevMethod and method.name == prevMethod.name then

				-- Keep the one with more parameters, and set the min field
				if #method.params > #prevMethod.params then
					-- This one has more
					local min = prevMethod.min or #prevMethod.params
					method.min = min
					table.remove( class.methods, i - 1 )  -- remove previous one
					prevMethod = method
				elseif #method.params < #prevMethod.params then
					-- Previous one had more
					prevMethod.min = #method.params
					table.remove( class.methods, i  )  -- remove this one
				else
					-- They have the same number. 
					-- This should only happen for Math.abs, Math.min, and Math.max,
					-- which have int and double versions.
					-- Mark as overloaded, print warning, and delete this one
					print( string.format( "%s.%s is overloaded", class.name, method.name ) )
					prevMethod.overloaded = true
					table.remove( class.methods, i  )  -- remove this one
				end
			else
				i = i + 1
				prevMethod = method
			end
		end
	end
end

-- Return a string hash tag link to the Code12 documentation for the
-- given method name of the given class name, or nil if none.
local function docLinkForMethod( className, methodName )
	if className == "ct" then   
		-- e.g. "API.html#ct.circle" for API ct.circle
		return "API.html#ct." .. string.lower( methodName )
	elseif className == "GameObj" then   
		-- e.g. "API.html#obj.gettext" for method GameObj.getText
		return "API.html#obj." .. string.lower( methodName )
	elseif className == "Code12Program" then
		-- e.g. "API.html#clickable" for field GameObj.clickable
		return "API.html#" .. string.lower( methodName )
	elseif className == "Math" then
		return "API.html#java-math-class-methods-and-fields-supported"
	elseif className == "String" then
		return "API.html#java-string-class-methods-supported"
	end
	return nil
end

-- Make the Lua output file from the parseTrees. Return true if successful.
local function makeLuaFile()
	-- Open the output file
	outFile = io.open( apiTablesFile, "w" )
	if not outFile then
		print( "*** Cannot open output file " .. apiTablesFile )
		return false
	end

	-- Begin the output file 
	outFile:write( "-- Code12 API tables\n" )
	outFile:write( "-- *** DO NOT EDIT *** This file is generated by the Make API tool.\n\n" )
	outFile:write( "return {\n")

	-- Write each class
	for iClass = 1, #classes do
		local class = classes[iClass]

		-- Write class header also lowercase version if different
		local classNameLower = string.lower( class.name )
		if classNameLower ~= class.name then
			outFile:write( "\n[\"" .. classNameLower .. "\"] = \"" .. class.name .. "\",\n" )
		end
		outFile:write( "\n[\"" .. class.name .. "\"] = {\n    name = \"" .. class.name .. "\",\n" )

		-- Write the fields
		outFile:write( "    fields = {\n")
		for i = 1, #class.fields do
			local field = class.fields[i]

			-- Field entry with vt
			outFile:write( "        [\"" .. field.name .. "\"] = { vt = " .. vtStr(field.vt) .. " },\n" )

			-- Lowercase mapping if needed
			local nameLower = string.lower( field.name )
			if nameLower ~= field.name then
				outFile:write( "        [\"" .. nameLower .. "\"] = \"" .. field.name .. "\",\n" )
			end

		end
		outFile:write( "    },\n" )

		-- Write the methods
		outFile:write( "    methods = {\n")
		for i = 1, #class.methods do
			local method = class.methods[i]

			-- Method, vt, min, overloaded
			outFile:write( "        [\"" .. method.name .. "\"] = { vt = " .. vtStr(method.vt) ..", " )
			if method.min then
				outFile:write( "min = " .. method.min .. ", " )
			end
			if method.variadic then
				outFile:write( "variadic = true, " )
			end
			if method.overloaded then
				outFile:write( "overloaded = true, " )
			end

			-- Write this method's parameters
			outFile:write( "params = {")
			for j = 1, #method.params do
				local param = method.params[j]

				outFile:write( "{ name = \"" .. param.name .. "\", vt = " .. vtStr(param.vt) .. "}")
				if j < #method.params then
					outFile:write( "," )
				end
			end
			outFile:write( "}" )

			-- Write the documentation link if any
			local link = docLinkForMethod( class.name, method.name )
			if link then
				outFile:write( ', docLink = "' .. link .. '"' )
			end

			-- End the method
			outFile:write( " },\n" )

			-- Lowercase mapping if needed
			local nameLower = string.lower( method.name )
			if nameLower ~= method.name then
				outFile:write( "        [\"" .. nameLower .. "\"] = \"" .. method.name .. "\",\n" )
			end
		end
		outFile:write( "    }\n" )  -- end of the method list
		outFile:write( "},\n" )     -- end of the class
	end
	outFile:write( "\n}\n" )     -- end of the master table

	-- Close output file
	io.close( outFile )
	return true
end

-- Run the test app
local function runApp()
	-- Process the test file
	print("")   -- Make console output easier to see
	if source.readFile( apiSummaryFile ) then
		if parseFile() then
			buildTables()
			fixOverloads()
			makeLuaFile()
			print( "Lua file created successfully" )
		else
			print( "*** Error parsing file" )
		end
	else
		print( "*** Could not read input file")
	end
	print("")
end

-- Run the app then quit
runApp()
native.requestExit()




