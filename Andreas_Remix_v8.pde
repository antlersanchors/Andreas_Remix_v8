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

  for (int i = 0; i < myCircles.length; i++) {
    if (myCircles[i].mouseXmoved != 0 && myCircles[i].active == true ) {

      // Calculate how much time has passed
      passedTime = millis() - savedTime;
      // Has ten seconds passed?
      if (passedTime > totalTime) {
        println( " 10 seconds have passed! " );
        myCircles[i].active = false;
        savedTime = millis(); // Save the current time to restart the timer!
      }

      myCircles[i].move();
      myCircles[i].display();
    }
  }
}


void mousePressed() {
//  Circle myNewCircle = new Circle("melina", color(0, 64));
//  myCircles = append(myCircles, myNewCircle);
  
  myCircles[2].centerX = mouseX;
  myCircles[2].centerY = mouseY;

  myCircles[2].newStroke();

  myCircles[2].active = true;
//  haveibeenclicked = true;
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
  println("### received: " + name + " - " + tag + " - " + x);
}

void receive(String name, String tag, float x, float y) {
  println("### received: " + name + " - " + tag + " - " + x + ", " + y);
  for (int i = 0; i < myCircles.length; i++) {
    if (name.equals("client") && tag.equals(myCircles[i].name)) {
      myCircles[i].mouseXmoved = x;
      myCircles[i].mouseYmoved = y;
    }
  }
}


void receive(String name, String tag, float x, float y, float z) {
  println("### received: " + name + " - " + tag + " - " + x + ", " + y + ", " + z);
}

void keyReleased() {
  if (key == DELETE || key == BACKSPACE) background(255);
}

