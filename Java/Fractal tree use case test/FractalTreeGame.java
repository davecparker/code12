
import Code12.*;

public class FractalTreeGame extends Code12Program
{
    GameObj thetaSlider, branchLengthSlider;
    double playerTheta, prevPlayerTheta, referanceTheta, playerBranchLength, prevPlayerBranchLength, referanceBranchLength, randomTheta, randomBranchLength, thetaIncrement, branchLengthIncrement;
    boolean beginLevelTransition, endLevelTransition;

    public static void main(String[] args)
    {
        Code12.run(new FractalTreeGame());
    }

    public void start()
    {
        ct.setBackColor("dark gray");
        ct.line(12.5, 5, 87.5, 5, "white");
        thetaSlider = ct.circle(87.5, 5, 2, "white");
        thetaSlider.setLineColor("white");
        ct.line(12.5, 9, 87.5, 9, "white");
        branchLengthSlider = ct.circle(12.5, 9, 2, "white");
        branchLengthSlider.setLineColor("white");

        playerTheta = Math.PI;
        prevPlayerTheta = Math.PI;
        referanceTheta = Math.PI;
        playerBranchLength = 0;
        prevPlayerBranchLength = 0;
        referanceBranchLength = 0;
        randomTheta = Math.PI * (ct.random(1, 99) * 0.01);
        randomBranchLength = ct.random(180, 280) * 0.1;
        thetaIncrement = 0.5;
        branchLengthIncrement = 0.5;
        beginLevelTransition = true;
        endLevelTransition = false;
    }

    public void onMouseDrag(GameObj obj, double x, double y)
    {
        if ((obj == thetaSlider || obj == branchLengthSlider) && !beginLevelTransition && !endLevelTransition)
            updateSlider(obj, x);
    }

    public void onCharTyped(String ch)
    {
        if (!beginLevelTransition && !endLevelTransition)
        {
            if (thetaSlider.x <= 12.5 || thetaSlider.x >= 87.5)
                thetaIncrement *= -1;
            if (branchLengthSlider.x <= 12.5 || branchLengthSlider.x >= 87.5)
                branchLengthIncrement *= -1;
            updateSlider(thetaSlider, thetaSlider.x + thetaIncrement);
            updateSlider(branchLengthSlider, branchLengthSlider.x + branchLengthIncrement);
        }
    }

    public void update()
    {
        updatePlayerTree();
        if (beginLevelTransition)
            beginLevel();
        else if (endLevelTransition)
            endLevel();
        else if (hasPlayerWon())
        {
            ct.clearGroup("referance branches");
            randomTheta = Math.PI * (ct.random(1, 99) * 0.01);
            randomBranchLength = ct.random(180, 280) * 0.1;
            endLevelTransition = true;
        }
    }

    public void beginLevel()
    {
        ct.clearGroup("referance branches");
        if (referanceTheta > randomTheta)
            referanceTheta -= 0.02;
        if (referanceBranchLength < randomBranchLength)
            referanceBranchLength += 0.3;
        if (thetaSlider.x > 25)
            updateSlider(thetaSlider, thetaSlider.x - 0.5);
        if (referanceTheta <= randomTheta && referanceBranchLength >= randomBranchLength && thetaSlider.x <= 25)
            beginLevelTransition = false;
        updateReferanceTree();
    }

    public void endLevel()
    {
        updateSlider(thetaSlider, thetaSlider.x + 0.5);
        updateSlider(branchLengthSlider, branchLengthSlider.x - 0.5);
        if (thetaSlider.x >= 87.5 && branchLengthSlider.x <= 12.5)
        {
            referanceTheta = Math.PI;
            referanceBranchLength = 10;
            endLevelTransition = false;
            beginLevelTransition = true;
        }
    }

    public void defineBranches(double x1, double y1, double phi, double branchLength, int bundlesRemaining)
    {
        double x2 = branchLength * Math.cos(phi) + x1;
        double y2 = y1 - branchLength * Math.sin(phi);
        GameObj branch = ct.line(x1, y1, x2, y2, "white");
        branch.group = "player branches";
        if (bundlesRemaining > 0)
        {
            branchLength /= 1.45;
            bundlesRemaining--;
            defineBranches(x2, y2, phi + playerTheta, branchLength, bundlesRemaining);
            defineBranches(x2, y2, phi - playerTheta, branchLength, bundlesRemaining);
        }
    }

    public void defineReferanceBranches(double x1, double y1, double phi, double branchLength, int bundlesRemaining)
    {
        double x2 = branchLength * Math.cos(phi) + x1;
        double y2 = y1 - branchLength * Math.sin(phi);
        GameObj branch = ct.line(x1, y1, x2, y2, "light blue");
        branch.group = "referance branches";
        branch.setLayer(0);
        if (bundlesRemaining > 0)
        {
            branchLength /= 1.45;
            bundlesRemaining--;
            defineReferanceBranches(x2, y2, phi + referanceTheta, branchLength, bundlesRemaining);
            defineReferanceBranches(x2, y2, phi - referanceTheta, branchLength, bundlesRemaining);
        }
    }

    public void updateSlider(GameObj slider, double x)
    {
        if (x < 12.5)
            slider.x = 12.5;
        else if (x > 87.5)
            slider.x = 87.5;
        else
            slider.x = x;
    }

    public void updatePlayerTree()
    {
        playerTheta = Math.PI / 6 * (0.08 * thetaSlider.x - 1);
        playerBranchLength = 1.0 / 3 * (0.8 * branchLengthSlider.x + 20);
        if (playerTheta != prevPlayerTheta || playerBranchLength != prevPlayerBranchLength)
        {
            prevPlayerTheta = playerTheta;
            prevPlayerBranchLength = playerBranchLength;
            ct.clearGroup("player branches");
            defineBranches(50, 100, Math.PI / 2, playerBranchLength, 6);
        }
    }

    public void updateReferanceTree()
    {
        defineReferanceBranches(50, 100, Math.PI / 2, referanceBranchLength, 6);
    }

    public boolean hasPlayerWon()
    {
        return playerTheta > referanceTheta - 0.01 && playerTheta < referanceTheta + 0.01 && playerBranchLength > referanceBranchLength - 0.3 && playerBranchLength < referanceBranchLength + 0.3;
    }

}
