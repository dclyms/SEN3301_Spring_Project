class Tile {
  float x, z;
  float size;
  int col, row;
  boolean isDirty = true;

  Tile(float x, float z, float size, int col, int row) {
    this.x = x;
    this.z = z;
    this.size = size;
    this.col = col;
    this.row = row;
  }

  void draw() {
    pushStyle();
    noStroke();
    float half = (size - 4) / 2.0;
    float top  = 101;
    float bot  = 105;

    if (isDirty) {
      // sandy texture when dirty
      textureMode(NORMAL);
      beginShape(QUADS);
        texture(dirtyTex);
        vertex(x - half, top, z - half, 0, 0);
        vertex(x + half, top, z - half, 1, 0);
        vertex(x + half, top, z + half, 1, 1);
        vertex(x - half, top, z + half, 0, 1);
      endShape();
      fill(220, 180, 155);
    } else {
      // black and white checkerboard when clean
      boolean isWhite = (col + row) % 2 == 0;
      fill(isWhite ? color(240) : color(20));
      beginShape(QUADS);
        vertex(x - half, top, z - half);
        vertex(x + half, top, z - half);
        vertex(x + half, top, z + half);
        vertex(x - half, top, z + half);
      endShape();
      fill(isWhite ? 200 : 40);
    }

    // thin slab edges
    beginShape(QUADS);
      vertex(x - half, top, z - half); vertex(x + half, top, z - half);
      vertex(x + half, bot, z - half); vertex(x - half, bot, z - half);

      vertex(x - half, top, z + half); vertex(x + half, top, z + half);
      vertex(x + half, bot, z + half); vertex(x - half, bot, z + half);

      vertex(x - half, top, z - half); vertex(x - half, top, z + half);
      vertex(x - half, bot, z + half); vertex(x - half, bot, z - half);

      vertex(x + half, top, z - half); vertex(x + half, top, z + half);
      vertex(x + half, bot, z + half); vertex(x + half, bot, z - half);
    endShape();

    popStyle();
  }
}
