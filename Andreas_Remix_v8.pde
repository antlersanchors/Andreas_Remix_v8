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

int masterStroke;

//MOVEMENT STUFF
PVector mouse;
PVector dir;
PVector center;


void setup() {
  
  size(displayWidth, displayHeight);
  frameRate(25);
  smooth();

  myCircles = new ArrayList();

  background(255);
  masterStroke = int(random(0, 255));

  mClient = new NetworkClient(this, "edc.local", "client");
}

void draw() {
  //  fill(250,1);
  //  rect(0,0,width,height);

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

  PVector center = new PVector(width/2, height/2);
  println("The Center of Everything is: " + center);
  PVector mouse = new PVector(mouseX, mouseY);
  PVector dir = PVector.sub(mouse, center);
  println("Before normalize: dir = " + dir);
  dir.normalize();
  println("After normalize: dir = " + dir);

  myCircles.add(new Circle("client", color(random(255)), mouse, dir));
  int myCirclesSize = myCircles.size();
  Circle targetC = (Circle) myCircles.get(myCirclesSize-1);

  targetC.centerX = mouseX;
  targetC.centerY = mouseY;

  targetC.newStroke();

  targetC.active = true;
}

void mouseMoved() {
  mClient.send("chelichael", mouseX, mouseY);
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

  PVector center = new PVector(width/2, height/2);
  println("The Center of Everything is: " + center);

  float randomY = random(width);
  PVector mouse = new PVector(x, randomY);
  PVector dir = PVector.sub(mouse, center);
  println("Before normalize: dir = " + dir);
  dir.normalize();
  println("After normalize: dir = " + dir);

  myCircles.add(new Circle("client", color(random(255)), mouse, dir));
  int myCirclesSize = myCircles.size();
  Circle targetC = (Circle) myCircles.get(myCirclesSize-1);

  targetC.centerX = x;
  targetC.centerY = randomY;

  targetC.newStroke();

  targetC.active = true;

  println("### received: " + name + " - " + tag + " - " + x);
}

void receive(String name, String tag, float x, float y) {
  println("### received: " + name + " - " + tag + " - " + x + ", " + y);

  float totalX =+ x;
  float totalY =+ y;
  int counter = 0;

  float avgX = totalX/10;
  float  avgY = totalY/10;

  if (counter == 9) {

    counter = 0;
    totalX = 0;
    totalY = 0;


    counter++;

    PVector center = new PVector(width/2, height/2);
    println("The Center of Everything is: " + center);
    PVector mouse = new PVector(avgX, avgY);
    PVector dir = PVector.sub(mouse, center);
    println("Before normalize: dir = " + dir);
    dir.normalize();
    println("After normalize: dir = " + dir);

    myCircles.add(new Circle("client", color(random(255)), mouse, dir));
    int myCirclesSize = myCircles.size();
    Circle targetC = (Circle) myCircles.get(myCirclesSize-1);

    targetC.centerX = width/2;
    targetC.centerY = height/2;

    targetC.newStroke();

    targetC.active = true;
}
    //  for (int i = 0; i < myCircles.size (); i++) {
    //    Circle c = (Circle) myCircles.get(i);
    //    if (name.equals("client") && tag.equals(c.name)) {
    //
    //      c.mouseXmoved = x;
    //      c.mouseYmoved = y;
    //    }
    //  }
  
}
void receive(String name, String tag, float x, float y, float z) {
  println("### received: " + name + " - " + tag + " - " + x + ", " + y + ", " + z);

  float totalX =+ x;
  float totalY =+ y;
  int counter = 0;

  float avgX = totalX/10;
  float  avgY = totalY/10;

  if (counter == 9) {

    counter = 0;
    totalX = 0;
    totalY = 0;

    counter++;

    PVector center = new PVector(width/2, height/2);
    println("The Center of Everything is: " + center);
    PVector mouse = new PVector(avgX, avgY);
    PVector dir = PVector.sub(mouse, center);
    println("Before normalize: dir = " + dir);
    dir.normalize();
    println("After normalize: dir = " + dir);

    myCircles.add(new Circle("cleaner", color(255), mouse, dir));
    int myCirclesSize = myCircles.size();
    Circle targetC = (Circle) myCircles.get(myCirclesSize-1);

    targetC.centerX = x;
    targetC.centerY = y;

    targetC.newStroke();

    targetC.active = true;
  }
}

void keyReleased() {
  if (key == DELETE || key == BACKSPACE) background(255);
}

