PVector pos = new PVector(12, 12);
PVector dir = new PVector(0, 1);
PVector plane = new PVector(1, 0);
float FOV = 85;
float rot = 0.0;

int gameWidth;
int gameHeight;

float rayNum;
float rayWidth;

//int mapWidth = 26;
//int mapHeight = 36;

float wallHeightMod = 1.5;

int lastTime;

boolean keyUp, keyDown, keyLeft, keyRight, keyStrafeL, keyStrafeR;

int whichMap = 0;
boolean drawRays = false;

float walkSpeed = 0.005;
float rotSpeed = 0.002;

float mapScale = 10;

PVector[] hits;  //store hit positions so we can draw map rays separate from the main raycasting function

float camPlaneMag = tan( FOV / 2.0 * (PI / 180.0) ); //took this out of raycast() to use elsewhere

int[][] worldMap = new int[][] {
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, 
  {1, 2, 0, 2, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 2, 0, 2, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 2, 0, 3, 3, 2, 2, 2, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1}, 
  {1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 3, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1}, 
  {1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 2, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 3, 4, 4, 5, 5, 4, 3, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 2, 2, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 2, 3, 0, 0, 0, 0, 0, 2, 2, 2, 2, 1, 0, 1, 2, 2, 2, 2, 2, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 2, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 2, 2, 2, 2, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 3, 3, 3, 3, 3, 3, 3, 0, 0, 3, 0, 0, 0, 2, 1, 0, 1, 2, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 3, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 2, 0, 0, 0, 2, 0, 0, 3, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
};

final int texWidth = 64;
final int texHeight = 64;

boolean drawTextures = true;

int[][] texture = new int[6][texWidth * texHeight];

color[] buffer;

void setup() {
  size(1000, 500, P2D);
  //frameRate(30);
  //pixelDensity(2);
  gameWidth = width;
  gameHeight = height;  
  rayNum = gameWidth;
  rayWidth = gameWidth/rayNum;
  noSmooth();
  //strokeCap(PROJECT);
  hits = new PVector[(int)rayNum];
  for (int x = 0; x < (int)rayNum; x++) {
    hits[x] = new PVector(0, 0);
  }

  //generate a texture
  for (int x = 0; x < texWidth; x++) {
    for (int y = 0; y < texHeight; y++) {
      //texture[texWidth * y + x] = 255- (x + y)*4;
      int xorcolor = (x * 256 / texWidth) ^ (y * 256 / texHeight);
      int ycolor = y * 256 / texHeight;
      int xycolor = y * 128 / texHeight + x * 128 / texWidth;
      //texture[texWidth * y + x] = xorcolor + 256 * xorcolor + 65536 * xorcolor;
      texture[0][texWidth * y + x] = xycolor + 256 * xycolor + 65536 * xycolor; //sloped greyscale
      texture[1][texWidth * y + x] = 256 * xycolor + 65536 * xycolor; //sloped yellow gradient
      texture[2][texWidth * y + x] = xorcolor + 256 * xorcolor + 65536 * xorcolor; //xor greyscale
      texture[3][texWidth * y + x] = 256 * xorcolor; //xor green
      texture[4][texWidth * y + x] = 65536 * ycolor; //red gradient
      texture[5][texWidth * y + x] = 128 + 256 * 128 + 65536 * 128; //flat grey texture
      //texture[0][texWidth * y + x] = color(x*2, y*2, 150);
      
      
      texture[0][texWidth * y + x] = color(random(255));
    }
  }

  buffer = new color[gameWidth * gameHeight];
}


void draw() {

  background(20);
  noStroke();

  for (int y = 0; y < height/2; y++) {
    float distMod = map(y, height/2, 0, 0, 50);
    stroke(180-distMod);
    line(0, y, width, y);
  }

  for (int y = height/2; y < height; y++) {
    float distMod = map(y, height/2, height, 0, 50);
    stroke(130-distMod);
    line(0, y, width, y);
  }

  if (drawTextures) {
    loadPixels();
    for (int i = 0; i < pixels.length; i++) {
      buffer[i] = color(150);
    }
  }

  int dt = millis() - lastTime;
  //println(dt);
  update(dt);
  lastTime = millis();

  raycast();

  if (drawTextures) {
    arrayCopy(buffer, pixels);
    updatePixels();
  }

  drawMap();

  fill(0);
  textAlign(RIGHT);
  text("framerate: " + frameRate, width-20, 30);
  text(pos.x + " " + pos.y, width-20, 45);
  text("m to draw maps", width-20, 60);
  text("r to turn on map rays", width-20, 75);
  text("arrows to move", width-20, 90);
  text("shift & alt to change FOV", width-20, 105);
  text(". and , to change wall height modifier", width-20, 120);
  text("o and p to change number of rays", width-20, 135);
  text(rayNum + " " + rayWidth, width-20, 150);
}

void update(int dt) {
  camPlaneMag = tan( FOV / 2.0 * (PI / 180.0) );

  dir.x = cos(rot);
  dir.y = -sin(rot);  //play with these to really screw things up
  plane.x = sin(rot);
  plane.y = cos(rot);
  //plane.x = -dir.y;
  //plane.y = dir.x;

  if (keyLeft) {
    rot += rotSpeed * dt;
  }
  if (keyRight) {
    rot -= rotSpeed * dt;
  }
  //println("modified walk speed is " + walkSpeed * dt);
  if (keyUp) {
    //no collision version
    //pos.add(new PVector( dir.x * walkSpeed * dt, dir.y * walkSpeed * dt));
    if (worldMap[(int)(pos.x + dir.x * walkSpeed * dt)][(int)pos.y] == 0) {
      pos.x += dir.x * walkSpeed * dt;
    }
    if (worldMap[(int)pos.x][(int)(pos.y + dir.y * walkSpeed * dt)] == 0) {
      pos.y += dir.y * walkSpeed * dt;
    }
  }
  if (keyDown) {
    //no collision version
    //pos.add(new PVector(-dir.x * walkSpeed * dt, -dir.y * walkSpeed * dt));
    if (worldMap[(int)(pos.x - dir.x * walkSpeed * dt)][(int)pos.y] == 0) {
      pos.x -= dir.x * walkSpeed * dt;
    }
    if (worldMap[(int)pos.x][(int)(pos.y - dir.y * walkSpeed * dt)] == 0) {
      pos.y -= dir.y * walkSpeed * dt;
    }
  }
  if (keyStrafeR) {
    if (worldMap[(int)(pos.x + plane.x * walkSpeed * dt)][(int)pos.y] == 0) {
      pos.x += plane.x * walkSpeed * dt;
    }
    if (worldMap[(int)pos.x][(int)(pos.y + plane.y * walkSpeed * dt)] == 0) {
      pos.y += plane.y * walkSpeed * dt;
    }
  }
  if (keyStrafeL) {
    if (worldMap[(int)(pos.x - plane.x * walkSpeed * dt)][(int)pos.y] == 0) {
      pos.x -= plane.x * walkSpeed * dt;
    }
    if (worldMap[(int)pos.x][(int)(pos.y - plane.y * walkSpeed * dt)] == 0) {
      pos.y -= plane.y * walkSpeed * dt;
    }
  }
}

void keyPressed() {
  if (key == CODED) {
    switch (keyCode) {
    case UP:
      keyUp = true;
      break;
    case DOWN:
      keyDown = true;
      break;
    case LEFT:
      keyLeft = true;
      break;
    case RIGHT:
      keyRight = true;
      break;
    }
  }
  if (key == 'w') {
    keyUp = true;
  }
  if (key == 's') {
    keyDown = true;
  }
  if (key == 'a') {
    keyStrafeL = true;
  }
  if (key == 'd') {
    keyStrafeR = true;
  }
  if (key == 'o') {
    if (rayNum > 10) {
      rayNum = (int)rayNum - 10;
      rayWidth = gameWidth/rayNum;
    }
  }
  if (key == 'p') {
    if (rayNum < gameWidth) {
      rayNum = (int)rayNum + 10;
      rayWidth = gameWidth/rayNum;
      //buffer = new color[gameWidth * gameHeight];
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    switch (keyCode) {
    case UP:
      keyUp = false;
      break;
    case DOWN:
      keyDown = false;
      break;
    case LEFT:
      keyLeft = false;
      break;
    case RIGHT:
      keyRight = false;
      break;
    case SHIFT:
      FOV++;
      break;
    case ALT:
      FOV--;
      break;
    }
  }
  if (key == 'w') {
    keyUp = false;
  }
  if (key == 's') {
    keyDown = false;
  }
  if (key == 'a') {
    keyStrafeL = false;
  }
  if (key == 'd') {
    keyStrafeR = false;
  }
  if (key == 'm') {
    whichMap = (whichMap + 1) % 4;
    println(whichMap);
  }
  if (key == 'r') {
    drawRays = !drawRays;
  }
  if (key == '.') {
    wallHeightMod += 0.1;
  }
  if (key == ',') {
    wallHeightMod -= 0.1;
  }
  if (key == 't') {
    drawTextures = !drawTextures;
  }
}

void raycast() {
  PVector rayPos = new PVector(0, 0);
  PVector rayDir = new PVector(0, 0);

  //using this to track hit position (trying)
  PVector hitPos = new PVector(0, 0);


  //cast rays
  for (int x = 0; x < (int)rayNum; x++) {
    //calculate ray position and direction
    //cameraX will drive the direction of the rays by taking the result of scaling the right vector.
    float cameraX = (2 * x / (float)rayNum) - 1; //x coordinate in camera space

    rayPos.set(pos.x, pos.y);
    //rayDir.set(dir.x + plane.x * cameraX, dir.y + plane.y * cameraX);  //no FOV control
    rayDir.set(dir.x + (plane.x * camPlaneMag) * cameraX, 
      dir.y + (plane.y * camPlaneMag) * cameraX);

    //the current square of the map the ray is in
    int mapX = (int)rayPos.x;
    int mapY = (int)rayPos.y;

    //DDA (Digital Differential Analysis) algorithm always jumps exactly one square each loop, 
    //either a square in the x-direction or a square in the y-direction.
    //if it has to go in the negative or positive x-direction, and the negative or positive y-direction
    //will depend on the direction of the ray, and this will be stored in stepX and stepY (either -1 or +1)

    //length of ray from current position to next x or y-side
    float sideDistX;
    float sideDistY;

    //distance the ray has to travel to go from 1 x-side to the next x-side 
    //or from 1 y-side to the next y-side
    //float deltaDistX = sqrt(1 + (rayDir.y * rayDir.y) / (rayDir.x * rayDir.x)); 
    //float deltaDistY = sqrt(1 + (rayDir.x * rayDir.x) / (rayDir.y * rayDir.y));

    // or?
    // scale the vector by the inverse of the x component,
    // which makes the x component equal to one.
    // then calculate the magnitude
    float scaleX = 1.0 / rayDir.x;
    float scaleY = 1.0 / rayDir.y;
    float deltaDistX = (new PVector(1, rayDir.y * scaleX)).mag();  //screw with this for more rendering madness
    float deltaDistY = (new PVector(1, rayDir.x * scaleY)).mag(); 

    float wallDist;

    //what direction to step in x or y (+1 or -1)
    int stepX;
    int stepY;

    //was there a wall hit?
    int hit = 0;
    //was a NS or EW wall hit?
    int side = 0;

    //calculate step and initial sideDist
    //if the ray direction has a negative x-component, 
    //sideDistX is the distance from ray starting position to the first side to the left, etc.
    //for these values, the integer value mapX is used and the real position subtracted from it, 
    //and 1.0 is added in some of the cases depending if the side to the left or right or top or bottom is used. 
    //then you get the perpendicular distance to this side, 
    //so multiply it with deltaDistX or deltaDistY to get the real oblique distance
    if (rayDir.x < 0) {
      stepX = -1;
      sideDistX = (rayPos.x - mapX) * deltaDistX;
    } else {
      stepX = 1;
      sideDistX = (mapX + 1.0 - rayPos.x) * deltaDistX;
    }
    if (rayDir.y < 0) {
      stepY = -1;
      sideDistY = (rayPos.y - mapY) * deltaDistY;
    } else {
      stepY = 1;
      sideDistY = (mapY + 1.0 - rayPos.y) * deltaDistY;
    }


    //start DDA 
    //its a loop that increments the ray with 1 square every time, until a wall is hit.
    //each time, it either jumps a square in the x-direction (w stepX) or y - it always jumps 1 square at once
    //if the ray's direction would be the x-direction, the loop will only have to jump a square in the x-direction every time, 
    //because the ray will never change its y-direction, etc.
    //sideDistX and sideDistY get incremented with deltaDistX with every jump in their direction,
    //and mapX and mapY get incremented with stepX and stepY respectively
    //when the ray has hit a wall, the loop ends, and then we'll know whether an x-side or y-side was hit in "side"
    //and what wall was hit with mapX and mapY
    //we won't know exactly where the wall was hit, but that's not needed for no-texture walls.

    while (hit == 0) {
      //jump to next map square, OR in x-direction, OR in y-direction
      if (sideDistX < sideDistY) {
        sideDistX += deltaDistX;
        mapX += stepX;
        side = 0;
      } else {
        sideDistY += deltaDistY;
        mapY += stepY;
        side = 1;
      }
      //check to see if ray has hit a wall
      if (worldMap[mapX][mapY] > 0) {
        hit = 1;
      }
    }

    //after DDA is complete, calculate the distance of the ray to the wall
    //so we can calculate how high the wall has to be drawn after this.
    //we don't use the oblique distance however, but instead only the distance perpendicular to the camera plane
    //(projected on the camera direction) to avoid the fisheye effect.
    //the fisheye effect is an effect you see if you use the real distance, where all walls become rounded
    //the fisheye effect is avoided by the way distance is calculated here 
    //(and its easier to calculate this perpendicular distance; we don't need to know the exact location where the wall was hit)
    //(1-stepX)/2 = 1 if stepX = -1 and 0 if stepX is +1  -
    //this is needed because we need to add 1 to the length when rayDir.x < 0, 
    //this is for the same reason why 1.0 was added to the initial value of sideDistX in one case but not in the other.
    //the distance is then calculated as follows - if an x-side is hit, mapX-rayPosX+(1-stepX)/2) 
    // is the number of squares the ray has crossed in X direction.
    //if the ray is perpendicular on the X side, this is the correct value already, 
    //but because the direction of the ray is different most of the time,
    //it's real perpendicular distance will be larger, so we divide it through the X coordinate of the rayDir vector

    //calculate distance projected on camera direction (oblique distance will give fisheye effect!)
    if (side == 0) {
      wallDist = abs((mapX - rayPos.x + (1.0 - stepX) / 2.0) / rayDir.x);
    } else {
      wallDist = abs((mapY - rayPos.y + (1.0 - stepY) / 2.0) / rayDir.y);
    }

    if (drawRays) {  //only store rays if they're being drawn to the map
      hitPos.set(rayPos.x + rayDir.x * wallDist, rayPos.y + rayDir.y * wallDist);
      hits[x].set(hitPos.x, hitPos.y);
    }

    float colorDistMod = map(wallDist, 0, 20, 0, 50);

    //bma testing... distance to uniform grid point
    //wallDist = dist(pos.x, pos.y, mapX, mapY);

    //bma testing - fishbowl effect? nope

    //out of the calculated distance, calculate the height of the line that has to be drawn on screen
    //this is the inverse of wallDist, then multiplied by the screen height, to bring it to pixel coordinates.
    //(or another value if you want walls to be higher or lower)
    //out of this lineHeight (the height of the vertical line that should be drawn), 
    //the start and end position of where we should really draw are calculated.
    //the center of the wall should be at the center of the screen, 
    //and if these points lie outside the screen, they're capped to 0 or h-1

    //calculate height of line to draw on screen
    float lineHeight = abs(gameHeight/wallDist) * wallHeightMod;
    int lineHeightDiff = 0;
    if (lineHeight > gameHeight) {
      lineHeightDiff = (int)abs(lineHeight-gameHeight);
      lineHeight = min(lineHeight, gameHeight);
    }
    //***problem here. i need to know the total projected height of the line to map the texture properly.

    if (drawTextures) {
      int texNum = worldMap[mapX][mapY] - 1;
      //texturing calculations
      float wallX; //where exactly the wall was hit.
      if (side == 1) {
        wallX = rayPos.x + ((mapY - rayPos.y + (1 - stepY) / 2) / rayDir.y) * rayDir.x;
      } else {
        wallX = rayPos.y + ((mapX - rayPos.x + (1 - stepX) / 2) / rayDir.x) * rayDir.y;
      }
      wallX -= floor((wallX));

      //x coordinate of the texture
      int texX = int(wallX * (float)texWidth);
      if (side == 0 && rayDir.x > 0) {
        texX = texWidth - texX - 1;
      }
      if (side == 1 && rayDir.y < 0) {
        texX = texWidth - texX - 1;
      }

      float startY = gameHeight/2 - lineHeight/2;
      //float yIncr = max(1, lineHeight/texHeight);  //get the amount to increment to only draw based on texture size
      //for (int y = 0; y < lineHeight; y+=1) {   //1 vs. yIncr?
      for (int y = 0; y < lineHeight; y+=1) {
        //int texY = (int)map(y, 0, lineHeight, 0, texHeight);
        int texY = (int)map(y, 0-lineHeightDiff/2, lineHeight + lineHeightDiff/2, 0, texHeight);
        int c = texture[texNum][texWidth * texY + texX];
        //int c = (int)random(255);
        if (side == 1) { 
          c = (c >> 1) & 8355711;
        }

        if (rayWidth == 1) {
          //for (int yy = y; yy < (y + yIncr); yy++) {    //fill in the gaps
          //int pixelPos = gameWidth * (yy + (int)startY) + x;   //get the position to fill, modified w/ yy
          int pixelPos = gameWidth * (y + (int)startY) + x;
          if (pixelPos < buffer.length && pixelPos >= 0) {
            buffer[pixelPos] = c;
          }
          //}
        } else {
          int whatX = int(x * rayWidth); 
          //buffer[gameWidth * (y + (int)startY) + whatX] = color(c, c, c); //this is just the lines with spaces in between
          for (int moreX = whatX; moreX < whatX + rayWidth; moreX++) {
            int pixelPos = gameWidth * (y + (int)startY) + moreX;
            if (pixelPos < buffer.length && pixelPos >= 0) {
              buffer[pixelPos] = c;
            }
          }
          //add similar y buffer skip if y increment rate changed...

          //best glitch so far
          //for (int moreX = 1; moreX < rayWidth; moreX++) {
          //  //buffer[(int)rayNum * (y + (int)startY) + x * moreX] = color(c, c, c);  
          //}
        }
      }
    } else {
      lineHeight = min(lineHeight, gameHeight);
      //depending on what number the wall that was hit was, a color is chosen.
      //if a y-side was hit, the color is darker (for fake shading)
      if (mapX >= 0 && mapY >= 0) {
        switch (worldMap[mapX][mapY]) {
        case 0:
          break;
        case 1:
          stroke(200+colorDistMod, 150+colorDistMod, 150+colorDistMod);
          fill(200+colorDistMod, 150+colorDistMod, 150+colorDistMod);
          break;
        case 2:
          stroke(50+colorDistMod, 100+colorDistMod, 100+colorDistMod);
          fill(50+colorDistMod, 100+colorDistMod, 100+colorDistMod);
          break;
        case 3:
          stroke(150+colorDistMod, 75+colorDistMod, 100+colorDistMod);
          fill(150+colorDistMod, 75+colorDistMod, 100+colorDistMod);
          break;
        }
      }

      if (side == 1) {
        switch (worldMap[mapX][mapY]) {
        case 1:
          stroke(200/2+colorDistMod, 150/2+colorDistMod, 150/2+colorDistMod);
          fill(200/2+colorDistMod, 150/2+colorDistMod, 150/2+colorDistMod);
          break;
        case 2:
          stroke(50/2+colorDistMod, 100/2+colorDistMod, 100/2+colorDistMod);
          fill(50/2+colorDistMod, 100/2+colorDistMod, 100/2+colorDistMod);
          break;
        case 3:
          stroke(150/2+colorDistMod, 75/2+colorDistMod, 100/2+colorDistMod);
          fill(150/2+colorDistMod, 75/2+colorDistMod, 100/2+colorDistMod);
          break;
        }
      }

      //center the line
      float startY = height/2 - lineHeight/2;
      if (rayWidth == 1) {
        line(x, startY, x, startY + lineHeight);
      } else {
        noStroke();
        //stroke(0);
        //rect(x, startY, x + rayWidth, lineHeight);  //crazy glitch!! worth maybe being an art project
        rect(x * rayWidth, startY, rayWidth+0.1, lineHeight);
      }
    }
  }
}



void drawMap() {
  switch (whichMap) {
  case 0:  //no map
    break;

  case 1:  //static map (in corner) 
    fill(255, 100);
    stroke(255);
    for (int x = 0; x < worldMap.length; x++) {
      for (int y = 0; y < worldMap[0].length; y++) {
        if (worldMap[x][y] != 0) {
          rect(x*mapScale, y*mapScale, mapScale, mapScale);
        }
      }
    }

    //plane line relative to pos
    //stroke(0,255,0);
    //line((plane.x + pos.x) * 10, (plane.y + pos.y) * 10,
    //   pos.x * 10, pos.y * 10);

    //draw map rays
    if (drawRays) {
      for (int x = 0; x < (int)rayNum; x++) {
        stroke(50, 10);
        line(pos.x * mapScale, pos.y * mapScale, hits[x].x * mapScale, hits[x].y * mapScale);
      }
    }

    //camera position
    fill(255);
    ellipse(pos.x * mapScale, pos.y * mapScale, 5, 5);

    //dir line relative to pos
    stroke(255, 0, 0);
    line(pos.x * mapScale, pos.y * mapScale, (pos.x + dir.x) * mapScale, (pos.y + dir.y) * mapScale);

    //draw actual cam plane length line
    stroke(0);
    line((camPlaneMag*0.5*plane.x + pos.x) * 10, (camPlaneMag*0.5*plane.y + pos.y) * 10, 
      (camPlaneMag*0.5*-plane.x + pos.x) * 10, (camPlaneMag*0.5*-plane.y + pos.y) * 10);
    break;

  case 2:  //centered map, non-rotating
    pushMatrix();
    translate(width/2, height/2);
    pushMatrix();
    translate(-pos.x * mapScale*2, -pos.y * mapScale*2);
    stroke(255, 50);
    fill(255, 75);
    for (int x = 0; x < worldMap.length; x++) {
      for (int y = 0; y < worldMap[0].length; y++) {
        if (worldMap[x][y] != 0) {
          rect(x*mapScale*2, y*mapScale*2, mapScale*2, mapScale*2);
        }
      }
    }

    if (drawRays) {
      for (int x = 0; x < (int)rayNum; x++) {
        stroke(50, 50);
        line(pos.x * mapScale*2, pos.y * mapScale*2, hits[x].x * mapScale*2, hits[x].y * mapScale*2);
      }
    }

    popMatrix();
    fill(255, 100);
    ellipse(0, 0, 10, 10);
    stroke(255, 0, 0, 100);
    line(0, 0, (0 + dir.x) * mapScale * 2, (0 + dir.y) * mapScale * 2);
    popMatrix();
    break;

  case 3: //centered map, rotating
    pushMatrix();
    translate(width/2, height/2);
    rotate(rot - PI/2);

    pushMatrix();
    translate(-pos.x * mapScale*2, -pos.y * mapScale*2);
    stroke(255, 50);
    fill(255, 75);
    for (int x = 0; x < worldMap.length; x++) {
      for (int y = 0; y < worldMap[0].length; y++) {
        if (worldMap[x][y] != 0) {
          rect(x*mapScale*2, y*mapScale*2, mapScale*2, mapScale*2);
        }
      }
    }
    if (drawRays) {
      for (int x = 0; x < (int)rayNum; x++) {
        stroke(50, 30);
        line(pos.x * mapScale*2, pos.y * mapScale*2, hits[x].x * mapScale*2, hits[x].y * mapScale*2);
      }
    }
    popMatrix();

    fill(255, 150);
    ellipse(0, 0, 10, 10);
    stroke(255, 0, 0, 150);
    line(0, 0, (0 + dir.x) * mapScale * 2, (0 + dir.y) * mapScale * 2);
    popMatrix();
    break;
  }
}