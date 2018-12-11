class ErrorQuestions
{
	// Generate error for not supporting variadic methods?
	// void variadicMethod(int... args)
	// {
	// }
	
	// Java allows empty array init?
	int[] arrEmptyInit = { };

	int funcMissingReturn5()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = true;
		if (boolVar1)
			return r;
		else if (boolVar2)
			ct.println();
		else
			ct.println();
		// ? error not generated
		// ERROR "Function is missing a return statement"
	}

	int funcPathMissingReturn4Brackets()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = false;
		if (boolVar1)
		{
			return r;
		}
		else if (boolVar2)
		{
			ct.println();
			// ? error not generated
			// ERROR "path is missing a return statement"
		}
	}

	int funcPathMissingReturn4()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = false;
		if (boolVar1)
			return r;
		else if (boolVar2)
			// ? error not generated
			// ERROR "path is missing a return statement"
			ct.println();
	}

	public void start()
	{
		// Should "~" generate "operator is not supported" error instead of
		// "~" was unexpected here?
		ct.println(~2);

		// Support "." after function call that returns a String or GameObj?
		GameObj rect = ct.rect(50, 50, 10, 10);
		boolean boolVar = rect.getText().equals("");

		// Should this generate error "Syntax Error: a name was unexpected here" ?
		Boolean boolVar = rect.getText().equals("");
	}

	// ? error not generated
	// ERROR "The main function must be declared as" public static
	public void main(String[] args)
	{
		Code12.run(new ErrorQuestions());
	}
}