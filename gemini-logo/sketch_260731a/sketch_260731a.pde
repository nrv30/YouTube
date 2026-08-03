enum PHASE {
  INIT,
  FLOWER,
  ELL,
  HEX,
  CIRCLE
};

PHASE phase = PHASE.INIT;
int fps = 24;
Timer initTimer = new Timer(1*fps);
Timer tweenTimer = new Timer(1*fps);
Timer spinTimer = new Timer(2*fps);
int currShape = 0;
PShape[] shapes;
PShape ghost;
float circleMaxRadius = 200;
PImage img;
int samples = 102; // has to be divisible by 6 because stupid hexagon


void setup() {
   pixelDensity(1);
  frameRate(fps);
  size(800, 800, P2D);
  
  shapes = new PShape[4];
  int shapesCounter = 0;
  
  pushMatrix();
  translate(width/2, height/2);
  scale(1, -1);
  
  PShape flower = createShape();
  flower.beginShape();
  flower.fill(0xFFFF0000);
  drawFlower(flower, circleMaxRadius, samples);
  flower.endShape();
  shapes[shapesCounter++] = flower;
  
  PShape el = createShape();
  el.beginShape();
  el.fill(0xFFFF0000);
  drawEllipse(el, 0.9 * circleMaxRadius, 1.1 * circleMaxRadius, samples);
  el.endShape();
  shapes[shapesCounter++] = el;
  
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
  drawEllipse(circle, circleMaxRadius, circleMaxRadius, samples);
  circle.endShape();
  shapes[shapesCounter++] = circle;
  
  popMatrix();
  //assert(shapes[0].getVertexCount() == shapes[1].getVertexCount());
  //assert(shapes[1].getVertexCount() == shapes[2].getVertexCount());
  //assert(shapes[2].getVertexCount() == shapes[3].getVertexCount());
}

void draw() {
  background(0x000000);
  pushMatrix();
  translate(width/2, height/2);
  scale(-1, -1);
  
  if (phase != PHASE.INIT) {
    float t = (float)tweenTimer.framesElapsed / tweenTimer.maxFrames; //<>//
    float t1 = (float)spinTimer.framesElapsed / spinTimer.maxFrames;
    //println(t1);
    
    PShape tweenShape = createShape();
    tweenShape.beginShape();
    tweenShape.fill(0xFFFF0000);
    for (int i = 0; i < shapes[currShape].getVertexCount(); ++i) {
      PVector start = shapes[currShape].getVertex(i);
      PVector end = shapes[currShape + 1].getVertex(i);
      float x = lerp(start.x, end.x, t);
      float y = lerp(start.y, end.y, t);
      tweenShape.vertex(x, y);
    }
    tweenShape.endShape(); //<>//
    tweenShape.rotate(t1*TWO_PI);
      
    shape(tweenShape, 0, 0);
    
    if (tweenTimer.updateTimer()) {
      currShape++;
    }
    if (currShape == 3)
      noLoop();
    spinTimer.updateTimer();
  } else {
    float t = (float)initTimer.framesElapsed / initTimer.maxFrames;
    PShape flower = createShape();
    
    flower.beginShape();
    flower.fill(0xFFFF0000);
    drawFlower(flower, lerp(0, circleMaxRadius, t), samples);
    flower.endShape();
    
    shape(flower);
    
    if (initTimer.updateTimer()) {
      phase = PHASE.FLOWER;
    }
  }
  //shape(ghost);
  
  popMatrix();

//  pushMatrix();
//  translate(width/2 - img.width/2, height/2 - img.height/2);
//  // scale(1, -1);

//  noStroke();
//  beginShape();
//  texture(img);
//  textureMode(NORMAL);
  
//  vertex(0, 0, 0, 0);
//  vertex(img.width, 0, 1, 0);
//  vertex(img.width, img.height, 1, 1);
//  vertex(0, img.height, 0, 1);
//  rotate(t1*tau);
//  endShape(CLOSE);

  
//  popMatrix();
  
  //image(img, width/2 - imageWidth/2, height/2 - imageHeight/2, imageWidth, imageHeight);
}

void drawFlower(PShape flower, float maxRadius, int samplesCount) {
  for (int i = 0; i < samplesCount; ++i) {
    float t = (float)i / samplesCount;
    float angle = t * TWO_PI;
    float radius = (0.95 - 0.05 * cos(8 * angle)) * maxRadius;
    float x = radius * cos(angle);
    float y = radius * sin(angle);
    flower.vertex(x, y);
  }
}

void drawEllipse(PShape el, float xRad, float yRad, int samplesCount) {
  for (int i = 0; i < samplesCount; ++i) {
    float t = (float)i / samplesCount;
    float angle = t * TWO_PI;
    float x = xRad * cos(angle);
    float y = yRad * sin(angle);
    el.vertex(x, y);
  }
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
