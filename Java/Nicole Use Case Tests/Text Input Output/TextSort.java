import Code12.*;

class TextSort extends Code12Program
{
   String[] rows;
   String row0;
   String row1;
   String row2;
   String row3;
   String row4;
   String row5;
   String row6;
   String row7;
   String row8;
   String row9;
   
   String temp;
   int max;    //index of max value in subarray

   public static void main(String[] args)
   { 
      Code12.run(new TextSort()); 
   }
   
   public void start()
   {
      row0 = "***\n";
      row1 = "*******\n";
      row2 = "**\n";
      row3 = "***********\n";
      row4 = "*\n";
      row5 = "****\n";
      row6 = "****************\n";
      row7 = "******\n";
      row8 = "***\n";
      row9 = "*********\n";
           
      rows = new String[10];
      
      // Assign elements to array
      rows[0] = row0;
      rows[1] = row1;
      rows[2] = row2;
      rows[3] = row3;
      rows[4] = row4;
      rows[5] = row5;
      rows[6] = row6;
      rows[7] = row7;
      rows[8] = row8;
      rows[9] = row9;
      
      ct.println("-------------------");
      // Initial positions; unsorted
      for ( int i = 0; i < rows.length; i++ )
      {
         ct.print( rows[i] );
      }
      
      ct.println("-------------------");
      
      BubbleSort( rows );

   // Helper function to find index of longest String element
   public void sort(String[] array, int n)
   {
      for (int i=1 ;i<n; i++)
      {
         String temp = array[i];
 
         // Insert s[j] at its correct position
         int j = i - 1;
         while (j >= 0 && temp.length() < array[j].length())
         {
               array[j+1] = array[j];
               j--;
         }
         
         array[j+1] = temp;
      }
   }
   
   public void BubbleSort( String[] arr )
   {
      int j;
      boolean needsSorting = true;     // this is true to begin first pass through the array
      String temp;                     // placeholder variable

      while ( flag )
      {
         ct.println("---------------------");
         needsSorting = false;                  // set bool to false in case of a possible adjacent swap
                                                // this will exit the loop after the final pass
         for( j=0;  j < arr.length - 1;  j++ )
         {
            if ( arr[j].length() > arr[j+1].length() )   // compare length of current element w/ the next
            {
               temp = arr[ j ];                          // swap elements if the next element is shorter
               arr[ j ] = arr[ j+1 ];
               arr[ j+1 ] = temp;
               needsSorting = true;                      //shows a swap occurred 
            }
         }
            
         // print array each "generation"
         for ( int i = 0; i < arr.length; i++ )
         {
            ct.print( arr[i] );
         }
      }
   } 
   
   // TODO
   // add functions for:
   //    selection sort
   //    sequential search
   //    binary search as an example of more efficient searches
   
}