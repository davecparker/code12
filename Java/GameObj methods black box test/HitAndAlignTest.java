
import Code12.*;

public class HitAndAlignTest extends Code12Program
{
    String[] alignArray = {"top left", "top center", "top right", "left", "center", "right", "bottom left", "bottom center", "bottom right"};
    GameObj[] objArray = new GameObj[5];
    GameObj player;
    int clickedCount = 0;

    public static void main(String[] args)
    {
        Code12.run(new HitAndAlignTest());
    }

    public void start()
    {
        objArray[0] = ct.circle(10, 10, 5, "red");
        objArray[1] = ct.rect(30, 30, 10, 5, "blue");
        objArray[2] = ct.line(0, 0, 100, 100);
        objArray[3] = ct.text("code12", 50, 50, 5, "majenta");
        objArray[4] = ct.image("goldfish.png", 80, 80, 5);

        player = ct.rect(25, 75, 5, 5);

        for (int i = 0; i < objArray.length; i++)
            objArray[i].clickable = true;
    }

    public void update()
    {
        for (int i = 0; i < objArray.length; i++)
        {
            // clicked
            if (objArray[i].clicked())
            {
                ct.println(objArray[i].getType() + " was clicked");
                ct.println("Align to " + alignArray[clickedCount] + ", " + clickedCount);
                objArray[i].align(alignArray[clickedCount], true);
                clickedCount++;

                if (clickedCount == alignArray.length)
                    clickedCount = 0;
            }

            // hit
            if (player.hit(objArray[i]))
            {
                ct.println(objArray[i].getType() + " hit player");
                // delete
                objArray[i].delete();
            }

            // test
            //if (player.hit(null))                                        // java.lang.NullPointerException
            //{ }
        }
    }

    public void onKeyPress(String key)
    {
        if (key.equals("up"))
            player.ySpeed = -2;
        else if (key.equals("down"))
            player.ySpeed = 2;
        else if (key.equals("left"))
            player.xSpeed = -2;
        else if (key.equals("right"))
            player.xSpeed = 2;
    }

    public void onKeyRelease(String key)
    {
        if (key.equals("up") || key.equals("down"))
            player.ySpeed = 0;
        else if (key.equals("left") || key.equals("right"))
            player.xSpeed = 0;
    }
}
