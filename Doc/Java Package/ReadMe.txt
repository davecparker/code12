Using the Code12 Java Package
=============================

The Code12 Java Package allows you to use the Code12 API outside of the
Code12 Application, with any standard Java development environment.
The Code12 Java Package is not required when using the Code12 Application.


Installing the Package
----------------------
1. Download the Code12 Java Package file (Code12-package.zip) from www.code12.org

2. Right-click and extract the zip file to a folder on your computer

3. Place the "Code12" folder as a subfolder in the folder where your Java source
   files are located, or ensure that the folder containing the "Code12" folder is 
   on the CLASSPATH in your Java development environment.


Adapting Your Code12 Java Programs
----------------------------------
There are a few small additions you need to make to your Code12 Java programs
to allow them to run outside the Code12 application using the Code12 Java Package:

    1. Make sure the class name in your program matches the name of the Java
       source code file, for example "class MyProgram" for MyProgram.java.

    2. Add "import Code12.*;" at the very top of the file.

    3. Add "extends Code12Program" at the end of your "class MyProgram" line.

    4. Add the following Java main function:

           public static void main(String[] args)
           { 
               Code12.run(new MyProgram()); 
           }
      
       IMPORTANT: Note that "MyProgram" above must be changed to match 
       the name of your class.


The following example program shows these additions, for an example Java program
file named "MyProgram.java".

    import Code12.*;

    class MyProgram extends Code12Program
    {
        public static void main( String[] args )
        { 
            Code12.run( new MyProgram() ); 
        }
   
        public void start()
        {
            ct.text( "Hello from Code12!", 50, 50, 15 );
        }
    }
