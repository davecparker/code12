
class GraphingUtility
{
    GameObj[] buttons;
    GameObj equationText;
    String[] tokens, operators;
    double[] operands;
    String equation;

    public void start()
    {
        ct.setBackColor("dark gray");
        ct.setScreenOrigin(-50, -50); // the center of the screen is placed at (0, 0) to simulate a real graph

        // equationText stores the expression the user creates
        equationText = ct.text("", -45, 30, 5, "white");
        equationText.align("left");
        equationText.setLayer(2);

        // equation is a copy of the expression to verify if it has changed
        equation = "";

        /*
         * buttons contains all 24 buttons that are used to create expressions
         * x, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, <
         * ., +, -, *, /, %, !, ^, (, ), [, ]
         */
        buttons = new GameObj[24];
        defineButtons();
        disableButtons();

        // creates both x and y axes
        GameObj xAxis = ct.line(-50, 0, 50, 0, "white");
        GameObj yAxis = ct.line(0, -50, 0, 50, "white");
        xAxis.setLineWidth(2);
        yAxis.setLineWidth(2);
    }

// user input /////////////////////////////////////////////////////////////////

    // on mouse release, add button.getText to equationText or backspace
    public void onMouseRelease(GameObj obj, double x, double y)
    {
        if (isButton(obj))
        {   // only clickable buttons will be beyond this point
            String buttonText = obj.getText();
            if (buttonText.equals("<"))
                backspaceAction();
            else
            {   /*
                 * if the button is not the backspace button,
                 * enable all buttons then diables all buttons that shouldn't be used afterwards
                 */
                equationText.setText(equationText.getText() + buttonText);
                enableButtons();
                disableButtons();
            }
        }
    }

    // creates all 24 buttons with appropiate x, y, and text
    void defineButtons()
    {
        for (int i = 0; i < buttons.length; i++)
        {
            double x = 8 * i % 96 - 44;
            double y = 8 * ct.intDiv(i, 12) + 35;
            String c = charAt("x0123456789<.+-*/%!^()[]", i);
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

    // makes all buttons clickable
    void enableButtons()
    {
        for (int i = 0; i < buttons.length; i++)
        {
            buttons[i].setClickable(true);
            buttons[i].setFillColor("white");
        }
    }

    // makes all buttons unclickable according to the last clicked button
    void disableButtons()
    {
        String buttonTexts = getDisableButtons();
        for (String buttonText: toCharArray(buttonTexts))
            disableButton(buttonText);
    }

    // makes a single button unclickable
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

    // returns all button texts that should be disabled according to the last clicked button
    String getDisableButtons()
    {
        String c = getLastChar(equationText.getText());
        if (c.equals("."))
            return "x.+-*/%!^()[]";
        if (c.equals("+") || c.equals("*") || c.equals("/") || c.equals("%") || c.equals("^"))
            return "+*/%!^)]";
        if (c.equals("-"))
            return "+-*/%!^)]";
        if (c.equals("(") || c.equals("["))
            return "+*/%^)]";
        if (c.equals(""))
            return "+*/%!^)]<";
        return "";
    }

    // removes one single character from equationText
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

// program methods ////////////////////////////////////////////////////////////

    // if the equation has not been parsed, parse, and redefine coordinates
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

    // creates circles from [-50, 50] with the y value given from -parse(x)
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

// tokenization methods
    // tokenizes all items via operands and operators in equation and appends them to tokens
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

    // simplifies expression to help parsing
    String simplify(String expression)
    {
        expression = replaceSubtraction(expression);
        expression = replaceMultiplication(expression);
        return expression;
    }

    // replaces binary operation of subtraction to adding negatives
    String replaceSubtraction(String expression)
    {
        for (int i = 1; i < expression.length(); i++)
        {
            String c1 = charAt(expression, i - 1);
            String c2 = charAt(expression, i);
            if (!isBinaryOperator(c1) && !isBeginningGroupOperator(c1) && c2.equals("-")) // if '-' is being used as binary operator ex. x-2 => x+-2
                expression = expression.substring(0, i) + "+" + expression.substring(i);
        }
        return expression;
    }

    // replaces all implicit multiplication with explicit multiplication
    String replaceMultiplication(String expression)
    {
        for (int i = 0; i < expression.length(); i++)
        {
            String c1 = charAt(expression, i - 1);
            String c2 = charAt(expression, i);
            if (c1.equals("-") && (c2.equals("x") || c2.equals("(") || c2.equals("["))) // if '-x' exists, ex. 1+-x => 1+-1*x
                expression = expression.substring(0, i) + "1*" + expression.substring(i);
            else if (isImplicitMultiplication(c1, c2)) // ex. -x(1 + 3x)4x^3 => -1*x*(1 + 3*x)*4*x^3
                expression = expression.substring(0, i) + "*"  + expression.substring(i);
        }
        return expression;
    }

    // returns true if multiplication is implied between two characters, ex. 3x(x+1) => 3*x*(x+1)
    boolean isImplicitMultiplication(String c1, String c2)
    {
        boolean b1 = c1.equals("x") && (isOperand(c2) || c2.equals("."));
        boolean b2 = (c1.equals("x") || isOperand(c1)) && (c2.equals("x") || isBeginningGroupOperator(c2));
        boolean b3 = (c2.equals("x") || isOperand(c2)) && (c1.equals("!") || isEndingGroupOperator(c1));
        boolean b4 = isEndingGroupOperator(c1) && isBeginningGroupOperator(c2);
        boolean b5 = c1.equals("!") && isBeginningGroupOperator(c2);
        return b1 || b2 || b3 || b4 || b5;
    }

// value parsing methods
    /*
     * uses order of operations to evaluate an expression given a single value for x
     * algorithim used: https://en.wikipedia.org/wiki/Shunting-yard_algorithm
     */
    double parse(double x)
    {
        operands  = new double[tokens.length];
        operators = new String[tokens.length];
        for (int i = 0; i < tokens.length; i++)
        {
            if (tokens[i].equals("x"))
                pushD(operands, x);
            else if (isOperand(tokens[i]))
                pushD(operands, ct.parseNumber(tokens[i]));
            else if (isBeginningGroupOperator(tokens[i]))
                pushS(operators, tokens[i]);
            else if (isEndingGroupOperator(tokens[i]))
                parseGroupOperators(tokens[i]);
            else if (isOperator(tokens[i]))
                parseOperators(tokens[i]);
        }
        while (operators[0] != null)
            parseExpression();
        return operands[0];
    }

    // parses group operators
    void parseGroupOperators(String token)
    {
        String c;
        if (token.equals(")"))
            c = "(";
        else
            c = "[";
        while (!operators[0].equals(c))
            parseExpression();
        if (c.equals("["))
            operands[0] = Math.abs(operands[0]);
        popS(operators);
    }

    // parses operators
    void parseOperators(String token)
    {
        while (operators[0] != null && getPrecedence(operators[0]) >= getPrecedence(token))
            parseExpression();
        pushS(operators, token);
    }

    // parses expressions
    void parseExpression()
    {
        String operator = popS(operators);
        double operand1 = popD(operands);
        if (operator.equals("!"))
            pushD(operands, gamma(operand1 + 1));
        else
        {
            double operand2 = popD(operands);
            pushD(operands, apply(operator, operand2, operand1));
        }
    }

// operation applying methods
    // applys a binary operator to two operands
    double apply(String operator, double operand1, double operand2)
    {
        double value;
        if (operator.equals("+"))
            value = operand1 + operand2;
        else if (operator.equals("*"))
            value = operand1 * operand2;
        else if (operator.equals("/"))
            value = operand1 / operand2;
        else if (operator.equals("%"))
            value = operand1 % operand2;
        else if (operator.equals("^"))
            value = Math.pow(operand1, operand2);
        if (ct.isError(value))
            return 1 / 0.0;
        return value;
    }

    /*
     * used as translated factorial function
     * taken from: https://rosettacode.org/wiki/Gamma_function#Java
     * for more info visit: https://en.wikipedia.org/wiki/Gamma_function
     */
    double gamma(double x)
    {
        double[] p = {0.99999999999980993, 676.5203681218851, -1259.1392167224028,
                      771.32342877765313, -176.61502916214059, 12.507343278686905,
                      -0.13857109526572012, 9.9843695780195716e-6, 1.5056327351493116e-7};
        int g = 7;
        if(x < 0.5)
        {
            double value = Math.PI / (Math.sin(Math.PI * x) * gamma(1 - x));
            if (ct.isError(value))
                return 1 / 0.0;
            return value;
        }
        x -= 1;
        double a = p[0];
        double t = x + g + 0.5;
        for(int i = 1; i < p.length; i++)
            a += p[i] / (x + i);
        double value = Math.sqrt(2 * Math.PI) * Math.pow(t, x + 0.5) * Math.exp(-t) * a;
        if (ct.isError(value))
            return 1 / 0.0;
        return value;
    }

// helper methods /////////////////////////////////////////////////////////////

// parsing helper methods
    boolean hasEquationChanged()
    {
        return !equation.equals(equationText.getText());
    }

    boolean isParseable()
    {
        return isExpressionComplete() && areGroupOperatorsValid() && areDecimalsValid();
    }

    boolean isExpressionComplete()
    {
        String c = getLastChar(equationText.getText());
        return !isBinaryOperator(c) && !c.equals("");
    }

    boolean areGroupOperatorsValid()
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
        return parCount== 0 && absCount == 0;
    }

    boolean areDecimalsValid()
    {
        String equationString = equationText.getText();
        boolean isDecimal = false;
        for (int i = 0; i < equationString.length(); i++)
        {
            String c = charAt(equationString, i);
            if (c.equals(".") && isDecimal)
                return false;
            if (c.equals("."))
                isDecimal = true;
            else if (!ct.canParseNumber(c))
                isDecimal = false;
        }
        return true;
    }

// operator and operand helper methods
    int getPrecedence(String operator)
    {
        if (operator.equals("+") || operator.equals("-"))
            return 1;
        if (operator.equals("*") || operator.equals("/") || operator.equals("%") || operator.equals("!"))
            return 2;
        if (operator.equals("^"))
            return 3;
        return 0;
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

// button helper methods
    GameObj getButton(String buttonText)
    {
        for (int i = 0; i < buttons.length; i++)
        {
            if (buttonText.equals(buttons[i].getText()))
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

// array helper methods
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

// String helper methods
    String charAt(String s, int i)
    {
        if (s.length() <= 0 || i < 0)
            return "";
        if (i == s.length())
            return s.substring(i);
        return s.substring(i, i + 1);
    }

    String getLastChar(String s)
    {
        return charAt(s, s.length() - 1);
    }

    String[] toCharArray(String s)
    {
        String[] charArray = new String[s.length()];
        for (int i = 0; i < s.length(); i++)
            charArray[i] = charAt(s, i);
        return charArray;
    }

}
