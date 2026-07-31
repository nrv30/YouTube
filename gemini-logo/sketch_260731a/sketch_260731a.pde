PVector center;
color pink = color(255, 102, 204);
int fps = 24;
Timer phase1 = new Timer(fps*1);
// int max_radiuis = 300;

void setup() {
  pixelDensity(1);
  frameRate(fps);
  size(800, 800);
  center = new PVector(width/2, height/2);
}

void draw() {
  float t = phase1.getPercentElapsed();
  t = t*t*t;
  loadPixels();
  for (int y = 0; y < width; ++y) {
    for (int x = 0; x < height; ++x) {
      int i = y*width+x;
      pixels[i] = flower(x, y, lerp(0.0, 150.0, t));
    }
  }
  updatePixels();
  if (phase1.updateTimer()) { //<>//
    noLoop();
  }
  // saveFrame("output/frame-#.tga");
  // saveFrame("output/line-######.png");
  // saveFrame("output/#####.tga");
}

color flower(int x, int y, float max_radius) {
  float theta = atan2(y-center.y, x-center.x);
  float radius = (0.95 - 0.05 * cos(8 * theta)) * max_radius;
  float fromCenter = dist(center.x, center.y, x, y);
  if (fromCenter < radius) {
    return pink;
  } else {
    return 0xFF000000;
  }
}
