// decent voyager matches: 18, 14, 12, 11, 10, 09, 08, 04+, 03, 02

// LIBRARIES
import ddf.minim.*;
import ddf.minim.analysis.*;

// DECLARE GLOBAL VARIABLE 

// library instances
// ?? viz class
Minim minim;
AudioPlayer sample;
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
boolean cont = true;

// rotation
float rotAngle = 0.0;
float angleStep = 0.01;


void setup() {
  size(256, 256);
  //fullScreen();

  // initialize minim audio player
  // pass 'this' to indicate [sketch|data] directory for filepath.
  minim = new Minim(this);

  // initialize (?) the audioplayer instance with audio file via minim 
  // arguments: (file name / absolute path / url, int buffersize)
  // ?? url attempts returned errors
  // ?? why default buffersize: 1024
  sample = minim.loadFile("SOE_03.mp3", 1024);

  // loop sample in audioplayer
  sample.loop();

  // initialize and patch the FFT analyzer
  // ?? what does patch mean
  fft = new FFT( sample.bufferSize(), sample.sampleRate() );

  // calculate the averages by grouping frequency bands linearly. use 30 averages.
  // ?? calculate the average of what?
  fft.linAverages( bands );

  // initialize the visuals instance
  vis = new Visuals(fft.specSize());
  vis.setup();

  sum = new float[bands];
}      

void draw() {

  // color
  stroke(255);
  fill(255, 60);
  // !! feature opportunity
  // fill(255, map(rotAngle, 0, 10, 0,255));

  // rotation
  if (rotAngle >= 10 || rotAngle >= 10) {
    angleStep = -angleStep;
  }
  rotAngle += angleStep;

  // ?? figure out what this does
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

  // !! feature opportunity (cont)
  // ?? integrate into viz class
  // ?? explore draw order of shapes
  if (cont) {
    pushMatrix();
    translate(width/2, height/2);
    rotate(rotAngle);
    float sclx = 200;
    int x = 0;
    float orbit = 10;
    orbit += 3*angleStep;

    ellipse(-2, -20, 7, 7);
    // ?? used to translate off screen
    ellipse(10+ orbit, 0, 10, 10);
    line(0, 0, 10 + orbit, 0);
    line(-2, -20, 10 + orbit, 0);

    // lines
    // ?? accidental dormant code
    // ?? not visable when drawn after points
    // ?? + || -
    //for (int i = 0; i < sample.bufferSize() - 1; i+=4) {
    //  point(x + rotAngle, -20  + sample.left.get(i)*sclx + rotAngle);
    //  pushMatrix();
    //  rotate(-3*rotAngle);
    //  point(-40 + sample.right.get(i)*sclx*2.5, x);
    //  popMatrix();
    //  x++;
    //}
    
    // independent circle
    // ?? accidental dormant code
    // ?? not visable when drawn after points
    // ?? + || -
    //pushMatrix();
    //rotate(rotAngle/3);
    //ellipse(-2, -40, 5, 5);
    //popMatrix();
    
    // points
    for (int i = 0; i < bands; i++) {
      // draw the bands with a scale factor
      translate(sum[i], i);
      rotate(sum[i]);
      ellipse(i, -20, sum[i]*2, sum[i]*2);
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
  // 'R' to rewind
  // ?? I think this is actually start over
  if (key == 'r') {
    sample.rewind();
  }

  // !! feature opportunity
  if (key == 'p') {
    cont = !cont;
  }
}