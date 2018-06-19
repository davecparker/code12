
import Code12.*;

public class GameObjCreationTest extends Code12Program
{
    public GameObj speedRefrence;
    public GameObj objText;
    public int objCount = 0;
    public GameObj fps;
    public int time;
    public String[] colors = {"black", "white", "red", "green", "blue", "cyan",
                              "majenta", "yellow", "gray", "orange", "pink", "purple",
                              "light gray", "light red", "light green", "light blue", "light cyan", "light majenta",
                              "light yellow", "dark gray", "dark red", "dark green", "dark blue", "dark cyan",
                              "dark majenta", "dark yellow", null};

    // RECOMMENDATION: test only one at a time
    public boolean circleTest = false,      // tests special cases for diameter and color parameters
                   rectTest = false,        // tests special cases for height and width parameters
                   lineTest = false,        // tests placements of x and y coordinates for both points
                   textTest = false,        // tests String escape sequences and special cases for height parameter
                   imageTest = false,       // tests image parameter and special cases for width parameter
                   gridTest = false,        // creates a square grid of any object that is true spanning from -200 to 200
                   colorTest = false,       // tests all colors available
                   performanceTest = false; // tests fps when constantly adding objects to screen

    public static void main(String[] args)
    {
        Code12.run(new GameObjCreationTest());
    }

    public void start()
    {
        // test GameCircle parameters
        if (this.circleTest)
        {
            if (this.gridTest)
            {
                for (int x = -200; x <= 200; x++)
                {
                    for (int y = -200; y <= 200; y++)
                        ct.circle(x, y, 2, null);
                }
            }

            ct.circle(25, 25, 10, null);                                        // creates an invisble fill color
            ct.circle(75, 25, 0);                                               // creates a circle with one pixle width
            ct.circle(25, 75, -10);                                             // creates no visible circle
            ct.circle(75, 75, 10, "");                                          // any and all typos in color parameter results in gray circle color
        }

        // test GameRect parameters
        if (this.rectTest)
        {
            if (this.gridTest)
            {
                for (int x = -200; x <= 200; x++)
                {
                    for (int y = -200; y <= 200; y++)
                        ct.rect(x, y, 2, 2, null);
                }
            }

            ct.rect(10, 10, 20, 10, "blue");
            ct.rect(50, 50, 0, 10);                                             // creates a line
            ct.rect(60, 60, 0, 0);                                              // creates a single pixle
            ct.rect(40, 40, -5, 10);                                            // creates no visible rectangle
        }

        // test GameLine parameters
        if (this.lineTest)
        {
            if (this.gridTest)
            {
                for (int x = -200; x <= 200; x++)
                {
                    for (int y = -200; y <= 200; y++)
                        ct.line(x - 1, y - 1, x + 1, y + 1);
                }
            }

            ct.line(0, 0, 100, 100, "green");
            ct.line(20, 30, 20, 30);                                            // creates a single pixle
            ct.line(60, 70, -1, 70);
        }

        // test GameText parameters
        if (this.textTest)
        {
            if (this.gridTest)
            {
                for (int x = -200; x <= 200; x++)
                {
                    for (int y = -200; y <= 200; y++)
                        ct.text("code12", x, y, 2);
                }
            }

            //ct.text(null, 50, 50, 10, "red");                                 // THROWS: java.lang.NullPointerException
            ct.text("1.\t2.\n3.", 20, 20, 10);                                  // ERROR: tab and newline escape sequences do not work
            ct.text("qwerty", 60, 60, 0);                                       // creates no visible text
            ct.text("code12", 40, 60, -5);                                      // ERROR: flips text vertically and horizontally
        }

        // test GameImage parameters
        if (this.imageTest)
        {
            if (this.gridTest)
            {
                for (int x = -100; x <= 100; x++)
                {
                    for (int y = -100; y <= 100; y++)
                        ct.image("goldfish.png", x, y, 2);
                }
            }

            //ct.image(null, 50, 50, 10);                                       // THROWS: java.lang.NullPointerException
            ct.image("", 50, 20, 10);                                           // creates "image not found" image
            //ct.image("goldfish.png", 50, 50, 0);                              // THROWS: "java.lang.IllegalArgumentException: Width (0) and height (0) must be non-zero"
            ct.image("goldfish.png", 50, 50, -10);                              // ERROR: places image in unique place with improper size
        }

        // test colors
        if (this.colorTest)
        {
            int x = 15, y = 10;
            for (int i = 0; i < this.colors.length; i++)
            {
                ct.circle(x, y, 10, this.colors[i]);
                ct.text((i == this.colors.length - 1 ? "null" : this.colors[i]), x, y, 2, (i == 0 ? "white" : "black"));
                x += 15;
                if (x >= ct.getWidth())
                {
                    x = 15;
                    y += 20;
                }
            }
        }

        // performance test prep
        if (this.performanceTest)
        {
            this.speedRefrence = ct.circle(10, 20, 10);
            this.speedRefrence.xSpeed = 4;
            this.speedRefrence.setLayer(2);
            this.objText = ct.text("0", 80, 10, 5, "black");
            this.objText.setLayer(3);
            this.fps = ct.text("0.0", 20, 10, 5, "black");
            this.fps.setLayer(3);
            this.time = ct.getTimer();
        }
    }

    public void update()
    {
        // performance test
        if (this.performanceTest)
        {
            int newTime = ct.getTimer() - this.time;
            this.time = ct.getTimer();

            if (this.speedRefrence.x >= ct.getWidth() || this.speedRefrence.x <= 0)
               this.speedRefrence.xSpeed *= -1;
            this.objText.setText(ct.formatInt(++this.objCount));

            ct.circle(ct.random(0, 100), ct.random(15, 100), 3, "white");
            ct.rect(ct.random(0, 100), ct.random(15, 100), 3, 3, "white");
            ct.image("goldfish.png", ct.random(0, 100), ct.random(15, 100), 3);

            this.fps.setText(ct.formatInt(1000 / newTime));
            ct.println(1000 / newTime);
        }
    }

}
