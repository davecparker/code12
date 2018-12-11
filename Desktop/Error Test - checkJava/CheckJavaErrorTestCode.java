class CheckJavaErrorTestCode
{
	int classLevelInt = 0;
	double classLevelDouble = 0;
	boolean classLevelBoolean = false;
	String classLevelString = "";
	GameObj classLevelGameObj;
	int[] classLevelIntArr = new int[10];
	GameObj classLevelUnassignedVar;
	// ERROR "API functions cannot be called before start()"
	GameObj varFromCtCallBeforeStart = ct.rect(0, 0, 10, 10);
	// ERROR "User-defined functions cannot be called before start()"
	GameObj intVarFromUserMethod = intMethod();

	void syntaxLevelDependentTests()
	{
		String strVar = "";
		GameObj gameObjVar = ct.circle(0, 0, 1);
		// if syntaxLevel is 7-12: 
		// ERROR "Use str1.equals( str2 ) to compare two String values"
		if ("" != strVar)
			voidMethod();
		// ERROR "Use str1.equals( str2 ) to compare two String values"
		ct.println(gameObjVar.group == "circles");
	}

	int intMethod()
	{
		return 0;
	}
	void voidMethod()
	{
		int voidMethodVar;
		return;
	}
	void voidMethodWithParams(int p1, double p2, boolean p3, String p4, GameObj p5)
	{
	}

	GameObj noErrorsMethod()
	{
		System.out.println("Hello world");
		classLevelGameObj = ct.rect(0, 0, 10, 10);
		GameObj returnValue = null;
		boolean boolVar = false;
		int[] intArrayInitWithExpressions = { 1 + 2, 3 * 4 + 50, (67 - 890) + 3 };
		GameObj[] gObjArrayInitWithCTCalls = { ct.rect(50, 50, 10, 10), ct.text("text", 50, 50, 10) };
		double[] dblArrayInitWithExpressionsAndIntPromotion = { 1 + 2, 3.4 * 7 / 2 };

		for (;boolVar;)
		{
			ct.println();
			if (boolVar)
				ct.println();
			else
				break;
			ct.println();
		}
		while (boolVar)
		{
			if (boolVar)
				break;
			ct.println();
		}
		do
		{
			ct.println();
			if (boolVar)
				break;
		}
		while (boolVar);
		// Leave at end of method to test each path having a return with no return following
		for (;boolVar;)
		{
			if (boolVar)
				return returnValue;
		}
		if (classLevelBoolean)
		{
			return returnValue;
		}
		else if (boolVar)
		{
			return returnValue;
		}
		else
		{
			return returnValue;
		}
	}
	// void syntaxLevelDependentTests()
	// ERROR "parameter names should start with a lower-case letter"
	public void onMousePress( GameObj obj, double x, double Yvalue )
	{
	}
	// ERROR "parameter names should start with a lower-case letter"
	void parameterStartsWithCapitalMethod( double doubleParam, int IntParam, boolean boolParam )
	{
		int userFunc1Var = 1;
	}
	// ERROR "function names should start with a lower-case letter"
	void StartsWithCapitalLetterMethod()
	{
	}
	void testErrors3()
	{
		int intVar = 0;
		boolean boolVar = false;
		// ERROR "variable names should start with a lower-case letter"
		int Starts_with_capital_letter_var;
		// ERROR "variable names should start with a lower-case letter"
		double StartsWithCapitalLetterVarWithAssignment = 3.14;
		// ERROR "variable names should start with a lower-case letter"
		GameObj[] GameObjArrVar = new GameObj[10];
		// ERROR "Names are case-sensitive, known name is"
		double dblVar = intvar + 1;
		// ERROR "Names are case-sensitive, known name is"
		ct.println(boolvar);
		// ERROR "Names are case-sensitive, known name is"
		voidmethod();
		// ERROR "Names are case-sensitive, known name is"
		ct.PrintLn();
		// ERROR "already defined"
		int classLevelGameObj;
		// ERROR "already defined"
		int intVar;
		// ERROR "already defined"
		boolean boolVar;
		// ERROR "differs only by upper/lower case from existing variable"
		GameObj classlevelInt;
		// ERROR "differs only by upper/lower case from existing variable"
		boolean boolvar = true;
		if (boolVar)
		{
			int prevBlockVar;
		}
		// ERROR "Undefined variable (previous variable"
		prevBlockVar = 2e2;
		// ERROR "Undefined variable (previous variable"
		ct.println(voidMethodVar + 1);
		// ERROR "Undefined variable (previous similar variable"
		prevBlockvar = 1.1;
		// ERROR "must be declared with a type before being assigned"
		undeclaredVar = 0;
		// ERROR "Undefined variable"
		classLevelGameObj.setText(undeclaredVar);
		// ERROR "must be assigned before it is used"
		ct.print(classLevelUnassignedVar);
		int unassignedVar;
		// ERROR "must be assigned before it is used"
		ct.print(unassignedVar);
	}
	// ERROR "Return type" (for Code12 events)
	public boolean onMousePress( GameObj obj, double x, double y )
	{
		return classLevelBoolean;
	}
	// ERROR "Wrong number of parameters" (for Code12 events)
	public void onMouseDrag( GameObj obj, double x, double y, double z )
	{
	}
	// ERROR "Wrong type for parameter 3"
	public void onMouseRelease( GameObj obj, double x, int y )
	{
	}
	// ERROR "function must be declared starting with" public
	void onKeyPress( String keyName )
	{
	}
	// ERROR "function must be declared starting with" public
	private void onKeyRelease( String keyName )
	{
	}

	// ERROR "function should not be declared static"
	public static void onCharTyped( String charString )
	{
	}
	public void onResize()
	{
	}
	// ERROR "function was already defined"
	public void onResize()
	{
	}
	void existingUserFunction()
	{
	}
	// ERROR "already defined"
	void existingUserFunction()
	{
	}
	// ERROR "differs only by upper/lower case from existing function"
	void existingUserfunction()
	{
	}
	void testErrors2()
	{
		int intVar = 0;
		double dblVar = 0;
		boolean boolVar = false;
		String strVar = "";
		GameObj rect = ct.rect(50, 50, 10, 10);
		GameObj circle = ct.circle(50, 50, 10);
		GameObj text = ct.text("text", 50, 50, 10);
		GameObj image = ct.image("bogusFileName.png", 50, 50, 10);
		int[] intArr = new int[10];
		double[] dblArr = new double[10];
		boolean[] boolArr = new boolean[10];
		String[] strArr = new String[10];
		GameObj[] objArr = new GameObj[10];
		// ERROR "double cannot be assigned to an int"
		intVar = dblVar;
		// ERROR "double cannot be assigned to a String"
		strVar = dblVar;
		// ERROR "Integer value cannot be assigned to a String"
		strVar = intVar;
		// ERROR "String cannot be assigned to a double"
		dblVar = strVar;
		// ERROR "String cannot be assigned to an int"
		intVar = strVar;
		// ERROR "cannot be assigned to type"
		dblVar = rect;
		// ERROR "can only be applied to an array"
		rect[0].x = dblVar;
		// ERROR "can only be applied to an array"
		intVar[0]++;
		// ERROR "index must be an integer"
		strArr[intVar * 1.0] = strVar;
		// ERROR "index must be an integer"
		objArr[dblVar] = rect;
		// ERROR "Arrays can only access" .length field
		intArr = new int[intArr.foo * 2];
		// ERROR "no data fields"
		ct.print(intVar.x);
		// ERROR "function as a variable"
		rect.setText = strVar;
		// ERROR "Unknown field"
		dblVar = rect.foo;
		// ERROR "Unknown field"
		rect.foo = 0;
		// ERROR "Calling main program or event functions directly is not allowed"
		onMousePress( rect, rect.x, rect.y );
		// ERROR "Unknown function, the Code12 function name is"
		GameObj line = line(50, 50, 10, 10);
		// ERROR "Unknown function, the Code12 function name is"
		println();
		// ERROR "Undefined function"
		undefinedFunc();
		// ERROR "Unknown or misspelled function"
		rect = ct.rec(0, 0, 1, 1);
		// ERROR "Unknown or misspelled function"
		ct.printLine();
		// ERROR "Unknown function"
		ct.foo();
		// ERROR "supported System functions are"
		System.foo.bar();
		// ERROR "supported System functions are"
		System.err.println("File opening failed:");
		// ERROR "Unknown or unsupported Math method"
		double stdev = Math.foo(doubleVar);
		// ERROR "Unknown or misspelled method"
		rect.getWidht(dblVar);
		// ERROR "Unknown or misspelled method"
		strVar.equal(classLevelString);
		// ERROR "Unknown method"
		rect.foo();		
		// ERROR "Unknown method"
		rect.group.concat(text.getText());
		// ERROR "Unknown method"
		classLevelString.setSize(intVar, dblVar);
		// ERROR "Unknown method"
		strVar.size();
		// ERROR "Method call on invalid type"
		objArr.delete();
		// ERROR "Method call on invalid type"
		intVar.delete();
		// ERROR "requires 1 parameter"
		ct.print();
		// ERROR "requires 2 parameters"
		if ( Math.min(1) < 0 )
			voidMethod();
		// ERROR "requires 5 parameters"
		voidMethodWithParams();
		// ERROR "Too many parameters passed"
		if ( Math.min(1, 2, 3) < 0 )
			voidMethod();
		// ERROR "Too many parameters passed"
		double minOf3 = Math.min(1, 2, 3);
		// ERROR "Too many parameters passed"
		voidMethod(1);
		// ERROR "Too many parameters passed"
		ct.println("hello", "world");
		// ERROR "expects type"
		ct.println( ct.distance(ct.round(rect.x), rect.y, circle, circle.y) );
		// ERROR "expects type"
		dblVar = Math.max(intVar, strVar);
		voidMethodWithParams(intVar, intVar, boolVar, strVar, rect);
		// ERROR "expects type"
		voidMethodWithParams(intVar, dblVar, boolVar, strVar, intVar);
		// ERROR "expects type"
		voidMethodWithParams(intVar, dblVar, strVar, strVar, rect);
		// ERROR "expects type"
		voidMethodWithParams(intVar, boolVar, boolVar, strVar, rect);
		// ERROR "expects type"
		voidMethodWithParams(dblVar, dblVar, boolVar, strVar, rect);
		// ERROR "Loop test must evaluate to a boolean"
		for (;intVar;)
			ct.println();
		do
			ct.println();
		// ERROR "Loop test must evaluate to a boolean"
		while ( (1 + 1.0 == 2e0) + "");
		// ERROR "Loop test must evaluate to a boolean"
		while (boolVar + "")
			// ERROR "can only be applied to numbers"
			rect.group += 1;		
		// ERROR "can only be applied to numbers"
		boolVar += false;
		// ERROR "must be numeric"
		dblVar *= rect;
		// ERROR "must be numeric"
		dblVar += boolVar + "";
		// ERROR "must be numeric"
		intVar += boolVar;
		// ERROR "double cannot be assigned to int"
		intVar /= classLevelInt * rect.x;
		// ERROR "double cannot be assigned to int"
		intVar *= 1e0;
		// ERROR "double cannot be assigned to int"
		classLevelInt -= classLevelDouble;
		// ERROR "double cannot be assigned to int"
		intVar += 1.0;
		// ERROR "test must be boolean"
		if (dblVar)
			ct.println();
		// ERROR "test must be boolean"
		else if (intVar)
			ct.println();
		// ERROR "test must be boolean"
		if (0)
			ct.println();
		// ERROR "must operate on an array"
		for (int x : null)
			break;
		// ERROR "must operate on an array"
		for (int x : image)
			break;
		// ERROR "must operate on an array"
		for (int x : intVar)
			break;
		// ERROR "loop array contains elements of type"
		for (GameObj x : classLevelIntArr)
			break;
		// ERROR "loop array contains elements of type"
		for (boolean x : new String[10])
			break;
		// ERROR "loop array contains elements of type"
		for (int x : dblArr)
			break;
	}
	void voidFuncReturnsValue6()
	{
		GameObj r = ct.circle(0, 0, 1);
		while (classLevelBoolean)
			if (classLevelBoolean)
				// ERROR "cannot return a value"
				return r;
		// ERROR "cannot return a value"
		return r;
	}
	void voidFuncReturnsValue5()
	{
		GameObj r = null;
		for (;classLevelBoolean;)
			// ERROR "cannot return a value"
			return r;
		// ERROR "cannot return a value"
		return r;
	}
	void voidFuncReturnsValue4()
	{
		String r = null;
		if (classLevelBoolean)
			// ERROR "cannot return a value"
			return r;
		// ERROR "cannot return a value"
		return r;
	}
	void voidFuncReturnsValue3()
	{
		String r = "";
		if (classLevelBoolean)
			// ERROR "cannot return a value"
			return r;
		// ERROR "cannot return a value"
		return r;
	}
	void voidFuncReturnsValue2()
	{
		boolean r = false;
		if (classLevelBoolean)
			// ERROR "cannot return a value"
			return r;
		// ERROR "cannot return a value"
		return r;
	}
	void voidFuncReturnsValue1()
	{
		double r = 0;
		// ERROR "cannot return a value"
		return r;
	}
	int funcWrongReturnValueType7()
	{
		// ERROR "Incorrect return value type"
		return classLevelInt * 1.0;
	}
	int funcWrongReturnValueType6()
	{
		GameObj r = ct.circle(0, 0, 1);
		while (classLevelBoolean)
			if (classLevelBoolean)
				// ERROR "Incorrect return value type"
				return r;
		// ERROR "Incorrect return value type"
		return r;
	}
	String funcWrongReturnValueType5()
	{
		GameObj r = null;
		for (;classLevelBoolean;)
			// ERROR "Incorrect return value type"
			return r;
		// ERROR "Incorrect return value type"
		return r;
	}
	GameObj funcWrongReturnValueType4()
	{
		String r = null;
		if (classLevelBoolean)
			// ERROR "Incorrect return value type"
			return r;
		// ERROR "Incorrect return value type"
		return r;
	}
	boolean funcWrongReturnValueType3()
	{
		String r = "";
		if (classLevelBoolean)
			// ERROR "Incorrect return value type"
			return r;
		// ERROR "Incorrect return value type"
		return r;
	}
	double funcWrongReturnValueType2()
	{
		boolean r = false;
		if (classLevelBoolean)
			// ERROR "Incorrect return value type"
			return r;
		// ERROR "Incorrect return value type"
		return r;
	}
	int funcWrongReturnValueType1()
	{
		double r = 0;
		// ERROR "Incorrect return value type"
		return r;
	}
	int funcNoReturnValue6()
	{
		int r = 0;
		while (classLevelBoolean)
			if (classLevelBoolean)
				// ERROR "requires a return value"
				return;
		return r;
	}
	int funcNoReturnValue5()
	{
		int r = 0;
		for (;classLevelBoolean;)
			// ERROR "requires a return value"
			return;
		return r;
	}
	int funcNoReturnValue4()
	{
		int r = 0;
		if (classLevelBoolean)
			// ERROR "requires a return value"
			return;
		// ERROR "requires a return value"
		return;
	}
	int funcNoReturnValue3()
	{
		int r = 0;
		if (classLevelBoolean)
			// ERROR "requires a return value"
			return;
		return r;
	}
	int funcNoReturnValue2()
	{
		int r = 0;
		if (classLevelBoolean)
			return r;
		// ERROR "requires a return value"
		return;
	}
	int funcNoReturnValue1()
	{
		// ERROR "requires a return value"
		return;
	}
	void funcBreakStmtErrors()
	{
		if (classLevelBoolean)
		{
			// ERROR "only allowed inside loops"
			break;
		}
		else if (classLevelBoolean)
			// ERROR "only allowed inside loops"
			break;
		else
			// ERROR "only allowed inside loops"
			break;
		// ERROR "only allowed inside loops"
		break;
	}
	int funcUnreachableStmt8()
	{
		int r = 0;
		if (classLevelBoolean)
		{
			if (classLevelBoolean)
			{
				ct.println();
			}
			else if (1 + 1 == 3)
			{
				return r;
				// ERROR "statement is unreachable"
				ct.println();
			}
		}
		return r;
	}
	int funcUnreachableStmt7()
	{
		int r = 0;
		while (classLevelBoolean)
		{
			return r;
			// ERROR "statement is unreachable"
			ct.println();
		}
		return r;
	}
	int funcUnreachableStmt6()
	{
		int r = 0;
		if (classLevelBoolean)
		{
			ct.println();
		}
		else if (1 + 1 == 3)
		{
			return r;
			// ERROR "statement is unreachable"
			ct.println();
		}
		return r;
	}
	int funcUnreachableStmt5()
	{
		int r = 0;
		if (classLevelBoolean)
		{
			ct.println();
		}
		else
		{
			return r;
			// ERROR "statement is unreachable"
			ct.println();
		}
		return r;
	}
	int funcUnreachableStmt4()
	{
		int r = 0;
		if (classLevelBoolean)
		{
			return r;
			// ERROR "statement is unreachable"
			if (1 + 1 == 2)
				ct.println();
		}
		return r;
	}
	int funcUnreachableStmt3()
	{
		int r = 0;
		return r;
		// ERROR "statement is unreachable"
		for (;classLevelBoolean;)
			break;
		ct.println();
		return r;
	}
	int funcUnreachableStmt2()
	{
		int r = 0;
		return r;
		// ERROR "statement is unreachable"
		if (classLevelBoolean)
			ct.println();
		ct.println();
		return r;
	}
	void funcUnreachableStmt1()
	{
		return;
		// ERROR "statement is unreachable"
		ct.println();
		ct.println();
	}
	int funcMissingReturn10()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = false;
		if (boolVar1)
			if (boolVar1)
				ct.println();
			else if (boolVar2)
				return r;
			else
				return r;
		// ERROR "Function is missing a return statement"
	}
	int funcMissingReturn9()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = false;
		if (boolVar1)
			if (boolVar2)
				return r;
			else
				ct.println();
		// ERROR "Function is missing a return statement"
	}
	int funcMissingReturn8()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = false;
		if (boolVar1)
			if (boolVar2)
				return r;
			else
				return r;
		// ERROR "Function is missing a return statement"
	}
	int funcMissingReturn7()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = true;
		if (boolVar1)
			ct.println();
		else if (boolVar2)
			ct.println();
		else
			return r;
		// ERROR "Function is missing a return statement"
	}
	int funcMissingReturn6()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = true;
		if (boolVar1)
			ct.println();
		else if (boolVar2)
			return r;
		else
			ct.println();
		// ERROR "Function is missing a return statement"
	}

	int funcMissingReturn4()
	{
		boolean boolVar = false;
		if (boolVar)
			ct.println();
		else
			ct.println();
		// ERROR "Function is missing a return statement"
	}
	int funcMissingReturn2()
	{
		int r = 0;
		boolean boolVar = false;
		if (boolVar)
			return r;
		// ERROR "Function is missing a return statement"
	}
	int funcMissingReturn1()
	{
		// ERROR "Function is missing a return statement"
	}
	int funcPathMissingReturn3Brackets()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = false;
		if (boolVar1)
		{
			ct.println();
			// ERROR "path is missing a return statement"
		}
		else if (boolVar2)
		{
			return r;
		}
	}
	int funcPathMissingReturn2Brackets()
	{
		int r = 0;
		boolean boolVar = false;
		if (boolVar)
		{
			return r;
		}
		else
		{
			ct.println();
			// ERROR "path is missing a return statement"
		}
	}
	int funcPathMissingReturn1Brackets()
	{
		int r = 0;
		boolean boolVar = false;
		if (boolVar)
		{
			ct.println();
			// ERROR "path is missing a return statement"
		}
		else
		{
			return r;
		}
	}
	int funcPathMissingReturn10()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = false;
		if (boolVar1)
			if (boolVar1)
				return r;
			else if (boolVar2)
				return r;
			else
				// ERROR "path is missing a return statement"
				ct.println();
		else
			return r;
	}
	int funcPathMissingReturn9()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = false;
		if (boolVar1)
			if (boolVar1)
				return r;
			else if (boolVar2)
				// ERROR "path is missing a return statement"
				ct.println();
			else
				return r;
		else
			return r;
	}
	int funcPathMissingReturn8()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = false;
		if (boolVar1)
			if (boolVar1)
				// ERROR "path is missing a return statement"
				ct.println();
			else if (boolVar2)
				return r;
			else
				return r;
		else
			return r;
	}
	int funcPathMissingReturn7()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = false;
		if (boolVar1)
			// ERROR "path is missing a return statement"
			ct.println();
		else if (boolVar2)
			return r;
		else
			return r;
	}
	int funcPathMissingReturn6()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = false;
		if (boolVar1)
			return r;
		else if (boolVar2)
			// ERROR "path is missing a return statement"
			ct.println();
		else
			return r;
	}
	int funcPathMissingReturn5()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = false;
		if (boolVar1)
			return r;
		else if (boolVar2)
			return r;
		else
			// ERROR "path is missing a return statement"
			ct.println();
	}
	int funcPathMissingReturn3()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = false;
		if (boolVar1)
			// ERROR "path is missing a return statement"
			ct.println();
		else if (boolVar2)
			return r;
	}
	int funcPathMissingReturn2()
	{
		int r = 0;
		boolean boolVar = false;
		if (boolVar)
			return r;
		else
			// ERROR "path is missing a return statement"
			ct.println();
	}
	int funcPathMissingReturn1()
	{
		int r = 0;
		boolean boolVar = false;
		if (boolVar)
			// ERROR "path is missing a return statement"
			ct.println();
		else
			return r;
	}

	void testErrors1()
	{
		int intVar = 1;
		double dblVar = 1.2;
		boolean boolVar = false;
		String strVar = "";
		GameObj rect = ct.rect(50, 50, 10, 10);
		GameObj circle = ct.circle(50, 50, 10);
		GameObj text = ct.text("text", 50, 50, 10);
		GameObj image = ct.image("bogusFileName.png", 50, 50, 10);
		int[] intArr = new int[10];
		double[] dblArr = new double[10];
		boolean[] boolArr = new boolean[10];
		String[] strArr = new String[10];
		GameObj[] objArr = new GameObj[10];

		// ERROR "already of type int"
		circle.x = (int) intVar + 314;
		// ERROR "already of type int"
		circle.x = (int) (intVar + 314);
		// ERROR "(int) type cast can only be applied to type double"
		objArr = new GameObj[2 * (int) objArr];
		// ERROR "already of type double"
		dblVar = (double) (10 * 2.3);
		// ERROR "Type casts can only be (int) or (double)"
		rect.group = (String) circle.group;
		// ERROR "Unknown data field of Math class"
		dblVar = Math.P;

		// "The negate operator (-) can only apply to numbers"
		// ERROR "negate operator"
		rect.x = -rect;
		// ERROR "negate operator"
		strVar = -strVar;

		// "The not operator (!) can only apply to boolean values"
		// ERROR "not operator"
		boolVar = !intVar;

		// "Array count must be an integer"
		// ERROR "count must be an integer"
		objArr = new GameObj["ten"];
		// ERROR "count must be an integer"
		strArr = new String[intVar + dblVar];
		// ERROR "count must be an integer"
		boolArr = new boolean[intVar + dblVar];
		// ERROR "count must be an integer"
		dblArr = new double[dblVar];
		// ERROR "count must be an integer"
		intArr = new int[10.0];
		// "Code12 does not support making objects with new"
		// ERROR "objects with new"
		circle.group = new String();
		// ERROR "objects with new"
		rect.setText( new String() );
		// ERROR "objects with new"
		String[] newStringArr2 = { strVar, new String() };
		// ERROR "objects with new"
		String[] newStringArr = { new String() };
		// ERROR "objects with new"
		String newString = new String();
		// ERROR "objects with new"
		intVar = new Integer(1);
		// ERROR "objects with new"
		rect = new GameObj();

		// "Code12 does not support arrays of arrays"
		// ERROR "arrays of arrays"
		String[] arrInit9 = { new String[intVar] };
		// ERROR "arrays of arrays"
		GameObj[] arrInit8 = { rect, intArr, text };
		// ERROR "arrays of arrays"
		GameObj[] arrInit7 = { rect, image, objArr };

		// "Array initializers must all be the same type"
		// ERROR "all be the same type"
		GameObj[] arrInit6 = { ct.rect(50, 50, 10, 10), text, 0 };
		// ERROR "all be the same type"
		GameObj[] arrInit5 = { "circle", circle };
		// ERROR "all be the same type"
		String[] arrInit4 = { strVar + 1, intVar, intVar + 2 };
		// ERROR "all be the same type"
		boolean[] arrInit3 = { false, boolVar, null };
		// ERROR "all be the same type"
		double[] arrInit2 = { circle, 0.5 };
		// ERROR "all be the same type"
		int[] arrInit1 = { 1, "1" };
		

		// "The (+) operator cannot be applied to arrays"
		// ERROR "cannot be applied to arrays"
		ct.println(objArr + strVar);
		// ERROR "cannot be applied to arrays"
		ct.println(strArr + strVar);
		// ERROR "cannot be applied to arrays"
		ct.println(boolArr + strVar);
		// ERROR "cannot be applied to arrays"
		ct.println(strVar + dblArr);
		// ERROR "cannot be applied to arrays"
		ct.println(strVar + intArr);

		// "The (+) operator can only apply to numbers or Strings"
		// ERROR "can only apply to numbers or Strings"
		ct.println(intArr + dblVar);
		// ERROR "can only apply to numbers or Strings"
		ct.println(rect + dblVar);
		// ERROR "can only apply to numbers or Strings"
		ct.println(boolVar + dblVar);
		// ERROR "can only apply to numbers or Strings"
		ct.println(intArr + intVar);
		// ERROR "can only apply to numbers or Strings"
		ct.println(rect + intVar);
		// ERROR "can only apply to numbers or Strings"
		ct.println(boolVar + intVar);
		// ERROR "can only apply to numbers or Strings"
		ct.println(dblVar + intArr);
		// ERROR "can only apply to numbers or Strings"
		ct.println(dblVar + rect);
		// ERROR "can only apply to numbers or Strings"
		ct.println(dblVar + boolVar);
		// ERROR "can only apply to numbers or Strings"
		ct.println(intVar + intArr);
		// ERROR "can only apply to numbers or Strings"
		ct.println(intVar + rect);
		// ERROR "can only apply to numbers or Strings"
		ct.println(intVar + boolVar);
		// ERROR "can only apply to numbers or Strings"
		dblVar = 1 / (boolVar + intArr + 1);
		// ERROR "can only apply to numbers or Strings"
		strVar = boolVar + rect;
		// ERROR "can only apply to numbers or Strings"
		intVar = boolVar + dblVar / 2;
		// ERROR "can only apply to numbers or Strings"
		intVar = boolVar + intVar - 1;
		// ERROR "can only apply to numbers or Strings"
		boolVar = boolVar + boolVar;
		// ERROR "can only apply to numbers or Strings"
		rect.x = circle + text;
		// ERROR "can only apply to numbers or Strings"
		rect.width = 2 + rect;
		// ERROR "can only apply to numbers or Strings"
		ct.println(rect.x + false);

		// "Numeric operator (%strVar) can only apply to numbers"
		// ERROR "Numeric operator"
		dblVar = strVar - ".txt";
		// ERROR "Numeric operator"
		intVar = rect.group % text;
		// ERROR "Numeric operator"
		dblVar = circle / 10;
		// ERROR "Numeric operator"
		rect.width = rect * 2;
		// ERROR "Numeric operator"
		rect.x = 100 - rect;

		// "Integer divide may lose remainder. Use (double) or ct.intDiv()"
		// ERROR "Integer divide"
		int[] intArrayInitWithExpressions = { 1 + 2 / 1, (3 + 1) / 2 };
		// ERROR "Integer divide"
		boolVar = intVar / intVar == 1;
		// ERROR "Integer divide"
		dblVar = -10 / 3;
		// ERROR "Integer divide"
		dblVar = 10 / -3;
		// ERROR "Integer divide"
		intVar = 123 / 5;
		// ERROR "Integer divide"
		intVar = (1 + 2) / 3;
		// ERROR "Integer divide"
		intVar = 1 / (2 + 3);
		// ERROR "Integer divide"
		rect.x = intVar / 1;
		// ERROR "Integer divide"
		ct.println(1 + intVar / intVar);
		// ERROR "Integer divide"
		dblVar = 2 / intVar;
		// ERROR "Integer divide"
		intVar = intVar / 2;

		// "Logical operator (%strVar) can only apply to boolean values"
		// ERROR "Logical operator"
		circle = intVar || false;
		// ERROR "Logical operator"
		if (true && dblVar)
			voidMethod();
		// ERROR "Logical operator"
		else if (rect && true)
			voidMethod();
		// ERROR "Logical operator"
		while (intVar && boolVar)
			break;
		do
			break;
		// ERROR "Logical operator"
		while (dblVar || strVar);

		// "Inequality operator (%strVar) can only apply to numbers"
		// ERROR "Inequality operator"
		boolVar = circle < rect;
		// ERROR "Inequality operator"
		if (1 > false)
			voidMethod();
		// ERROR "Inequality operator"
		else if ("level" <= 10)
			voidMethod();
		// ERROR "Inequality operator"
		while ( 1 + 1 >= rect.visible )
			break;
		do
			break;
		// ERROR "Inequality operator"
		while (3.14 < text);

		// "Cannot compare %strVar to %strVar"
		// ERROR "Cannot compare"
		boolVar = boolVar == rect;
		// ERROR "Cannot compare"
		boolVar = rect != true;
		// ERROR "Cannot compare"
		boolVar = "3.14" == Math.PI;
		// ERROR "Cannot compare"
		for (;intVar != strVar;)
			voidMethod();
		// ERROR "Cannot compare"
		boolVar = strVar == true;
		// ERROR "Cannot compare"
		boolVar = "false" != false;
		do
			voidMethod();
		// ERROR "Cannot compare"
		while (1 == false);
		// ERROR "Cannot compare"
		while (boolVar != 0)
			voidMethod();
		// ERROR "Cannot compare"
		if (rect == 1)
			voidMethod();
		// ERROR "Cannot compare"
		else if (1 != circle)
			voidMethod();

		// "Use == to compare for equality (= is for assignment)"
		// ERROR "compare for equality"
		ct.println(circle = rect);
		// ERROR "compare for equality"
		while (boolVar = false)
			boolVar = true;
		// ERROR "compare for equality"
		if (rect.x = 100)
			rect.setSpeed(-1, 0);
		// ERROR "compare for equality"
		boolVar = (1 + 1 = 2);
		// ERROR "compare for equality"
		if (intVar = 1)
			ct.println("oops");

		// "%strVar does not return a value"
		// ERROR "does not return a value"
		ct.println(voidMethod());
		// ERROR "does not return a value"
		intVar = ct.println();

		// ERROR "operator is not supported"
		intVar = 2 | 1;
		// ERROR "operator is not supported"
		intVar = 2 ^ 1;
		// ERROR "operator is not supported"
		ct.println(2 & 1);
		// ERROR "operator is not supported"
		ct.println(2 >>> 1);
		// ERROR "operator is not supported"
		ct.println(2 >> 1);
		// ERROR "operator is not supported"
		ct.println(2 << 1);
	}

	public void start()
	{
	}
}