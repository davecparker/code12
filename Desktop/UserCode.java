import Code12.*;

class UserCode extends Code12Program
{
	GameObj ball, bigBall;
	final int LIMIT = 600;
	int speed = 3;

	public void start()
	{
		int x = 10 + 50 * 2 + (45 * 2);

		// Draw some circles
		ball = ct.circle(x + 30, 70, 50);
		ct.circle(x / 2 + 10, 200, 150);
		bigBall = ct.circle(x, 400, 200);
	}

	public void update()
	{
		double factor = 2;

		ball.x++;
		if (ball != null && !(ball.x <= LIMIT))
			ball.x = 0;

		bigBall.x += speed;
		if (bigBall.x > LIMIT)
		{
			bigBall.x--;
			bigBall.width /= factor;
			bigBall.height *= (1 / factor);
			speed = -speed;
		}
		else if (bigBall.x < 0)
			speed = -speed;
		else
		{
			// Nothing
		}
	}
}
