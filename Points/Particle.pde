class Particle {
  float xCurr, yCurr;
  float xInit, yInit;
  float xo, yo;
  float val;
  float randZeroToOne;
  public int styleCounter =0;
  int thisStyle;
  Particle(float xo_, float yo_, int thisStyle_) {
    xo = xo_;
    yo = yo_;
    thisStyle = thisStyle_ -1;
    float degreeTemp = random(360);
    float rTemp = random(10, 200);
    xInit = cos(radians(degreeTemp))*rTemp+xo;
    yInit = sin(radians(degreeTemp))*rTemp+yo;
    xCurr = xInit;
    yCurr = yInit;
  }
  void update() {
    float x0 = xCurr;
    float y0 = yCurr;
    float a = 1000;
    float b = 1000;
    float r = sqrt(a*a+b*b);
    float quer_fugir_x = xCurr-(a/r)*100/r;
    float quer_fugir_y = yCurr-(b/r)*100/r;
    float quer_voltar_x = (xInit-x0)/10;
    float quer_voltar_y = (yInit-y0)/10;
    xCurr = quer_fugir_x+quer_voltar_x;
    yCurr = quer_fugir_y+quer_voltar_y;
  }
  void display() {
    strokeWeight(1);
    stroke(0);
    point(xCurr, yCurr);

  }
  void reset() {
    float degreeTemp = random(360);
    int MaxDepth = width/3;

    
    float rTemp = 0;

    //Select new style
    if (thisStyle == 0 ) {
      rTemp = random(10, random(10, MaxDepth));               // set the last number to change how far the particles spread
    }
    if (thisStyle == 1) {
      rTemp = (-(abs(log(random(0, 1))+5)/5)+1)*MaxDepth;     //Cluster towards centre, logarithmic
    }
    if (thisStyle ==2) {
      rTemp = (exp(0.693181437634459*random(0, 1))-1)*MaxDepth; //Exponential curve
    }
    if (thisStyle ==3) {
      rTemp = abs(log(random(0, 1))+0.2)*MaxDepth;            //Create Outer rim and cluster in middle
    }
    if (thisStyle ==4) {
      rTemp = abs(cos(1*PI*random(0, 1)))*MaxDepth;           //Cos with 2 troughs
    }
    if (thisStyle ==5) {
      rTemp = abs(1/(tan(PI*random(0, 1))))*MaxDepth;         //1 gulf inbetween core and rim
    }
    if (thisStyle ==6) {
      rTemp = random(0, 1)*MaxDepth;                          //Inner and outer ring
      if ((rTemp<0.7*MaxDepth) && (rTemp>0.25*MaxDepth)){
          rTemp=0.25*MaxDepth;
      }else{
        //rTemp = MaxDepth;
      }        
    }
    if (thisStyle ==7) {
      rTemp = 1/(tan(2*PI*random(0, 1)))*MaxDepth;            //notice no absolute value, causes a lot of values to go to 0
    }
    if (thisStyle ==8) {
      rTemp = atan(1.5*(random(0, 1)))*MaxDepth; 
    }

    if (thisStyle==9) {
      rTemp = (abs(log(random(0.2, 1))+5)/5)*MaxDepth;          //Cluster towards outside, logarithmic
    }



    if (rTemp > MaxDepth) {
      rTemp = MaxDepth;    //Catch Bogies
    }
    if (rTemp < 0) {
      rTemp = 0;    //Catch Bogies
    }
    //println(rTemp);
    xInit = cos(radians(degreeTemp))*rTemp+xo;
    yInit = xInit;
    yInit = sin(radians(degreeTemp))*rTemp+yo;
  }
}

