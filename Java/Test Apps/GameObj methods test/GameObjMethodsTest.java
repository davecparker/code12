
class GameObjMethodsTest
{
    GameObj title, backButton, backText;
    GameObj[] screenButtons, screenLabels, testObjs;
    String[] alignments = {"center", "right", "bottom right", "bottom", "bottom left", "left", "top left", "top", "top right", null};
    String[] colors = {"black", "white", "red", "green", "blue", "cyan", "magenta", "yellow",
                        "gray", "orange", "pink", "purple",
                        "light gray", "light red", "light green", "light blue", "light cyan", "light magenta", "light yellow",
                        "dark gray", "dark red", "dark green", "dark blue", "dark cyan", "dark magenta", "dark yellow", null};

    public void start()
    {
        testObjs = new GameObj[10];
        defineScreens();
        enableMainScreen();
    }

    void defineScreens()
    {
        title = ct.text("", 50, 8, 8);
        backButton = ct.rect(10, 2.5, 20, 5, "light blue");
        backButton.setLayer(2);
        backText = ct.text("Back", 10, 2.5, 3);
        backText.setLayer(2);
        screenButtons = new GameObj[15];
        screenLabels = new GameObj[15];
        for (int i = 0; i < screenButtons.length; i++)
        {
            screenButtons[i] = ct.rect(25 + 50 * ct.intDiv(i, 8), 8 * (i % 8) + 30, 40, 5, "light blue");
            screenLabels[i] = ct.text("", 25 + 50 * ct.intDiv(i, 8), 8 * (i % 8) + 30, 3);
        }
        disableScreens();
    }

    void enableMainScreen()
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

    void disableScreens()
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

    void deleteTestObjs()
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

    void backButtonAction()
    {
        disableScreens();
        enableMainScreen();
    }

    void mainScreenAction(GameObj obj)
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

    public void update()
    {
        String titleName = title.getText();
        if (titleName.equals("clicked Test"))
            clickedUpdateAction();
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
        if (clickedTestObj(obj) && ((titleName.equals("get/setLayer Test") && isTestObjIndexWithin(obj, 0, 5)) || (titleName.equals("hit Test") && isTestObjIndexWithin(obj, 0, 5)) || titleName.equals("objectHitInGroup Test")))
            userMouseDragInteraction(obj, x, y);
    }

    void userMousePressInteraction(GameObj obj, double x, double y)
    {
        String titleName = title.getText();
        if (titleName.equals("get/setText Test") && isTestObjIndexWithin(obj, 0, 5))
            getsetTextClickAction(obj);
        else if (titleName.equals("setSize Test") && isTestObjIndexWithin(obj, 0, 5))
            setSizeClickAction(obj);
        else if (titleName.equals("align Test") && isTestObjIndexWithin(obj, 0, 5))
            alignClickAction(obj);
        else if (titleName.equals("setFillColor Test") || titleName.equals("setLineColor Test") && isTestObjIndexWithin(obj, 0, 27))
            setFillLineColorClickAction(obj);
        else if ((titleName.equals("setFillColorRGB Test") || titleName.equals("setLineColorRGB Test")) && isTestObjIndexWithin(obj, 0, 40))
            setFillLineColorRGBClickAction(obj);
        else if (titleName.equals("get/setLayer Test") && isTestObjIndexWithin(obj, 0, 5))
            getsetLayerClickAction(obj);
        else if (titleName.equals("containsPoint Test"))
            containsPointClickAction(obj, x, y);
        else if (titleName.equals("hit Test") && isTestObjIndexWithin(obj, 5, 10))
            hitClickAction(obj);
    }

    void userMouseDragInteraction(GameObj obj, double x, double y)
    {
        obj.x = x;
        obj.y = y;
        String titleName = title.getText();
        if (titleName.equals("hit Test"))
            hitDragAction();
        else if (titleName.equals("objectHitInGroup Test"))
            objectHitInGroupDragAction();
    }

    void getTypeTest()
    {
        title.setText("getType Test");
        ct.println("\n**getType Test**");
        testObjs = getBasicTestObjs(10, 15);
        for (int i = 5; i < 10; i++)
            testObjs[i] = ct.text(testObjs[i - 5].getType(), 50, 15 * i - 45, 6);
    }

    void getsetTextTest()
    {
        title.setText("get/setText Test");
        ct.println("\n**get/setText Test**");
        ct.println("\tClick an object to change its text");
        testObjs = getBasicTestObjs(10, 15);
        for (int i = 5; i < 10; i++)
            testObjs[i] = ct.text(testObjs[i - 5].getText(), 50, 15 * i - 45, 6);
    }

    void getsetTextClickAction(GameObj obj)
    {
        String input = ct.inputString("Enter a string to modify the object's text: ");
        obj.setText(input);
        testObjs[getTestObjIndex(obj) + 5].setText(obj.getText());
    }

    void toStringTest()
    {
        title.setText("toString Test");
        ct.println("\n**toString Test**");
        testObjs = getBasicTestObjs(10, 15);
        for (int i = 5; i < 10; i++)
            testObjs[i] = ct.text(testObjs[i - 5].toString(), 70, 15 * i - 45, 3);
        for (int i = 0; i < testObjs.length; i++)
            ct.println(testObjs[i]);
    }

    void setSizeTest()
    {
        title.setText("setSize Test");
        ct.println("\n**setSize Test**");
        ct.println("\tClick an object to set its size");
        ct.println("\tVerify that reference points are placed on the bisection\n\tof each edge of the object once you enter width and height");
        testObjs = getBasicTestObjs(9, 50);
    }

    void setSizeClickAction(GameObj obj)
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
        double objArea = obj.getHeight() * Math.pow(ct.getPixelsPerUnit(), 2);
        if (!type.equals("text"))
        {
            userGivenArea *= (testObjs[6].x - testObjs[5].x);
            objArea *= obj.getWidth();
        }
        if (userGivenArea != objArea)
            ct.showAlert("ERROR: the object did not set it's height and/or width correctly");
    }

    void alignTest()
    {
        // TODO: null parameter does not make fill color null
        title.setText("align Test");
        ct.println("\n**align Test**");
        ct.println("\tClick an object to set its alignment");
        ct.println("\tAlignments: 'top left', 'top', 'top right', 'left', 'center', 'right',\n'bottom left', 'bottom right'");
        testObjs = getBasicTestObjs(15, 50);
        for (int i = 5; i < 10; i++)
        {
            testObjs[i] = ct.rect(50, 15 * i - 45, testObjs[i - 5].getWidth(), testObjs[i - 5].getHeight(), null);
            testObjs[i].setFillColor(null);
            testObjs[i].setLineColor("green");
        }
        for (int i = 10; i < testObjs.length; i++)
            testObjs[i] = ct.circle(50, 15 * i - 120, 1, "black");
    }

    void alignClickAction(GameObj obj)
    {
        String input = ct.inputString("Enter an alignment: ('null' for null value):");
        if (input.equals("null"))
            input = null;
        obj.align(input);
        testObjs[getTestObjIndex(obj) + 5].align(input);
    }

    void setFillColorTest()
    {
        title.setText("setFillColor Test");
        ct.println("\n**setFillColor Test**");
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

    void setLineColor()
    {
        title.setText("setLineColor Test");
        ct.println("\n**setLineColor Test**");
        ct.println("\tClick an object to set its line color");
        GameObj[] testObjsCopy = new GameObj[54];
        for (int i = 0; i < 27; i++)
        {
            double x = 12 * i % 96 + 6;
            double y = ct.intDiv(i, 8) * 18 + 30;
            testObjsCopy[i] = ct.circle(x, y, 10, "light gray");
            testObjsCopy[i].setLineColor(colors[i]);
            testObjsCopy[i].setLineWidth(5);
            if (i == 26)
                testObjsCopy[i + 27] = ct.text("null", x, y + 8, 2);
            else
                testObjsCopy[i + 27] = ct.text(colors[i], x, y + 8, 2);
        }
        testObjs = testObjsCopy;
    }

    void setFillLineColorClickAction(GameObj obj)
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

    void setFillColorRGBTest()
    {
        title.setText("setFillColorRGB Test");
        ct.println("\n**setFillColorRGB Test**");
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

    void setLineColorRGBTest()
    {
        title.setText("setLineColorRGB Test");
        ct.println("\n**setLineColorRGB Test**");
        ct.println("\tClick an object to set its RGB line color");
        GameObj[] testObjsCopy = new GameObj[80];
        for (int i = 0; i < 40; i++)
        {
            int color = i * ct.intDiv(255, 40);
            double x = 12 * i % 96 + 8;
            double y = ct.intDiv(i, 8) * 15 + 30;
            testObjsCopy[i] = ct.rect(x, y, 8, 8, "light gray");
            testObjsCopy[i].setLineColorRGB(color, color, color);
            testObjsCopy[i].setLineWidth(5);
            String rgb = "{" + color + ", " + color + ", " + color + "}";
            testObjsCopy[i + 40] = ct.text(rgb, x, y + 8, 2);
        }
        testObjs = testObjsCopy;
    }

    void setFillLineColorRGBClickAction(GameObj obj)
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

    void getsetLayerTest()
    {
        title.setText("get/setLayer Test");
        ct.println("\n**get/setLayer Test**");
        ct.println("\tDrag an object to compare layers, release mouse to set layer");
        testObjs = getBasicTestObjs(10, 15);
        for (int i = 5; i < 10; i++)
            testObjs[i] = ct.text("1", 50, 15 * i - 45, 6);
    }

    void getsetLayerClickAction(GameObj obj)
    {
        obj.setLayer(ct.inputInt("Enter a layer number for " + obj.getType() + " object"));
        int i = getTestObjIndex(obj);
        testObjs[i + 5].setText(ct.formatInt(testObjs[i].getLayer()));
    }

    void deleteTest()
    {
        title.setText("delete Test");
        ct.println("\n**delete Test**");
        testObjs = getBasicTestObjs(5, 50);
        for (int i = 0; i < testObjs.length; i++)
        {
            testObjs[i].delete();
            String a = testObjs[i].getType();
            String b = testObjs[i].getText();
            testObjs[i].setText("deleted");
            String c = testObjs[i].toString();
            //testObjs[i].setSize(5, 5);
            testObjs[i].align("right");
            testObjs[i].setFillColor("green");
            testObjs[i].setFillColorRGB(255, 0, 0);
            //testObjs[i].setLineColor("blue");
            //testObjs[i].setLineColorRGB(0, 255, 255);
            int d = testObjs[i].getLayer();
            //testObjs[i].setLayer(2);
            testObjs[i].delete();
            boolean e = testObjs[i].clicked();
            boolean f = testObjs[i].containsPoint(50, 50);
            boolean g = testObjs[i].hit(testObjs[i]);
            GameObj h = testObjs[i].objectHitInGroup("delete");
            testObjs[i].x = testObjs[i].x;
            testObjs[i].y = testObjs[i].y;
            //testObjs[i].setSize(1, 1);
            double j = testObjs[i].getWidth();
            double k = testObjs[i].getHeight();
            testObjs[i].setXSpeed(testObjs[i].getXSpeed());
            testObjs[i].setYSpeed(testObjs[i].getYSpeed());
            //testObjs[i].setLineWidth(1);
            //testObjs[i].setClickable(true);
            testObjs[i].visible = testObjs[i].visible;
            testObjs[i].group = testObjs[i].group;
        }
        ct.println("\tPassed deletion");
    }

    void clickedTest()
    {
        title.setText("clicked Test");
        ct.println("\n**clicked Test**");
        ct.println("\tClick an object");
        testObjs = getBasicTestObjs(5, 50);
    }

    void clickedUpdateAction()
    {
        for (int i = 0; i < 5; i++)
        {
            if (testObjs[i].clicked())
                ct.println("\t" + testObjs[i].getType() + " clicked");
        }
    }

    void containsPointTest()
    {
        title.setText("containsPoint Test");
        ct.println("\n**containsPoint Test**");
        ct.println("\tClick the screen to place a point\n\tcoordinate should turn green if is within another object\n\tclick the text on the right to alter the object's size");
        testObjs = getBasicTestObjs(10000, 30);
        for (int i = 0; i < 5; i++)
            testObjs[i + 5] = ct.text("Set " + testObjs[i].getType() + "'s size", 75, 15 * i + 30, 4);
    }

    void containsPointClickAction(GameObj obj, double x, double y)
    {
        for (int i = 5; i < 10; i++)
        {
            if (obj == testObjs[i])
                testObjs[i - 5].setSize(ct.inputNumber("Enter a width:"), ct.inputNumber("Enter a height:"));
        }
        int i;
        for (i = 10; i < testObjs.length; i++)
        {
            if (testObjs[i] == null)
                break;
        }
        if (i != testObjs.length)
        {
            testObjs[i] = ct.circle(x, y, 1, "black");
            testObjs[i + 1] = ct.text("(" + ct.roundDecimal(x, 1) + ", " + ct.roundDecimal(y, 1) + ")", x + 3, y - 3, 3);
            for (int j = 0; j < 5; j++)
            {
                if (testObjs[j].containsPoint(x, y))
                {
                    testObjs[i].setFillColor("green");
                    testObjs[i].setLineColor("green");
                    testObjs[i + 1].setFillColor("green");
                    ct.println(testObjs[j].getType() + " contains point (" + x + ", " + y + ")");
                }
            }
        }
    }

    // TODO: set size as well
    void hitTest()
    {
        title.setText("hit Test");
        ct.println("\n**hit Test**");
        ct.println("\tDrag objects to hit one another");
        testObjs = getBasicTestObjs(10, 15);
        for (int i = 0; i < 5; i++)
            testObjs[i + 5] = ct.text("Set " + testObjs[i].getType() + "'s size", 85, 15 * i + 30, 3);
    }

    void hitClickAction(GameObj obj)
    {
        for (int i = 5; i < 10; i++)
        {
            if (obj == testObjs[i])
                testObjs[i - 5].setSize(ct.inputNumber("Enter a width:"), ct.inputNumber("Enter a height:"));
        }
    }

    void hitDragAction()
    {
        for (int i = 0; i < 5; i++)
        {
            for (int j = 0; j < 5; j++)
            {
                if (i != j && testObjs[i].hit(testObjs[j]))
                    ct.println("\t" + testObjs[i] + " hit " + testObjs[j]);
            }
        }
    }

    void objectHitInGroupTest()
    {
        title.setText("objectHitInGroup Test");
        ct.println("\n**objectHitInGroup Test**");
        ct.println("\tDrag objects to hit one another,\n\tthe blue circles are of group 'blue'\n\tthe green circles are of group 'green'");
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

    void objectHitInGroupDragAction()
    {
        for (int i = 0; i < 5; i++)
        {
            if (testObjs[i].objectHitInGroup("blue") != null)
                ct.println("\t" + testObjs[i] + " hit group blue " + testObjs[i].objectHitInGroup("blue"));
            else if (testObjs[i].objectHitInGroup("green") != null)
                ct.println("\t" + testObjs[i] + " hit group green " + testObjs[i].objectHitInGroup("green"));
        }
    }

    GameObj[] getBasicTestObjs(int index, double x)
    {
        GameObj[] objArray = new GameObj[index];
        objArray[0] = ct.circle(x, 30, 10);
        objArray[1] = ct.rect(x, 45, 10, 10);
        objArray[2] = ct.line(x - 5, 55, x + 5, 65);
        objArray[3] = ct.text("code12", x, 75, 6);
        objArray[4] = ct.image("goldfish.png", x, 90, 15);
        return objArray;
    }

    boolean clickedButton(GameObj obj)
    {
        for (int i = 0; i < screenButtons.length; i++)
        {
            if (obj == screenButtons[i] || obj == screenLabels[i])
                return true;
        }
        return false;
    }

    boolean clickedTestObj(GameObj obj)
    {
        return getTestObjIndex(obj) != -1;
    }

    int getTestObjIndex(GameObj obj)
    {
        if (obj == null)
            return -1;
        for (int i = 0; i < testObjs.length; i++)
        {
            if (obj == testObjs[i])
                return i;
        }
        return -1;
    }

    boolean isTestObjIndexWithin(GameObj obj, int min, int max)
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
