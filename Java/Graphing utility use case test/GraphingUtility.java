
import Code12.*;

public class GraphingUtility extends Code12Program
{
    GameObj xAxis, yAxis, equationText;
    GameObj[] buttons = new GameObj[17];
    GameObj[] buttonTexts = new GameObj[17];
    String[] deconstructedExpression;
    String equation = "";

    public static void main(String[] args)
    {
        Code12.run(new GraphingUtility());
    }

    public void start()
    {
        ct.setBackColor("light gray");
        xAxis = ct.line(0, ct.getHeight() / 2, ct.getWidth(), ct.getHeight() / 2, "white");
        xAxis.align("center", true);
        //xAxis.lineWidth = 2;
        yAxis = ct.line(ct.getWidth() / 2, 0, ct.getWidth() / 2, ct.getHeight(), "white");
        yAxis.align("center", true);
        //yAxis.lineWidth = 2;
        equationText = ct.text("", ct.getWidth() / 20, 7*ct.getHeight() / 8 + 2, 2, "white");
        equationText.align("left", true);
        equationText.setLayer(2);

        defineButtons();
        enableButtons("x-0123456789");
        disableButtons("+*/^<");
    }

    public void update()
    {
        for (int i = 0; i < buttons.length; i++)
        {
            String buttonString = buttonTexts[i].getText();
            if (buttons[i].clicked() && buttonString.equals("<"))
                backspaceAction();
            else if (buttons[i].clicked())
            {
                equationText.setText(equationText.getText() + buttonTexts[i].getText());
                enableButtons("x+-*/^0123456789<");
                disableButtons(getToBeDisabledButtons());
            }
        }

        if (hasEquationChanged() && isParseable())
        {
            ct.clearGroup("coordinates");
            equation = equationText.getText();
            deconstructExpression();
            for (double x = -0.05; x < ct.getWidth(); x += 0.1)
                defineLine(x);
        }
    }

    public void defineLine(double x)
    {
        GameObj line = ct.line(x, -parse(x - 50) + ct.getHeight() / 2, x + 0.1, -parse((x + 0.1) - 50) + ct.getHeight() / 2, "light blue");
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
        double x = 25 + 5 * (i % 11) + ct.intDiv(i, 16) * 25;
        double y = 5*ct.getHeight() / 6 + 10 + ct.intDiv(i, 11) * 5;
        buttons[i] = ct.rect(x, y, 3, 1, "white");
        buttons[i].align("center", true);
        buttons[i].setLayer(2);
        buttonTexts[i] = ct.text(charAt("x0123456789+-*/^<", i), x, y, 1);
        buttonTexts[i].align("center", true);
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
        String[] expressionArray = new String[expression.length()];
        int count = 0;
        for (int i = 0; i < expression.length(); i++)
        {
            if (isOperand(charAt(expression, i)))
                expressionArray[count] = expressionArray[count] + charAt(expression, i);
            else if (isOperator(charAt(expression, i)))
            {
                expressionArray[count + 1] = charAt(expression, i);
                count += 2;
            }
        }
        deconstructedExpression = expressionArray;
    }

    public double parse(double x)
    {
        String[] expression = substituteXVariable(x);
        double solution = ct.parseNumber(expression[0]);
        for (int i = 1; i < deconstructedExpression.length && expression[i] != null; i++)
        {
            if (expression[i].equals("+"))
                solution += ct.parseNumber(expression[i + 1]);
            else if (expression[i].equals("*"))
                solution *= ct.parseNumber(expression[i + 1]);
            else if (expression[i].equals("/"))
                solution /= ct.parseNumber(expression[i + 1]);
            else if (expression[i].equals("^"))
                solution = Math.pow(solution, ct.parseNumber(expression[i + 1]));
        }
        return solution;
    }

    public String[] substituteXVariable(double x)
    {
        String[] expression = new String[deconstructedExpression.length];
        for (int i = 0; i < deconstructedExpression.length; i++)
        {
            String token = deconstructedExpression[i];
            if (token.equals("-x") && x < 0)
                expression[i] = ct.formatDecimal(x);
            else if (token.equals("x") || token.equals("-x") && x > 0)
                expression[i] = ct.formatDecimal(x);
            else
                expression[i] = token;
        }
        return expression;
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
