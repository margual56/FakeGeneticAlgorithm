//----------TO CHANGE----------
int numberOfGenes = 500;
int numberOfAIs = 50;
int numberOfObstacles = 15;
//----------TO CHANGE----------

PVector grav, spawn, target;
float best = 0;
float globalBest = 0;
int generations = 0;

int mouseClickedCount = 0;
int count;
float doubleClickTimer = 0.5;

ArrayList<AI> ais;
ArrayList<Obstacle> obs;

int finished = 0;

void settings() {
  size((int)(displayWidth*0.9), (int)(displayHeight*0.9));
}

void setup(){
  count = 0;

  best = 0;
  globalBest = 0;
  generations = 0;
  finished = 0;

  grav = new PVector(0, 0);
  spawn = new PVector(width-width/4, height-height/4);

  target = new PVector(width/4, height/4);

  ais = new ArrayList<AI>();
  obs = new ArrayList<Obstacle>();

  for (int i = 0; i<numberOfObstacles; i++) {
    float r = random(15, 40);
    obs.add(new Obstacle(random(r, width-r), random(r, height-r), r));
  } 

  for (int i = 0; i<numberOfAIs; i++) {
    ais.add(new AI(numberOfGenes));
  }
}

void draw() {
  background(41);

  frameRate(60);

  stroke(255, 0, 0);
  strokeWeight(20);
  point(target.x, target.y);
  strokeWeight(1);

  if (finished>=ais.size()) {
    newGeneration();
  } else {
    for (AI a : ais) {
      a.update();
      a.show();
    }
  }

  for (Obstacle o : obs) {
    o.show();
  }

  stroke(255);
  fill(255);
  
  textAlign(LEFT);
  textSize(35);
  text("Best: " + nfc(best, 4), 10, 40);
  text("Global best: " + nfc(globalBest, 4), 10, 70);

  textAlign(CENTER);
  text("Genes left: " + nfc(getLastGen()) + "/" + nfc(numberOfGenes), width/2-20, 50);
  text("Generation: " + generations, width-140, 50);
  
  PVector p = PVector.mult(grav, frameRate);
  textAlign(CENTER, CENTER);
  text("Gravity: [" + nfc(p.x, 3) + ", " + nfc(p.y, 3) + "]", width/2, 75);
  
  if(mousePressed){
    count++;
  
    if(count>=doubleClickTimer*frameRate){
      frameCount = -1;
    } 
  }
}

int getLastGen() {
  for (AI a : ais) {
    if (!a.dead) {
      return a.currentGen;
    }
  }

  return ais.get(0).currentGen;
}

void newGeneration() {
  generations++;
  fill(0);
  rect(0, 0, width, height);

  int fittestIndex = 0;
  float max = -9999;
  for (int i = 0; i<ais.size(); i++) {
    float f = ais.get(i).fitness;

    if (max<f) {
      fittestIndex = i;
      max = f;
    }
  }

  best = max;
  if (best>globalBest) {
    globalBest = best;
  }

  ArrayList<PVector> fittestGenes = ais.get(fittestIndex).genes;

  if (max>=0) {
    ais.get(0).reset(fittestGenes, 0);
    
    for (int i = 1; i<floor(ais.size()*(max)); i++) {
      ais.get(i).reset(fittestGenes, 0.01);
    }

    for (int i = floor(ais.size()*(max)); i<floor(ais.size()); i++) {
      ais.get(i).reset(fittestGenes, 0.8);
    }
  } else {    
    for (int i = 0; i<floor(ais.size()); i++) {
      ais.get(i).reset();
    }
  }
  finished = 0;
}

void mousePressed() {
  
}

void mouseReleased(){
  count = 0;
}
