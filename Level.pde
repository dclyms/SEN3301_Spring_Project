class Level {
  int number;
  int cols, rows, tileSize;
  float timeLimit;

  Level(int number, int cols, int rows, int tileSize, float timeLimit) {
    this.number    = number;
    this.cols      = cols;
    this.rows      = rows;
    this.tileSize  = tileSize;
    this.timeLimit = timeLimit;
  }
}
