
class ConcatTest
{
	public void start()
	{
		int a = 5;
		double b = 2;
		String str = "hello";
		String[] strArray = {"a", "b", "c"};
		GameObj circle = ct.circle(50, 50, 5);
		circle.group = "group ";
		GameObj[] texts = { ct.text("text1", 10, 10, 4), ct.text("text2", 30, 30, 4) };
		texts[0].group = "group ";

		// testing int +=
		ct.println("int a: " + a);
		a += 5;
		ct.println("a += 5 => a: " + a);
		// should result in error:
		// ct.println("a += 3.14 => error");
		// a += 3.14;
		// ct.println("a += \"string\" => error");
		// a += "string";
		// ct.println("a += true => error");
		// a += true;
		// ct.println("a += null => error");
		// a += null;
		ct.println();

		// testing double +=
		ct.println("int b: " + b);
		b += 3.14;
		ct.println("b += 3.14 => b: " + b);
		ct.println();

		// testing concatenation +=
		// str += strExpr
		ct.println("String str: \"" + str + "\"");
		str += " world";
		ct.println("str += \" world\" => " + str);

		// str[i] += strExpr
		ct.println("strArray: {" + strArray[0] + ", " + strArray[1] + ", " + strArray[2] + "}");
		strArray[0] += strArray[1] + strArray[2];
		ct.println("strArray[0] += strArray[1] + strArray[2] => " + strArray[0]);

		// obj.str += strExpr
		ct.println("String circle.group: \"" + circle.group + "\"");
		circle.group += "circles";
		ct.println("circle.group += \"circles\" => " + circle.group);

		// obj[i].str += strExpr
		ct.println("String texts[0].group: \"" + texts[0].group + "\"");
		texts[0].group += getStr();
		ct.println("texts[0].group += \" texts\" => " + texts[0].group);

		// should result in error
		// ct.println("str += 5 => error");
		// str += 5;
		// ct.println("str += 3.14 => error");
		// str += 3.14;
		// ct.println("str += true => error");
		// str += true;
		// ct.println("str += null => error");
		// str += null;
		// str += getNull();

		boolean flag = false;
		// flag += 2;

		ct.println();
	}

	String getStr()
	{
		String str = "texts";
		return str;
	}

	String getNull()
	{
		return null;
	}
}
