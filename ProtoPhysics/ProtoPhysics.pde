//This is a prototype for a poly collision detection
boolean play = true;
boolean shoot = false;
ArrayList<Polygon> shapes = new ArrayList<Polygon>();
Polygon myPoly;
Polygon pigs;
Polygon bullet;
float speed = 5;

float score = 0;




void setup() {
  size(800, 500);
  pigs = makePiggies();
  myPoly = makePlayer();
  bullet  = makeBullet();
}
void draw() {
  //UPDATE EVERYTHING
  fill(255);
  text("Score: " + score, 20, 20);

  println(score);

  PVector mouse = new PVector(mouseX, mouseY);
   bullet.position.x = myPoly.position.x;


  if (play) myPoly.position = mouse; // make myPoly follow the mouse position
  if (myPoly.position.y >400) myPoly.position.y = 400;
  if (myPoly.position.y <400) myPoly.position.y = 400;
  if (myPoly.position.x < 85) myPoly.position.x = 85;
  if (myPoly.position.x >715) myPoly.position.x = 715;


  float time = millis()/1000.0; // get number of seconds as a float
  float velocity = speed * (time/2);
 
  if (play == true) {
     pigs.position.y += velocity;
  if (velocity >= 50) velocity = 30;


    if (pigs.position.y >= 500) {
      pigs.position.x = random(85, 715);
      score = score + 100;
    }
    if(bullet.colliding == true && pigs.colliding == true) {
      pigs.position.x = random(85, 715);
      pigs.position.y = -100;
      score = score + 200;
      
    }
    if(shoot == true){
      bullet.position.y -= 20;
     
      if(bullet.position.y <= -20){
        bullet.position.y = myPoly.position.y -10;
        shoot = false;
      }
    }
    
  }
  if (pigs.position.y >= 500) pigs.position.y = -100;



  //println("pigs speed" + velocity);

  for (Polygon p : shapes) p.update();
  for (Polygon p : shapes) {
    if (play) p.checkCollisions(shapes); // check for collision against ALL polygons
    if (pigs.colliding == true && myPoly.colliding == true) {
      println("endGame");
      play = false;
    }

    if (!play) p.checkCollision(mouse); // check for collision against mouse position (single point)
  }



  //DRAW EVERYTHNG
  background(0);
  for (Polygon p : shapes) p.draw();
}
Polygon makePiggies() {
  Polygon pig = new Polygon();
  //p.moving = true;
  shapes.add(pig);
  pig.addPoint(-10, -10);
  pig.addPoint(10, -30);
  pig.addPoint(20, 30);
  pig.addPoint(-20, 20);
  return pig;
}
Polygon makePlayer() {
  Polygon p = new Polygon();
  p.scale = 3;
  shapes.add(p);
  p.addPoint(-10, -10);
  p.addPoint(10, -30);
  p.addPoint(20, 30);
  return p;
}
Polygon makeBullet() {
  Polygon b = new Polygon();
  b.scale = 1;
  shapes.add(b);
  b.addPoint(1, 1);
  b.addPoint(2, 2);
  b.addPoint(3, 1);
  b.position = new PVector(myPoly.position.x , myPoly.position.y -10);
  return b;
}

void mousePressed() {
  shoot = !shoot;
}

