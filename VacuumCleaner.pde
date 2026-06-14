class VacuumCleaner {
  float x, y, z;
  float vx, vz;
  float dirTimer = 0;

  VacuumCleaner(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
    pickNewDirection();
  }

  void pickNewDirection() {
    float angle = random(TWO_PI);
    float speed = 0.8;
    vx = cos(angle) * speed;
    vz = sin(angle) * speed;
    dirTimer = random(2.0, 5.0);
  }

  void update(Room room, Furniture[] furnitures) {
    dirTimer -= 1.0 / frameRate;
    if (dirTimer <= 0) pickNewDirection();

    float prevX = x;
    float prevZ = z;
    x += vx;
    z += vz;

    // bounce off room walls
    float half = TILE_SIZE / 2.0;
    float minX = -GRID_COLS * TILE_SIZE / 2.0 + half;
    float maxX =  GRID_COLS * TILE_SIZE / 2.0 - half;
    float minZ = -GRID_ROWS * TILE_SIZE / 2.0 + half;
    float maxZ =  GRID_ROWS * TILE_SIZE / 2.0 - half;
    if (x < minX || x > maxX) { vx *= -1; x = constrain(x, minX, maxX); dirTimer = 0; }
    if (z < minZ || z > maxZ) { vz *= -1; z = constrain(z, minZ, maxZ); dirTimer = 0; }

    // bounce off furniture
    float radius = 55;
    for (Furniture f : furnitures) {
      if (f.collidesWith(x, z, radius)) {
        if      (!f.collidesWith(prevX, z, radius)) { vx *= -1; x = prevX; }
        else if (!f.collidesWith(x, prevZ, radius)) { vz *= -1; z = prevZ; }
        else { vx *= -1; vz *= -1; x = prevX; z = prevZ; }
        dirTimer = 0;
      }
    }

    // clean the tile it's sitting on
    int gridX = (int)((x + GRID_COLS * TILE_SIZE / 2.0) / TILE_SIZE);
    int gridZ = (int)((z + GRID_ROWS * TILE_SIZE / 2.0) / TILE_SIZE);
    room.cleanAt(gridX, gridZ);
  }

  void draw() {
    pushMatrix();
    pushStyle();
    translate(x, y, z);
    noStroke();
    textureMode(NORMAL);

    // body
    drawCylinderTex(vacuumTex, 50, 15, 20);

    // base
    pushMatrix();
      translate(0, 8, 0);
      drawCylinderTex(vacuumTex, 55, 8, 20);
    popMatrix();

    // spinning brushes
    pushMatrix();
      translate(-55, 8, 0);
      rotateY(time);
      fill(245, 240, 225);
      drawCylinder(12, 5, 20);
    popMatrix();
    pushMatrix();
      translate(55, 8, 0);
      rotateY(-time);
      fill(245, 240, 225);
      drawCylinder(12, 5, 20);
    popMatrix();

    popStyle();
    popMatrix();
  }

  void drawCylinderTex(PImage tex, float r, float h, int sides) {
    float angle = TWO_PI / sides;
    tint(255);

    // top cap
    beginShape();
      texture(tex);
      for (int i = 0; i < sides; i++) {
        float a = i * angle;
        vertex(cos(a) * r, -h/2, sin(a) * r, 0.5 + cos(a)*0.5, 0.5 + sin(a)*0.5);
      }
    endShape(CLOSE);

    // bottom cap
    beginShape();
      texture(tex);
      for (int i = 0; i < sides; i++) {
        float a = i * angle;
        vertex(cos(a) * r, h/2, sin(a) * r, 0.5 + cos(a)*0.5, 0.5 + sin(a)*0.5);
      }
    endShape(CLOSE);

    // sides
    beginShape(QUAD_STRIP);
      texture(tex);
      for (int i = 0; i <= sides; i++) {
        float a = i * angle;
        float u = float(i) / sides;
        vertex(cos(a) * r, -h/2, sin(a) * r, u, 0);
        vertex(cos(a) * r,  h/2, sin(a) * r, u, 1);
      }
    endShape();
  }

  void drawCylinder(float r, float h, int sides) {
    float angle = TWO_PI / sides;

    beginShape();
    for (int i = 0; i < sides; i++)
      vertex(cos(i * angle) * r, -h/2, sin(i * angle) * r);
    endShape(CLOSE);

    beginShape();
    for (int i = 0; i < sides; i++)
      vertex(cos(i * angle) * r, h/2, sin(i * angle) * r);
    endShape(CLOSE);

    beginShape(QUAD_STRIP);
    for (int i = 0; i <= sides; i++) {
      vertex(cos(i * angle) * r, -h/2, sin(i * angle) * r);
      vertex(cos(i * angle) * r,  h/2, sin(i * angle) * r);
    }
    endShape();
  }
}
