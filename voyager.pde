// LIBRARY IMPORTS
import ddf.minim.*;
import ddf.minim.analysis.*;

boolean cont = true;

// GLOBAL VARIABLE DECLARATIONS

// fonts
PFont fL;
PFont fS;
// minim instance
Minim minim;
// audioplayer instance
AudioPlayer sample;
// visuals instance
Visuals vis;

// Fast-Fourier Transform (FFT)
FFT fft;
// FFT # of bands
int bands = 256;
// FFT smoothing factor
float smooth_factor = 0.02;
// FFT scaling factor
float scale=0.5;

// Create a smoothed values array
float[] sum;
int frame = 0;

// flag for showing debug data
boolean debug = false;

float rotAngle = 0.0;
float angleStep = 0.01;


void setup() {
  //size(256, 256);
  fullScreen();
  // initialize minim audio player
  // pass 'this' to indicate sketch || data directory for filepath.
  minim = new Minim(this);
  // minim loads audio file into audioplayer instance 
  // arguments: (file name / absolute path / url, int buffersize)
  // default buffersize: 
  sample = minim.loadFile("SOE_03.mp3", 1024);
  // decent matches: 18, 14, 12, 11, 10, 09, 08, 04+, 03, 02
  //sample = minim.loadFile("pauline.mp3", 1024);
  
  // loop audio
  sample.loop();

  // initialize and patch the FFT analyzer
  fft = new FFT( sample.bufferSize(), sample.sampleRate() );

  // calculate the averages by grouping frequency bands linearly. use 30 averages.
  fft.linAverages( bands );

  fL = createFont("SourceCodePro-Regular.ttf", 16);
  fS = createFont("SourceCodePro-Regular.ttf", 12);
  textAlign(LEFT, BOTTOM);

  sum = new float[bands];

  // initialize the visuals class
  vis = new Visuals(fft.specSize());
  vis.setup();
}      

void draw() {
  // rotation 
  if (rotAngle >= 10 || rotAngle >= 10) {
    angleStep = -angleStep;
  }
 stroke(255);
  rotAngle += angleStep;
  //fill(255, map(rotAngle, 0, 10, 0,255));
  fill(255,60);
  // get the FFT and push it to the visualizer
  fft.forward(sample.mix);
  for (int i = 0; i < bands; i++) {
    // smooth the FFT data by smoothing factor
    sum[i] += (fft.getAvg(i) - sum[i]) * smooth_factor;
    // use smoothed, scaled values
    vis.setBand(i, sum[i]*scale); 
    // use raw values
    //vis.setBand(i, fft.getAvg(i));
  }

  // DRAW VISUALS
  vis.draw();

  if (cont){
    pushMatrix();
    translate(width/2, height/2);
    rotate(rotAngle);
    float sclx = 200;
    int x = 0;
    float orbit = 10;
    orbit += 3*angleStep;
    
    ellipse(-2, -20, 7, 7);
    ellipse(10+ orbit, 0, 10, 10);
    line(0,0, 10 + orbit,0);
    line(-2,-20, 10 + orbit,0);
        for (int i = 0; i < bands; i++) {
      // draw the bands with a scale factor
      translate(sum[i],i);
      rotate(sum[i]);
      ellipse(i,-20,sum[i]*2,sum[i]*2);
    }
    
    pushMatrix();
    rotate(rotAngle/3);
    ellipse(-2, -40, 5, 5);

    popMatrix();

    for (int i = 0; i < sample.bufferSize() - 1; i+=4) {
      point(x + rotAngle, -20  + sample.left.get(i)*sclx + rotAngle);
      pushMatrix();
      rotate(-3*rotAngle);
      point(-40 + sample.right.get(i)*sclx*2.5, x);
      popMatrix();
      x++;
    }
    popMatrix();
  }

  if (sample.isPlaying()) {
    vis.setFrame(frame++);
  }
  if (sample.position() < 60) {
    frame = 0;
  }
}

void keyPressed() {

  // SPACE to pause/play the sound
  if (key == ' ') {
    if (sample.isPlaying()) {
      sample.pause();
    } else {
      sample.loop();
    }
  }
  // 'R' to rewind (I think this is actually start over)
  if (key == 'r') {
    sample.rewind();
  }
  
    if (key == 'p') {
    cont = !cont;
  }
}