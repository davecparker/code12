class MainProgram
{   
   public void start()
   {
      ct.println("Hey");
      ct.setTitle("My Program");
      //GameObj x = ct.setTitle("My Program");
      GameObj c = ct.circle(50, 30, 10);
      if (ct.clicked()) 
         c.setFillColor("blue");
      Math.sin(50);
   }
}
