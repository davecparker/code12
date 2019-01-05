
class GraphingUtility
{
    GameObj[] buttons;
    GameObj equationText;
    String[] tokens;
    String equation;

    public void start()
    {
        ct.setBackColor("dark gray");
        ct.setScreenOrigin(-50, -50);

        buttons = new GameObj[24];

        GameObj xAxis = ct.line(-50, 0, 50, 0, "white");
        GameObj yAxis = ct.line(0, -50, 0, 50, "white");
        xAxis.setLineWidth(2);
        yAxis.setLineWidth(2);

        equationText = ct.text("", -45, 30, 5, "white");
        equationText.align("left");
        equationText.setLayer(2);

        equation = "";

        defineButtons();
        disableButtons();
    }

    public void onMouseRelease(GameObj obj, double x, double y)
    {
        if (isButton(obj))  // NOTE: if obj is not clickable, obj == null
        {                   // NOTE: only clickable buttons will be beyond this point
            String buttonText = obj.getText();
            if (buttonText.equals("<"))
                backspaceAction();
            else
            {
                equationText.setText(equationText.getText() + buttonText);
                enableButtons();
                disableButtons();
            }
        }
    }

    public void update()
    {
        if (hasEquationChanged() && isParseable())
        {
            ct.clearGroup("coordinates");
            equation = equationText.getText();
            tokenize();
            defineCoords();
        }
    }

    void defineCoords()
    {
        for (double x = -50; x <= 50; x += 0.2)
        {
            double y = -parse(x);
            if (y >= -50 && y <= 50)
            {
                GameObj coord = ct.circle(x, y, 0.5, "light red");
                coord.setLineWidth(0);
                coord.group = "coordinates";
            }
        }
    }

    void defineButtons()
    {
        for (int i = 0; i < buttons.length; i++)
        {
            double x = 8 * i % 96 - 44;
            double y = 8 * ct.intDiv(i, 12) + 35;
            String c = charAt("x0123456789<.+-*/%^()[]!", i);
            buttons[i] = ct.rect(x, y, 5, 3, "white");
            buttons[i].setText(c);
            buttons[i].setLayer(2);
            buttons[i].setLineWidth(0);
            buttons[i].group = "buttons";
            GameObj text = ct.text(c, x, y, 2);
            text.setLayer(2);
            text.setClickable(false);
            text.group = "buttons";
        }
    }

    void enableButtons()
    {
        for (int i = 0; i < buttons.length; i++)
        {
            buttons[i].setClickable(true);
            buttons[i].setFillColor("white");
        }
    }

    void disableButtons()
    {
        String buttonTexts = getDisableButtons();
        for (String buttonText: toCharArray(buttonTexts))
            disableButton(buttonText);
    }

    void disableButton(String buttonText)
    {
        for (int i = 0; i < buttons.length; i++)
        {
            if (buttonText.equals(buttons[i].getText()))
            {
                buttons[i].setClickable(false);
                buttons[i].setFillColor("light red");
                break;
            }
        }
    }

    String getDisableButtons()
    {
        String c = getLastChar(equationText.getText());
        if (c.equals("."))
            return "x.+-*/%^()[]!";
        if (c.equals("+") || c.equals("*") || c.equals("/") || c.equals("%") || c.equals("^"))
            return "+*/%^)]!";
        if (c.equals("-"))
            return "+-*/%^)]!";
        if (c.equals("(") || c.equals("["))
            return "+*/%^)]";
        if (c.equals(""))
            return "+*/%^)]<";
        return "";
    }

    void backspaceAction()
    {
        String equationString = equationText.getText();
        if (equationString.length() > 0)
        {
            equationString = equationString.substring(0, equationString.length() - 1);
            equationText.setText(equationString);
            enableButtons();
            disableButtons();
        }
    }

    void tokenize()
    {
        String expression = simplify(equation);
        String[] de = new String[expression.length()];
        for (int i = 0; i < expression.length(); i++)
        {
            String operand = getOperand(expression, i);
            if (operand != null)
            {
                append(de, operand);
                i += operand.length() - 1;
            }
            else
                append(de, charAt(expression, i));
        }
        tokens = resize(de);
    }

    String simplify(String expression)
    {
        expression = replaceSubtraction(expression);
        expression = replaceMultiplication(expression);
        return expression;
    }

    String replaceSubtraction(String expression)
    {
        for (int i = 1; i < expression.length(); i++)
        {
            String c1 = charAt(expression, i - 1);
            String c2 = charAt(expression, i);
            if (!isBinaryOperator(c1) && c2.equals("-")) // if '-' is being used as binary operator ex. x-2 => x+-2
                expression = expression.substring(0, i) + "+" + expression.substring(i);
        }
        return expression;
    }

    String replaceMultiplication(String expression)
    {
        for (int i = 0; i < expression.length(); i++)
        {
            String c1 = charAt(expression, i - 1);
            String c2 = charAt(expression, i);
            if (c1.equals("-") && c2.equals("x")) // if '-x' exists, ex. 1+-x => 1+-1*x
                expression = expression.substring(0, i) + "1*" + expression.substring(i);
            else if (isImplicitMultiplication(c1, c2)) // ex. -x(1 + 3x)4x^3 => -1*x*(1 + 3*x)*4*x^3
                expression = expression.substring(0, i) + "*"  + expression.substring(i);
        }
        return expression;
    }

    boolean isImplicitMultiplication(String c1, String c2)
    {
        boolean b1 = c1.equals("x") && (isOperand(c2) || c2.equals("."));
        boolean b2 = (c1.equals("x") || isOperand(c1)) && (c2.equals("x") || isBeginningGroupOperator(c2));
        boolean b3 = (c2.equals("x") || isOperand(c2)) && (c1.equals("!") || isEndingGroupOperator(c1));
        boolean b4 = isEndingGroupOperator(c1) && isBeginningGroupOperator(c2);
        boolean b5 = c1.equals("!") && isBeginningGroupOperator(c2);
        return b1 || b2 || b3 || b4 || b5;
    }

    String getOperand(String expression, int i)
    {
        for (int j = expression.length(); j > i; j--)
        {
            String operand = expression.substring(i, j);
            if (isOperand(operand))
                return operand;
        }
        return null;
    }

    String[] resize(String[] array)
    {
        int length;
        for (length = 0; length < array.length; length++)
        {
            if (array[length] == null)
                break;
        }
        String[] newArray = new String[length];
        for (int i = 0; i < length; i++)
            newArray[i] = array[i];
        return newArray;
    }

    // TODO: add pemdas, use isError to check division by zero: if so, make y value off screen
    double parse(double x)
    {
        String[] operators = new String[tokens.length];
        double[] operands  = new double[tokens.length];
        for (int i = 0; i < tokens.length; i++)
        {
            if (tokens[i].equals("x"))
                pushD(operands, x);
            else if (isOperand(tokens[i]))
                pushD(operands, ct.parseNumber(tokens[i]));
            else if (isBeginningGroupOperator(tokens[i]))
                pushS(operators, tokens[i]);
            else if (isEndingGroupOperator(tokens[i]))
            {
                // TODO: add support for []
                while (!operators[0].equals("("))
                {
                    ct.println(i);
                    String operator = popS(operators);
                    double operand1 = popD(operands);
                    if (operator.equals("!"))
                        pushD(operands, fac(operand1));
                    else
                    {
                        double operand2 = popD(operands);
                        pushD(operands, apply(operator, operand2, operand2));
                    }
                }
                popS(operators);
            }
            else if (isOperator(tokens[i]))
            {
                while (operators[0] != null && getPrecedence(operators[0]) >= getPrecedence(tokens[i]))
                {
                    String operator = popS(operators);
                    double operand1 = popD(operands);
                    if (operator.equals("!"))
                        pushD(operands, fac(operand1));
                    else
                    {
                        double operand2 = popD(operands);
                        pushD(operands, apply(operator, operand2, operand1));
                    }
                }
                pushS(operators, tokens[i]);
            }
        }
        while (operators[0] != null)
        {
            String operator = popS(operators);
            double operand1 = popD(operands);
            if (operator.equals("!"))
                pushD(operands, fac(operand1));
            else
            {
                double operand2 = popD(operands);
                pushD(operands, apply(operator, operand2, operand1));
            }
        }
        ct.println("operands:");
        for (int j = 0; j < tokens.length; j++)
            ct.println(operands[j]);
        ct.println("operators:");
        for (int j = 0; j < tokens.length; j++)
            ct.println(operators[j]);
        ct.println();
        return operands[0];
    }

    double apply(String operator, double operand1, double operand2)
    {
        double value = (operand1 * operand2) / Math.abs(operand1 * operand2);
        if (operator.equals("+"))
            value = operand1 + operand2;
        else if (operator.equals("*"))
            value = operand1 * operand2;
        else if (operator.equals("/"))
            value = operand1 / operand2;
        else if (operator.equals("%"))
            value = value * operand1 % operand2;
        else if (operator.equals("^"))
            value = Math.pow(operand1, operand2);
        if (ct.isError(value))
            return 1 / 0.0;
        return value;
    }

    double popD(double[] array)
    {
        double value = 1 / 0.0;
        for (int i = array.length - 1; i >= 0; i--)
        {
            double tmp = array[i];
            array[i] = value;
            value = tmp;
        }
        return value;
    }

    String popS(String[] array)
    {
        String value = null;
        for (int i = array.length - 1; i >= 0; i--)
        {
            String tmp = array[i];
            array[i] = value;
            value = tmp;
        }
        return value;
    }

    void pushD(double[] array, double value)
    {
        for (int i = 0; i < array.length; i++)
        {
            double tmp = array[i];
            array[i] = value;
            value = tmp;
        }
    }

    void pushS(String[] array, String value)
    {
        for (int i = 0; i < array.length; i++)
        {
            String tmp = array[i];
            array[i] = value;
            value = tmp;
        }
    }

    int getPrecedence(String operator)
    {
        if (operator.equals("+") || operator.equals("-"))
            return 1;
        if (operator.equals("*") || operator.equals("/") || operator.equals("%") || operator.equals("!"))
            return 2;
        if (operator.equals("^"))
            return 3;
        if (isGroupOperator(operator))
            return 4;
        return 0;
    }

    void append(String[] array, String value)
    {
        for (int i = array.length - 1; i >= 0; i--)
        {
            if (array[i] != null)
            {
                array[i + 1] = value;
                break;
            }
        }
        if (array[0] == null)
            array[0] = value;
    }

    double fac(double x)
    {
        if (x <= 0)
            return 1;
        return (int) x * fac(x - 1);
    }

    boolean hasEquationChanged()
    {
        return !equation.equals(equationText.getText());
    }

    // TODO: no multiple '.' per number
    boolean isParseable()
    {
        int parCount = 0;
        int absCount = 0;
        String equationString = equationText.getText();
        for (int i = 0; i < equationString.length(); i++)
        {
            String c = charAt(equationString, i);
            if (c.equals("("))
                parCount++;
            else if (c.equals(")"))
                parCount--;
            else if (c.equals("["))
                absCount++;
            else if (c.equals("]"))
                absCount--;
            if (parCount < 0 || absCount < 0)
                return false;
        }
        String c = getLastChar(equationString);
        return !isBinaryOperator(c) && !c.equals("") && parCount == 0 && absCount == 0;
    }

    boolean isOperand(String s)
    {
        String c = charAt(s, 0);
        if (c.equals("+"))
            return false;
        return ct.canParseNumber(s);
    }

    boolean isOperator(String s)
    {
        return s.equals("!") || isBinaryOperator(s) || isGroupOperator(s);
    }

    boolean isBinaryOperator(String s)
    {
        return s.equals("+") || s.equals("-") || s.equals("*") || s.equals("/") || s.equals("%") || s.equals("^");
    }

    boolean isGroupOperator(String s)
    {
        return isBeginningGroupOperator(s) || isEndingGroupOperator(s);
    }

    boolean isBeginningGroupOperator(String s)
    {
        return s.equals("(") || s.equals("[");
    }

    boolean isEndingGroupOperator(String s)
    {
        return s.equals(")") || s.equals("]");
    }

    boolean isItemIn(String s, String[] array)
    {
        for (int i = 0; i < array.length; i++)
        {
            if (s.equals(array[i]))
                return true;
        }
        return false;
    }

    String[] toCharArray(String s)
    {
        String[] charArray = new String[s.length()];
        for (int i = 0; i < s.length(); i++)
            charArray[i] = charAt(s, i);
        return charArray;
    }

    String getLastChar(String s)
    {
        return charAt(s, s.length() - 1);
    }

    String charAt(String s, int i)
    {
        if (s.length() <= 0 || i < 0)
            return "";
        if (i == s.length())
            return s.substring(i);
        return s.substring(i, i + 1);
    }

    GameObj getButton(String buttonString)
    {
        for (int i = 0; i < buttons.length; i++)
        {
            if (buttonString.equals(buttons[i].getText()))
                return buttons[i];
        }
        return null;
    }

    boolean isButton(GameObj obj)
    {
        if (obj == null)
            return false;
        String group = obj.group;
        return group.equals("buttons");
    }

}
