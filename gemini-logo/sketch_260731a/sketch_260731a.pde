PVector center;
color pink = color(255, 102, 204);

void setup() {
  size(800, 800);
  center = new PVector(pixelWidth/2, pixelHeight/2);
}

// translate(center.x, center.y);
void draw() {
  loadPixels();
  for (int y = 0; y < pixelWidth; ++y) {
    for (int x = 0; x < pixelHeight; ++x) {
      int i = y*pixelWidth+x;
      pixels[i] = flower(x, y, 300);
    }
  }
  updatePixels();
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
