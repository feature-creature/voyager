// AUTHOR: Luke Demarest
// DATE: 2017.11.06
// LICENSE: GPL

// OBJECTIVE: VISUALS OF EARTH
// OFFICIAL SOUND FILE: 3
// other decent sound files: 18, 14, 12, 11, 10, 09, 08, 04+, 03, 02

// CRITERIA:
//  Imagination
//  Synchresis
//  Estrangement
//  Surprise

// RULES:
//  Size = 256px by 256px.
//  No use of external files except the sound.
//  Use only greyscale color (0 -255)
//  No user interaction

// FUTURE TODO:
// Not elegant with human voice

// IMPORT LIBRARIES
import ddf.minim.*;
import ddf.minim.analysis.*;

// DECLARE GLOBAL VARIABLE 

// library instances
Minim minim;
AudioPlayer sample;
// 
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

// rotation
float rotAngle = 1;
float angleStep = 0.01;


void setup() {
  //size(256, 256);
  fullScreen();
  background(0);

  // initialize minim audio player
  // pass 'this' to indicate [sketch|data] directory for filepath.
  minim = new Minim(this);

  // initialize the audioplayer instance with audio file via minim 
  // arguments: (file name / absolute path / url, int buffersize)
  // ?? url attempts returned errors
  // ?? why default buffersize: 1024 (2^10)
  sample = minim.loadFile("six.mp3", 1024);
    //sample = minim.loadFile("SOE_03.mp3", 1024);

  // loop sample in audioplayer
  sample.loop();

  // initialize and patch the FFT analyzer
  fft = new FFT( sample.bufferSize(), sample.sampleRate() );

  // calculate the averages by grouping frequency bands linearly. use 30 averages.
  fft.linAverages( bands );

  // initialize the visuals instance
  vis = new Visuals(fft.specSize());
  vis.setup();

  sum = new float[bands];
}      

void draw() {

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



  // ?? integrate into viz class
  // ellipse points
  pushMatrix();
  translate(width/2, height/2);
  rotate(rotAngle);
  for (int i = 0; i < bands; i++) {
    // draw the bands with a scale factor
    translate(sum[i], i);
    rotate(sum[i]);
    ellipse(i, -20, sum[i]*2, sum[i]*2);
  }
  popMatrix();



  if (sample.isPlaying()) {
    vis.setFrame(frame++);
  }
  if (sample.position() < 60) {
    frame = 0;
  }

  //saveFrame("frames/"+ date() + "_" + frameCount + ".tif");
  //saveFrame("frames/####.tif");
}