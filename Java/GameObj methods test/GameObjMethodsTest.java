
import Code12.*;

public class GameObjMethodsTest extends Code12Program
{
    public static void main(String[] args)
    {
        Code12.run(new GameObjMethodsTest());
    }

    public void start()
    {

    }

    public void getTypeTest(GameObj obj)
    {
        ct.println("Getting GameObj type");
        ct.println(obj.getType());
        ct.println("Type: " + obj.getType());
    }

    public void getTextTest(GameObj obj)
    {
        ct.println("Getting text");
        ct.println("Text: " + obj.getText());
    }

    public void setTextTest(GameObj obj)
    {
        ct.println("Setting text to null value");
        obj.setText(null);
        ct.println("New text: " + obj.getText());
        ct.println("Setting text to NEW TEXT");
        obj.setText("NEW TEXT");
        ct.println("New text: " + obj.getText());
    }

    public void toStringTest(GameObj obj)
    {
        ct.println("Printing object");
        ct.println("To String: " + obj.toString());
        ct.println("To String: " + obj);
    }

    public void setSizeTest(GameObj obj)
    {
        ct.println("Setting size to 10 by 20");
        obj.setSize(10, 20);
        ct.println("Width, height: " + obj.width + ", " + obj.height);
    }

    public void alignTest(GameObj obj)
    {
        ct.println("Aligning to top left");
        obj.align("top left");
        obj.align("top left", true);
        obj.align(" ");
        obj.align(null);
    }

    public void setFillColorTest(GameObj obj)
    {
        ct.println("Set fill color to cyan");
        obj.setFillColor("cya");
        obj.setFillColor("cyan");
    }

    public void setFillColorRGBTest(GameObj obj)
    {
        ct.println("Set fill RGB color to purple");
        obj.setFillColorRGB(255, 0, 255);
        obj.setFillColorRGB(256, 10, 10);
        obj.setFillColorRGB(-1, 10, 10);
    }

    public void setLineColor(GameObj obj)
    {
        ct.println("Set line color to red");
        obj.setLineColor("re");
        obj.setLineColor("red");
    }

    public void setLineColorRGBTest(GameObj obj)
    {
        obj.setLineColorRGB(0, 0, 255);
        obj.setLineColorRGB(-1, 0, 0);
        ct.println("Set line RGB color to blue");
    }

    public void getLayerTest(GameObj obj)
    {
        ct.println("Layer: " + obj.getLayer());
    }

    public void setLayerTest(GameObj obj)
    {
        ct.println("Setting layer to 3 and -1 respectively");
        obj.setLayer(3);
        obj.setLayer(-1);
        ct.println("New Layer: " + obj.getLayer());
    }

    public void containsPointTest(GameObj obj)
    {
        if (obj.containsPoint(32, 32))
            ct.println(obj.getType() + " contains point (32, 32)");
    }

}
