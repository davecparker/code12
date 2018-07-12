
import Code12.*;

public class GraphingUtility extends Code12Program
{
    GameObj xAxis, yAxis, equationText;
    GameObj[] buttons = new GameObj[22];
    GameObj[] buttonTexts = new GameObj[22];
    String[] buttonTextLabels = {"x", ".", "+", "-", "*", "/", "^", "√", "(", ")", "←",
                                "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "more"};
    int parenthesisCount = 0;

    public static void main(String[] args)
    {
        Code12.run(new GraphingUtility());
    }

    public void start()
    {
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
        disableButtons(".+*/^√)←");
    }

    public void update()
    {
        for (int i = 0; i < buttons.length; i++)
        {
            if (buttons[10].clicked())
                backspaceAction();
            else if (buttons[20].clicked())
            {
            }
            else if (buttons[i].clicked())
            {
                incrementParenthesisCount(buttonTextLabels[i], false);
                enableButtons("x.+-*/^√()0123456789←");
                disableButtons(getToBeDisabledButtons(buttonTextLabels[i]));
                equationText.setText(equationText.getText() + buttonTextLabels[i]);
            }
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
        double y = 5*ct.getHeight() / 6 + 10 + ct.intDiv(i, 11) * 5;

        buttons[i] = ct.rect(x, y, 3, 1, "gray");
        buttons[i].align("center", true);
        buttons[i].clickable = true;
        buttons[i].setLayer(2);

        buttonTexts[i] = ct.text(buttonTextLabels[i], x, y, 1);
        buttonTexts[i].align("center", true);
        buttonTexts[i].setLayer(2);
    }

    // TODO: eliminate multiple decimals in one number
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
        if (buttonString.equals("x"))
            return "x.(0123456789";
        if (buttonString.equals("."))
            return "x.+-*/^√()";
        if (buttonString.equals("+") || buttonString.equals("-") || buttonString.equals("√"))
            return ".+-*/^√)";
        if (buttonString.equals("*") || buttonString.equals("/") || buttonString.equals("^"))
            return ".+*/^√)";
        if (buttonString.equals("("))
            return ".+*/^√)";
        if (buttonString.equals(")"))
            return "x.(0123456789";
        return "";
    }

    public void backspaceAction()
    {
        String equationString = equationText.getText();
        incrementParenthesisCount(pop(equationString), true);
        equationString = equationString.substring(0, equationString.length() - 1);
        equationText.setText(equationString);
        enableButtons("x.+-*/^√()0123456789←");
        disableButtons(getToBeDisabledButtons(pop(equationString)));
        if (equationString.length() == 0)
            disableButton("←");
    }

    public boolean isParseable()
    {
        String equationChar = pop(equationText.getText());
        if (equationChar.equals(".") || equationChar.equals("+") || equationChar.equals("-") || equationChar.equals("*") || equationChar.equals("/") || equationChar.equals("^") || equationChar.equals("√") || equationChar.equals("("))
            return false;
        return true;
    }

    public String parse(String expression, double x)
    {
        if (containsChar(expression, "("))
        {
            String expressionSub1 = expression.substring(0, expression.indexOf("("));
            String simplifiedExpression = parse(getParenthesisSubstring(expression), x);
            String expressionSub2 = expression.substring(expression.indexOf(")") + 1);
            return parse(expressionSub1 + parenthesisExpression + expressionSub2);
        }
        if (containsChar(expression, "^"))
        {
            String expressionSub1 = expression.substring(0, expression.indexOf(getBaseNumber(expression, charAt(expression, "^"))));
            String simplifiedExpression = Math.pow(getBaseNumber(expression, charAt(expression, "^")), getArgNumber(expression, charAt(expression, "^")));
            String expressionSub2 = ;
            return parse(expressionSub1 + ct.formatDecimal(simplifiedExpression) + );
        }
        if (containsChar(expression, "√"))
        {
            return parse();
        }
        if (containsChar(expression, "*") || containsChar(expression, "/"))
        {
            return parse();
        }
        if (containsChar(expression, "+") || containsChar(expression, "-"))
        {
            return parse();
        }
        return equation;
    }

    public String[] getEquationSubtrings(String equationString, String operand)
    {
        String[] expressions;
        if (operand.equals("("))
        {
            expressions = new String[3];
            expressions[0] = 
        }
        else if (operand.equals("√"))
        {

        }
        else
        {

        }

    }

    public int[] getBaseNumberIndexes(String equationString, int index)
    {
        int[] indexes = {0, index};
        for (int i = index; i > 0; i--)
        {
            String character = charAt(equationString, i);
            String newCharacter = "*";
            if (i - 1 > 0)
                newCharacter = charAt(equationString, i - 1)
            if (character.equals("-") && !newCharacter.equals("*") && !newCharacter.equals("/") && !newCharacter.equals("^") && !newCharacter.equals("√"))
                break;
            if (ct.canParseNumber(charAt(equationString, i) + number))
                indexes[0] = i;
        }
        return indexes;
    }

    public double getArgNumber(String equationString, int index)
    {
        String number = "";
        for (int i = index + 1; i < equationString.length(); i++)
        {
            if (ct.canParseNumber(number + charAt(equationString, i)))
                number += charAt(equationString, i);
        }
        return ct.parseNumber(number);
    }

    public double equationOutput(String solution)
    {
        return ct.parseNumber(solution);
    }

    public void incrementParenthesisCount(String buttonString, boolean backspaceAction)
    {
        if (buttonString.equals("(") && !backspaceAction || buttonString.equals(")") && backspaceAction)
            parenthesisCount++;
        else if (buttonString.equals(")") && !backspaceAction || buttonString.equals("(") && backspaceAction)
            parenthesisCount--;
    }

    public String getParenthesisSubstring(String equationString)
    {
        int subParenthesisCount = 1;
        int openingParenthesis = equationString.indexOf("(");
        int closingParenthesis = 0;
        for (int i = openingParenthesis + 2; i < equationString.length() - 1; i++)
        {
            String substring = charAt(equationString, i);
            if (substring.equals("("))
                subParenthesisCount++;
            else if (substring.equals(")"))
                subParenthesisCount--;
            if (subParenthesisCount == 0)
            {
                closingParenthesis = i;
                break;
            }
        }
        return equationString.substring(openingParenthesis + 1, closingParenthesis);
    }

    public String charAt(String string, int i)
    {
        if (string.length() == 0)
            return "";
        if (i == string.length())
            return string.substring(i);
        return string.substring(i, ++i);
    }

    public String pop(String string)
    {
        return charAt(string, string.length() - 1);
    }

    public boolean containsChar(String string, String value)
    {
        for (int i = 0; i < string.length(); i++)
        {
            if (i + value.length() > string.length())
            {
                if (value.equals(string.substring(i)))
                    return true;
            }
            else if (value.equals( string.substring(i, i + value.length()) ))
                return true;
        }
        return false;
    }

}
