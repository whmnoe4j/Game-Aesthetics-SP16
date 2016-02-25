char[][] map;
int SIZE = 50;
int cellSize = 13;

PFont monaco;

int cLength = SIZE-2;     //how long the cave should be (in tiles)
int cRoughness = 10;  //how much the cave varies in width
int cWindyness = 90;  //how much the cave varies in positioning

int x, y;
int stepWidth;
int step;
int totalRuns;

void setup() {
  size(650,640);
  pixelDensity(2);
  noSmooth();
  textAlign(BOTTOM, LEFT);
  background(0);
  monaco = loadFont("Monaco-16.vlw");
  textFont(monaco);
  map = new char[SIZE][SIZE];
  for (int i = 0; i < SIZE; i++) {
    for (int j = 0; j < SIZE; j++) {
      map[j][i] = '#';
    }
  }
  
  x = SIZE/2 + floor(random(-5,5));
  y = SIZE-1;
  map[x][y] = '.';
  
  stepWidth = floor(random(3, SIZE/4));
  for (int i = -stepWidth/2; i < stepWidth/2; i++) {
    map[x+i][y] = '.';
  }
  
}

void draw() {
  background(0);
  step();
  for (int i = 0; i < SIZE; i++) {
    for (int j = 0; j < SIZE; j++) {
      text(map[j][i],j*cellSize,i*cellSize);
    }
  }
  if (step == cLength && totalRuns < 2) {
    totalRuns++;
    step = 0;
    x = SIZE/2;
    y = SIZE-2;
  }
}

void step() {
  if (step < cLength) {
    y--;
    if (random(100) <= cRoughness) {
      int r = 0;
      while (r == 0) {
        r = floor(random(-2,3));
      }
      stepWidth += r;
      if (stepWidth < 3) {
        stepWidth = 3;
      } else if (stepWidth > SIZE) {
        stepWidth = SIZE;
      }
    }
    
    if (random(100) <= cWindyness) {
      int r = 0;
      while (r == 0) {
        r = floor(random(-2,3));
      }
      x += r;
      if (x < 0) {
        x = 0;
      }
      if (x > SIZE-3) {
        x = SIZE-3;
      }
    }
    
    for (int i = -stepWidth/2; i < stepWidth/3; i++) {
      map[x+i][y] = '.';
      }
    step++;
  }
}