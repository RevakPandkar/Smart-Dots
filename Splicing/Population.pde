import java.util.Arrays;

class Population {
  Dot[] dots;

  float fitnessSum;
  int gen = 1;

  int bestDot1 = 0;
  int bestDot2 = 0;

  int minStep = 1000;

  Population(int size) {
    dots = new Dot[size];
    for (int i = 0; i< size; i++) {
      dots[i] = new Dot();
    }
  }

  void show() {
    for (int i = 2; i< dots.length; i++) {
      dots[i].show();
    }
    dots[0].show();
    dots[1].show();
  }

  void update() {
    for (int i = 0; i< dots.length; i++) {
      if (dots[i].brain.step > minStep) {
        dots[i].dead = true;
      } else {
        dots[i].update();
      }
    }
  }

  void calculateFitness() {
    for (int i = 0; i< dots.length; i++) {
      dots[i].calculateFitness();
    }
  }

  boolean allDotsDead() {
    for (int i = 0; i< dots.length; i++) {
      if (!dots[i].dead && !dots[i].reachedGoal) {
        return false;
      }
    }

    return true;
  }

  void naturalSelection() {
    Dot[] newDots = new Dot[dots.length];
    setBestDots();

    newDots[0] = dots[bestDot1].giveBaby();
    newDots[0].isBest = true;

    newDots[1] = dots[bestDot2].giveBaby();
    newDots[1].isBest = true;


    calculateFitnessSum();
    
    for (int i = 2; i < dots.length - 1; i += 2) {
      //select parents based on fitness
      Dot[] parents = selectParents();
      Dot[] offSprings = crossover(parents[0], parents[1]);

      newDots[i] = offSprings[0];
      newDots[i+1] = offSprings[1];
      
    }

    dots = newDots;
    gen ++;
  }

  void calculateFitnessSum() {
    fitnessSum = 0;
    for (int i = 0; i< dots.length; i++) {
      fitnessSum += dots[i].fitness;
    }
  }

  Dot[] selectParents() {

    Dot[] parents = {null, null};
    float randA = random(fitnessSum);
    float randB = random(fitnessSum);

    float runningSum = 0;

    for (int i = 0; i< dots.length; i++) {
      runningSum += dots[i].fitness;
      if (runningSum > randA && parents[0] == null) {
        parents[0] = dots[i];
      }
      if (runningSum > randB && parents[1] == null) {
        parents[1] = dots[i];
      }
    }

    return parents;
  }

  Dot[] crossover(Dot parentA, Dot parentB) {
    int rand = (int) random(parentA.brain.directions.length - 2);
    
    Dot[] offSprings = {new Dot(),new Dot()};
    
    PVector[] helper1 = new PVector[rand+1];
    PVector[] helper2 = new PVector[parentA.brain.directions.length - rand - 1];
    
    helper1 = Arrays.copyOfRange(parentA.brain.directions,0,rand);
    helper2 = Arrays.copyOfRange(parentB.brain.directions,rand+1,parentB.brain.directions.length-1);
    
    int aLen = helper1.length;
    int bLen = helper2.length;
    
    System.arraycopy(helper1, 0, offSprings[0].brain.directions, 0, aLen);
    System.arraycopy(helper2, 0, offSprings[0].brain.directions, aLen, bLen);
    
    
    PVector[] helper3 = new PVector[rand+1];
    PVector[] helper4 = new PVector[parentB.brain.directions.length - rand - 1];
    
    helper3 = Arrays.copyOfRange(parentB.brain.directions,0,rand);
    helper4 = Arrays.copyOfRange(parentA.brain.directions,rand+1,parentB.brain.directions.length-1);
    
    int cLen = helper3.length;
    int dLen = helper4.length;

    System.arraycopy(helper3, 0, offSprings[1].brain.directions, 0, cLen);
    System.arraycopy(helper4, 0, offSprings[1].brain.directions, cLen, dLen);
    
    return offSprings;
  }

  void mutateBabies() {
    for (int i = 2; i< dots.length; i++) {
      dots[i].brain.mutate();
    }
  }

  void setBestDots() {
    int maxIndex = 0;
    float max = 0;

    for (int i=0; i<dots.length; i++) {
      if (dots[i].fitness > max) {
        max = dots[i].fitness;
        maxIndex = i;
      }
    }

    bestDot1 = maxIndex;

    max = 0;
    maxIndex = 0;

    for (int i=0; i<dots.length; i++) {
      if (i == bestDot1) {
        continue;
      }
      if (dots[i].fitness > max) {
        max = dots[i].fitness;
        maxIndex = i;
      }
    }

    bestDot2 = maxIndex;

    if (dots[bestDot1].reachedGoal || dots[bestDot2].reachedGoal) {
      if (dots[bestDot1].brain.step < dots[bestDot2].brain.step) {
        minStep = dots[bestDot1].brain.step;
      } else {
        minStep = dots[bestDot2].brain.step;
      }
      println("Step: ", minStep);
    }
  }
}
