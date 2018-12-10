class Emoji
{
	double headSize = 40;
	double eyeDistance = headSize * 0.35;
	GameObj head, leftEye, rightEye, nose, mouth;

	public void start()
	{
		// Make the initial face
		head = ct.circle( 50, 25, headSize, "yellow" );
		double eyeHeight = headSize * 0.2;
		double eyeSize = headSize * 0.125;
		leftEye = ct.circle( head.x - eyeDistance / 2, head.y - eyeHeight, 
						eyeSize, "black" );
		rightEye = ct.circle( head.x + eyeDistance / 2, head.y - eyeHeight, 
						eyeSize, "black" );
		nose = ct.circle( head.x, head.y, eyeSize, "red" );
		mouth = ct.rect( head.x, head.y + headSize * 0.2, headSize * 0.5, 
						eyeSize / 2, "black" );
	}

	public void update()
	{
		// Ask the user for a new x-coordinate for the face
		head.x = ct.inputNumber( "Enter x-coordinate for the face" );
		leftEye.x = head.x - eyeDistance / 2;
		rightEye.x = head.x + eyeDistance / 2;
		nose.x = head.x;
		mouth.x = head.x;

		// Ask the user for a new eye distance
		eyeDistance = ct.inputNumber( "Enter the eye distance" );
		leftEye.x = head.x - eyeDistance / 2;
		rightEye.x = head.x + eyeDistance / 2;

		// Ask the user if they want a nose
		nose.visible = ct.inputYesNo( "Do you want a nose?" );
	}
}
