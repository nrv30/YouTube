float tau = 2*PI; //<>// //<>// //<>//
int fps = 24;
Timer timer = new Timer(1*fps);
Timer spinTimer = new Timer(2*fps);
int currShape = 0;
PShape[] shapes;
float circleMaxRadius = 200;

void setup() {
  frameRate(fps);
  size(800, 800);

  shapes = new PShape[4];
  int shapesCounter = 0;
  
  pushMatrix();
  translate(width/2, height/2);
  scale(1, -1);
  
  // has to be divisible by 6 because stupid hexagon
  int samples = 102; 
  
  PShape flower = createShape();
  flower.beginShape();
  flower.fill(0xFFFF0000);
  for (int i = 0; i < samples; ++i) {
    float t = (float)i / samples;
    float angle = t * tau;
    float radius = (0.95 - 0.05 * cos(8 * angle)) * circleMaxRadius;
    float x = radius * cos(angle);
    float y = radius * sin(angle);
    flower.vertex(x, y);
  }
  flower.endShape();
  shapes[shapesCounter++] = flower;
  
  PShape ellipseSh = createShape();
  ellipseSh.beginShape();
  float xRad = 0.9 * circleMaxRadius;
  float yRad = 1.1 * circleMaxRadius;
  ellipseSh.fill(0xFFFF0000);
  for (int i = 0; i < samples; ++i) {
    float t = (float)i / samples;
    float angle = t * tau;
    float x = xRad * cos(angle);
    float y = yRad * sin(angle);
    ellipseSh.vertex(x, y);
  }
  ellipseSh.endShape();
  shapes[shapesCounter++] = ellipseSh;
  
  // todo: rounded corners
  // just kidding I'm not implementing that it's too hard
  PShape hexagon = createShape();
  PVector corners[] = new PVector[6];
  corners[0] = new PVector(circleMaxRadius * cos(PI/6), circleMaxRadius * sin(PI/6));
  PVector curr = corners[0].copy();
  for (int i = 1; i < 6; ++i) {
    float angle = radians(60.0);
    curr = curr.copy().rotate(angle);
    corners[i] = curr.copy(); 
  }
    
  hexagon.beginShape();
  hexagon.fill(0xFFFF0000);
  int samplesPerSegment = samples / 6;
  for (int i = 0; i < 6; ++i) {
    drawHexSegment(hexagon, corners, i, samplesPerSegment);
  }
  
  hexagon.endShape();
  shapes[shapesCounter++] = hexagon;
  
  PShape circle = createShape();
  circle.beginShape();
  circle.fill(0xFFFF0000);
  for (int i = 0; i < samples; ++i) {
    float t = (float)i / samples;
    float angle = t * tau;
    float x = circleMaxRadius * cos(angle);
    float y = circleMaxRadius * sin(angle);
    circle.vertex(x, y);
  }
  circle.endShape();
  shapes[shapesCounter++] = circle;
  
  popMatrix();
  assert(shapes[0].getVertexCount() == shapes[1].getVertexCount());
  assert(shapes[1].getVertexCount() == shapes[2].getVertexCount());
  assert(shapes[2].getVertexCount() == shapes[3].getVertexCount());
}

void draw() {
  background(0x000000);
  pushMatrix();
  translate(width/2, height/2);
  scale(-1, -1);
  
  float t = (float)timer.framesElapsed / timer.maxFrames;
  float t1 = (float)spinTimer.framesElapsed / spinTimer.maxFrames;
  println(t1);
  
  beginShape();
  rotate(t1*tau);
  fill(0xFFFF0000);
  for (int i = 0; i < shapes[currShape].getVertexCount(); ++i) {
    PVector start = shapes[currShape].getVertex(i);
    PVector end = shapes[currShape + 1].getVertex(i);
    float x = lerp(start.x, end.x, t);
    float y = lerp(start.y, end.y, t);
    vertex(x, y);
  }
  endShape();
  //shape(shapes[2], 0, 0)
  popMatrix();
  
  if (timer.updateTimer()) {
    currShape++;
  }
  if (currShape == 3)
    noLoop();
  spinTimer.updateTimer();
}

void drawHexSegment(PShape hexagon, PVector[] corners, int corner, int samplesCount) {
  int next = (corner + 1) < 6 ? corner + 1 : 0;
  for (int i = 0; i < samplesCount; ++i) {
    float t = (float)i / samplesCount;
    float x = lerp(corners[corner].x, corners[next].x, t);
    float y = lerp(corners[corner].y, corners[next].y, t);
    hexagon.vertex(x, y);
  } 
}
