class Robot {
  int gridX, gridZ;
  float x, y, z;
  boolean isMoving;
  float facing = 0;
  float prevX, prevZ;

  Robot(int gridX, int gridZ) {
    this.gridX = gridX;
    this.gridZ = gridZ;
    this.y = 25;
    this.x = -GRID_COLS * TILE_SIZE / 2.0 + gridX * TILE_SIZE + TILE_SIZE / 2.0;
    this.z = -GRID_ROWS * TILE_SIZE / 2.0 + gridZ * TILE_SIZE + TILE_SIZE / 2.0;
  }

  void update(boolean up, boolean down, boolean left, boolean right) {
    prevX = x;
    prevZ = z;
    float speed = 2.5;
    if (up)    z += speed;
    if (down)  z -= speed;
    if (left)  x += speed;
    if (right) x -= speed;

    isMoving = up || down || left || right;

    if (up)    facing = PI;
    if (down)  facing = 0;
    if (left)  facing = -PI/2;
    if (right) facing = PI/2;

    float half = TILE_SIZE / 2.0;
    x = constrain(x, -GRID_COLS * TILE_SIZE / 2.0 + half, GRID_COLS * TILE_SIZE / 2.0 - half);
    z = constrain(z, -GRID_ROWS * TILE_SIZE / 2.0 + half, GRID_ROWS * TILE_SIZE / 2.0 - half);

    gridX = (int)((x + GRID_COLS * TILE_SIZE / 2.0) / TILE_SIZE);
    gridZ = (int)((z + GRID_ROWS * TILE_SIZE / 2.0) / TILE_SIZE);
  }

  void draw() {
    pushMatrix();
    translate(x, y + sin(time) * 5, z);
    rotateY(facing);
    scale(0.8);

      // body
      pushMatrix();
        translate(0, 0, 0);
        fill(185, 215, 245);
        box(60, 80, 40);
      popMatrix();

      // head
      pushMatrix();
        translate(0, -70, 0);
        fill(185, 215, 245);
        box(40, 35, 35);
      popMatrix();

      // left arm
      pushMatrix();
        translate(-45, -10, 0);
        fill(185, 215, 245);
        if (isMoving) rotateZ(radians(30) + sin(time) * 0.2);
        else          rotateZ(radians(30));
        box(20, 50, 20);
      popMatrix();

      // right arm
      pushMatrix();
        translate(45, -10, 0);
        fill(185, 215, 245);
        if (isMoving) rotateZ(radians(-30) - sin(time) * 0.2);
        else          rotateZ(radians(-30));
        box(20, 50, 20);
      popMatrix();

      // broom handle + head sweep together
      pushMatrix();
        translate(-45, 15, 0);
        rotateX(radians(-45));
        if (isMoving) rotateZ(sin(time * 3) * 0.35);
        pushMatrix();
          translate(0, 20, 0);
          fill(240, 240, 245);
          box(8, 80, 8);
        popMatrix();
        pushMatrix();
          translate(0, 60, 0);
          fill(240, 240, 245);
          box(40, 10, 20);
        popMatrix();
      popMatrix();

    popMatrix();
  }
}
