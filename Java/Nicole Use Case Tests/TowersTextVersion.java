/*Step 1: Move (n-1) discs from pole1 to pole2 (recursive)
Step 2: Move the nth disc (last disc) from pole1 to pole3.
Step 3: Move the n-1 discs which is present in pole2 to pole3 (recursive)
*/


import Code12.*;

class TowersTextVersion extends Code12Program
{
    int totalDisks;
    int count = 0;
   public static void main(String[] args)
   { 
      Code12.run(new TowersTextVersion()); 
   }
   
   public void start()
   {
        totalDisks = ct.inputInt("Enter total number of disks: ");
   }
   
   public void update()
   {
        solveTowers(totalDisks, "A", "B", "C" );
   }

    public void solveTowers(int top, String from, String inter, String to)
    {
        if (top == 1)
            ct.println("Disk 1 from " + from + " to " + to);
        else
        {
            solveTowers(top - 1, from, to, inter);
            ct.println("Disk " + top + " from " + from + " to " + to);
            solveTowers(top - 1, inter, from, to);
        }
    }

}