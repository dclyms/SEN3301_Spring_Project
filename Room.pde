class Room {
  int cols, rows, tileSize;
  float startX, startZ;
  Tile[][] tiles;

  Room(int cols, int rows, int tileSize) {
    this.cols = cols;
    this.rows = rows;
    this.tileSize = tileSize;
    startX = -cols * tileSize / 2.0;
    startZ = -rows * tileSize / 2.0;

    tiles = new Tile[cols][rows];
    for (int c = 0; c < cols; c++) {
      for (int r = 0; r < rows; r++) {
        tiles[c][r] = new Tile(
          startX + c * tileSize + tileSize / 2.0,
          startZ + r * tileSize + tileSize / 2.0,
          tileSize, c, r
        );
      }
    }
  }

  float getCleanPercent() {
    int clean = 0;
    for (int c = 0; c < cols; c++)
      for (int r = 0; r < rows; r++)
        if (!tiles[c][r].isDirty) clean++;
    return (float) clean / (cols * rows) * 100;
  }

  void dirtyAt(int col, int row) {
    if (col >= 0 && col < cols && row >= 0 && row < rows)
      tiles[col][row].isDirty = true;
  }

  void cleanAt(int col, int row) {
    if (col >= 0 && col < cols && row >= 0 && row < rows)
      tiles[col][row].isDirty = false;
  }

  void draw() {
    float roomW = cols * tileSize;
    float roomD = rows * tileSize;
    float cx = startX + roomW / 2.0;
    float cz = startZ + roomD / 2.0;

    // floor
    pushMatrix();
      translate(cx, 115, cz);
      fill(255, 245, 220);
      box(roomW, 20, roomD);
    popMatrix();

    // tiles
    for (int c = 0; c < cols; c++)
      for (int r = 0; r < rows; r++)
        tiles[c][r].draw();

    // right wall
    pushMatrix();
      translate(startX + roomW + 10, 0, cz);
      fill(255, 182, 205);
      box(20, 250, roomD);
    popMatrix();

    // back wall
    pushMatrix();
      translate(startX + (roomW + 20) / 2.0, 0, startZ + roomD + 10);
      fill(255, 182, 205);
      box(roomW + 20, 250, 20);
    popMatrix();
  }
}
