
import Code12.*;

public class GameObjCreationTest extends Code12Program
{
    GameObj[] screenButtons, screenLabels;
    GameObj title, speedRefrence, objText, fps;
    double objCount, time, inf, nan;
    String[] colors = {"black", "white", "red", "green", "blue", "cyan", "magenta", "yellow",
                        "gray", "orange", "pink", "purple",
                        "light gray", "light red", "light green", "light blue", "light cyan", "light magenta", "light yellow",
                        "dark gray", "dark red", "dark green", "dark blue", "dark cyan", "dark magenta", "dark yellow",
                        null};

    public static void main(String[] args)
    {
        Code12.run(new GameObjCreationTest());
    }

    public void start()
    {
        fps = null;
        time = 0;
        inf = 1 / 0.0;
        nan = 0 / 0.0;
        defineScreens();
        enableMainScreen();
    }

    public void defineScreens()
    {
        title = ct.text("", 50, 8, 8);
        screenButtons = new GameObj[7];
        screenLabels = new GameObj[7];
        screenButtons[0] = ct.rect(10, 2.5, 20, 5, "light blue");
        screenLabels[0] = ct.text("", 10, 2.5, 3);
        for (int i = 1; i < screenButtons.length; i++)
            screenButtons[i] = ct.rect(50, 12 * i + 12, 80, 8, "light blue");
        for (int i = 1; i < screenLabels.length; i++)
            screenLabels[i] = ct.text("", 50, 12 * i + 12, 3);
        disableScreens();
    }

    public void enableMainScreen()
    {
        title.setText("GameObj Creation Testing");
        String[] labels = {"", "Circle Tests", "Rect Tests", "Line Tests", "Text Tests", "Image Tests"};
        enableScreen(labels);
    }

    public void enableCircleScreen()
    {
        title.setText("Circle Tests");
        String[] labels = {"Back", "Diameter Test", "Inf & Nan Test", "Color Test", "Performance Test"};
        enableScreen(labels);
    }

    public void enableRectScreen()
    {
        title.setText("Rect Tests");
        String[] labels = {"Back", "Height & Width Test", "Inf & Nan Test", "Color Test", "Performance Test"};
        enableScreen(labels);
    }

    public void enableLineScreen()
    {
        title.setText("Line Tests");
        String[] labels = {"Back", "Coordinate Test", "Inf & Nan Test", "Color Test", "Performance Test"};
        enableScreen(labels);
    }

    public void enableTextScreen()
    {
        title.setText("Text Tests");
        String[] labels = {"Back", "String Test", "String Length Test", "Height Test", "Inf & Nan Test", "Color Test", "Performance Test"};
        enableScreen(labels);
    }

    public void enableImageScreen()
    {
        title.setText("Image Tests");
        String[] labels = {"Back", "Filename Test", "Width Test", "Inf & Nan Test", "Performance Test"};
        enableScreen(labels);
    }

    public void enableScreen(String[] labels)
    {
        for (int i = 0; i < labels.length; i++)
            screenButtons[i].visible = true;
        for (int i = 0; i < labels.length; i++)
        {
            screenLabels[i].setText(labels[i]);
            screenLabels[i].visible = true;
        }
    }

    public void disableScreens()
    {
        for (int i = 1; i < screenButtons.length; i++)
        {
            screenButtons[i].visible = false;
            screenLabels[i].visible = false;
        }
        ct.clearGroup("testObjs");
    }

    public void circleDiameterTest()
    {
        title.setText("Circle Diameter Test");
        for (int i = -10; i <= 10; i += 2)
        {
            double x = 4 * i + 50;
            double y = -3 * i + 63;
            GameObj circle = ct.circle(x, y, i);
            GameObj text = ct.text(ct.formatInt(i), x, y - 8, 3);
            circle.group = "testObjs";
            text.group = "testObjs";
        }
    }

    public void circleInfNanTest()
    {
        title.setText("Circle Inf & Nan Test");
        GameObj[] testObjs = new GameObj[10];
        testObjs[0] = ct.circle(inf, 50, 10);
        testObjs[1] = ct.circle(50, inf, 10);
        testObjs[2] = ct.circle(50, 50, inf);
        testObjs[3] = ct.circle(inf, inf, inf);
        testObjs[4] = ct.circle(nan, 50, 10);
        testObjs[5] = ct.circle(50, nan, 10);
        testObjs[6] = ct.circle(50, 50, nan);
        testObjs[7] = ct.circle(nan, nan, nan);
        testObjs[8] = ct.circle(inf, nan, 10);
        testObjs[9] = ct.circle(nan, inf, 10);
        for (int i = 0; i < testObjs.length; i++)
            testObjs[i].group = "testObjs";
    }

    public void circleColorTest()
    {
        title.setText("Circle Color Test");
        for (int i = 0; i < colors.length; i++)
        {
            double x = 12 * i % 96 + 6;
            double y = ct.intDiv(i, 8) * 18 + 30;
            GameObj circle = ct.circle(x, y, 10, colors[i]);
            GameObj text;
            if (i == 26)
                text = ct.text("null", x, y + 8, 2);
            else
                text = ct.text(colors[i], x, y + 8, 2);
            circle.group = "testObjs";
            text.group = "testObjs";
        }
    }

    public void circlePerformanceTest()
    {
        performanceTestUpdate();
        GameObj circle = ct.circle(ct.random(0, 100), ct.random(25, 100), 3);
        circle.group = "performanceObjs";
    }

    public void rectHeightWidthTest()
    {
        title.setText("Rect Height & Width Test");
        for (int i = -8; i <= 8; i += 2)
        {
            GameObj textWidth = ct.text(ct.formatInt(i), 5 * i + 55, 20, 3);
            GameObj textHeight = ct.text(ct.formatInt(i), 5, 4 * i + 60, 3);
            textWidth.group = "testObjs";
            textHeight.group = "testObjs";
            for (int j = -8; j <= 8; j += 2)
            {
                double x = 5 * j + 55;
                double y = 4 * i + 60;
                GameObj rect = ct.rect(x, y, i, j);
                rect.group = "testObjs";
            }
        }
    }

    public void rectInfNanTest()
    {
        title.setText("Rect Inf & Nan Test");
        GameObj[] testObjs = new GameObj[16];
        testObjs[0] = ct.rect(inf, 50, 50, 50);
        testObjs[1] = ct.rect(50, inf, 50, 50);
        testObjs[2] = ct.rect(50, 50, inf, 50);
        testObjs[3] = ct.rect(50, 50, 50, inf);
        testObjs[4] = ct.rect(50, 50, inf, inf);
        testObjs[5] = ct.rect(inf, inf, 50, 50);
        testObjs[6] = ct.rect(inf, inf, inf, inf);
        testObjs[7] = ct.rect(nan, 50, 50, 50);
        testObjs[8] = ct.rect(50, nan, 50, 50);
        testObjs[9] = ct.rect(50, 50, nan, 50);
        testObjs[10] = ct.rect(50, 50, 50, nan);
        testObjs[11] = ct.rect(50, 50, nan, nan);
        testObjs[12] = ct.rect(nan, nan, 50, 50);
        testObjs[13] = ct.rect(nan, nan, nan, nan);
        testObjs[14] = ct.rect(50, 50, inf, nan);
        testObjs[15] = ct.rect(50, 50, nan, inf);
        for (int i = 0; i < testObjs.length; i++)
            testObjs[i].group = "testObjs";
    }

    public void rectColorTest()
    {
        title.setText("Rect Color Test");
        for (int i = 0; i < colors.length; i++)
        {
            double x = 12 * i % 96 + 6;
            double y = ct.intDiv(i, 8) * 18 + 30;
            GameObj rect = ct.rect(x, y, 10, 10, colors[i]);
            GameObj text;
            if (i == 26)
                text = ct.text("null", x, y + 6, 2);
            else
                text = ct.text(colors[i], x, y + 6, 2);
            rect.group = "testObjs";
            text.group = "testObjs";
        }
    }

    public void rectPerformanceTest()
    {
        performanceTestUpdate();
        GameObj rect = ct.rect(ct.random(0, 100), ct.random(25, 100), 3, 3);
        rect.group = "performanceObjs";
    }

    public void lineCoordTest()
    {
        title.setText("Line Coordinate Test");
        for (int i = -8; i <= 8; i += 2)
        {
            GameObj textWidth = ct.text(ct.formatInt(i), 4 * i + 50, 20, 3);
            GameObj textHeight = ct.text(ct.formatInt(i), 5, 4 * i + 60, 3);
            textWidth.group = "testObjs";
            textHeight.group = "testObjs";
            for (int j = -8; j <= 8; j += 2)
            {
                double x1 = 4 * j + 50;
                double y1 = 4 * i + 60;
                double x2 = x1 + j / 2.0;
                double y2 = y1 + i / 2.0;
                GameObj line = ct.line(x1, y1, x2, y2);
                line.group = "testObjs";
            }
        }
    }

    public void lineInfNanTest()
    {
        title.setText("Line Inf & Nan Test");
        GameObj[] testObjs = new GameObj[20];
        testObjs[0] = ct.line(inf, 50, 50, 50);
        testObjs[1] = ct.line(50, inf, 50, 50);
        testObjs[2] = ct.line(50, 50, inf, 50);
        testObjs[3] = ct.line(50, 50, 50, inf);
        testObjs[4] = ct.line(50, 50, inf, inf);
        testObjs[5] = ct.line(inf, inf, 50, 50);
        testObjs[6] = ct.line(inf, 50, inf, 50);
        testObjs[7] = ct.line(50, inf, 50, inf);
        testObjs[8] = ct.line(inf, inf, inf, inf);
        testObjs[9] = ct.line(nan, 50, 50, 50);
        testObjs[10] = ct.line(50, nan, 50, 50);
        testObjs[11] = ct.line(50, 50, nan, 50);
        testObjs[12] = ct.line(50, 50, 50, nan);
        testObjs[13] = ct.line(50, 50, nan, nan);
        testObjs[14] = ct.line(nan, nan, 50, 50);
        testObjs[15] = ct.line(nan, nan, nan, nan);
        testObjs[16] = ct.line(inf, inf, nan, nan);
        testObjs[17] = ct.line(nan, nan, inf, inf);
        testObjs[18] = ct.line(inf, nan, inf, nan);
        testObjs[19] = ct.line(nan, inf, nan, inf);
        for (int i = 0; i < testObjs.length; i++)
            testObjs[i].group = "testObjs";
    }

    public void lineColorTest()
    {
        title.setText("Line Color Test");
        GameObj rect = ct.rect(30, 25, 8, 8, "black");
        rect.group = "testObjs";
        for (int i = 0; i < colors.length; i++)
        {
            double x = 15 * i % 90 + 10;
            double y = ct.intDiv(i, 6) * 15 + 20;
            GameObj line = ct.line(x, y, x + 10, y + 10, colors[i]);
            line.lineWidth = 5;
            GameObj text;
            if (i == 26)
                text = ct.text("null", x + 5, y + 11, 3);
            else
                text = ct.text(colors[i], x + 5, y + 11, 3);
            line.group = "testObjs";
            text.group = "testObjs";
        }
    }

    public void linePerformanceTest()
    {
        performanceTestUpdate();
        GameObj line = ct.line(ct.random(0, 100), ct.random(25, 100), ct.random(0, 100), ct.random(25, 100));
        line.group = "performanceObjs";
    }

    public void textStringTest()
    {
        title.setText("Text String Test");
        String[] stringArray = {null, "(1)\t(2)\t(3)", "(1)\n(2)\n(3)"};
        String[] labels = {"null", "tabs", "new lines"};
        for (int i = 0; i < stringArray.length; i++)
        {
            GameObj text = ct.text(stringArray[i], 55, 20 * i + 20, 5);
            GameObj label = ct.text(labels[i], 40, 20 * i + 20, 3);
            text.group = "testObjs";
            label.group = "testObjs";
        }
    }

    public void textStringLengthTest()
    {
        title.setText("Text String Length Test");
        String textString = "";
        int x = 25;
        for (double i = 0; i < 10.1; i++)
        {
            GameObj text = ct.text(textString, x, 8 * i + 20, 4);
            GameObj length = ct.text(ct.formatDecimal(text.width, 4), x - text.width / 2 - 8, text.y, 3);
            textString = textString + ct.formatDecimal(i, 0);
            text.group = "testObjs";
            length.group = "testObjs";
            if (i == 9)
            {
                i = 0.1;
                x += 55;
            }
        }
    }

    public void textHeightTest()
    {
        title.setText("Text Height Test");
        for (double i = -8; i <= 8; i += 2)
        {
            double x = 3.5 * i + 50;
            double y = -4 * i + 55;
            GameObj text = ct.text("code12", x, y, i);
            GameObj height = ct.text(ct.formatDecimal(i), x - 15, y, 3);
            text.group = "testObjs";
            height.group = "testObjs";
        }
    }

    public void textInfNanTest()
    {
        title.setText("Text Inf & Nan Test");
        GameObj[] testObjs = new GameObj[8];
        testObjs[0] = ct.text("code12", inf, 50, 10);
        testObjs[1] = ct.text("code12", 50, inf, 10);
        testObjs[2] = ct.text("code12", 50, 50, inf);
        testObjs[3] = ct.text("code12", inf, inf, inf);
        testObjs[4] = ct.text("code12", nan, 50, 10);
        testObjs[5] = ct.text("code12", 50, nan, 10);
        testObjs[6] = ct.text("code12", 50, 50, nan);
        testObjs[7] = ct.text("code12", nan, nan, nan);
        for (int i = 0; i < testObjs.length; i++)
            testObjs[i].group = "testObjs";
    }

    public void textColorTest()
    {
        title.setText("Text Color Test");
        GameObj rect = ct.rect(20, 35, 12, 5, "black");
        rect.group = "testObjs";
        for (int i = 0; i < colors.length; i++)
        {
            double x = 30 * ct.intDiv(i, 10) + 20;
            double y = i % 10 * 5 + 30;
            GameObj text = ct.text(colors[i], x, y, 5, colors[i]);
            if (i == 26)
                text.setText("null");
            text.group = "testObjs";
        }
    }

    public void textPerformanceTest()
    {
        performanceTestUpdate();
        GameObj text = ct.text("code12", ct.random(0, 100), ct.random(25, 100), 2);
        text.group = "performanceObjs";
    }

    public void imageFilenameTest()
    {
        title.setText("Image Filename Test");
        String[] stringArray = {"goldfish.png", "goldfish.pg", "goldfish", "", null, "jpg image.jpg", "code12 image.code12", "GameObjCreationTest.java"};
        for (int i = 0; i < stringArray.length; i++)
        {
            double y = 10 * i + 20;
            GameObj image = ct.image(stringArray[i], 60, y, 5);
            GameObj filename;
            if (i == 3)
                filename = ct.text("empty string", 40, y, 3);
            else if (i == 4)
                filename = ct.text("null", 40, y, 3);
            else
                filename = ct.text(stringArray[i], 40, y, 3);
            image.group = "testObjs";
            filename.group = "testObjs";
        }
    }

    public void imageWidthTest()
    {
        title.setText("Image Width Test");
        for (int i = -8; i <= 8; i += 2)
        {
            double y = 4.5 * i + 60;
            GameObj image = ct.image("goldfish.png", 50, y, i);
            GameObj width = ct.text(ct.formatInt(i), 40, y, 3);
            width.setLayer(2);
            image.group = "testObjs";
            width.group = "testObjs";
        }
    }

    public void imageInfNanTest()
    {
        title.setText("Image Inf & Nan Test");
        GameObj[] testObjs = new GameObj[8];
        testObjs[0] = ct.image("goldfish.png", inf, 50, 10);
        testObjs[1] = ct.image("goldfish.png", 50, inf, 10);
        testObjs[2] = ct.image("goldfish.png", 50, 50, inf);
        testObjs[3] = ct.image("goldfish.png", inf, inf, inf);
        testObjs[4] = ct.image("goldfish.png", nan, 50, 10);
        testObjs[5] = ct.image("goldfish.png", 50, nan, 10);
        testObjs[6] = ct.image("goldfish.png", 50, 50, nan);
        testObjs[7] = ct.image("goldfish.png", nan, nan, nan);
        for (int i = 0; i < testObjs.length; i++)
            testObjs[i].group = "testObjs";
    }

    public void imagePerformanceTest()
    {
        performanceTestUpdate();
        GameObj image = ct.image("goldfish.png", ct.random(0, 100), ct.random(25, 100), 3);
        image.group = "performanceObjs";
    }

    public void performanceTestPrep(String objType)
    {
        title.setText(objType + " Performance Test");
        speedRefrence = ct.circle(10, 20, 5, "green");
        speedRefrence.xSpeed = 4;
        speedRefrence.setLayer(2);
        speedRefrence.group = "performanceObjs";
        objText = ct.text("0", 90, 15, 5);
        objText.group = "performanceObjs";
        fps = ct.text("0.0", 10, 15, 5);
        fps.group = "performanceObjs";
        objCount = 0;
        time = ct.getTimer();
    }

    public void performanceTestUpdate()
    {
        String timePerFrame = ct.formatDecimal(1000 / (ct.getTimer() - time), 2);
        fps.setText(timePerFrame);
        ct.println(timePerFrame);
        if (speedRefrence.x >= 100 || speedRefrence.x <= 0)
           speedRefrence.xSpeed *= -1;
        objCount++;
        objText.setText(ct.formatDecimal(objCount));
        time = ct.getTimer();
    }

    public void update()
    {
        String titleName = title.getText();
        if (titleName.equals("Circle Performance Test"))
            circlePerformanceTest();
        else if (titleName.equals("Rect Performance Test"))
            rectPerformanceTest();
        else if (titleName.equals("Line Performance Test"))
            linePerformanceTest();
        else if (titleName.equals("Text Performance Test"))
            textPerformanceTest();
        else if (titleName.equals("Image Performance Test"))
            imagePerformanceTest();
        else
            ct.clearGroup("performanceObjs");
    }

    public void onMouseRelease(GameObj obj, double x, double y)
    {
        boolean objClicked = objClicked(obj);
        String titleName = title.getText();
        if (obj == screenButtons[0] || obj == screenLabels[0])
            backButtonAction();
        else if (objClicked && titleName.equals("GameObj Creation Testing"))
            mainScreenAction(obj);
        else if (objClicked && titleName.equals("Circle Tests"))
            circleScreenAction(obj);
        else if (objClicked && titleName.equals("Rect Tests"))
            rectScreenAction(obj);
        else if (objClicked && titleName.equals("Line Tests"))
            lineScreenAction(obj);
        else if (objClicked && titleName.equals("Text Tests"))
            textScreenAction(obj);
        else if (objClicked && titleName.equals("Image Tests"))
            imageScreenAction(obj);
    }

    public boolean objClicked(GameObj obj)
    {
        boolean objClicked = false;
        for (int i = 0; i < screenButtons.length; i++)
        {
            if (obj == screenButtons[i] || obj == screenLabels[i])
                objClicked = true;
        }
        return objClicked;
    }

    public void backButtonAction()
    {
        disableScreens();
        String titleName = title.getText();
        String titleLastChar = titleName.substring(titleName.length() - 1);
        String titleFirstChar = titleName.substring(0, 1);
        if (titleLastChar.equals("s") || titleLastChar.equals("g"))
            enableMainScreen();
        else if (titleFirstChar.equals("C"))
            enableCircleScreen();
        else if (titleFirstChar.equals("R"))
            enableRectScreen();
        else if (titleFirstChar.equals("L"))
            enableLineScreen();
        else if (titleFirstChar.equals("T"))
            enableTextScreen();
        else if (titleFirstChar.equals("I"))
            enableImageScreen();
    }

    public void mainScreenAction(GameObj obj)
    {
        disableScreens();
        if (obj == screenButtons[1] || obj == screenLabels[1])
            enableCircleScreen();
        else if (obj == screenButtons[2] || obj == screenLabels[2])
            enableRectScreen();
        else if (obj == screenButtons[3] || obj == screenLabels[3])
            enableLineScreen();
        else if (obj == screenButtons[4] || obj == screenLabels[4])
            enableTextScreen();
        else if (obj == screenButtons[5] || obj == screenLabels[5])
            enableImageScreen();
    }

    public void circleScreenAction(GameObj obj)
    {
        disableScreens();
        if (obj == screenButtons[1] || obj == screenLabels[1])
            circleDiameterTest();
        else if (obj == screenButtons[2] || obj == screenLabels[2])
            circleInfNanTest();
        else if (obj == screenButtons[3] || obj == screenLabels[3])
            circleColorTest();
        else if (obj == screenButtons[4] || obj == screenLabels[4])
            performanceTestPrep("Circle");
    }

    public void rectScreenAction(GameObj obj)
    {
        disableScreens();
        if (obj == screenButtons[1] || obj == screenLabels[1])
            rectHeightWidthTest();
        else if (obj == screenButtons[2] || obj == screenLabels[2])
            rectInfNanTest();
        else if (obj == screenButtons[3] || obj == screenLabels[3])
            rectColorTest();
        else if (obj == screenButtons[4] || obj == screenLabels[4])
            performanceTestPrep("Rect");
    }

    public void lineScreenAction(GameObj obj)
    {
        disableScreens();
        if (obj == screenButtons[1] || obj == screenLabels[1])
            lineCoordTest();
        else if (obj == screenButtons[2] || obj == screenLabels[2])
            lineInfNanTest();
        else if (obj == screenButtons[3] || obj == screenLabels[3])
            lineColorTest();
        else if (obj == screenButtons[4] || obj == screenLabels[4])
            performanceTestPrep("Line");
    }

    public void textScreenAction(GameObj obj)
    {
        disableScreens();
        if (obj == screenButtons[1] || obj == screenLabels[1])
            textStringTest();
        else if (obj == screenButtons[2] || obj == screenLabels[2])
            textStringLengthTest();
        else if (obj == screenButtons[3] || obj == screenLabels[3])
            textHeightTest();
        else if (obj == screenButtons[4] || obj == screenLabels[4])
            textInfNanTest();
        else if (obj == screenButtons[5] || obj == screenLabels[5])
            textColorTest();
        else if (obj == screenButtons[6] || obj == screenLabels[6])
            performanceTestPrep("Text");
    }

    public void imageScreenAction(GameObj obj)
    {
        disableScreens();
        if (obj == screenButtons[1] || obj == screenLabels[1])
            imageFilenameTest();
        else if (obj == screenButtons[2] || obj == screenLabels[2])
            imageWidthTest();
        else if (obj == screenButtons[3] || obj == screenLabels[3])
            imageInfNanTest();
        else if (obj == screenButtons[4] || obj == screenLabels[4])
            performanceTestPrep("Image");
    }

}
