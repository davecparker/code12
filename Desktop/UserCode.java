import Code12.*;

class UserCode extends Code12Program
{
	GameObj ball = null;

	public void start()
	{
		int x = 200;

		// Draw some circles
		ball = ct.circle(x + 50, 100, 50);
		ct.circle(x / 2 + 10, 200, 150);
		ct.circle(x, 400, 200);
	}

	public void update()
	{
		ball.x = ball.x + 3;
	}
}
