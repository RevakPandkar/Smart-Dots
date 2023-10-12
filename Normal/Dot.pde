class Dot {

  PVector pos;
  PVector vel;
  PVector acc;
  Brain brain;

  float fitness = 0;

  boolean reachedGoal = false;
  boolean dead = false;
  boolean isBest = false;

  Dot() {

    brain = new Brain(1000);

    pos = new PVector(width/2, height - 10);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
  }

  void show() {

    if (isBest) {
      fill(0, 255, 0);
      ellipse(pos.x, pos.y, 8, 8);
    } else {
      fill(0);
      ellipse(pos.x, pos.y, 4, 4);
    }
  }

  void move() {

    if (brain.directions.length > brain.step) {
      acc = brain.directions[brain.step];
      brain.step++;
    } else {
      dead = true;
    }


    vel.add(acc);
    vel.limit(5);
    pos.add(vel);
  }

  void update() {
    if (!dead && !reachedGoal) {
      move();
    }

    if (pos.x< 2|| pos.y<2 || pos.x>width-2 || pos.y>height -2) {
      dead = true;
    } else if (dist(pos.x, pos.y, goal.x, goal.y) < 5) {
      reachedGoal = true;
    } else if (pos.x< 500 && pos.y < 310 && pos.x > 0 && pos.y > 300) {//if hit obstacle
      dead = true;
    } 
    else if (pos.x< 800 && pos.y < 510 && pos.x > 200 && pos.y > 500) {//if hit obstacle
      dead = true;
    }
  }

  void calculateFitness() {
    if (reachedGoal) {
      fitness = 1.0/16.0 + 10000.0/(float)(brain.step * brain.step);
    }  else {
      float distanceToGoal = dist(pos.x, pos.y, goal.x, goal.y);
      fitness = 1.0/(distanceToGoal * distanceToGoal);
    }
  }

  Dot giveBaby() {
    Dot baby = new Dot();
    baby.brain = brain.clone();   //babies have the same brain as their parents
    return baby;
  }
}
