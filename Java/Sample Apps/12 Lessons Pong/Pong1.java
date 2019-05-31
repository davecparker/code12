class Pong1
{
	public void start()
	{
		ct.setTitle( "Pong 1" );
		ct.setBackColor( "black" );
		ct.line( 50, 0, 50, 100, "white" );
		ct.text( "0", 25, 5, 10, "white" );
		ct.text( "0", 75, 5, 10, "white" );
		ct.rect( 10, 50, 2, 10, "white" );
		ct.rect( 90, 50, 2, 10, "white" );
		ct.circle( 12.5, 50, 2, "white" );
	}
}
