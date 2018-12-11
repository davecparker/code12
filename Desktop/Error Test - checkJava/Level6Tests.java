import Code12.*;

class TestProgram extends Code12Program
{
	public void start()
	{
		String strVar = "";
		GameObj gameObjVar = ct.circle(0, 0, 1);
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
	}

	public void update()
	{
	}


}