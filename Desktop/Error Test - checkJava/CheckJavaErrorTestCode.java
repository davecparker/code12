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

	void testMethod()
	{
		int i = 1;
		double d = 1.2;
		boolean b = false;
		String s = "";
		GameObj rect = ct.rect(50, 50, 10, 10);
		GameObj circle = ct.circle(50, 50, 10);
		GameObj text = ct.text("text", 50, 50, 10);
		int[] intArr = new int[10];
		double[] dblArr = new double[10];
		boolean[] boolArr = new boolean[10];
		String[] strArr = new String[10];
		GameObj[] objArr = new GameObj[10];

		// "Array initializers must all be the same type"
		

		// "The (+) operator cannot be applied to arrays"
		// ERROR "cannot be applied to arrays"
		ct.println(objArr + s);
		// ERROR "cannot be applied to arrays"
		ct.println(strArr + s);
		// ERROR "cannot be applied to arrays"
		ct.println(boolArr + s);
		// ERROR "cannot be applied to arrays"
		ct.println(s + dblArr);
		// ERROR "cannot be applied to arrays"
		ct.println(s + intArr);

		// "The (+) operator can only apply to numbers or Strings"
		// ERROR "can only apply to numbers or Strings"
		ct.println(intArr + d);
		// ERROR "can only apply to numbers or Strings"
		ct.println(rect + d);
		// ERROR "can only apply to numbers or Strings"
		ct.println(b + d);
		// ERROR "can only apply to numbers or Strings"
		ct.println(intArr + i);
		// ERROR "can only apply to numbers or Strings"
		ct.println(rect + i);
		// ERROR "can only apply to numbers or Strings"
		ct.println(b + i);
		// ERROR "can only apply to numbers or Strings"
		ct.println(d + intArr);
		// ERROR "can only apply to numbers or Strings"
		ct.println(d + rect);
		// ERROR "can only apply to numbers or Strings"
		ct.println(d + b);
		// ERROR "can only apply to numbers or Strings"
		ct.println(i + intArr);
		// ERROR "can only apply to numbers or Strings"
		ct.println(i + rect);
		// ERROR "can only apply to numbers or Strings"
		ct.println(i + b);
		// ERROR "can only apply to numbers or Strings"
		d = 1 / (b + intArr + 1);
		// ERROR "can only apply to numbers or Strings"
		s = b + rect;
		// ERROR "can only apply to numbers or Strings"
		i = b + d / 2;
		// ERROR "can only apply to numbers or Strings"
		i = b + i - 1;
		// ERROR "can only apply to numbers or Strings"
		b = b + b;
		// ERROR "can only apply to numbers or Strings"
		rect.x = circle + text;
		// ERROR "can only apply to numbers or Strings"
		rect.width = 2 + rect;
		// ERROR "can only apply to numbers or Strings"
		ct.println(rect.x + false);

		// "Numeric operator (%s) can only apply to numbers"
		// ERROR "Numeric operator"
		d = s - ".txt";
		// ERROR "Numeric operator"
		i = rect.group % text;
		// ERROR "Numeric operator"
		d = circle / 10;
		// ERROR "Numeric operator"
		rect.width = rect * 2;
		// ERROR "Numeric operator"
		rect.x = 100 - rect;

		// "Integer divide may lose remainder. Use (double) or ct.intDiv()"
		// ERROR "Integer divide"
		b = i / i == 1;
		// ERROR "Integer divide"
		d = -10 / 3;
		// ERROR "Integer divide"
		d = 10 / -3;
		// ERROR "Integer divide"
		i = 123 / 5;
		// ERROR "Integer divide"
		i = (1 + 2) / 3;
		// ERROR "Integer divide"
		i = 1 / (2 + 3);
		// ERROR "Integer divide"
		rect.x = i / 1;
		// ERROR "Integer divide"
		ct.println(1 + i / i);
		// ERROR "Integer divide"
		d = 2 / i;
		// ERROR "Integer divide"
		i = i / 2;

		// "Logical operator (%s) can only apply to boolean values"
		// ERROR "Logical operator"
		circle = i || false;
		// ERROR "Logical operator"
		if (true && d)
			voidMethod();
		// ERROR "Logical operator"
		else if (rect && true)
			voidMethod();
		// ERROR "Logical operator"
		while (i && b)
			break;
		do
			break;
		// ERROR "Logical operator"
		while (d || s);

		// "Inequality operator (%s) can only apply to numbers"
		// ERROR "Inequality operator"
		b = circle < rect;
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
		if ("" != s)
			voidMethod();
		// ERROR "compare two String values"
		ct.println(circle.group == "circles");

		// if syntaxLevel < 7: "Strings cannot be compared with ==. You must use the equals method, which requires level 7"
		// RROR "cannot be compared with"
		// ct.println(circle.group != "");
		// RROR "cannot be compared with"
		// ct.println(s == "");

		// "Cannot compare %s to %s"
		// ERROR "Cannot compare"
		b = b == rect;
		// ERROR "Cannot compare"
		b = rect != true;
		// ERROR "Cannot compare"
		b = "3.14" == Math.PI;
		// ERROR "Cannot compare"
		for (;i != s;)
			voidMethod();
		// ERROR "Cannot compare"
		b = s == true;
		// ERROR "Cannot compare"
		b = "false" != false;
		do
			voidMethod();
		// ERROR "Cannot compare"
		while (1 == false);
		// ERROR "Cannot compare"
		while (b != 0)
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
		while (b = false)
			b = true;
		// ERROR "compare for equality"
		if (rect.x = 100)
			rect.setSpeed(-1, 0);
		// ERROR "compare for equality"
		b = (1 + 1 = 2);
		// ERROR "compare for equality"
		if (i = 1)
			ct.println("oops");

		// "%s does not return a value"
		// ERROR "does not return a value"
		ct.println(voidMethod());
		// ERROR "does not return a value"
		i = ct.println();

		// "The %s operator is not supported by Code12 "
		// RROR "operator is not supported"
		// ct.println(~2);
		// ERROR "operator is not supported"
		i = 2 | 1;
		// ERROR "operator is not supported"
		i = 2 ^ 1;
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