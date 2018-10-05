
import Code12.*;

public class GameObjMethodsTest extends Code12Program
{
    GameObj title, backButton, backText;
    GameObj[] screenButtons, screenLabels, testObjs;
    String[] alignments = {"center", "right", "bottom right", "bottom", "bottom left", "left", "top left", "top", "top right", null};
    String[] colors = {"black", "white", "red", "green", "blue", "cyan", "magenta", "yellow",
                        "gray", "orange", "pink", "purple",
                        "light gray", "light red", "light green", "light blue", "light cyan", "light magenta", "light yellow",
                        "dark gray", "dark red", "dark green", "dark blue", "dark cyan", "dark magenta", "dark yellow", null};

    public static void main(String[] args)
    {
        Code12.run(new GameObjMethodTest());
    }

    public void start()
    {
        testObjs = new GameObj[10];
        defineScreens();
        enableMainScreen();
    }

    public void update()
    {
    }

    public void defineScreens()
    {
        title = ct.text("", 50, 8, 8);
        backButton = ct.rect(10, 2.5, 20, 5, "light blue");
        backText = ct.text("Back", 10, 2.5, 3);
        screenButtons = new GameObj[15];
        screenLabels = new GameObj[15];
        for (int i = 0; i < screenButtons.length; i++)
        {
            screenButtons[i] = ct.rect(25 + 50 * ct.intDiv(i, 8), 8 * (i % 8) + 30, 40, 5, "light blue");
            screenLabels[i] = ct.text("", 25 + 50 * ct.intDiv(i, 8), 8 * (i % 8) + 30, 3);
        }
        disableScreens();
    }

    public void enableMainScreen()
    {
        title.setText("GameObj Method Testing");
        String[] labels = {"getType", "get/setText", "toString", "setSize", "align", "setFillColor", "setFillColorRGB", "setLineColor", "setLineColorRGB",
                            "get/setLayer", "delete", "clicked", "containsPoint", "hit", "objectHitInGroup"};
        for (int i = 0; i < labels.length; i++)
        {
            screenButtons[i].visible = true;
            screenLabels[i].visible = true;
            screenLabels[i].setText(labels[i]);
        }
    }

    public void disableScreens()
    {
        for (int i = 0; i < screenButtons.length; i++)
        {
            screenButtons[i].visible = false;
            screenLabels[i].visible = false;
        }
        backButton.visible = false;
        backText.visible = false;
        deleteTestObjs();
    }

    public void deleteTestObjs()
    {
        for (int i = 0; i < testObjs.length; i++)
        {
            if (testObjs[i] != null)
            {
                testObjs[i].delete();
                testObjs[i] = null;
            }
        }
    }

    public void onMouseRelease(GameObj obj, double x, double y)
    {
        if (obj == backButton || obj == backText)
            backButtonAction();
        else if (clickedButton(obj))
            mainScreenAction(obj);
        else if (clickedTestObj(obj))
            userMousePressInteraction(obj, x, y);
    }

    public void onMouseDrag(GameObj obj, double x, double y)
    {
        String titleName = title.getText();
        if (clickedTestObj(obj) && (titleName.equals("get/setLayer Test") || titleName.equals("hit Test") || titleName.equals("objectHitInGroup Test")))
            userMouseDragInteraction(obj, x, y);
    }

    public void userMousePressInteraction(GameObj obj, double x, double y)
    {
        String titleName = title.getText();
        if (titleName.equals("get/setText Test"))
            getsetTextClickAction(obj);
        else if (titleName.equals("setSize Test"))
            setSizeClickAction(obj);
        else if (titleName.equals("align Test") && isTestObjIndexWithin(obj, 0, 5))
            alignClickAction(obj);
        else if (titleName.equals("setFillColor Test") || titleName.equals("setLineColor Test") && isTestObjIndexWithin(obj, 0, 27))
            setFillLineColorClickAction(obj);
        else if ((titleName.equals("setFillColorRGB Test") || titleName.equals("setLineColorRGB Test")) && isTestObjIndexWithin(obj, 0, 40))
            setFillLineColorRGBClickAction(obj);
        else if (titleName.equals("get/setLayer Test") && obj == testObjs[10])
            getsetLayerClickAction();
        else if (titleName.equals("clicked Test"))
            clickedClickAction(obj);
    }

    public void userMouseDragInteraction(GameObj obj, double x, double y)
    {
        obj.x = x;
        obj.y = y;
        String titleName = title.getText();
        if (titleName.equals("hit Test"))
            hitDragAction();
        else if (titleName.equals("objectHitInGroup Test"))
            objectHitInGroupDragAction();
    }

    public void backButtonAction()
    {
        disableScreens();
        enableMainScreen();
    }

    public void mainScreenAction(GameObj obj)
    {
        disableScreens();
        backButton.visible = true;
        backText.visible = true;
        if (obj == screenButtons[0] || obj == screenLabels[0])
            getTypeTest();
        else if (obj == screenButtons[1] || obj == screenLabels[1])
            getsetTextTest();
        else if (obj == screenButtons[2] || obj == screenLabels[2])
            toStringTest();
        else if (obj == screenButtons[3] || obj == screenLabels[3])
            setSizeTest();
        else if (obj == screenButtons[4] || obj == screenLabels[4])
            alignTest();
        else if (obj == screenButtons[5] || obj == screenLabels[5])
            setFillColorTest();
        else if (obj == screenButtons[6] || obj == screenLabels[6])
            setFillColorRGBTest();
        else if (obj == screenButtons[7] || obj == screenLabels[7])
            setLineColor();
        else if (obj == screenButtons[8] || obj == screenLabels[8])
            setLineColorRGBTest();
        else if (obj == screenButtons[9] || obj == screenLabels[9])
            getsetLayerTest();
        else if (obj == screenButtons[10] || obj == screenLabels[10])
            deleteTest();
        else if (obj == screenButtons[11] || obj == screenLabels[11])
            clickedTest();
        else if (obj == screenButtons[12] || obj == screenLabels[12])
            containsPointTest();
        else if (obj == screenButtons[13] || obj == screenLabels[13])
            hitTest();
        else if (obj == screenButtons[14] || obj == screenLabels[14])
            objectHitInGroupTest();
    }

    public void getTypeTest()
    {
        title.setText("getType Test");
        ct.println("**getType Test**");
        testObjs = getBasicTestObjs(10, 15);
        testObjs[5] = ct.text(testObjs[0].getType(), 50, 30, 6);
        testObjs[6] = ct.text(testObjs[1].getType(), 50, 45, 6);
        testObjs[7] = ct.text(testObjs[2].getType(), 50, 60, 6);
        testObjs[8] = ct.text(testObjs[3].getType(), 50, 75, 6);
        testObjs[9] = ct.text(testObjs[4].getType(), 50, 90, 6);
    }

    public void getsetTextTest()
    {
        title.setText("get/setText Test");
        ct.println("**get/setText Test**");
        ct.println("\tClick an object to change its text");
        testObjs = getBasicTestObjs(10, 15);
        testObjs[5] = ct.text(testObjs[0].getText(), 50, 30, 6);
        testObjs[6] = ct.text(testObjs[1].getText(), 50, 45, 6);
        testObjs[7] = ct.text(testObjs[2].getText(), 50, 60, 6);
        testObjs[8] = ct.text(testObjs[3].getText(), 50, 75, 6);
        testObjs[9] = ct.text(testObjs[4].getText(), 50, 90, 6);
    }

    public void toStringTest()
    {
        title.setText("toString Test");
        ct.println("**toString Test**");
        testObjs = getBasicTestObjs(11, 15);
        testObjs[5] = ct.text("toString()", 70, 23, 4);
        testObjs[6] = ct.text(testObjs[0].toString(), 70, 30, 3);
        testObjs[7] = ct.text(testObjs[1].toString(), 70, 45, 3);
        testObjs[8] = ct.text(testObjs[2].toString(), 70, 60, 3);
        testObjs[9] = ct.text(testObjs[3].toString(), 70, 75, 3);
        testObjs[10] = ct.text(testObjs[4].toString(), 70, 90, 3);
        for (int i = 0; i < testObjs.length; i++)
            ct.println(testObjs[i]);
    }

    public void setSizeTest()
    {
        title.setText("setSize Test");
        ct.println("**setSize Test**");
        ct.println("\tClick an object to set its size");
        ct.println("\tVerify that reference points are placed on the bisection\n\tof each edge of the object once you enter width and height");
        testObjs = getBasicTestObjs(9, 50);
    }

    public void alignTest()
    {
        // TODO: null parameter does not make fill color null
        title.setText("align Test");
        ct.println("**align Test**");
        ct.println("\tClick an object to set its alignment");
        ct.println("\tAlignments: 'top left', 'top', 'top right', 'left', 'center', 'right', 'bottom left', 'bottom right'");
        testObjs = getBasicTestObjs(15, 50);
        testObjs[5] = ct.rect(50, 30, 10, 10, null);
        testObjs[6] = ct.rect(50, 45, 10, 10, null);
        testObjs[7] = ct.rect(50, 60, 10, 10, null);
        testObjs[8] = ct.rect(50, 75, 17.33333333333, 6, null);
        testObjs[9] = ct.rect(50, 90, 15, 7.90625, null);
        testObjs[10] = ct.circle(50, 30, 1, "black");
        testObjs[11] = ct.circle(50, 45, 1, "black");
        testObjs[12] = ct.circle(50, 60, 1, "black");
        testObjs[13] = ct.circle(50, 75, 1, "black");
        testObjs[14] = ct.circle(50, 90, 1, "black");
        for (int i = 5; i < 10; i++)
        {
            testObjs[i].setFillColor(null);
            testObjs[i].setLineColor("green");
        }
    }

    public void setFillColorTest()
    {
        title.setText("setFillColor Test");
        ct.println("**setFillColor Test**");
        ct.println("\tClick an object to change its fill color");
        GameObj[] testObjsCopy = new GameObj[54];
        for (int i = 0; i < 27; i++)
        {
            double x = 12 * i % 96 + 6;
            double y = ct.intDiv(i, 8) * 18 + 30;
            testObjsCopy[i] = ct.circle(x, y, 10);
            testObjsCopy[i].setFillColor(colors[i]);
            if (i == 26)
                testObjsCopy[i + 27] = ct.text("null", x, y + 8, 2);
            else
                testObjsCopy[i + 27] = ct.text(colors[i], x, y + 8, 2);
        }
        testObjs = testObjsCopy;
    }

    public void setFillColorRGBTest()
    {
        title.setText("setFillColorRGB Test");
        ct.println("**setFillColorRGB Test**");
        ct.println("\tClick an object to set its RGB fill color");
        GameObj[] testObjsCopy = new GameObj[80];
        for (int i = 0; i < 40; i++)
        {
            int color = i * ct.intDiv(255, 40);
            double x = 12 * i % 96 + 8;
            double y = ct.intDiv(i, 8) * 15 + 30;
            testObjsCopy[i] = ct.rect(x, y, 8, 8);
            testObjsCopy[i].setFillColorRGB(color, color, color);
            String rgb = "{" + color + ", " + color + ", " + color + "}";
            testObjsCopy[i + 40] = ct.text(rgb, x, y + 8, 2);
        }
        testObjs = testObjsCopy;
    }

    public void setLineColor()
    {
        title.setText("setLineColor Test");
        ct.println("**setLineColor Test**");
        ct.println("\tClick an object to set its line color");
        GameObj[] testObjsCopy = new GameObj[54];
        for (int i = 0; i < 27; i++)
        {
            double x = 12 * i % 96 + 6;
            double y = ct.intDiv(i, 8) * 18 + 30;
            testObjsCopy[i] = ct.circle(x, y, 10, "light gray");
            testObjsCopy[i].setLineColor(colors[i]);
            testObjsCopy[i].lineWidth = 5;
            if (i == 26)
                testObjsCopy[i + 27] = ct.text("null", x, y + 8, 2);
            else
                testObjsCopy[i + 27] = ct.text(colors[i], x, y + 8, 2);
        }
        testObjs = testObjsCopy;
    }

    public void setLineColorRGBTest()
    {
        title.setText("setLineColorRGB Test");
        ct.println("**setLineColorRGB Test**");
        ct.println("\tClick an object to set its RGB line color");
        GameObj[] testObjsCopy = new GameObj[80];
        for (int i = 0; i < 40; i++)
        {
            int color = i * ct.intDiv(255, 40);
            double x = 12 * i % 96 + 8;
            double y = ct.intDiv(i, 8) * 15 + 30;
            testObjsCopy[i] = ct.rect(x, y, 8, 8, "light gray");
            testObjsCopy[i].setLineColorRGB(color, color, color);
            testObjsCopy[i].lineWidth = 5;
            String rgb = "{" + color + ", " + color + ", " + color + "}";
            testObjsCopy[i + 40] = ct.text(rgb, x, y + 8, 2);
        }
        testObjs = testObjsCopy;
    }

    // TODO: add \t to directions && change getsetLayerTest to use onMouseRelease and get rid of reseting test
    public void getsetLayerTest()
    {
        title.setText("get/setLayer Test");
        ct.println("**get/setLayer Test**");
        ct.println("\tDrag an object to compare layers, click 'Reset test' to reset layers");
        testObjs = getBasicTestObjs(11, 15);
        for (int i = 0; i < 5; i++)
            testObjs[i].setLayer(ct.inputInt("Enter a layer number for " + testObjs[i].getType() + " object"));
        testObjs[5] = ct.text(ct.formatInt(testObjs[0].getLayer()), 50, 30, 6);
        testObjs[6] = ct.text(ct.formatInt(testObjs[1].getLayer()), 50, 45, 6);
        testObjs[7] = ct.text(ct.formatInt(testObjs[2].getLayer()), 50, 60, 6);
        testObjs[8] = ct.text(ct.formatInt(testObjs[3].getLayer()), 50, 75, 6);
        testObjs[9] = ct.text(ct.formatInt(testObjs[4].getLayer()), 50, 90, 6);
        testObjs[10] = ct.text("Reset test", 90, 15, 5, "red");
    }

    public void deleteTest()
    {
        title.setText("delete Test");
        ct.println("**delete Test**");
        testObjs = getBasicTestObjs(5, 50);
        for (int i = 0; i < testObjs.length; i++)
        {
            testObjs[i].delete();
            testObjs[i].getType();
            testObjs[i].getText();
            testObjs[i].setText("deleted");
            testObjs[i].toString();
            testObjs[i].setSize(5, 5);
            testObjs[i].align("right", true);
            testObjs[i].setFillColor("green");
            testObjs[i].setFillColorRGB(255, 0, 0);
            testObjs[i].setLineColor("blue");
            testObjs[i].setLineColorRGB(0, 255, 255);
            testObjs[i].getLayer();
            testObjs[i].setLayer(2);
            testObjs[i].delete();
            testObjs[i].clicked();
            testObjs[i].containsPoint(50, 50);
            testObjs[i].hit(testObjs[i]);
            testObjs[i].objectHitInGroup("delete");
            testObjs[i].x = testObjs[i].x;
            testObjs[i].y = testObjs[i].y;
            testObjs[i].width = testObjs[i].width;
            testObjs[i].height = testObjs[i].height;
            testObjs[i].xSpeed = testObjs[i].xSpeed;
            testObjs[i].ySpeed = testObjs[i].ySpeed;
            testObjs[i].lineWidth = testObjs[i].lineWidth;
            testObjs[i].visible = testObjs[i].visible;
            testObjs[i].clickable = testObjs[i].clickable;
            testObjs[i].autoDelete = testObjs[i].autoDelete;
            testObjs[i].group = testObjs[i].group;
        }
        ct.println("Passed deletion, nothing should appear");
    }

    public void clickedTest()
    {
        title.setText("clicked Test");
        ct.println("**clicked Test**");
        ct.println("Click an object");
        testObjs = getBasicTestObjs(5, 50);
    }

    public void containsPointTest()
    {
        title.setText("containsPoint Test");
        ct.println("**containsPoint Test**");
        ct.println("The x-coords of the objects is 15");
        testObjs = getBasicTestObjs(6, 15);
        while (true)
        {
            double x = ct.inputNumber("Enter a x-coord value:");
            double y = ct.inputNumber("Enter a y-coord value (-1 to stop):");
            if (y == -1)
                break;
            testObjs[5] = ct.circle(x, y, 1, "black");
            for (int i = 0; i < testObjs.length - 1; i++)
            {
                if (testObjs[i].containsPoint(x, y))
                    ct.println(testObjs[i].getType() + " contains point (" + x + ", " + y + ")");
            }
        }
    }

    public void hitTest()
    {
        title.setText("hit Test");
        ct.println("**hit Test**");
        ct.println("Drag objects to hit one another");
        testObjs = getBasicTestObjs(8, 50);
        testObjs[5] = ct.line(65, 40, 65, 50);
        testObjs[6] = ct.line(60, 60, 70, 60);
        testObjs[7] = ct.line(60, 80, 70, 70);
    }

    public void objectHitInGroupTest()
    {
        title.setText("objectHitInGroup Test");
        ct.println("**objectHitInGroup Test**");
        ct.println("Drag objects to hit one another");
        testObjs = getBasicTestObjs(13, 50);
        for (int i = 5; i < 9; i++)
        {
            testObjs[i] = ct.circle(15, 50, 10, "blue");
            testObjs[i].group = "blue";
        }
        for (int i = 9; i < 12; i++)
        {
            testObjs[i] = ct.circle(85, 50, 10, "green");
            testObjs[i].group = "green";
        }
    }

    public void getsetTextClickAction(GameObj obj)
    {
        String input = ct.inputString("Enter a string to modify the object's text: ");
        obj.setText(input);
        testObjs[getTestObjIndex(obj) + 5].setText(obj.getText());
    }

    public void setSizeClickAction(GameObj obj)
    {
        ct.clearGroup("reference points");
        String type = obj.getType();
        double width = 1;
        if (!type.equals("text"))
            width = ct.inputNumber("Enter a width to modify the object's size:");
        double height = ct.inputNumber("Enter a height to modify the object's size:");
        obj.setSize(width, height);
        for (int i = 0; i < 5; i++)
            testObjs[i].setLayer(0);
        obj.setLayer(1);
        if (type.equals("text"))
        {
            testObjs[7] = ct.circle(obj.x, obj.y - height / 2, 1, "white");
            testObjs[8] = ct.circle(obj.x, obj.y + height / 2, 1, "white");
        }
        else if (type.equals("line"))
        {
            testObjs[5] = ct.circle(obj.x, obj.y + height / 2, 1, "white");
            testObjs[6] = ct.circle(obj.x + width, obj.y + height / 2, 1, "white");
            testObjs[7] = ct.circle(obj.x + width / 2, obj.y, 1, "white");
            testObjs[8] = ct.circle(obj.x + width / 2, obj.y + height, 1, "white");
        }
        else
        {
            testObjs[5] = ct.circle(obj.x - width / 2, obj.y, 1, "white");
            testObjs[6] = ct.circle(obj.x + width / 2, obj.y, 1, "white");
            testObjs[7] = ct.circle(obj.x, obj.y - height / 2, 1, "white");
            testObjs[8] = ct.circle(obj.x, obj.y + height / 2, 1, "white");
        }
        for (int i = 5; i < testObjs.length; i++)
        {
            if (testObjs[i] != null)
                testObjs[i].group = "reference points";
        }
        double userGivenArea = (testObjs[8].y - testObjs[7].y) * Math.pow(ct.getPixelsPerUnit(), 2);
        double objArea = obj.height * Math.pow(ct.getPixelsPerUnit(), 2);
        if (!type.equals("text"))
        {
            userGivenArea *= (testObjs[6].x - testObjs[5].x);
            objArea *= obj.width;
        }

        if (userGivenArea != objArea)
            ct.showAlert("ERROR: the object did not set it's height and/or width correctly");
    }

    public void alignClickAction(GameObj obj)
    {
        String input = ct.inputString("Enter an alignment: ('null' for null value):");
        if (input.equals("null"))
            input = null;
        obj.align(input);
        testObjs[getTestObjIndex(obj) + 5].align(input);
    }

    public void setFillLineColorClickAction(GameObj obj)
    {
        String input = ct.inputString("Enter a color: ('null' for null value):");
        if (input.equals("null"))
            input = null;
        String titleName = title.getText();
        if (titleName.equals("setFillColor Test"))
            obj.setFillColor(input);
        else
            obj.setLineColor(input);
        testObjs[getTestObjIndex(obj) + 27].setText(input);
    }

    public void setFillLineColorRGBClickAction(GameObj obj)
    {
        int r = ct.inputInt("Enter a red value:");
        int g = ct.inputInt("Enter a green value:");
        int b = ct.inputInt("Enter a blue value:");
        String titleName = title.getText();
        if (titleName.equals("setFillColorRGB Test"))
            obj.setFillColorRGB(r, g, b);
        else
            obj.setLineColorRGB(r, g, b);
        String rgb = "{" + r + ", " + g + ", " + b + "}";
        testObjs[getTestObjIndex(obj) + 40].setText(rgb);
    }

    public void getsetLayerClickAction()
    {
        deleteTestObjs();
        getsetLayerTest();
    }

    public void clickedClickAction(GameObj obj)
    {
        if (obj.clicked())
            ct.println(obj.getType() + " clicked");
    }

    public void hitDragAction()
    {
        for (int i = 0; i < testObjs.length; i++)
        {
            for (int j = 0; j < testObjs.length; j++)
            {
                if (i != j && testObjs[i].hit(testObjs[j]))
                    ct.println(testObjs[i] + " hit " + testObjs[j]);
            }
        }
    }

    public void objectHitInGroupDragAction()
    {
        for (int i = 0; i < 5; i++)
        {
            if (testObjs[i].objectHitInGroup("blue") != null)
                ct.println(testObjs[i] + " hit group blue " + testObjs[i].objectHitInGroup("blue"));
            else if (testObjs[i].objectHitInGroup("green") != null)
                ct.println(testObjs[i] + " hit group green " + testObjs[i].objectHitInGroup("green"));
        }
    }

    public GameObj[] getBasicTestObjs(int index, double x)
    {
        GameObj[] objArray = new GameObj[index];
        objArray[0] = ct.circle(x, 30, 10);
        objArray[1] = ct.rect(x, 45, 10, 10);
        objArray[2] = ct.line(x - 5, 55, x + 5, 65);
        objArray[3] = ct.text("code12", x, 75, 6);
        objArray[4] = ct.image("goldfish.png", x, 90, 15);
        return objArray;
    }

    public boolean clickedButton(GameObj obj)
    {
        for (int i = 0; i < screenButtons.length; i++)
        {
            if (obj == screenButtons[i] || obj == screenLabels[i])
                return true;
        }
        return false;
    }

    public boolean clickedTestObj(GameObj obj)
    {
        return getTestObjIndex(obj) != -1;
    }

    public int getTestObjIndex(GameObj obj)
    {
        for (int i = 0; i < testObjs.length; i++)
        {
            if (obj == testObjs[i])
                return i;
        }
        return -1;
    }

    public boolean isTestObjIndexWithin(GameObj obj, int min, int max)
    {
        int index = getTestObjIndex(obj);
        for (int i = min; i < max; i++)
        {
            if (index == i)
                return true;
        }
        return false;
    }

}
