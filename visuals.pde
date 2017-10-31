class Visuals{
  // this is where the sound spectrum data is stored
  float[] bands;
  // how many values are in the array
  int numBands;
  // frame counter (resets when sound restarts)
  int frame;
  
  // Define your global variables here:
  
  
  void setup(){
    
  }
  
  void draw(){
    background(0);
    
    //access 'bands' array in draw with an index between 0 to 'numBands-1'.
    float r = bands[15] * width;
    ellipse(width/2, height/2, r, r);
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  ///////////////////////////////////////////
 // NO NEED TO TOUCH THIS CODE  ////////////
///////////////////////////////////////////

  Visuals(int _numBands){
    numBands = _numBands;
    bands = new float[numBands];
  }
  
  void setBand(int i, float v){
    if(i >= 0 && i < numBands){
      bands[i] = v;  
    }else{
      println("bad reference on vis.setBand"); 
    }
  }
  
  void setFrame(int fr){
    frame = fr;
  }
  
}