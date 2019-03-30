class Test
{

	public void start()
	{
		//do something
		ct.circle( 2, 2, 2 );
		
		ct.println("test");
		ct.pause();

		//do something else

		ct.rect( 10, 10, 10 ,10 );


		ct.showAlert("test");
		ct.pause();

		test();
		//Backwards pauses
		// for( int i = 0; i < 5; i++ )
		// {
		// 	ct.pause();

		// 	if( i == 4)
		// 	{
		// 		ct.println("Test " + i);
		// 		ct.pause();
		// 	}

		// 	if( i == 3 )
		// 	{
		// 		ct.println("Test " + i);
		// 		ct.pause();
		// 	}

		// 	if ( i == 2 )
		// 	{
		// 		ct.println("Test " + i);
		// 		ct.pause();
		// 	}

		// 	if( i == 1 )
		// 	{
		// 		ct.println("Test " + i);
		// 		ct.pause();
		// 	}

		// 	if( i == 0 )
		// 	{
		// 		ct.println("Test " + i);
		// 		ct.pause();
		// 	}			
		// }
	}

	public void test()
	{
		ct.circle( 2, 2, 2 );
		
		ct.println("test");
		ct.pause();

		//do something else

		ct.rect( 10, 10, 10 ,10 );

		ct.showAlert("test");
		ct.pause();
	}
}
	
