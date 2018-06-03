
import Code12.*;

public class AIBrain {

  private final String[] spatialDirections = {"up", "down", "left", "right", "up-right", "up-left", "down-right", "down-left"};
  public String[] directions;
  public int step = 0;

  public AIBrain() {
    this.directions = new String[600];
    randomizeDirections();
  }

  public String getDirection() {
    return this.directions[this.step];
  }

  public void incrementStep() {
    if (this.step <= this.directions.length - 1)
      this.step++;
  }

  private void randomizeDirections() {
    for (int i = 0; i < this.directions.length; i++) {
      int random = (int) (Math.random() * 8);
      this.directions[i] = this.spatialDirections[random];
    }
  }

  public void mutate() {
    for (int i = 0; i < 10; i++) {
      int randIndex = (int) (Math.random() * (this.directions.length - 1));
      int randDirection = (int) (Math.random() * 8);
      this.directions[randIndex] = this.spatialDirections[randDirection];
    }
  }

  public AIBrain clone() {
    AIBrain newBrain = new AIBrain();
    for (int i = 0; i < this.directions.length; i++)
      newBrain.directions[i] = this.directions[i];
    return newBrain;
  }

}
