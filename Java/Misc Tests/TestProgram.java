import Code12.*;

class TestProgram extends Code12Program
{
	
	public static void main(String[] args)
	{ 
		Code12.run(new TestProgram()); 
	}
	
	GameObj t;
	
	
	public void start()
	{
		t = ct.text("code12", 80, 25, 6);
	}
	
	public void update()
	{	
		t.x -= 0.1;
		t.y += 0.1;
		t.height += 0.05;
	}
}