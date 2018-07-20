import Code12.*;

class TestProgram extends Code12Program
{

	public static void main(String[] args)
	{ 
		Code12.run(new TestProgram()); 
	}

	String[] keyNames = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
							"n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
							"0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
							"numPad0", "numPad1", "numPad2", "numPad3", "numPad4", "numPad5", "numPad6", "numPad7", "numPad8", "numPad9",
							"up", "down", "left", "right", "space", "enter", "tab", "backspace", "escape" };
	int numberOfKeyNames = keyNames.length;
	
	public void start()
	{
		ct.println("start:");

		// Test valid key names don't cause runtime crash
		for (int i = 0; i < numberOfKeyNames; i++)
			ct.logm("ct.keyPressed(\"" + keyNames[i] + "\") =", ct.keyPressed(keyNames[i]));

		// Test invalid and null key names don't cause runtime crash
		ct.logm("ct.keyPressed(null) =", ct.keyPressed(null));
		ct.logm("ct.keyPressed(\"invalid key name\") =", ct.keyPressed("invalid key name"));

		ct.println("update:");
	}

	public void update()
	{
		// Test valid key names return correct value on key press
		for (int i = 0; i < numberOfKeyNames; i++)
		{
			if ( ct.keyPressed(keyNames[i]) )
			{
				ct.println(keyNames[i] + " key pressed");
			}
		}
	}

	public void onKeyPress( String keyName )
	{
		if (keyName.equals("tap"))
			ct.println("tab key pressed");
	}
}