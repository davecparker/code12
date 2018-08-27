
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
        objArray[0] = ct.circle(10, 10, 5, "red");
        objArray[1] = ct.rect(30, 30, 10, 5, "blue");
        objArray[2] = ct.line(0, 0, 100, 100);
        objArray[3] = ct.text("code12", 50, 50, 5, "magenta");
        objArray[4] = ct.image("goldfish.png", 80, 80, 5);

        GameObj player = ct.rect(80, 20, 5, 5, "blue");

        for (int i = 0; i < objArray.length; i++)
        {
            // getType
            ct.println("Getting GameObj type");
            ct.println(objArray[i].getType());
            ct.println("Type: " + objArray[i].getType());

            // getText
            ct.println("Getting text");
            ct.println("Text: " + objArray[i].getText());

            // setText
            ct.println("Setting text to null value");
            objArray[i].setText(null);
            ct.println("New text: " + objArray[i].getText());
            ct.println("Setting text to NEW TEXT");
            objArray[i].setText("NEW TEXT");
            ct.println("New text: " + objArray[i].getText());

            // toString
            ct.println("Printing object");
            ct.println("To String: " + objArray[i]);

            // setSize
            ct.println("Setting size to 10 by 20");
            objArray[i].setSize(10, 20);
            ct.println("Width, height: " + objArray[i].width + ", " + objArray[i].height);

            // align
            ct.println("Aligning to top left");
            objArray[i].align("top left");
            objArray[i].align("top left", true);
            objArray[i].align(" ");
            objArray[i].align(null);

            // setFillColor
            ct.println("Set fill color to cyan");
            objArray[i].setFillColor("cya");
            objArray[i].setFillColor("cyan");

            // setFillColorRGB
            ct.println("Set fill RGB color to purple");
            objArray[i].setFillColorRGB(255, 0, 255);
            objArray[i].setFillColorRGB(256, 10, 10);
            objArray[i].setFillColorRGB(-1, 10, 10);

            // setLineColor
            ct.println("Set line color to red");
            objArray[i].setLineColor("re");
            objArray[i].setLineColor("red");

            // setLineColorRGB
            objArray[i].setLineColorRGB(0, 0, 255);
            objArray[i].setLineColorRGB(-1, 0, 0);
            ct.println("Set line RGB color to blue");

            // getLayer
            ct.println("Layer: " + objArray[i].getLayer());

            // setLayer
            ct.println("Setting layer to 3 and -1 respectively");
            objArray[i].setLayer(3);
            objArray[i].setLayer(-1);
            ct.println("New Layer: " + objArray[i].getLayer());

            // containsPoint
            if (objArray[i].containsPoint(32, 32))
                ct.println(objArray[i].getType() + " contains point (32, 32)");

            ct.println();
        }
    }

}
