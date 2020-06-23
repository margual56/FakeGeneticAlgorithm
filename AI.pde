class AI {
  PVector pos; //the position of the AI
  PVector acc = new PVector(0, 0);
  ArrayList<PVector> genes = new ArrayList<PVector>(); //A list of all the genes it has

  float size = 0.5; //The size of the triangle
  int currentGen = 0; //The index of the current gene

  float fitness = 0; //The final score for the AI (not set yet)
  float dSum = 0; //The sum of all distances (used to calculate the fitness)
  float angle = 0; //The angle it is moving to
  boolean dead = false; //Whether it is dead or not

  AI(int n) { //Constructor, n is the number of genes

    pos = new PVector(width-width/4, height-height/4); //Set the position to the middle of the screen

    //Give each gene a value
    for (int i = 0; i<n; i++) {
      PVector gen = PVector.random2D();
      //gen.setMag(random(5));
      genes.add(gen);
    }
  }

  void update() {    
    if (!dead) { //If still positions to go,
      move(); //Then move
      angle = getAngle(); //Get the angle you are going to move to
      //println(degrees(angle));

      float newD = PVector.dist(target, pos);
      if (newD>10) {
        dSum += newD;
      } else {
        dSum-=200;
      }
    }
  }

  //This reset has inherited genes
  void reset(ArrayList<PVector> newGenes, float mutRate) {

    for (int i = 0; i<newGenes.size(); i++) {
      if (random(1)<mutRate) {
        PVector gen = PVector.random2D();
        //gen.setMag(random(5));
        genes.set(i, gen);
      } else {
        genes.set(i, newGenes.get(i));
      }
    }

    dead = false;
    dSum = 0;
    angle = 0;
    currentGen = 0;
    fitness = 0;
    acc = new PVector(0, 0);
    pos = new PVector(spawn.x, spawn.y); //Set the position to the middle of the screen
  }

  //This reset doesn't
  void reset() {

    for (int i = 0; i<genes.size(); i++) {
      PVector gen = PVector.random2D();
      //gen.setMag(random(5));
      genes.set(i, gen);
    }

    dead = false;
    dSum = 0;
    angle = 0;
    currentGen = 0;
    fitness = 0;
    acc = new PVector(0, 0);
    pos = new PVector(spawn.x, spawn.y); //Set the position to the middle of the screen
  }

  float getAngle() {
    //return PVector.angleBetween(pos, acc);
    return atan2(acc.y, acc.x)+PI/2;
  }

  void move() {
    checkGenes(); //Run out of genes?? (set dead variale and stuff)
    checkCollisions();

    if (!dead) {
      acc.add(genes.get(currentGen)); //Add the velocity to the acceleration
      acc.add(grav);
      pos.add(acc); //Add the acceleration to the current position
      constrainPos(); //Keep it in-bounds
      currentGen++; //Add the gene
    }
  }

  void checkCollisions() {
    for (Obstacle o : obs) {
      float d2o = PVector.dist(o.pos, pos);

      if (d2o<=o.r+5) {
        fitness-=999;
        die();
      }
    }
  }

  void constrainPos() {
    if (pos.x<0 || pos.x>width || pos.y<0 || pos.y>height) {
      //fitness += -0.6;
      dSum+=999*(genes.size()-currentGen);
      die();
    }

    pos.x = constrain(pos.x, -1, width+1);
    pos.y = constrain(pos.y, -1, height+1);
  }

  void checkGenes() {
    if (currentGen>=genes.size()) { //If this is the last gen
      die();
    }
  }

  void die() {
    dead = true; //Die
    fitness = getFit(); //Calculate and set the fitness
    //println(fitness);
    finished++;
  }

  float getFit() {
    float avg = dSum/genes.size();

    if (fitness==0) {
      return abs(map(avg, 0, sqrt(pow(width, 2)+pow(height, 2))/1.5, 1, 0));
    } else {
      return fitness+abs(map(avg, 0, sqrt(pow(width, 2)+pow(height, 2))/1.5, 1, 0));
    }
  }

  void show() {
    pushMatrix();

    translate(pos.x, pos.y);
    rotate(angle);

    stroke(0);
    fill(255);
    triangle(0, -30*size, 20*size, 30*size, -20*size, 30*size);

    popMatrix();
  }
}
