class Bookcase extends Furniture {

  Bookcase(float x, float z) {
    super(x, z);
    // rotated 90° so it lines up with the left wall
    colMinX = -25; colMaxX = 25;
    colMinZ = -58; colMaxZ = 58;
  }

  void draw() {
    pushMatrix();
    translate(x, 0, z);
    rotateY(HALF_PI);

    // frame
    pushMatrix();
      translate(0, 15, 0);
      fill(210, 175, 140);
      box(110, 200, 45);
    popMatrix();

    // shelves
    for (int i = 0; i < 3; i++) {
      pushMatrix();
        translate(0, 35 + i * 55, 0);
        fill(190, 155, 120);
        box(105, 6, 40);
      popMatrix();
    }

    // books
    color[] bookColors = {
      color(255, 182, 185),
      color(190, 215, 235),
      color(195, 235, 198),
      color(255, 223, 186),
      color(221, 195, 235)
    };

    for (int shelf = 0; shelf < 3; shelf++) {
      float shelfY = 25 + shelf * 55;
      float bx = -42;
      for (int b = 0; b < 5; b++) {
        pushMatrix();
          translate(bx, shelfY, 0);
          fill(bookColors[b]);
          box(14, 28 + (b % 2) * 8, 30);
        popMatrix();
        bx += 18;
      }
    }

    popMatrix();
  }
}
