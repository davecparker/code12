
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
        this.objArray[0] = ct.circle(10, 10, 5, "red");
        this.objArray[1] = ct.rect(30, 30, 10, 5, "blue");
        this.objArray[2] = ct.line(0, 0, 100, 100);
        this.objArray[3] = ct.text("code12", 50, 50, 5, "majenta");
        this.objArray[4] = ct.image("goldfish.png", 80, 80, 5);

        this.player = ct.rect(25, 75, 5, 5);

        for (int i = 0; i < this.objArray.length; i++)
            this.objArray[i].clickable = true;
    }

    public void update()
    {
        for (int i = 0; i < this.objArray.length; i++)
        {
            // clicked
            if (this.objArray[i].clicked())
            {
                ct.println(this.objArray[i].getType() + " was clicked");
                ct.println("Align to " + this.alignArray[clickedCount] + ", " + clickedCount);
                this.objArray[i].align(this.alignArray[clickedCount], true);
                this.clickedCount++;

                if (this.clickedCount == this.alignArray.length)
                    this.clickedCount = 0;
            }

            // hit
            if (this.player.hit(this.objArray[i]))
            {
                ct.println(this.objArray[i].getType() + " hit player");
                // delete
                this.objArray[i].delete();
            }

            // test
            //if (this.player.hit(null))                                        // java.lang.NullPointerException
            //{ }
        }
    }

    public void onKeyPress(String key)
    {
        if (key.equals("up"))
            this.player.ySpeed = -2;
        else if (key.equals("down"))
            this.player.ySpeed = 2;
        else if (key.equals("left"))
            this.player.xSpeed = -2;
        else if (key.equals("right"))
            this.player.xSpeed = 2;
    }

    public void onKeyRelease(String key)
    {
        if (key.equals("up") || key.equals("down"))
            this.player.ySpeed = 0;
        else if (key.equals("left") || key.equals("right"))
            this.player.xSpeed = 0;
    }
}
