
import Code12.*;

public class MainProgram extends Code12Program
{
    GameObj[] objArray = new GameObj[5];

    public static void main(String[] args)
    {
        Code12.run(new MainProgram());
    }

    public void start()
    {
        this.objArray[0] = ct.circle(10, 10, 5, "red");
        this.objArray[1] = ct.rect(30, 30, 10, 5, "blue");
        this.objArray[2] = ct.line(0, 0, 100, 100);
        this.objArray[3] = ct.text("code12", 50, 50, 5, "majenta");
        this.objArray[4] = ct.image("goldfish.png", 80, 80, 5);

        for (int i = 0; i < this.objArray.length; i++)
        {
            // getType
            ct.println("Type: " + this.objArray[i].getType());

            // getText
            ct.println("Text: " + this.objArray[i].getText());

            // setText
            this.objArray[i].setText("setText\n\ttest");                        // escape sequences do not work
            ct.println("New text: " + this.objArray[i].getText());

            // toString
            ct.println("To String: " + this.objArray[i]);

            // setSize
            this.objArray[i].setSize(10, 20);
            ct.println("Set size");

            // align
            this.objArray[i].align("top left");
            this.objArray[i].align("top left", true);
            ct.println("Align left");
            //this.objArray[i].align(" ");                                      // recognizes typo and returns a error saying "invalid argument" for align function

            // setFillColor
            this.objArray[i].setFillColor("cyan");
            this.objArray[i].setFillColor("cya");
            ct.println("Set color");

            // setFillColorRGB
            this.objArray[i].setFillColorRGB(0, 0, 0);
            this.objArray[i].setFillColorRGB(100, 50, 25);
            //this.objArray[i].setFillColorRGB(256, 10, 10);                    // java.lang.IllegalArgumentException: Color parameter outside of expected range: Red
            //this.objArray[i].setFillColorRGB(-1, 10, 10);                     // java.lang.IllegalArgumentException: Color parameter outside of expected range: Red
            ct.println("Set RGB color");

            // setLineColor
            this.objArray[i].setLineColor("red");
            this.objArray[i].setLineColor("re");
            ct.println("Set line color");

            // setLineColorRGB
            this.objArray[i].setLineColorRGB(255, 0, 255);
            //this.objArray[i].setLineColorRGB(-1, 0, 0);                       // java.lang.IllegalArgumentException: Color parameter outside of expected range: Red

            // getLayer
            ct.println("Layer: " + this.objArray[i].getLayer());

            // setLayer
            this.objArray[i].setLayer(3);
            this.objArray[i].setLayer(-1);
            ct.println("New Layer: " + this.objArray[i].getLayer());

            // containsPoint
            if (this.objArray[i].containsPoint(32, 32))
                ct.println(this.objArray[i].getType() + " contains point (30, 30)");

            this.objArray[i].clickable = true;

            // hit
            ct.println(this.objArray[i].getType() + " hit rect " + this.objArray[i].hit(this.objArray[2]));

            ct.println();
        }
    }

    public void update()
    {
        for (int i = 0; i < this.objArray.length; i++)
        {
            // clicked
            if (this.objArray[i].clicked())
            {
                ct.println(this.objArray[i].getType() + " was clicked");
                // delete
                this.objArray[i].delete();
            }
        }
    }

}
