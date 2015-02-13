class Polygon {
  boolean colliding = false;
  boolean moving = false;
  boolean doneChecking = false;
  PMatrix2D matrix = new PMatrix2D();
  ArrayList<PVector> points = new ArrayList<PVector>();
  PVector[] pointsTransformed;
  PVector[] edges;
  PVector[] norms;
  PVector position = new PVector(400, -100);
  float rotation = 0;
  float scale = 1;
  AABB aabb = new AABB();

  public Polygon() {
  }
  void update() {
    colliding = false;
    doneChecking = false;
    if (moving) {
      rotation += .01;
      scale = sin(rotation) + 1.5;
    }
    matrix.reset();
    matrix.translate(position.x, position.y);
    matrix.rotate(rotation);
    matrix.scale(scale);
    ///// BUILD pointsTransformed ARRAY:
    pointsTransformed = new PVector[points.size()];
    for (int i = 0; i < points.size (); i++) {
      PVector p = new PVector();
      matrix.mult(points.get(i), p);
      pointsTransformed[i] = p;
    }
    ///// BUILD edges AND norms ARRAYS
    edges = new PVector[points.size()];
    norms = new PVector[points.size()];
    for (int i = 0; i < points.size(); i ++) {
      int j = i +1;
      if (i >= pointsTransformed.length - 1) j = 0;
      PVector p1 = pointsTransformed[i];
      PVector p2 = pointsTransformed[j];

      edges[i] = PVector.sub(p2, p1);
      norms[i] = new PVector(edges[i].y, -edges[i].x);
      norms[i].normalize(); // maybe unnecessary? depends on what you do normalize requires sqrt, compute heavy
    }

    ///// UPDATE aabb:
    aabb.update(pointsTransformed);
  }
  void draw() {
    if (colliding) fill(255, 0, 0);
    else fill(255);
    noStroke();
    beginShape();
    for (int i = 0; i < pointsTransformed.length; i++) {
      vertex(pointsTransformed[i].x, pointsTransformed[i].y);
    }
    endShape();
    ///////////////// DRAW NORMALS
    stroke(255);
    //fill(255,0,0);

    for (int i = 0; i < edges.length; i++) {
      PVector midpoint = PVector.add(PVector.mult(edges[i], .5), pointsTransformed[i]);
      //ellipse(midpoint.x,midpoint.y,10,10);
      PVector endpoint = PVector.add(PVector.mult(norms[i], 10), midpoint);
      line(midpoint.x, midpoint.y, endpoint.x, endpoint.y);
    }

    ///////////////// DRAW AABB:
    aabb.draw();
  }
  void addPoint(PVector p) {
    addPoint(p.x, p.y);
  }
  void addPoint(float x, float y) {
    points.add(new PVector(x, y));
  }
  // CHECK FOR COLLISIONS BETWEEN THIS OBJECT AND A COLLECTION OF Polygon OBJECTS:
  void checkCollisions(ArrayList<Polygon> shapes) {
    for (Polygon p : shapes) {
      if (p == this) continue;
      if (p.doneChecking) continue;
      if (checkCollision(p)) {
        colliding = true; 
        p.colliding = true;
      }
    }
    doneChecking = true;
  }
  // CHECK FOR COLLISIONS BETWEEN THIS OBJECT AND A SINGLE Polygon OBJECT:
  boolean checkCollision(Polygon poly) {
    // DO AABB COLLISION:
    if (! aabb.checkCollision(poly.aabb)) return false;


    // USE SEPARATING AXIS THEOREM WITH this poly NORMALS
    for (PVector n : norms) {
      PVector mm1 = findMinMaxOfProjection(n);
      PVector mm2 = poly.findMinMaxOfProjection(n);
      if (mm1.y < mm2.x) return false;
      if (mm1.x > mm2.y) return false;
    }
    //use SAT with other poly norms
    for (PVector n : poly.norms) {
      PVector mm1 = findMinMaxOfProjection(n);
      PVector mm2 = poly.findMinMaxOfProjection(n);
      if (mm1.y < mm2.x) return false;
      if (mm1.x > mm2.y) return false;
    }
    return true;
  }
  boolean checkCollision(PVector pt) {
    // DO AABB COLLISION:
    if (!aabb.checkCollision(pt)) return false;
    // PROJECT PVector ONTO ALL NORMALS, CHECK FOR OVERLAP
    for (PVector n : norms) {
      PVector mm1 = findMinMaxOfProjection(n);
      float ptVal = pt.dot(n);
      if (ptVal > mm1.y) return false;
      if (ptVal < mm1.x) return false;
    }
    colliding = true;
    return true;

    
  }

  // PROJECT ALL POINTS ONTO AN AXIS, RETURN MIN/MAX
  // axis PVector the axis to project onto(idealy a unit vector);
  //returns PVector x is min y is max 
  PVector findMinMaxOfProjection(PVector axis) {
    PVector value = new PVector();
    for (int i =0; i < pointsTransformed.length;i++) {
      float dot = pointsTransformed[i].dot(axis);
      if (i == 0 || dot < value.x) value.x = dot;
      if (i == 0 || dot > value.y) value.y = dot;
    }
    return value;
  }
}

