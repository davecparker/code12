
import Code12.*;

public class GraphingUtility extends Code12Program
{

    GameObj xAxis, yAxis, equationText;
    GameObj[] buttons = new GameObj[22];
    GameObj[] buttonTexts = new GameObj[22];
    String[] buttonTextLabels = {"x", ".", "+", "-", "*", "/", "!", "^", "(", ")", "←",
                                "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "more"};
    int parenthesisCount = 0;

    public static void main(String[] args)
    {
        Code12.run(new GraphingUtility());
    }

    public void start()
    {
        ct.setHeight(150);

        xAxis = ct.line(0, ct.getHeight() / 2, ct.getWidth(), ct.getHeight() / 2);
        xAxis.align("center", true);
        xAxis.lineWidth = 2;

        yAxis = ct.line(ct.getWidth() / 2, 0, ct.getWidth() / 2, ct.getHeight());
        yAxis.align("center", true);
        yAxis.lineWidth = 2;

        equationText = ct.text("", ct.getWidth() / 20, 7*ct.getHeight() / 8 + 2, 2);
        equationText.align("left", true);
        equationText.setLayer(2);

        defineButtons();
        disableButtons(".+*/!^)←");
    }

    public void update()
    {
        for (int i = 0; i < buttons.length; i++)
        {
            // Backspace
            if (buttons[10].clicked())
                backspaceAction();

            else if (buttons[i].clicked())
            {
                incrementParenthesisCount(parenthesisCount, buttonTextLabels[i], false);

                enableButtons("x.+-*/!^()0123456789←");
                disableButtons(getToBeDisabledButtons(buttonTextLabels[i]));

                equationText.setText(equationText.getText() + buttonTextLabels[i]);
            }

            //if (buttonTextLabels[i].equals("more"))
            //    continue;
        }

        if (isParseable())
        {
            for (double x = 0; x < ct.getHeight(); x += 0.1)
            {
                //GameObj coordnate = ct.circle(x, equationOutput(x) + ct.getHeight() / 2, 1, "light blue");
                //coordnate.setLineColor("light blue");
            }
        }
    }

    public void defineButtons()
    {
        for (int i = 0; i < buttons.length; i++)
            defineButton(i);
    }

    public void defineButton(int i)
    {
        double x = 25 + 5 * (i % 11);
        double y = 7*ct.getHeight() / 8 + 10 + ct.intDiv(i, 11) * 5;

        buttons[i] = ct.rect(x, y, 3, 1, "gray");
        buttons[i].align("center", true);
        buttons[i].clickable = true;
        buttons[i].setLayer(2);

        buttonTexts[i] = ct.text(buttonTextLabels[i], x, y, 1);
        buttonTexts[i].align("center", true);
        buttonTexts[i].setLayer(2);
    }

    public void disableButtons(String buttonsString)
    {
        for (int i = 0; i < buttonsString.length(); i++)
            disableButton(charAt(buttonsString, i));
        if (parenthesisCount == 0)
            disableButton(")");
    }

    public void disableButton(String buttonString)
    {
        for (int i = 0; i < buttons.length; i++)
        {
            if (buttonString.equals(buttonTextLabels[i]))
            {
                buttons[i].clickable = false;
                buttonTexts[i].setFillColor("red");
                break;
            }
        }
    }

    public void enableButtons(String buttonsString)
    {
        for (int i = 0; i < buttonsString.length(); i++)
            enableButton(charAt(buttonsString, i));
    }

    public void enableButton(String buttonString)
    {
        for (int i = 0; i < buttons.length; i++)
        {
            if (buttonString.equals(buttonTextLabels[i]))
            {
                buttons[i].clickable = true;
                buttonTexts[i].setFillColor("black");
                break;
            }
        }
    }

    public String getToBeDisabledButtons(String buttonString)
    {
        if (buttonString.equals("x") || buttonString.equals("!"))
            return "x.(0123456789";
        if (buttonString.equals("."))
            return "x.+-*/!^()";
        if (buttonString.equals("+") || buttonString.equals("-"))
            return ".+-*/!^)";
        if (buttonString.equals("*") || buttonString.equals("/") || buttonString.equals("^"))
            return ".+*/!^)";
        if (buttonString.equals("("))
            return ".+*/!^)";
        if (buttonString.equals(")"))
            return "x.(0123456789";
        return "";
    }

    public void backspaceAction()
    {
        String equationString = equationText.getText();
        incrementParenthesisCount(parenthesisCount, pop(equationString), true);
        equationString = equationString.substring(0, equationString.length() - 1);
        equationText.setText(equationString);
        enableButtons("x.+-*/!^()0123456789←");
        disableButtons(getToBeDisabledButtons(pop(equationString)));
        if (equationString.length() == 0)
            disableButton("←");
    }

    public void incrementParenthesisCount(int count, String buttonString, boolean backspaceAction)
    {
        if (buttonString.equals("(") && !backspaceAction || buttonString.equals(")") && backspaceAction)
            count++;
        else if (buttonString.equals(")") && !backspaceAction || buttonString.equals("(") && backspaceAction)
            count--;
    }

    public String pop(String string)
    {
        return charAt(string, string.length() - 1);
    }

    public String charAt(String string, int i)
    {
        if (string.length() == 0)
            return "";
        if (i == string.length())
            return string.substring(i);
        return string.substring(i, ++i);
    }

    public boolean isParseable()
    {
        String equationChar = pop(equationText.getText());
        if (equationChar.equals(".") || equationChar.equals("+") || equationChar.equals("-") || equationChar.equals("*") || equationChar.equals("/")|| equationChar.equals("^") || equationChar.equals("("))
            return false;
        return true;
    }

    public double equationOutput(String equation, double x)
    {
        String equationString = equationText.getText();
        // for (int i = 0; i < equationString.length() - 1; i++)
        // {
        //     String equationSubString = equationString.substring(i, i + 1);
        //     if (equationSubString.equals("("))
        //     {
        //         int substringParenthesisCount = 1;
        //         for (int j = i; substringParenthesisCount; j++)
        //             incrementParenthesisCount(substringParenthesisCount, j, false);
        //
        //     }
        // }
        return 0;
    }

    // TODO: needs fixing
    public boolean containsChar(String string, String value)
    {
        for (int i = 0; i < string.length() - 1; i++)
        {
            String substring = string.substring(i, i + 1);
            if (substring.equals(value))
                return true;
        }
        return false;
    }

    public String grabParenthesisSubstring()
    {
        return "";
    }

    public int factorial(int x)
    {
        if (x == 0)
            return 1;
        if (x > 10)
            return 0;
        return x * factorial(--x);
    }

}
