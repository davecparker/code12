
class GraphingUtility
{
    GameObj xAxis, yAxis, equationText;
    GameObj[] buttons = new GameObj[17];
    GameObj[] buttonTexts = new GameObj[17];
    String[] deconstructedExpression;
    String[] simplifiedExpression;
    String equation = "";

    // TODO: make buttons turn red, not text, so buttonTexts can be deleted
    public void start()
    {
        ct.setBackColor("light gray");
        xAxis = ct.line(0, 50, 100, 50, "white");
        yAxis = ct.line(50, 0, 50, 100, "white");
        equationText = ct.text("", 5, 89.5, 2, "white");
        equationText.align("left");
        equationText.setLayer(2);

        defineButtons();
        enableButtons("x-0123456789");
        disableButtons("+*/^<");
    }

    public void onMouseRelease(GameObj obj, double x, double y)
    {
        // NOTE: new addition
        // TODO: verify this works
        if (isButton(obj))
        {
            String buttonText = obj.getText();
            if (buttonText.equals("<"))
                backspaceAction();
            else
            {
                equationText.setText(equationText.getText() + buttonText);
                enableButtons("x+-*/^0123456789<");
                disableButtons(getToBeDisabledButtons());
            }
        }

        // for (int i = 0; i < buttons.length - 1; i++)
        // {
        //     if (obj == buttons[i] || obj == buttonTexts[i] && buttons[i].clickable)
        //     {
        //         equationText.setText(equationText.getText() + buttonTexts[i].getText());
        //         enableButtons("x+-*/^0123456789<");
        //         disableButtons(getToBeDisabledButtons());
        //     }
        // }
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

    void defineLines()
    {
        double y1 = 50 - parse(-50);
        double y2 = 50 - parse(-49.9);
        for (double x = 0; x < 100; x += 0.1)
        {
            defineLine(x, y1, x + 0.1, y2);
            y1 = y2;
            y2 = 50 - parse(x - 49.9);
        }
    }

    void defineLine(double x1, double y1, double x2, double y2)
    {
        GameObj line = ct.line(x1, y1, x2, y2, "light blue");
        line.lineWidth = 3;
        line.group = "coordinates";
    }

    void defineButtons()
    {
        for (int i = 0; i < buttons.length; i++)
            defineButton(i);
    }

    void defineButton(int i)
    {
        double x = 5 * i % 55 + ct.intDiv(i, 16) * 25 + 25;
        double y = 93.33 + ct.intDiv(i, 11) * 5;
        String c = charAt("x0123456789+-*/^<", i);
        buttons[i] = ct.rect(x, y, 3, 1, "white");
        // NOTE: new addition
        buttons[i].setText(c);
        buttons[i].setLayer(2);
        buttons[i].group = "buttons";
        GameObj text = ct.text(c, x, y, 1);
        //text.setLayer(2);
        text.group = "buttons";
    }

    void enableButtons(String buttonsString)
    {
        String[] buttonStrings = toCharArray(buttonsString);
        for (String buttonString: buttonStrings)
            enableButton(buttonString);
    }

    void enableButton(String buttonString)
    {
        // NOTE: new addition
        GameObj button = getButton(buttonString);
        button.setClickable(true);
        // NOTE: button texts will still be able to be clicked if button is disabled
        // maybe place labels above buttons
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

    void disableButtons(String buttonsString)
    {
        String[] buttonStrings = toCharArray(buttonsString);
        for (String buttonString: buttonStrings)
            disableButton(buttonString);
    }

    void disableButton(String buttonString)
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

    String getToBeDisabledButtons()
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

    void backspaceAction()
    {
        if (equationString.length() > 0)
        {
            String equationString = equationText.getText();
            equationString = equationString.substring(0, equationString.length() - 1);
            equationText.setText(equationString);
            enableButtons("x+-*/^0123456789<");
            disableButtons(getToBeDisabledButtons());
            if (equationString.length() == 0)
                disableButton("<");
        }
    }

    void deconstructExpression()
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

    void substituteXVariable(double x)
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

    double parse(double x)
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

    boolean hasEquationChanged()
    {
        return !equation.equals(equationText.getText());
    }

    boolean isParseable()
    {
        String equationChar = getLastChar(equationText.getText());
        return !equationChar.equals("+") && !equationChar.equals("-") && !equationChar.equals("*") && !equationChar.equals("/") && !equationChar.equals("^") && !equationChar.equals("");
    }

    boolean isOperand(String value)
    {
        return value.equals("x") || value.equals("-") || value.equals(".") || value.equals("0") || value.equals("1") || value.equals("2") || value.equals("3") || value.equals("4") || value.equals("5") || value.equals("6") || value.equals("7") || value.equals("8") || value.equals("9");
    }

    boolean isOperator(String value)
    {
        return value.equals("+") || value.equals("*") || value.equals("/") || value.equals("^");
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

    // NOTE: new addition
    GameObj getButton(String buttonString)
    {
        for (int i = 0; i < buttons.length; i++)
        {
            if (buttonString.equals(buttons[i].getText()))
                return buttons[i];
        }
    }

    // NOTE: new addition
    boolean isButton(GameObj obj)
    {
        if (obj == null)
            return false;
        String group = obj.group;
        return group.equals("buttons");
    }

}
