class CheckJavaErrorTestCode
{
	int classLevelInt = 0;
	double classLevelDouble = 0;
	boolean classLevelBoolean = false;
	String classLevelString = "";
	GameObj classLevelGameObj;

	void voidMethod()
	{
	}

	void noErrorsMethod()
	{
		int[] intArrayInitWithExpressions = { 1 + 2, 3 * 4 + 50, (67 - 890) + 3 };
		GameObj[] gObjArrayInitWithCTCalls = { ct.rect(50, 50, 10, 10), ct.text("text", 50, 50, 10) };
		double[] dblArrayInitWithExpressionsAndIntPromotion = { 1 + 2, 3.4 * 7 / 2 };
	}

	void testErrorsMethod()
	{
		int intVar = 1;
		double doubleVar = 1.2;
		boolean booleanVar = false;
		String stringVar = "";
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
		circle.x = (int) (intVar + 314);
		// ERROR "(int) type cast can only be applied"
		objArr = new GameObj[2 * (int) objArr];
		// ERROR "already of type double"
		doubleVar = (double) (10 * 2.3);
		// ERROR "Type casts can only be (int) or (double)"
		rect.group = (String) circle.group;
		// ERROR "Unknown data field of Math class"
		doubleVar = Math.P;

		// "The negate operator (-) can only apply to numbers"
		// ERROR "negate operator"
		rect.x = -rect;
		// ERROR "negate operator"
		stringVar = -stringVar;

		// "The not operator (!) can only apply to boolean values"
		// ERROR "not operator"
		booleanVar = !intVar;

		// "Array count must be an integer"
		// ERROR "count must be an integer"
		objArr = new GameObj["ten"];
		// ERROR "count must be an integer"
		strArr = new String[intVar + doubleVar];
		// ERROR "count must be an integer"
		boolArr = new boolean[intVar + doubleVar];
		// ERROR "count must be an integer"
		dblArr = new double[doubleVar];
		// ERROR "count must be an integer"
		intArr = new int[10.0];

		// // "Code12 does not support making objects with new"
		// // ERRO "making objects with new"
		// circle.group = new String();
		// // ERRO "making objects with new"
		// rect.setText( new String() );
		// // ERRO "making objects with new"
		// String[] newStringArr2 = { stringVar, new String() };
		// // ERRO "making objects with new"
		// String[] newStringArr = { new String() };
		// // ERRO "making objects with new"
		// String newString = new String();
		// // ERRO "making objects with new"
		// intVar = new Integer(1);
		// // ERRO "making objects with new"
		// rect = new GameObj();

		// "Array initializer cannot be empty"
		// ERRO "cannot be empty"
		// int[] arrInit10 = { };

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
		String[] arrInit4 = { stringVar + 1, intVar, intVar + 2 };
		// ERROR "all be the same type"
		boolean[] arrInit3 = { false, booleanVar, null };
		// ERROR "all be the same type"
		double[] arrInit2 = { circle, 0.5 };
		// ERROR "all be the same type"
		int[] arrInit1 = { 1, "1" };
		

		// "The (+) operator cannot be applied to arrays"
		// ERROR "cannot be applied to arrays"
		ct.println(objArr + stringVar);
		// ERROR "cannot be applied to arrays"
		ct.println(strArr + stringVar);
		// ERROR "cannot be applied to arrays"
		ct.println(boolArr + stringVar);
		// ERROR "cannot be applied to arrays"
		ct.println(stringVar + dblArr);
		// ERROR "cannot be applied to arrays"
		ct.println(stringVar + intArr);

		// "The (+) operator can only apply to numbers or Strings"
		// ERROR "can only apply to numbers or Strings"
		ct.println(intArr + doubleVar);
		// ERROR "can only apply to numbers or Strings"
		ct.println(rect + doubleVar);
		// ERROR "can only apply to numbers or Strings"
		ct.println(booleanVar + doubleVar);
		// ERROR "can only apply to numbers or Strings"
		ct.println(intArr + intVar);
		// ERROR "can only apply to numbers or Strings"
		ct.println(rect + intVar);
		// ERROR "can only apply to numbers or Strings"
		ct.println(booleanVar + intVar);
		// ERROR "can only apply to numbers or Strings"
		ct.println(doubleVar + intArr);
		// ERROR "can only apply to numbers or Strings"
		ct.println(doubleVar + rect);
		// ERROR "can only apply to numbers or Strings"
		ct.println(doubleVar + booleanVar);
		// ERROR "can only apply to numbers or Strings"
		ct.println(intVar + intArr);
		// ERROR "can only apply to numbers or Strings"
		ct.println(intVar + rect);
		// ERROR "can only apply to numbers or Strings"
		ct.println(intVar + booleanVar);
		// ERROR "can only apply to numbers or Strings"
		doubleVar = 1 / (booleanVar + intArr + 1);
		// ERROR "can only apply to numbers or Strings"
		stringVar = booleanVar + rect;
		// ERROR "can only apply to numbers or Strings"
		intVar = booleanVar + doubleVar / 2;
		// ERROR "can only apply to numbers or Strings"
		intVar = booleanVar + intVar - 1;
		// ERROR "can only apply to numbers or Strings"
		booleanVar = booleanVar + booleanVar;
		// ERROR "can only apply to numbers or Strings"
		rect.x = circle + text;
		// ERROR "can only apply to numbers or Strings"
		rect.width = 2 + rect;
		// ERROR "can only apply to numbers or Strings"
		ct.println(rect.x + false);

		// "Numeric operator (%stringVar) can only apply to numbers"
		// ERROR "Numeric operator"
		doubleVar = stringVar - ".txt";
		// ERROR "Numeric operator"
		intVar = rect.group % text;
		// ERROR "Numeric operator"
		doubleVar = circle / 10;
		// ERROR "Numeric operator"
		rect.width = rect * 2;
		// ERROR "Numeric operator"
		rect.x = 100 - rect;

		// "Integer divide may lose remainder. Use (double) or ct.intDiv()"
		// ERROR "Integer divide"
		int[] intArrayInitWithExpressions = { 1 + 2 / 1, (3 + 1) / 2 };
		// ERROR "Integer divide"
		booleanVar = intVar / intVar == 1;
		// ERROR "Integer divide"
		doubleVar = -10 / 3;
		// ERROR "Integer divide"
		doubleVar = 10 / -3;
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
		doubleVar = 2 / intVar;
		// ERROR "Integer divide"
		intVar = intVar / 2;

		// "Logical operator (%stringVar) can only apply to boolean values"
		// ERROR "Logical operator"
		circle = intVar || false;
		// ERROR "Logical operator"
		if (true && doubleVar)
			voidMethod();
		// ERROR "Logical operator"
		else if (rect && true)
			voidMethod();
		// ERROR "Logical operator"
		while (intVar && booleanVar)
			break;
		do
			break;
		// ERROR "Logical operator"
		while (doubleVar || stringVar);

		// "Inequality operator (%stringVar) can only apply to numbers"
		// ERROR "Inequality operator"
		booleanVar = circle < rect;
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

		// if syntaxLevel >= 7: "Use str1.equals( str2 ) to compare two String values"
		// ERROR "compare two String values"
		if ("" != stringVar)
			voidMethod();
		// ERROR "compare two String values"
		ct.println(circle.group == "circles");

		// if syntaxLevel < 7: "Strings cannot be compared with ==. You must use the equals method, which requires level 7"
		// RROR "cannot be compared with"
		// ct.println(circle.group != "");
		// RROR "cannot be compared with"
		// ct.println(stringVar == "");

		// "Cannot compare %stringVar to %stringVar"
		// ERROR "Cannot compare"
		booleanVar = booleanVar == rect;
		// ERROR "Cannot compare"
		booleanVar = rect != true;
		// ERROR "Cannot compare"
		booleanVar = "3.14" == Math.PI;
		// ERROR "Cannot compare"
		for (;intVar != stringVar;)
			voidMethod();
		// ERROR "Cannot compare"
		booleanVar = stringVar == true;
		// ERROR "Cannot compare"
		booleanVar = "false" != false;
		do
			voidMethod();
		// ERROR "Cannot compare"
		while (1 == false);
		// ERROR "Cannot compare"
		while (booleanVar != 0)
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
		while (booleanVar = false)
			booleanVar = true;
		// ERROR "compare for equality"
		if (rect.x = 100)
			rect.setSpeed(-1, 0);
		// ERROR "compare for equality"
		booleanVar = (1 + 1 = 2);
		// ERROR "compare for equality"
		if (intVar = 1)
			ct.println("oops");

		// "%stringVar does not return a value"
		// ERROR "does not return a value"
		ct.println(voidMethod());
		// ERROR "does not return a value"
		intVar = ct.println();

		// "The %stringVar operator is not supported by Code12 "
		// RROR "operator is not supported"
		// ct.println(~2);
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

	// 'A Code12 program must define a "start" function'
	// RROR "A Code12 program must define"
	public void start()
	{
	}
}