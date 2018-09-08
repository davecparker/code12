
import Code12.*;

public class GraphingUtility extends Code12Program
{
    GameObj xAxis, yAxis, equationText;
    GameObj[] buttons = new GameObj[17];
    GameObj[] buttonTexts = new GameObj[17];
    String[] deconstructedExpression;
    String[] simplifiedExpression;
    String equation = "";

    public static void main(String[] args)
    {
        Code12.run(new GraphingUtility());
    }

    public void start()
    {
        ct.setBackColor("light gray");
        xAxis = ct.line(0, 50, 100, 50, "white");
        yAxis = ct.line(50, 0, 50, 100, "white");
        equationText = ct.text("", 5, 89.5, 2, "white");
        equationText.align("left", true);
        equationText.setLayer(2);

        defineButtons();
        enableButtons("x-0123456789");
        disableButtons("+*/^<");
    }

    public void onMouseRelease(GameObj obj, double x, double y)
    {
        String equationString = equationText.getText();
        if (obj == buttons[16] || obj == buttonTexts[16] && equationString.length() > 0)
            backspaceAction();
        for (int i = 0; i < buttons.length - 1; i++)
        {
            if (obj == buttons[i] || obj == buttonTexts[i] && buttons[i].clickable)
            {
                equationText.setText(equationText.getText() + buttonTexts[i].getText());
                enableButtons("x+-*/^0123456789<");
                disableButtons(getToBeDisabledButtons());
            }
        }
    }

    public void onKeyRelease(String keyName)
    {
        String equationString = equationText.getText();
        if (keyName.equals("backspace") && equationString.length() > 0)
            backspaceAction();
    }

    public void onCharTyped(String keyName)
    {
        for (int i = 0; i < buttons.length - 1; i++)
        {
            if (keyName.equals(buttonTexts[i].getText()) && buttons[i].clickable)
            {
                equationText.setText(equationText.getText() + buttonTexts[i].getText());
                enableButtons("x+-*/^0123456789<");
                disableButtons(getToBeDisabledButtons());
            }
        }
    }

    public void update()
    {
        if (hasEquationChanged() && isParseable())
        {
            ct.clearGroup("coordinates");
            equation = equationText.getText();
            deconstructExpression();
            defineLines();
        }
    }

    public void defineLines()
    {
        double y1 = -parse(-50) + 50;
        double y2 = -parse(-49.9) + 50;
        for (double x = 0; x < 100; x += 0.1)
        {
            defineLine(x, y1, x + 0.1, y2);
            y1 = y2;
            y2 = -parse(x - 49.9) + 50;
        }
    }

    public void defineLine(double x, double y, double x2, double y2)
    {
        GameObj line = ct.line(x, y, x2, y2, "light blue");
        line.lineWidth = 3;
        line.group = "coordinates";
    }

    public void defineButtons()
    {
        for (int i = 0; i < buttons.length; i++)
            defineButton(i);
    }

    public void defineButton(int i)
    {
        double x = 5 * i % 55 + ct.intDiv(i, 16) * 25 + 25;
        double y = 93.33 + ct.intDiv(i, 11) * 5;
        buttons[i] = ct.rect(x, y, 3, 1, "white");
        buttons[i].align("center", true);
        buttons[i].setLayer(2);
        buttonTexts[i] = ct.text(charAt("x0123456789+-*/^<", i), x, y, 1);
        buttonTexts[i].setLayer(2);
    }

    public void enableButtons(String buttonsString)
    {
        String[] buttonStrings = toCharArray(buttonsString);
        for (String buttonString: buttonStrings)
            enableButton(buttonString);
    }

    public void enableButton(String buttonString)
    {
        for (int i = 0; i < buttons.length; i++)
        {
            if (buttonString.equals(buttonTexts[i].getText()))
            {
                buttons[i].clickable = true;
                buttonTexts[i].clickable = true;
                buttonTexts[i].setFillColor("black");
                break;
            }
        }
    }

    public void disableButtons(String buttonsString)
    {
        String[] buttonStrings = toCharArray(buttonsString);
        for (String buttonString: buttonStrings)
            disableButton(buttonString);
    }

    public void disableButton(String buttonString)
    {
        for (int i = 0; i < buttons.length; i++)
        {
            if (buttonString.equals(buttonTexts[i].getText()))
            {
                buttons[i].clickable = false;
                buttonTexts[i].clickable = false;
                buttonTexts[i].setFillColor("red");
                break;
            }
        }
    }

    public String getToBeDisabledButtons()
    {
        String buttonString = getLastChar(equationText.getText());
        if (buttonString.equals("x"))
            return "x-0123456789";
        if (buttonString.equals("+") || buttonString.equals("*") || buttonString.equals("^") || buttonString.equals(""))
            return "+*/^";
        if (buttonString.equals("/"))
            return "0+*/^";
        if (buttonString.equals("-"))
            return "+-*/^";
        return "x-";
    }

    public void backspaceAction()
    {
        String equationString = equationText.getText();
        equationString = equationString.substring(0, equationString.length() - 1);
        equationText.setText(equationString);
        enableButtons("x+-*/^0123456789<");
        disableButtons(getToBeDisabledButtons());
        if (equationString.length() == 0)
            disableButton("<");
    }

    public void deconstructExpression()
    {
        String expression = equationText.getText();
        deconstructedExpression = new String[100];
        int count = 0;
        for (int i = 0; i < expression.length(); i++)
        {
            deconstructedExpression[count] = "";
            for (; i < expression.length() && isOperand(charAt(expression, i)); i++)
                deconstructedExpression[count] = deconstructedExpression[count] + charAt(expression, i);
            if (isOperator(charAt(expression, i)))
                deconstructedExpression[count + 1] = charAt(expression, i);
            count += 2;
        }
    }

    public void substituteXVariable(double x)
    {
        simplifiedExpression = new String[100];
        for (int i = 0; i < deconstructedExpression.length && deconstructedExpression[i] != null; i++)
        {
            String token = deconstructedExpression[i];
            if (token.equals("-x") && x > 0)
                simplifiedExpression[i] = "-" + ct.formatDecimal(x);
            else if (token.equals("-x") && x <= 0)
                simplifiedExpression[i] = ct.formatDecimal(Math.abs(x));
            else if (token.equals("x") || token.equals("-x") && x <= 0)
                simplifiedExpression[i] = ct.formatDecimal(x);
            else
                simplifiedExpression[i] = deconstructedExpression[i];
        }
    }

    public double parse(double x)
    {
        substituteXVariable(x);
        double solution = ct.parseNumber(simplifiedExpression[0]);
        for (int i = 1; i < simplifiedExpression.length && simplifiedExpression[i] != null; i++)
        {
            if (simplifiedExpression[i].equals("+"))
                solution += ct.parseNumber(simplifiedExpression[i + 1]);
            else if (simplifiedExpression[i].equals("*"))
                solution *= ct.parseNumber(simplifiedExpression[i + 1]);
            else if (simplifiedExpression[i].equals("/"))
                solution /= ct.parseNumber(simplifiedExpression[i + 1]);
            else if (simplifiedExpression[i].equals("^"))
                solution = Math.pow(solution, ct.parseNumber(simplifiedExpression[i + 1]));
        }
        return solution;
    }

    public boolean hasEquationChanged()
    {
        return !equation.equals(equationText.getText());
    }

    public boolean isParseable()
    {
        String equationChar = getLastChar(equationText.getText());
        return !equationChar.equals("+") && !equationChar.equals("-") && !equationChar.equals("*") && !equationChar.equals("/") && !equationChar.equals("^") && !equationChar.equals("");
    }

    public boolean isOperand(String value)
    {
        return value.equals("x") || value.equals("-") || value.equals(".") || value.equals("0") || value.equals("1") || value.equals("2") || value.equals("3") || value.equals("4") || value.equals("5") || value.equals("6") || value.equals("7") || value.equals("8") || value.equals("9");
    }

    public boolean isOperator(String value)
    {
        return value.equals("+") || value.equals("*") || value.equals("/") || value.equals("^");
    }

    public String[] toCharArray(String s)
    {
        String[] charArray = new String[s.length()];
        for (int i = 0; i < s.length(); i++)
            charArray[i] = charAt(s, i);
        return charArray;
    }

    public String getLastChar(String s)
    {
        return charAt(s, s.length() - 1);
    }

    public String charAt(String s, int i)
    {
        if (s.length() <= 0 || i < 0)
            return "";
        if (i == s.length())
            return s.substring(i);
        return s.substring(i, i + 1);
    }

}
