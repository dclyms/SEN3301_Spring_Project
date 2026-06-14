class Rabbit {
  int gridX, gridZ;
  float x, y, z;
  float targetX, targetZ;
  float facing = 0;
  float targetFacing = 0;
  float hopTimer = 2.0;

  Rabbit(int gridX, int gridZ) {
    this.gridX = gridX;
    this.gridZ = gridZ;
    this.y = 50;
    targetX = gridToWorldX(gridX);
    targetZ = gridToWorldZ(gridZ);
    x = targetX;
    z = targetZ;
  }

  float gridToWorldX(int gx) {
    return -GRID_COLS * TILE_SIZE / 2.0 + gx * TILE_SIZE + TILE_SIZE / 2.0;
  }

  float gridToWorldZ(int gz) {
    return -GRID_ROWS * TILE_SIZE / 2.0 + gz * TILE_SIZE + TILE_SIZE / 2.0;
  }

  void update(Room room, Furniture[] furnitures) {
    x = lerp(x, targetX, 0.15);
    z = lerp(z, targetZ, 0.15);

    // smooth turn, handles angle wrap-around
    float diff = targetFacing - facing;
    while (diff >  PI) diff -= TWO_PI;
    while (diff < -PI) diff += TWO_PI;
    facing += diff * 0.12;

    hopTimer -= 1.0 / frameRate;
    if (hopTimer <= 0) {
      int[] dx = {-1, 1, 0, 0};
      int[] dz = {0, 0, -1, 1};

      // try all 4 directions in a random order so the rabbit keeps moving
      int[] order = {0, 1, 2, 3};
      for (int i = 3; i > 0; i--) {
        int j = (int)random(i + 1);
        int tmp = order[i]; order[i] = order[j]; order[j] = tmp;
      }

      for (int i = 0; i < 4; i++) {
        int dir  = order[i];
        int newX = gridX + dx[dir];
        int newZ = gridZ + dz[dir];
        if (newX < 0 || newX >= GRID_COLS || newZ < 0 || newZ >= GRID_ROWS) continue;
        float tX = gridToWorldX(newX);
        float tZ = gridToWorldZ(newZ);
        boolean blocked = false;
        for (Furniture f : furnitures) {
          if (f.collidesWith(tX, tZ, 35)) { blocked = true; break; }
        }
        if (!blocked) {
          gridX = newX;
          gridZ = newZ;
          targetX = tX;
          targetZ = tZ;
          room.dirtyAt(gridX, gridZ);
          targetFacing = atan2(float(dz[dir]), float(-dx[dir]));
          break;
        }
      }
      hopTimer = random(0.5, 1.2);
    }
  }

  void draw() {
    pushMatrix();
    translate(x, y + sin(time * 2) * 10, z);
    rotateY(facing);

      // body
      pushMatrix();
        fill(255, 182, 205);
        box(60, 45, 40);
      popMatrix();

      // head
      pushMatrix();
        fill(255, 182, 205);
        translate(-40, -15, 0);
        box(35, 35, 30);
      popMatrix();

      // left ear
      pushMatrix();
        fill(255, 182, 205);
        translate(-40, -50 + sin(time * 2 + 0.3) * 2, 10);
        rotateX(sin(time * 2 + 0.3) * 0.08);
        box(10, 40, 10);
      popMatrix();

      // right ear
      pushMatrix();
        fill(255, 182, 205);
        translate(-40, -50 + sin(time * 2 + 1.2) * 2, -10);
        rotateX(sin(time * 2 + 1.2) * 0.08);
        box(10, 45, 10);
      popMatrix();

      // tail
      pushMatrix();
        fill(255, 210, 220);
        translate(40, -15, 0);
        box(15, 15, 15);
      popMatrix();

      // front legs
      pushMatrix();
        fill(255, 182, 205);
        translate(-20, 40 - sin(time * 2) * 4, 10);
        box(15, 30, 12);
      popMatrix();
      pushMatrix();
        fill(255, 182, 205);
        translate(-20, 40 - sin(time * 2) * 4, -10);
        box(15, 30, 12);
      popMatrix();

      // back legs
      pushMatrix();
        fill(255, 182, 205);
        translate(20, 40 - sin(time * 2) * 4, 10);
        box(15, 30, 12);
      popMatrix();
      pushMatrix();
        fill(255, 182, 205);
        translate(20, 40 - sin(time * 2) * 4, -10);
        box(15, 30, 12);
      popMatrix();

    popMatrix();
  }
}
