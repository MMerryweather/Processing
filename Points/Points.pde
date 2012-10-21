import megamu.mesh.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import controlP5.*;

int total;
int StyleNumber;
int BackGroundRadius;
public int myColor = color(0, 0, 0);
float xOffset, yOffset;
float [][] pos;
float rOffset;
float radOffset;
boolean record;

Particle [] particles;
Delaunay delaunay;
Minim minim;
AudioInput in;
FFT fft;
ControlP5 cp5;

//Begin slider values
public float circleMultiplier = 5;   //Sliderval
public int ResetDuration = 10;                 //Sliderticks2
public float rotationDegree = 0.25;  //sliderticks2
public float strokeConstant = 5;
public int NewTotal = 81;
public int NewStyleNumber = 1;
public boolean toggleValue = false;
//Begin Sliders
Textlabel textLabelCircleMultiplier;
Textlabel textLabelResetDuration;
Textlabel textLabelrotationDegree;
Textlabel textLabelstrokeConstant;
Textlabel textLabelNewTotal;
Textlabel textLabelNewStyleNumber;
Textlabel textLabeltoggleValue;


void setup() {
  size(1280, 800);
  //Set programs drawing parameter
  smooth();
  //noCursor();
  background(255);

  //Number of particles
  total = 81;
  StyleNumber =1;

  xOffset = width/2;
  yOffset = height/2;
  int q = 4;
  rOffset = 0;  

  //Set up Minim
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512);
  fft = new FFT(in.bufferSize(), in.sampleRate());
  fft.logAverages(60, q);

  int  leftOffset = 10;    //Changes whole group off the LHS
  int  topOffset = 10;    //Distance between first slider and top
  int  sliderWidth = 100;
  int  sliderHeight = 10; 
  int  textOffset = 5;    //Distance from slider to text
  int  verticalOffset = 15;  //distance between each line

  //Set up the sliders
  cp5 = new ControlP5(this);

  cp5.addSlider("circleMultiplier")
    .setRange(0, 10)
      .setValue(4)
        .setPosition(leftOffset, topOffset)
          .setSize(sliderWidth, sliderHeight)
            ;

  textLabelCircleMultiplier = cp5.addTextlabel("label")
    .setText("CIRCLE RADIUS")
      .setPosition(leftOffset+sliderWidth+textOffset, topOffset)
        .setColorValue(0x00000000)
          ;

  cp5.addSlider("ResetDuration")
    .setRange(1, 60)
      .setValue(10)
        .setPosition(leftOffset, topOffset + verticalOffset)
          .setSize(sliderWidth, sliderHeight)
            ;

  textLabelResetDuration = cp5.addTextlabel("label2")
    .setText("TIME TO RESET (S)")
      .setPosition(leftOffset+sliderWidth+textOffset, topOffset + verticalOffset)
        .setColorValue(0x00000000)
          ;

  cp5.addSlider("rotationDegree")
    .setRange(-0.5, 0.5)
      .setValue(0.25)
        .setPosition(leftOffset, topOffset+ verticalOffset*2)
          .setSize(sliderWidth, sliderHeight)
            //.setNumberOfTickMarks(9)
            ;

  textLabelrotationDegree = cp5.addTextlabel("label3")
    .setText("ROTATION SPEED (DEGREE)")
      .setPosition(leftOffset+sliderWidth+textOffset, topOffset+ verticalOffset*2)
        .setColorValue(0x00000000)
          ;

  cp5.addSlider("strokeConstant")
    .setRange(0, 4 )
      .setValue(0.25)
        .setPosition(leftOffset, topOffset+ verticalOffset*3)
          .setSize(sliderWidth, sliderHeight)
            ;

  textLabelstrokeConstant = cp5.addTextlabel("label4")
    .setText("STROKE WEIGHT")
      .setPosition(leftOffset+sliderWidth+textOffset, topOffset+ verticalOffset*3)
        .setColorValue(0x00000000)
          ;

  cp5.addSlider("NewTotal")
    .setRange(15, 200)
      .setValue(81)
        .setPosition(leftOffset, topOffset+ verticalOffset*4)
          .setSize(sliderWidth, sliderHeight)
            ;

  textLabelNewTotal = cp5.addTextlabel("label5")
    .setText("NODES")
      .setPosition(leftOffset+sliderWidth+textOffset, topOffset+ verticalOffset*4)
        .setColorValue(0x00000000)
          ;

  cp5.addSlider("NewStyleNumber")
    .setRange(1, 10)
      .setValue(1)
        .setPosition(leftOffset, topOffset+ verticalOffset*5)
          .setSize(sliderWidth, sliderHeight)
            .setNumberOfTickMarks(9)
              ;

  textLabelNewTotal = cp5.addTextlabel("textLabelNewStyleNumber")
    .setText("STYLE")
      .setPosition(leftOffset+sliderWidth+textOffset, topOffset+ verticalOffset*5)
        .setColorValue(0x00000000)
          ;

  cp5.addToggle("toggleValue")
    .setPosition(leftOffset, topOffset+ verticalOffset*6)
      .setSize(sliderWidth, sliderHeight)
        .setValue(false)
          .setMode(ControlP5.SWITCH)
            ;

  textLabelNewTotal = cp5.addTextlabel("textLabeltoggleValue")
    .setText("RECORD")
      .setPosition(leftOffset+sliderWidth+textOffset, topOffset+ verticalOffset*6)
        .setColorValue(0x00000000)
          ;
          
}
void draw() {
  pushMatrix();
  fft.forward(in.mix);
  radOffset = radians(rOffset);  //work in degrees and convert to radians
  background(255);

  translate(width/2, height/2);  //First translation to set the rotation point to the screens center
  
  pushMatrix();                  //Push to new stack
  rotate(radOffset);             //Do the rotation step
  translate(-width/2, -height/2);//Translate back to the centre
    
    //Reset on New Total
    if (total != NewTotal) {
      total = NewTotal;
      particles = new Particle[total];
      for (int i=0;i<total;i++) {
        particles[i] = new Particle(xOffset, yOffset, StyleNumber );
      }
      for (int i=0;i<total;i++) {
        particles[i].reset();
        rOffset = 0;
      }
    }
    //Add code to check if toggle is set to off.

    //Reset on New Style
    if (StyleNumber != NewStyleNumber) {
      StyleNumber = NewStyleNumber;
      particles = new Particle[total];
      for (int i=0;i<total;i++) {
        particles[i] = new Particle(xOffset, yOffset, StyleNumber );
      }
      for (int i=0;i<total;i++) {
        particles[i].reset();
        rOffset = 0;
      }
    }


    if (frameCount == 1) {
      particles = new Particle[total];
      for (int i=0;i<total;i++) {
        particles[i] = new Particle(xOffset, yOffset, StyleNumber);
      }
      for (int i=0;i<total;i++) {
        particles[i].reset();
        rOffset = 0;
      }
    }

    for (int i=0;i<total;i++) {
      particles[i].update();
      particles[i].display();
    }
    pos = new float[total][2];
    for ( int j=0; j<pos.length;j++) {
      pos[j][0] = particles[j].xCurr;
      pos[j][1] = particles[j].yCurr;
    }
    delaunay = new Delaunay(pos);
    float[][] edges = delaunay.getEdges();
    fill(0);
    ellipse(width/2,height/2,0.75*height,0.75*height);
    for (int i=0; i<edges.length; i++)
    {
      float startX = edges[i][0];
      float startY = edges[i][1];
      float endX = edges[i][2];
      float endY = edges[i][3];
      float trans = 255;
      float sw = strokeConstant;
      strokeWeight(sw);
      stroke(255, trans);
      float d = dist(startX, startY, endX, endY);
      //println(d);
      if (d<10000) {
        line(startX, startY, endX, endY);  //start messing with the structure
      }
      fill(255);
      float val = fft.getAvg(i%36)*circleMultiplier;      //change the multiplier for the max size of the circles
      ellipse(startX, startY, val, val);

      //Reset if more than x milliseconds
      int reset = 1000*ResetDuration;
      int s = millis() % reset;
      //print(s);
      if (s>=reset-1) {
        for (int m=0;m<total;m++) {
          particles[m].reset();
          rOffset = 0;
        }
      }
    }
  {
    if (toggleValue ==true) {
      // Note that #### will be replaced with the frame number. Fancy!
      saveFrame("Points-####.png");
    }
    
    rOffset = rOffset + rotationDegree ;  //Rotation speed (degrees)
    popMatrix();
    popMatrix();
  }
}

void keyPressed() {
  for (int i=0;i<total;i++) {
    particles[i].reset();
    rOffset = 0;
  }
}

void stop()
{
  // always close Minim audio classes when you finish with them
}


