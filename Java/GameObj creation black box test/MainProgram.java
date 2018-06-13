
import Code12.*;

public class MainProgram extends Code12Program
{
    public GameObj speedRefrence;
    public GameObj objText;
    public int objCount = 0;
    public GameObj fps;
    public int time;
    public String[] colors = {"black", "white", "red", "green", "blue", "cyan", "majenta", "yellow",
                    "gray", "orange", "pink", "purple", "light gray", "light red", "light green",
                    "light blue", "light cyan", "light majenta", "light yellow", "dark gray",
                    "dark red", "dark green", "dark blue", "dark cyan", "dark majenta", "dark yellow"};

    public static void main(String[] args)
    {
        Code12.run(new MainProgram());
    }

    public void start()
    {
        // RECOMMENDATION: uncomment only one test at a time

        // test GameCircle parameters
        //ct.circle(0, 0, 20, "blue");
        //ct.circle(ct.getWidth() / 2, ct.getHeight() / 2, 0);      // creates a circle with one pixle width
        //ct.circle(80, 80, -10);                                   // creates no visible circle
        //ct.circle(20, 20, 10, "");                                // any and all typos in color parameter results in gray circle color

        // test GameRect parameters
        //ct.rect(10, 10, 20, 10, "blue");
        //ct.rect(50, 50, 0, 10);                                   // creates a line
        //ct.rect(60, 60, 0, 0);                                    // creates a single pixle
        //ct.rect(40, 40, -5, 10);                                  // creates no visible rectangle

        // test GameLine parameters
        //ct.line(0, 0, 100, 100, "green");
        //ct.line(20, 30, 20, 30);                                  // creates a single pixle
        //ct.line(60, 70, -1, 70);

        // test GameText parameters
        //ct.text("test", 50, 50, 10, "red");
        //ct.text("1.\t2.\n3.", 20, 20, 10);                        // ERROR: tab and newline escape sequences do not work
        //ct.text("qwerty", 60, 60, 0);                             // creates no visible text
        //ct.text("code12", 40, 60, -5);                            // ERROR: flips text vertically and horizontally

        // test GameImage parameters
        //ct.image("goldfish.png", 50, 50, 10);
        //ct.image("", 50, 20, 10);                                 // creates "image not found" image
        //ct.image("goldfish.png", 50, 50, 0);                      // THROWS: "java.lang.IllegalArgumentException: Width (0) and height (0) must be non-zero"
        //ct.image("goldfish.png", 50, 50, -10);                    // ERROR: places image in unique place with improper size

        // test colors
        //for (int i = 0; i < colors.length; i++)
        //    ct.circle(ct.random(0, 100), ct.random(0, 100), 10, colors[i]);

        // performance test prep
        //this.speedRefrence = ct.circle(10, 20, 10);
        //this.speedRefrence.xSpeed = 4;
        //this.speedRefrence.setLayer(2);
        //this.objText = ct.text("0", 80, 10, 5, "black");
        //this.objText.setLayer(3);
        //this.fps = ct.text("0.0", 20, 10, 5, "black");
        //this.fps.setLayer(3);
        //this.time = ct.getTimer();
    }

    public void update()
    {
        // performance test
        int newTime = ct.getTimer() - this.time;
        this.time = ct.getTimer();

        //if (this.speedRefrence.x >= ct.getWidth() || this.speedRefrence.x <= 0)
        //    this.speedRefrence.xSpeed *= -1;
        //this.objText.setText(ct.formatInt(++this.objCount));

        //ct.circle(ct.random(0, 100), ct.random(15, 100), 3, "white");
        //ct.rect(ct.random(0, 100), ct.random(15, 100), 3, 3, "white");
        //ct.image("goldfish.png", ct.random(0, 100), ct.random(15, 100), 3);

        //this.fps.setText(ct.formatInt(1000 / newTime));
        //ct.println(1000 / newTime);
    }

}
