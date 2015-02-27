//Circle class is based on:
//
//P_2_2_3_01.pde
// 
// Generative Gestaltung, ISBN: 978-3-87439-759-9
// First Edition, Hermann Schmidt, Mainz, 2009
// Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
// Copyright 2009 Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
//
// http://www.generative-gestaltung.de
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

class Circle {

  float mouseXmoved, mouseYmoved;
  String name;

  int formResolution = 15;
  int stepSize = 8;
  float distortionFactor = 2;
  float initRadius = 150;
  public float centerX, centerY;
  public int strokeHue;
  float[] x = new float[formResolution];
  float[] y = new float[formResolution];

  boolean filled = false;
  boolean freeze = false;

  boolean active = false;
  
  //MOVEMENT STUFF
  PVector location;
  PVector velocity;
  PVector acceleration;
  float topspeed;
  float velScale = 0.15;

  float distanceFromCenter;
  int scaleFactor;
  
  

  PVector canvasCenter = new PVector(width/2, height/2);

  Circle(String pName, color pColor, PVector startLoc, PVector startDir) {
    name=pName;
    color strokecolor = pColor;
    
    location = startLoc;
    velocity = startDir;

    // init form
    centerX = width/2; 
    centerY = height/2;
    float angle = radians(360/float(formResolution));
    for (int i=0; i<formResolution; i++) {
      x[i] = cos(angle*i) * initRadius;
      y[i] = sin(angle*i) * initRadius;
    }
  }

  void timer() {
    // Calculate how much time has passed
    passedTime = millis() - savedTime;
    
    // Has ten seconds passed?
    if (passedTime > totalTime) {
      println( " 10 seconds have passed! " );
      this.active = false;

      savedTime = millis(); // Save the current time to restart the timer!
    }
  }

  //  void move(float towardsX, float towardsY) {
  void move() {

    //Don't think we need this
    //location.add(velocity);

    // calculate new points
    for (int i=0; i<formResolution; i++) {
      x[i] += random(-stepSize, stepSize);
      y[i] += random(-stepSize, stepSize);
      
      //Apply velocity
      centerX += (velScale * velocity.x);
      centerY += (velScale * velocity.y);
      
      // Descending movement randomizer
      centerY += i*0.01*noise(0, 0.3);
    }
  }


  
  void newStroke() {
    strokeHue = masterStroke;
    strokeHue = abs((masterStroke + int(random(-35,35)))); 
    println("Hue is now: " + strokeHue);
  }

  void display() {

    strokeWeight(0.75);
    noFill();

    //    strokeHue = int(random(125, 180));
    int strokeBrightness = int(random(175, 245));
    int strokeSaturation = int(random(35, 235));

    strokeAlpha = (map(passedTime, 0, 9900, 255, 0));

    colorMode(HSB);
    color strokecolor = color(strokeHue, strokeBrightness, strokeSaturation, strokeAlpha);
    stroke(strokecolor);

    beginShape();
    // start controlpoint
    curveVertex(x[formResolution-1]+centerX, y[formResolution-1]+centerY);

    // only these points are drawn
    for (int i=0; i<formResolution; i++) {
      curveVertex(x[i]+centerX+(5*noise(0, 0.03)), y[i]+centerY+(5*noise(0, 0.03)));
    }
    curveVertex(x[0]+centerX, y[0]+centerY);

    // end controlpoint
    curveVertex(x[1]+centerX, y[1]+centerY);
    endShape();
  }
}

