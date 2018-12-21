import Code12.*;

class Level6Tests extends Code12Program
{
	public void start()
	{
		String strVar = "";
		GameObj gameObjVar = ct.circle(0, 0, 1);

		// if syntaxLevel < 7:
		// ERROR "Strings cannot be compared with =="
		ct.println(gameObjVar.group != "");
		// ERROR "Strings cannot be compared with =="
		ct.println(strVar == "");
		// ERROR "Unknown or misspelled function name, did you mean"
		cc.prinltn();
		// ERROR "Unknown or misspelled function name, did you mean"
		foo.println();
		// ERROR "Unknown or misspelled function name, did you mean"
		foo.rect(1, 2, 3, 4);
		// ERROR "Unknown or misspelled function name, did you mean"
		math.sine();
		// ERROR "Unknown or misspelled function name, did you mean"
		foo.sin();
		// ERROR "Unknown or misspelled function name"
		foo.bar();
		// ERROR "Unknown or misspelled function name" "(Object method calls require syntax level 7)"
		gameObjVar.setText("");
		// ERROR "Unknown or misspelled function name, did you mean "Math.
		double x = foo.sin(Math.PI / 2);
	}

	// if syntaxLevel < 9:
	// ERROR "Unknown function name" "Use of user-defined functions requires syntax level 9"
	void myFunc()
	{
	}

	public void update()
	{
	}
}