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
 
   int max;    //index of max value in subarray

   public static void main(String[] args)
   { 
      Code12.run(new TextSort()); 
   }
   
   public void start()
   {
      row0 = "***";
      row1 = "*******";
      row2 = "**";
      row3 = "***********";
      row4 = "*";
      row5 = "****";
      row6 = "****************";
      row7 = "******";
      row8 = "***";
      row9 = "*********";
           
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
      // Print the initial array, unsorted
      printArray( rows );
      
      // Uncomment each one seperately
      //bubbleSort( rows );
      insertionSort( rows );
      //selectionSort( rows );
   }
   
   // Helper function to print array and the number of asterisks in each row
   public void printArray( String[] arr )
   {
         for ( int i = 0; i < arr.length; i++ )
         {
            ct.println( arr[i] + " [" + arr[i].length() + "]"  );
         }
   }
   
   public void insertionSort( String[] arr )
   {
      String temp;
      
      for ( int j = 1; j < arr.length; j++ )
      {
         temp = arr[j];
         int i = j - 1;
         while (i >= 0)
         {
            if (temp.compareTo(arr[i]) > 0) 
               break;
            arr[i + 1] = arr[i];
            i--;
            ct.println("----------------------------");
            printArray( rows );
         }
         arr[i + 1] = temp;
      }
   }
   
   public void bubbleSort( String[] arr )
   {
      int j;
      boolean needsSorting = true;     // this is true to begin first pass through the array
      String temp;                     // placeholder variable in order to swap positions
      
      while ( needsSorting )
      {
         ct.println("----------------------------");
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
            
         printArray( arr );
      }
   } 
   
   public void selectionSort( String[] arr )
   {
      int min;
      String temp;
      //  The beginning of the array ( arr[0] ) to arr.length - 1
      for ( int i = 0; i < arr.length - 1; i++)
      {
         // assume the shortest string is the first element 
         min = arr[i].length();
         // test against elements after j to find the shortest 
         // index out of bounds
         for (int j = i + 1; j <= arr.length; j++)
         {
            // if this string element is shorter, then it is the new minimum
            if ( arr[j].compareTo(arr[min]) < 0 )
               min = j;
         }
         if ( arr[min].length() != arr[i].length() ) 
         {
            // swap(a[i], a[iMin]) to go from shortest to longest
            temp = arr[ i ];    
            arr[ i ] = arr[ min ];
            arr[ min ] = temp;
         }
         
         printArray( arr );
      }
   }

  
}