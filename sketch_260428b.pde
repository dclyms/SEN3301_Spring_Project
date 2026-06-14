Robot robot;
Rabbit rabbit;
Room room;
VacuumCleaner vacuum;
Sofa sofa;
Bookcase bookcase;

int TILE_SIZE = 100;
int GRID_COLS = 6;
int GRID_ROWS = 6;

PImage dirtyTex, sofaTex, robotImg, vacuumTex;

int cameraX = -40;
int cameraY = 525;
int cameraZ = -200;
float time = 0;

boolean moveUp, moveDown, moveLeft, moveRight;
boolean zoomIn, zoomOut;

// game states: 0 = menu, 1 = playing, 2 = lost, 3 = level won, 4 = game won
int gameState = 0;

PFont gameFont;
float timer = 80;

int btnW = 220;
int btnH = 60;

Level[] levels;
int currentLevel = 0;

void setup() {
  fullScreen(P3D);
  surface.setResizable(true);

  gameFont = createFont("Yabikoma-e9W16.otf", 64);
  dirtyTex  = loadImage("TCom_Sand_Muddy2_2x2_512_albedo.tif");
  sofaTex   = loadImage("Fabric008_1K-JPG_Color.jpg");
  robotImg  = loadImage("robot.png");
  vacuumTex = loadImage("metallic.png");

  rabbit = new Rabbit(1, 1);
  vacuum = new VacuumCleaner(-150, 85, 0);

  levels = new Level[] {
    new Level(1,  6,  6, 100, 80),
    new Level(2,  8,  8, 100, 70),
    new Level(3, 10, 10, 100, 60)
  };

  initGame();
}

void initGame() {
  Level lvl = levels[currentLevel];
  GRID_COLS = lvl.cols;
  GRID_ROWS = lvl.rows;
  TILE_SIZE = lvl.tileSize;
  timer     = lvl.timeLimit;
  robot     = new Robot(lvl.cols / 2, lvl.rows / 2);
  room      = new Room(GRID_COLS, GRID_ROWS, TILE_SIZE);

  // put furniture along the room edges
  float halfX = GRID_COLS * TILE_SIZE / 2.0;
  float halfZ = GRID_ROWS * TILE_SIZE / 2.0;
  sofa     = new Sofa(0, halfZ - 55);
  bookcase = new Bookcase(-(halfX - 50), 0);

  if (currentLevel >= 1) rabbit = new Rabbit(1, 1);
  if (currentLevel >= 2) vacuum = new VacuumCleaner(0, 85, 0);
  moveUp = moveDown = moveLeft = moveRight = false;
}

void draw() {
  if      (gameState == 0) drawMenu();
  else if (gameState == 1) drawGame();
  else if (gameState == 2) drawLosePopup();
  else if (gameState == 3) drawWinPopup();
  else if (gameState == 4) drawGameWonPopup();
}

void drawMenu() {
  background(255, 220, 230);
  hint(DISABLE_DEPTH_TEST);
  camera();
  perspective();
  pushStyle();
  textFont(gameFont);

  textAlign(CENTER, CENTER);
  textSize(64);
  fill(200, 80, 120);
  text("Cleaning Bot", width / 2, height / 4);

  float bx     = width / 2 - btnW / 2;
  float startY = height / 2 - btnH / 2;
  float exitY  = height / 2 + 90 - btnH / 2;
  drawButton("Start Game", bx, startY, btnW, btnH, mouseOverButton(bx, startY, btnW, btnH));
  drawButton("Exit",       bx, exitY,  btnW, btnH, mouseOverButton(bx, exitY,  btnW, btnH));

  popStyle();
  hint(ENABLE_DEPTH_TEST);
}

void drawGame() {
  if (room.getCleanPercent() >= 75) { gameState = 3; return; }

  timer -= 1.0 / frameRate;
  if (timer <= 0) {
    timer = 0;
    if (room.getCleanPercent() < 75) gameState = 2;
  }

  background(255, 255, 255);
  translate(width / 2, height / 2, cameraZ);
  rotateX(radians(cameraX));
  rotateY(radians(cameraY));
  time += 0.05;
  if (zoomOut) cameraZ = constrain(cameraZ + 5, -800, 200);
  if (zoomIn)  cameraZ = constrain(cameraZ - 5, -800, 200);

  room.draw();
  robot.update(moveUp, moveDown, moveLeft, moveRight);

  // push the robot back if it walks into furniture
  Furniture[] furnitures = {sofa, bookcase};
  for (Furniture f : furnitures) {
    if (f.collidesWith(robot.x, robot.z, 28)) {
      robot.x = robot.prevX;
      robot.z = robot.prevZ;
    }
  }

  room.cleanAt(robot.gridX, robot.gridZ);
  robot.draw();
  sofa.draw();
  bookcase.draw();
  if (currentLevel >= 1) { rabbit.update(room, furnitures); rabbit.draw(); }
  if (currentLevel >= 2) { vacuum.update(room, furnitures); vacuum.draw(); }

  // HUD
  hint(DISABLE_DEPTH_TEST);
  camera();
  perspective();
  pushStyle();
  textFont(gameFont);

  if (timer <= 15) fill(220, 80, 80);
  else             fill(220, 100, 140);
  textSize(28);
  textAlign(LEFT, BOTTOM);
  text("Time: " + ceil(timer) + "s", 20, height - 20);

  fill(220, 100, 140);
  textAlign(RIGHT, BOTTOM);
  text(nf(room.getCleanPercent(), 1, 1) + "% cleaned", width - 20, height - 20);

  textAlign(LEFT, TOP);
  textSize(22);
  text("Level " + levels[currentLevel].number, 20, 20);

  popStyle();
  hint(ENABLE_DEPTH_TEST);
}

void drawLosePopup() {
  background(255, 255, 255);
  translate(width / 2, height / 2, cameraZ);
  rotateX(radians(cameraX));
  rotateY(radians(cameraY));
  room.draw();
  robot.draw();
  sofa.draw();
  bookcase.draw();

  hint(DISABLE_DEPTH_TEST);
  camera();
  perspective();
  pushStyle();
  textFont(gameFont);

  fill(0, 0, 0, 160);
  noStroke();
  rect(0, 0, width, height);

  float boxW = 380, boxH = 260;
  float boxX = width / 2 - boxW / 2;
  float boxY = height / 2 - boxH / 2;
  fill(40, 40, 40);
  stroke(200);
  strokeWeight(2);
  rect(boxX, boxY, boxW, boxH, 16);

  fill(255);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("Time's up!", width / 2, boxY + 55);
  textSize(20);
  fill(200);
  text("You cleaned " + nf(room.getCleanPercent(), 1, 1) + "%\nYou needed 75%", width / 2, boxY + 115);

  float bx   = width / 2 - btnW / 2;
  float tryY = boxY + boxH - 130;
  drawButton("Try Again", bx, tryY,             btnW, btnH, mouseOverButton(bx, tryY,             btnW, btnH));
  drawButton("Exit Game", bx, tryY + btnH + 14, btnW, btnH, mouseOverButton(bx, tryY + btnH + 14, btnW, btnH));

  popStyle();
  hint(ENABLE_DEPTH_TEST);
}

void drawWinPopup() {
  background(255, 255, 255);
  translate(width / 2, height / 2, cameraZ);
  rotateX(radians(cameraX));
  rotateY(radians(cameraY));
  room.draw();
  robot.draw();
  sofa.draw();
  bookcase.draw();

  hint(DISABLE_DEPTH_TEST);
  camera();
  perspective();
  pushStyle();
  textFont(gameFont);

  fill(0, 0, 0, 160);
  noStroke();
  rect(0, 0, width, height);

  float boxW = 380, boxH = 260;
  float boxX = width / 2 - boxW / 2;
  float boxY = height / 2 - boxH / 2;
  fill(40, 40, 40);
  stroke(200);
  strokeWeight(2);
  rect(boxX, boxY, boxW, boxH, 16);

  fill(255, 220, 80);
  textSize(36);
  textAlign(CENTER, CENTER);
  text("Congrats!", width / 2, boxY + 55);
  fill(200);
  textSize(20);
  text("You cleaned " + nf(room.getCleanPercent(), 1, 1) + "%", width / 2, boxY + 110);

  float bx   = width / 2 - btnW / 2;
  float btnY = boxY + boxH - 100;
  drawButton("Next Level", bx, btnY, btnW, btnH, mouseOverButton(bx, btnY, btnW, btnH));

  popStyle();
  hint(ENABLE_DEPTH_TEST);
}

void drawGameWonPopup() {
  background(255, 220, 230);
  hint(DISABLE_DEPTH_TEST);
  camera();
  perspective();
  pushStyle();
  textFont(gameFont);

  fill(200, 80, 120);
  textSize(72);
  textAlign(CENTER, CENTER);
  text("You Won!", width / 2, height / 2 - 80);

  fill(150, 40, 80);
  textSize(24);
  text("You cleaned all 3 levels!", width / 2, height / 2);

  float bx   = width / 2 - btnW / 2;
  float btnY = height / 2 + 70;
  drawButton("Main Menu", bx, btnY, btnW, btnH, mouseOverButton(bx, btnY, btnW, btnH));

  popStyle();
  hint(ENABLE_DEPTH_TEST);
}

void drawButton(String label, float x, float y, float w, float h, boolean hovered) {
  if (hovered) fill(255, 160, 190);
  else         fill(255, 182, 205);
  stroke(220, 100, 140);
  strokeWeight(2);
  rect(x, y, w, h, 10);
  fill(130, 40, 80);
  noStroke();
  textSize(26);
  textAlign(CENTER, CENTER);
  text(label, x + w / 2, y + h / 2);
}

boolean mouseOverButton(float x, float y, float w, float h) {
  return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
}

void mousePressed() {
  if (gameState == 0) {
    float bx     = width / 2 - btnW / 2;
    float startY = height / 2 - btnH / 2;
    float exitY  = height / 2 + 90 - btnH / 2;
    if (mouseOverButton(bx, startY, btnW, btnH)) { currentLevel = 0; initGame(); gameState = 1; }
    if (mouseOverButton(bx, exitY,  btnW, btnH)) exit();
  }

  if (gameState == 2) {
    float bx   = width / 2 - btnW / 2;
    float tryY = height / 2 - 260 / 2 + 260 - 130;
    if (mouseOverButton(bx, tryY,             btnW, btnH)) { initGame(); gameState = 1; }
    if (mouseOverButton(bx, tryY + btnH + 14, btnW, btnH)) exit();
  }

  if (gameState == 3) {
    float bx   = width / 2 - btnW / 2;
    float btnY = height / 2 - 260 / 2 + 260 - 100;
    if (mouseOverButton(bx, btnY, btnW, btnH)) {
      if (currentLevel >= levels.length - 1) {
        gameState = 4;
      } else {
        currentLevel++;
        initGame();
        gameState = 1;
      }
    }
  }

  if (gameState == 4) {
    float bx   = width / 2 - btnW / 2;
    float btnY = height / 2 + 70;
    if (mouseOverButton(bx, btnY, btnW, btnH)) { currentLevel = 0; gameState = 0; }
  }
}

void keyPressed() {
  if (gameState != 1) return;
  if (key == 'q' || key == 'Q') zoomOut = true;
  if (key == 'e' || key == 'E') zoomIn  = true;
  if (key == 'w' || key == 'W' || keyCode == UP)    moveUp    = true;
  if (key == 's' || key == 'S' || keyCode == DOWN)  moveDown  = true;
  if (key == 'a' || key == 'A' || keyCode == LEFT)  moveLeft  = true;
  if (key == 'd' || key == 'D' || keyCode == RIGHT) moveRight = true;
}

void keyReleased() {
  if (key == 'q' || key == 'Q') zoomOut = false;
  if (key == 'e' || key == 'E') zoomIn  = false;
  if (key == 'w' || key == 'W' || keyCode == UP)    moveUp    = false;
  if (key == 's' || key == 'S' || keyCode == DOWN)  moveDown  = false;
  if (key == 'a' || key == 'A' || keyCode == LEFT)  moveLeft  = false;
  if (key == 'd' || key == 'D' || keyCode == RIGHT) moveRight = false;
}
