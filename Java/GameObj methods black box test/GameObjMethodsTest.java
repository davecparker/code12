
import Code12.*;

public class GameObjMethodsTest extends Code12Program
{
    GameObj[] objArray = new GameObj[5];

    public static void main(String[] args)
    {
        Code12.run(new GameObjMethodsTest());
    }

    public void start()
    {
        this.objArray[0] = ct.circle(10, 10, 5, "red");
        this.objArray[1] = ct.rect(30, 30, 10, 5, "blue");
        this.objArray[2] = ct.line(0, 0, 100, 100);
        this.objArray[3] = ct.text("code12", 50, 50, 5, "majenta");
        this.objArray[4] = ct.image("goldfish.png", 80, 80, 5);

        this.player = ct.rect(80, 20, 5, 5, "blue");

        for (int i = 0; i < this.objArray.length; i++)
        {
            // getType
            ct.println("Getting GameObj type");
            ct.println("Type: " + this.objArray[i].getType());

            // getText
            ct.println("Getting text");
            ct.println("Text: " + this.objArray[i].getText());

            // setText
            ct.println("Setting text to null value");
            this.objArray[i].setText(null);
            ct.println("New text: " + this.objArray[i].getText());
            ct.println("Setting text to \'NEW TEXT\'");
            this.objArray[i].setText("NEW TEXT");
            ct.println("New text: " + this.objArray[i].getText());

            // toString
            ct.println("Printing object");
            ct.println("To String: " + this.objArray[i]);

            // setSize
            ct.println("Setting size to 10 by 20");
            this.objArray[i].setSize(10, 20);
            ct.println("Width, height: " + this.objArray[i].width + ", " + this.objArray[i].height)

            // align
            ct.println("Aligning to top left");
            this.objArray[i].align("top left");
            this.objArray[i].align("top left", true);
            //this.objArray[i].align(" ");                                      // recognizes typo and returns a error saying "invalid argument"
            //this.objArray[i].align(null);                                     // java.lang.NullPointerException

            // setFillColor
            ct.println("Set fill color to cyan");
            this.objArray[i].setFillColor("cya");                               // gray in color
            this.objArray[i].setFillColor("cyan");

            // setFillColorRGB
            ct.println("Set fill RGB color to purple");
            this.objArray[i].setFillColorRGB(255, 0, 255);
            //this.objArray[i].setFillColorRGB(256, 10, 10);                    // java.lang.IllegalArgumentException: Color parameter outside of expected range: Red
            //this.objArray[i].setFillColorRGB(-1, 10, 10);                     // java.lang.IllegalArgumentException: Color parameter outside of expected range: Red

            // setLineColor
            ct.println("Set line color to red");
            this.objArray[i].setLineColor("re");                                // gray in color
            this.objArray[i].setLineColor("red");

            // setLineColorRGB
            this.objArray[i].setLineColorRGB(0, 0, 255);
            //this.objArray[i].setLineColorRGB(-1, 0, 0);                       // java.lang.IllegalArgumentException: Color parameter outside of expected range: Red
            ct.println("Set line RGB color to blue");

            // getLayer
            ct.println("Layer: " + this.objArray[i].getLayer());

            // setLayer
            ct.println("Setting layer to 3 and -1 respectively");
            this.objArray[i].setLayer(3);
            this.objArray[i].setLayer(-1);
            ct.println("New Layer: " + this.objArray[i].getLayer());

            // containsPoint
            if (this.objArray[i].containsPoint(32, 32))
                ct.println(this.objArray[i].getType() + " contains point (32, 32)");

            ct.println();
        }
    }

}
