class Population {
  Dot[] dots;

  float fitnessSum;
  int gen = 1;

  int bestDot = 0;

  int minStep = 1000;

  Population(int size) {
    dots = new Dot[size];
    for (int i = 0; i< size; i++) {
      dots[i] = new Dot();
    }
  }

  void show() {
    for (int i = 1; i< dots.length; i++) {
      dots[i].show();
    }
    dots[0].show();
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
    setBestDot();

    newDots[0] = dots[bestDot].giveBaby();
    newDots[0].isBest = true;


    calculateFitnessSum();
    for (int i = 1; i< newDots.length; i++) {
      //select parent based on fitness
      Dot parent = selectParent();

      //get baby from them
      newDots[i] = parent.giveBaby();
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

  Dot selectParent() {
    float rand = random(fitnessSum);

    float runningSum = 0;

    for (int i = 0; i< dots.length; i++) {
      runningSum += dots[i].fitness;
      if (runningSum > rand) {
        return dots[i];
      }
    }

    return null;
  }

  void mutateBabies() {
    for (int i = 1; i< dots.length; i++) {
      dots[i].brain.mutate();
    }
  }

  void setBestDot() {
    int maxIndex = 0;
    float max = 0;

    for (int i=0; i<dots.length; i++) {
      if (dots[i].fitness > max) {
        max = dots[i].fitness;
        maxIndex = i;
      }
    }

    bestDot = maxIndex;

    if (dots[bestDot].reachedGoal) {
      minStep = dots[bestDot].brain.step;
      println("Step: ",minStep);
    }
  }
}
