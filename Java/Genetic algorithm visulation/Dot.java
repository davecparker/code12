
import Code12.*;

public class Dot {

  public static Game ct;
  public static GameObj goal;
  public static GameObj[] obstacles;
  public GameObj dot;
  public AIBrain brain;
  public boolean veteran;
  public boolean dead;
  
  public Dot(Game ct, GameObj goal, GameObj[] obstacles) {
    this.ct = ct;
    this.goal = goal;
    this.obstacles = obstacles;
    this.brain = new AIBrain();
    this.dot = ct.circle(ct.getWidth() / 2, ct.getHeight() - 2, 1);
    this.dot.setFillColor("blue");
  }
  
  public Dot(Game ct, GameObj goal, GameObj[] obstacles, AIBrain brain) {
    this.ct = ct;
    this.goal = goal;
    this.obstacles = obstacles;
    this.brain = brain;
    this.dot = ct.circle(ct.getWidth() / 2, ct.getHeight() - 2, 1);
    this.dot.setFillColor("blue");
  }

  public void setVeteran(boolean veteran) {
    this.veteran = veteran;
    if (veteran) {
      this.dot.setFillColor("green");
      this.dot.setLayer(2);
    }
  }

  public void killUponSpecifiedEvents(double windowWidth, double windowHeight) {
    killOutsideBoundary(windowWidth, windowHeight);
    killWithinGoal();
    killWithinObstacles();
    killOutOfDirections();
  }

  private void killOutsideBoundary(double windowWidth, double windowHeight) {
    if (isOutsideBoundary(windowWidth, windowHeight))
      kill();
  }

  private boolean isOutsideBoundary(double windowWidth, double windowHeight) {
    return (this.dot.x <= 0) || (this.dot.x >= windowWidth) || (this.dot.y <= 0) || (this.dot.y >= windowHeight);
  }

  private void killWithinGoal() {
    if (isWithinGoal())
      kill();
  }
  
  private boolean isWithinGoal() {
    return this.dot.hit(this.goal);
  }

  private void killWithinObstacles() {
    if (isWithinObstacles())
      kill();
  }

  private boolean isWithinObstacles() {
    for (int i = 0; i < this.obstacles.length; i++) {
      if (this.dot.hit(this.obstacles[i]))
        return true;
    }
    return false;
  }

  private void killOutOfDirections() {
    if (isOutOfDirections())
      kill();
  }

  private boolean isOutOfDirections() {
    return this.brain.step >= this.brain.directions.length;
  }
  
  public void kill() {
    this.dead = true;
    stopMoving();
  }
  
  public void stopMoving() {
    this.dot.xSpeed = 0;
    this.dot.ySpeed = 0;
  }

  public void move() {
    String newDirection = this.brain.getDirection();
    switch (newDirection) {
      case "up":
        this.dot.ySpeed = 1;
        break;
      case "up-right":
        dot.ySpeed = 1;
        dot.xSpeed = 1;
        break;
      case "up-left":
        dot.ySpeed = 1;
        dot.xSpeed = -1;
        break;
      case "down":
        this.dot.ySpeed = -1;
        break;
      case "down-right":
        dot.ySpeed = -1;
        dot.xSpeed = 1;
        break;
      case "down-left":
        dot.ySpeed = -1;
        dot.xSpeed = -1;
        break;
      case "right":
        this.dot.xSpeed = 1;
        break;
      case "left":
        this.dot.xSpeed = -1;
        break;
    }
    finishDirection();
  }

  private void finishDirection() {
    this.brain.incrementStep();
  }

  public double getFitness() {
    double distanceSquared = Math.pow(ct.distance(this.goal.x, this.goal.y, this.dot.x, this.dot.y), 2);
    double stepSquared = Math.pow(this.brain.step, 2);
    if (isWithinGoal())
      return (1 + (1 / stepSquared)) * 100000;
    return (1 / distanceSquared) * 10000;
  }

}