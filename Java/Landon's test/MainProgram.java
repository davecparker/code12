import Code12.*;

public class MainProgram extends Code12Program {

  public GameObj goal;
  public GameObj timer;
  public double time;
  public GameObj gen;
  public int genCount;
  public GameObj[] obstacles = new GameObj[10];
  public Dot[] dots = new Dot[100];

  public static void main(String[] args) {
    Code12.run(new MainProgram());
  }

  public void start() {
    // goal
    this.goal = ct.circle(ct.getWidth() / 2, 2, 1);
    
    // timer
    this.timer = ct.text("0.0", 5, 5, 5);
    this.time = System.currentTimeMillis();
    
    // generation
    this.gen = ct.text("Gen 1", ct.getWidth() - 10, 5, 5);
    this.genCount = 1;
      
    // obstacles
    for (int i = 0; i < this.obstacles.length; i++) {
      int x = ct.random(0, (int) ct.getWidth());
      int y = ct.random(20, (int) ct.getHeight() - 20);
      int width = ct.random(1, 10);
      int height = ct.random(1, 10);
      this.obstacles[i] = ct.rect(x, y, width, height);
    }
    
    // dots
    for (int i = 0; i < this.dots.length; i++)
      this.dots[i] = new Dot(ct, this.goal, this.obstacles);
  }

  public void update() {
    // update timer
    this.timer.setText(tenSecondTimer());
    
    // conditional updates for dots
    for (int i = 0; i < this.dots.length; i++) {
      this.dots[i].killUponSpecifiedEvents(ct.getWidth(), ct.getHeight());
      if (!this.dots[i].dead)
        this.dots[i].move();
    }
    
    // if all dots are eliminated
    if (isAllDotsDead()) {
      int veteranIndex = getIndexOfMaxFitnessDot();
      AIBrain maxFitnessBrain = this.dots[veteranIndex].brain;
      for (int i = 0; i < this.dots.length; i++) {
        // reset dots
        this.dots[i].dot.delete();
        this.dots[i] = new Dot(ct, this.goal, this.obstacles, maxFitnessBrain.clone());
        
        // assign veteran
        if (i == veteranIndex) {
          this.dots[i].setVeteran(true);
          continue;
        }
        
        // mutate
        this.dots[i].brain.mutate();
      }
      
      // prep for next round
      resetTimer();
      updateGen();
    }
  }
  
  private String tenSecondTimer() {
    double time = -(((System.currentTimeMillis() - this.time) / 1000) - 10);
    if (time > 0)
      return ct.formatDecimal(time, 1);
    return "0.0";
  }
  
  private void resetTimer() {
    this.time = System.currentTimeMillis();
  }
  
  private void updateGen() {
    this.genCount++;
    this.gen.setText("Gen " + this.genCount);
  }
  
  private boolean isAllDotsDead() {
    for (int i = 0; i < this.dots.length; i++) {
      if (!this.dots[i].dead)
         return false;
    }
    return true;
  }
  
  private int getIndexOfMaxFitnessDot() {
    int maxFitnessIndex = 0;
    for (int i = 1; i < this.dots.length; i++) {
      if (this.dots[i].getFitness() > this.dots[maxFitnessIndex].getFitness())
        maxFitnessIndex = i;
    }
    return maxFitnessIndex;
  }

}