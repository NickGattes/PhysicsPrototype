class AABB {

  boolean colliding = false;
  float halfW, halfH;
  float xmin, xmax, ymin, ymax;

  public AABB() {
  }
  void setSize(float w, float h) {
    halfW = w/2;
    halfH = h/2;
  }
  void update(PVector pos) {
    colliding = false;
    xmin = pos.x - halfW;
    xmax = pos.x + halfW;
    ymin = pos.y - halfH;
    ymax = pos.y + halfH;
  }
  void update(float xmin, float xmax, float ymin, float ymax) {
    colliding = false;
    this.xmin = xmin;
    this.xmax = xmax;
    this.ymin = ymin;
    this.ymax = ymax;
  }
  void update(PVector[] points) {
    colliding = false;
    for (int i = 0; i < points.length; i++) {
      PVector p = points[i];
      if (i == 0 || p.x < xmin) xmin = p.x;
      if (i == 0 || p.x > xmax) xmax = p.x;
      if (i == 0 || p.y < ymin) ymin = p.y;
      if (i == 0 || p.y > ymax) ymax = p.y;
    }
  }
  void draw() {
    noFill();
    if (colliding) stroke(255, 0, 0);
    else stroke(255);
    rectMode(CORNERS);
    rect(xmin, ymin, xmax, ymax);
  }
  boolean checkCollision(AABB aabb) {
    if (xmax < aabb.xmin) return false;
    if (xmin > aabb.xmax) return false;
    if (ymax < aabb.ymin) return false;
    if (ymin > aabb.ymax) return false;
    colliding = true;
    aabb.colliding = true;
    return true;
  }
  boolean checkCollision(PVector pt) {
    if (pt.y < ymin) return false;
    if (pt.y > ymax) return false;
    if (pt.x < xmin) return false;
    if (pt.x > xmax) return false;
    colliding = true;
    return true;
  }
}

