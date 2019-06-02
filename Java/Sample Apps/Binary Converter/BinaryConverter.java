
class BinaryConverter
{
    int input;
    int digits = 0;
    String output = "";

    public void start()
    {
        // prompt for decimal integer
        input = ct.inputInt("Please enter a positive integer to convert to binary:");

        // calculate how many digits will be in the binary equivalent
        while (input >= Math.pow(2, digits))
            digits++;

        // spending method of binary conversion
        while (digits > 0)
        {
            int pow2 = (int) Math.pow(2, digits - 1);
            int bDigit = ct.intDiv(input, pow2);
            output = output + bDigit;
            if (bDigit == 1)
                input -= pow2;
            digits--;
        }

        // output result
        ct.println(output);
    }
}
