class Visuals {
  // this is where the sound spectrum data is stored
  float[] bands;
  // how many values are in the array
  int numBands;
  // frame counter (resets when sound restarts)
  int frame;

  void setup() {
  }

  void draw() {
    // instead of background, draw rect with variable alpha
    // creates ghosting effect
    fill(0, map(rotAngle, 0, 10, 25, 205));
    stroke(0);
    rect(0, 0, width, height);
    // reset fill and stroke for other imagery
    fill(255, map(rotAngle, 0, 10, 20, 60));
    stroke(255, 200);

    // rotation
    if (rotAngle <= 0.0 || rotAngle >= 10.0) {
      angleStep = -angleStep;
    }
    rotAngle += angleStep;

    // access 'bands' array in draw with an index between 0 to 'numBands-1'.
    float r = bands[15] * width;
    // origin ellipse
    ellipse(width/2, height/2, r/3, r/3);

    // ellipse nodes && links that rotate around origin ellipse
    pushMatrix();
    translate(width/2, height/2);
    rotate(rotAngle);
    int x = 0;
    float orbit = 10;
    orbit += 3*angleStep;

    ellipse(-2, -20, 7, 7);
    ellipse(10+ orbit, 0, 10, 10);
    line(0, 0, 10 + orbit, 0);
    line(-2, -20, 10 + orbit, 0);
    popMatrix();
  }


  ///////////////////////////////////////////
  // NO NEED TO TOUCH THIS CODE  ////////////
  ///////////////////////////////////////////

  Visuals(int _numBands) {
    numBands = _numBands;
    bands = new float[numBands];
  }

  void setBand(int i, float v) {
    if (i >= 0 && i < numBands) {
      bands[i] = v;
    } else {
      println("bad reference on vis.setBand");
    }
  }

  void setFrame(int fr) {
    frame = fr;
  }
}


String date() {
  fill(200);
  rectMode(CORNER);
  rect(width/2- 75, height - 25, 140, 25);
  fill(0);
  textSize(10);
  return(
    year()
    + "_" + month() 
    + "_" + day()
    + "_" + hour()
    + "_" + minute()
    + "_" + second()
    );
}