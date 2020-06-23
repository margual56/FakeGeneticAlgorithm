class Obstacle {
  PVector pos;
  float r;

  Obstacle(float x, float y, float r) {
    pos = new PVector(x, y);
    this.r = r;
  }

  void show() {
    stroke(155, 0, 0);
    fill(50, 200, 200);

    ellipse(pos.x, pos.y, r*2, r*2);
  }
}
