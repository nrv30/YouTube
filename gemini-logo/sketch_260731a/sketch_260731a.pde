enum AnimPhase {
  Phase1,
}

PVector center;
color pink = color(255, 102, 204);
int fps = 24;
AnimPhase phase;
Timer timer;
// int max_radiuis = 300;

void setup() {
  pixelDensity(1);
  frameRate(fps);
  size(800, 800);
  center = new PVector(width/2, height/2);
  phase = AnimPhase.Phase1;
  timer = new Timer(fps*1);
}

void draw() {
    
  float t = timer.getPercentElapsed(); //<>//
  t = t*t*t;
  float maxRadius = lerp(0.0, 150.0, t);
  loadPixels();
  for (int y = 0; y < width; ++y) {
    for (int x = 0; x < height; ++x) {
      int i = y*width+x;
      
      switch(phase) {
        case Phase1: {
          // println("in phase 1");
          color c = flower(x, y, maxRadius);
          pixels[i] = c;
        }break;
        default: {
          println("reached default");
        }break;
      }
      
    }
  }
  updatePixels();
  
  if (timer.updateTimer()) { //<>//
    noLoop();
  }
  // saveFrame("output/#####.tga");
}

color flower(int x, int y, float max_radius) {
  float theta = atan2(y-center.y, x-center.x); //<>//
  float radius = (0.95 - 0.05 * cos(8 * theta)) * max_radius;
  float fromCenter = dist(center.x, center.y, x, y);
  if (fromCenter < radius) {
    return pink;
  } else {
    return 0xFF000000;
  }
}
