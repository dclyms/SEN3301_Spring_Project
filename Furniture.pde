abstract class Furniture {
  float x, z;
  float colMinX, colMaxX, colMinZ, colMaxZ;

  Furniture(float x, float z) {
    this.x = x;
    this.z = z;
  }

  // returns true if a circle at (px, pz) with the given radius overlaps this piece
  boolean collidesWith(float px, float pz, float radius) {
    return px + radius > x + colMinX &&
           px - radius < x + colMaxX &&
           pz + radius > z + colMinZ &&
           pz - radius < z + colMaxZ;
  }

  abstract void draw();
}
