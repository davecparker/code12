class MainProgram
{   
   public void start()
   {
      ct.println("Hey");
      ct.setTitle("My Program");
      GameObj c = ct.circle(50, 30, 10);
      c.setFillColor("blue");
      ct.log(c);
   }
}
