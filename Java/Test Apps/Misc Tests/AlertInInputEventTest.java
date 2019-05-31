class AlertInInputEventTest
{
	boolean onMousePressAlertOn = false;
	boolean onMouseDragAlertOn = false;
	boolean onMouseReleaseAlertOn = false;
	boolean onKeyPressAlertOn = false;
	boolean onKeyReleaseAlertOn = true;
	boolean onCharTypedAlertOn = false;

	public void start()
	{
		ct.println( "start" );
	}

	// public void update()
	// {
	// 	ct.println( "update" );
	// }

	public void onMousePress( GameObj obj, double x, double y)
	{
		ct.println( "onMousePress" );
		if ( onMousePressAlertOn )
		{
			ct.showAlert( "Mouse was pressed" );
			ct.println( "Back from alert" );
		}
	}

	public void onMouseDrag( GameObj obj, double x, double y )
	{
		ct.println( "onMouseDrag" );
		if ( onMouseDragAlertOn )
		{
			int input = ct.inputInt( "Mouse was dragged. Enter an integer." );
			ct.println( "Back from alert. " + input + " was entered." );
		}
	}

	public void onMouseRelease( GameObj obj, double x, double y )
	{
		ct.println( "onMouseRelease" );
		if ( onMouseReleaseAlertOn )
		{
			double input = ct.inputNumber( "Mouse was released. Enter a number." );
			ct.println( "Back from alert. " + input + " was entered." );
		}
	}

	public void onKeyPress( String keyName )
	{
		ct.println( "onKeyPress: " + keyName );
		if ( onKeyPressAlertOn )
		{
			boolean input = ct.inputYesNo( keyName + " was pressed. Click yes or no." );
			ct.println( "Back from alert" );
		}
	}

	public void onKeyRelease( String keyName )
	{
		ct.println( "onKeyRelease: " + keyName );
		if ( onKeyReleaseAlertOn )
		{
			// Causes infinite loop
			String input = ct.inputString( keyName + " was released. Enter a string." );
			ct.println( "Back from alert. " + input + " was entered." );
		}
	}

	public void onCharTyped( String charString )
	{
		ct.println( "onCharTyped: " + charString );
		if ( onCharTypedAlertOn )
		{
			int input = ct.inputInt( charString + " was typed. Enter an integer." );
			ct.println( "Back from alert. " + input + " was entered." );
		}
	}
}
