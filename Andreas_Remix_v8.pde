//Made by Andreas Refsgaard for Introduction to Programming @ CIID 2015.
//Beautified by Chelsey Wickmark and Michael Liston because Dennis and Jacob said so.

//Instructions: This sketch needs Andreas, Melina, Sergey and/or John to send their mouseMoved positions over the same network. 
//When a person moves his/her mouse a new cirle is added which they control. 

import ciid2015.exquisitdatacorpse.*;
import oscP5.*;
import netP5.*;

NetworkClient mClient;
float mBackgroundColor;
//Old array
//Circle[] myCircles = new Circle[4];

//Let's try an ArrayList
ArrayList myCircles;

boolean haveibeenclicked = false;

int savedTime;
int totalTime = 10000;
int passedTime;
float strokeAlpha;
int strokeHue;

void setup() {
  size(displayWidth, displayHeight);
  frameRate(25);
  smooth();

  //  myCircles[0] = new Circle("melina", color(0, 64)); 
  //  myCircles[1] = new Circle("andreas", color(0, 64)); 
  //  myCircles[2] = new Circle("sergey", color(0, 0, 255, 64)); 
  //  myCircles[3] = new Circle("john", color(255, 0, 0, 64)); 

  myCircles = new ArrayList();

  //  stroke(0, 50);
  background(255);

  mClient = new NetworkClient(this, "edc.local", "client");
}
void draw() {

  for (int i = 0; i < myCircles.size (); i++) {
    Circle c = (Circle) myCircles.get(i);
    if (c.active == true ) {

      c.timer();
      c.move();
      c.display();
    }
  }
}

void mousePressed() {


  myCircles.add(new Circle("client", color(0, 64)));
  println("alive");
  int myCirclesSize = myCircles.size();
  println("we have "+myCirclesSize);
  Circle targetC = (Circle) myCircles.get(myCirclesSize-1);

  targetC.centerX = mouseX;
  targetC.centerY = mouseY;

  targetC.newStroke();

  targetC.active = true;

  savedTime = millis();
}

void mouseMoved() {
  mClient.send("sergey", mouseX, mouseY);
}

//*** NETWORK STUFF ***
void keyPressed() {
  if (key == ',') {
    mClient.disconnect();
  }
  if (key == '.') {
    mClient.connect();
  }
}

void receive(String name, String tag, float x) {
//  println("### received: " + name + " - " + tag + " - " + x);
}

void receive(String name, String tag, float x, float y) {
//  println("### received: " + name + " - " + tag + " - " + x + ", " + y);

  for (int i = 0; i < myCircles.size (); i++) {
    Circle c = (Circle) myCircles.get(i);
    if (name.equals("client") && tag.equals(c.name)) {

      c.mouseXmoved = x;
      c.mouseYmoved = y;
    }
  }
}

void receive(String name, String tag, float x, float y, float z) {
//  println("### received: " + name + " - " + tag + " - " + x + ", " + y + ", " + z);
}

void keyReleased() {
  if (key == DELETE || key == BACKSPACE) background(255);
}

