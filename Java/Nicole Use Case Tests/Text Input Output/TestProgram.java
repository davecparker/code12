import Code12.*;

class TestProgram extends Code12Program
{
   String[] arr;

   public static void main(String[] args)
   { 
      Code12.run(new TestProgram()); 
   }
   
   public void start()
   {
      arr = new String[3];
      arr[0] = "small";
      arr[1] = "medium";
      arr[2] = "largest";
      
      for( int i = 0;  i < arr.length - 1;  i++ )
      {
         if ( arr[i].length() < arr[i+1].length() )
            ct.println( arr[i] + " is shorter than " + arr[i+1] );
      }
   }
  
}