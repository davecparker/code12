class MainProgram
{   
   public void start()
   {
      ct.println("Hey");
      ct.setTitle("My Program");
      GameObj c = ct.circle(50, 30, 10);
      // c.align("back");
      // ct.image("foo", 50, 70, 20);
      c.setFillColor("blue");
      // ct.sound("hoy");
      ct.log(c);
   }
}
