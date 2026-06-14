class Sofa extends Furniture {

  Sofa(float x, float z) {
    super(x, z);
    colMinX = -90; colMaxX = 90;
    colMinZ = -55; colMaxZ = 45;
  }

  void draw() {
    pushMatrix();
    translate(x, 0, z);
    pushStyle();
    stroke(0);
    strokeWeight(1.5);
    textureMode(NORMAL);

    // seat
    pushMatrix();
      translate(0, 85, -10);
      texBox(sofaTex, 160, 40, 90);
    popMatrix();

    // back
    pushMatrix();
      translate(0, 48, 35);
      texBox(sofaTex, 160, 75, 20);
    popMatrix();

    // left armrest
    pushMatrix();
      translate(-80, 75, -10);
      texBox(sofaTex, 20, 55, 90);
    popMatrix();

    // right armrest
    pushMatrix();
      translate(80, 75, -10);
      texBox(sofaTex, 20, 55, 90);
    popMatrix();

    // left cushion
    pushMatrix();
      translate(-38, 63, -10);
      texBox(sofaTex, 65, 18, 80);
    popMatrix();

    // right cushion
    pushMatrix();
      translate(38, 63, -10);
      texBox(sofaTex, 65, 18, 80);
    popMatrix();

    popStyle();
    popMatrix();
  }

  void texBox(PImage tex, float w, float h, float d) {
    float hw = w/2, hh = h/2, hd = d/2;
    beginShape(QUADS);
      texture(tex);
      // top
      vertex(-hw, -hh, -hd, 0, 0);
      vertex( hw, -hh, -hd, 1, 0);
      vertex( hw, -hh,  hd, 1, 1);
      vertex(-hw, -hh,  hd, 0, 1);
      // bottom
      vertex(-hw,  hh, -hd, 0, 0);
      vertex( hw,  hh, -hd, 1, 0);
      vertex( hw,  hh,  hd, 1, 1);
      vertex(-hw,  hh,  hd, 0, 1);
      // front
      vertex(-hw, -hh, -hd, 0, 0);
      vertex( hw, -hh, -hd, 1, 0);
      vertex( hw,  hh, -hd, 1, 1);
      vertex(-hw,  hh, -hd, 0, 1);
      // back
      vertex(-hw, -hh,  hd, 0, 0);
      vertex( hw, -hh,  hd, 1, 0);
      vertex( hw,  hh,  hd, 1, 1);
      vertex(-hw,  hh,  hd, 0, 1);
      // left
      vertex(-hw, -hh, -hd, 0, 0);
      vertex(-hw, -hh,  hd, 1, 0);
      vertex(-hw,  hh,  hd, 1, 1);
      vertex(-hw,  hh, -hd, 0, 1);
      // right
      vertex( hw, -hh, -hd, 0, 0);
      vertex( hw, -hh,  hd, 1, 0);
      vertex( hw,  hh,  hd, 1, 1);
      vertex( hw,  hh, -hd, 0, 1);
    endShape();
  }
}
