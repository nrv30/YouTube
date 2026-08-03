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
int samples = 102; // has to be divisible by 6 because of hexagon
float circleMaxRadius = 200;
int currShape = 0;
PShape[] shapes;
PShape astroid;
PImage img;
color blue = color(24, 130, 253);
color darkGray = color(73, 73, 73);

void setup() {
  pixelDensity(1);
  frameRate(fps);
  size(800, 800, P2D);
    
  shapes = new PShape[4];
  int shapesCounter = 0;
  
  pushMatrix();
  translate(width/2, height/2);
  scale(1, -1);
  
  noStroke();
  astroid = createShape();
  astroid.beginShape();
  astroid.fill(darkGray);
  drawAstroid(astroid, circleMaxRadius/2, samples);
  astroid.endShape();
  
  PShape flower = createShape();
  flower.beginShape();
  flower.fill(blue);
  drawFlower(flower, circleMaxRadius, samples);
  flower.endShape();
  shapes[shapesCounter++] = flower;
  
  PShape el = createShape();
  el.beginShape();
  el.fill(blue);
  drawEllipse(el, 0.9 * circleMaxRadius, 1.1 * circleMaxRadius, samples);
  el.endShape();
  shapes[shapesCounter++] = el;
  
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
  hexagon.fill(blue);
  int samplesPerSegment = samples / 6;
  for (int i = 0; i < 6; ++i) {
    drawHexSegment(hexagon, corners, i, samplesPerSegment);
  }
  
  hexagon.endShape();
  shapes[shapesCounter++] = hexagon;
  
  PShape circle = createShape();
  circle.beginShape();
  circle.fill(blue);
  drawEllipse(circle, circleMaxRadius, circleMaxRadius, samples);
  circle.endShape();
  shapes[shapesCounter++] = circle;
  
  popMatrix();
}

void draw() {
  background(0xFFFFFFFF);
  pushMatrix();
  translate(width/2, height/2);
  scale(-1, -1);
  
  PShape astroidCopy = createShape();
  if (phase != PHASE.INIT) {
    float t = (float)tweenTimer.framesElapsed / tweenTimer.maxFrames;
    float t1 = (float)spinTimer.framesElapsed / spinTimer.maxFrames;
    
    PShape tweenShape = createShape();
    tweenShape.beginShape();
    tweenShape.fill(blue);
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
    copyShape(astroid, astroidCopy, 0xFFFFFFFF);
    shape(astroidCopy, 0, 0);
    
    if (tweenTimer.updateTimer()) {
      currShape++;
    }
    if (currShape == 3)
      noLoop();
    spinTimer.updateTimer();
  } else {
    float t = (float)initTimer.framesElapsed / initTimer.maxFrames; //<>//
    t = pow(t, 2);
    PShape flower = createShape();
    
    flower.beginShape();
    flower.fill(blue);
    drawFlower(flower, lerp(0, circleMaxRadius, t), samples);
    flower.endShape();
    shape(flower);
    
    color c = lerpColor(darkGray, 0xFFFFFFFF, t);
    copyShape(astroid, astroidCopy, c);
    astroidCopy.rotate(t*PI);
    shape(astroidCopy, 0, 0);
    
    if (initTimer.updateTimer()) {
      phase = PHASE.FLOWER;
    }
  }  
  popMatrix();
}

void copyShape(PShape src, PShape copy, color c) {
  copy.setFill(c);
  copy.beginShape();
  for (int i = 0; i < src.getVertexCount(); ++i) {
    PVector v = src.getVertex(i);
    copy.vertex(v.x, v.y);
  }
  copy.endShape();
}

// https://en.wikipedia.org/wiki/Astroid
void drawAstroid(PShape astroid, float a, int samplesCount) {
  for (int i = 0; i < samplesCount; ++i) {
    float t = (float)i / samplesCount;
    float angle = t * TWO_PI;
    float x = a * pow(cos(angle), 3);
    float y = a * pow(sin(angle), 3);
    astroid.vertex(x, y);
  }
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
