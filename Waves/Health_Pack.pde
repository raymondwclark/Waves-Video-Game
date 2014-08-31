/*************************************** 
/*
/*Created and developed by Raymond Clark
/*
****************************************/

class HealthPack {
 PImage health = loadImage("healthpack.png");
 float healthPosX;
 float healthPosY;
 
 HealthPack() {
  healthPosX = random(100,1100);
  healthPosY = random(100,700);
 } 
 
 void display() {
   fill(0);
   noStroke();
   rect(healthPosX-20,healthPosY-25,40,10);
   fill(255);
   textMode(CENTER);
   textSize(12);
   noStroke();
   text("health", healthPosX,healthPosY-15.5);   
   imageMode(CENTER);
   image(health,healthPosX,healthPosY);   
 }
 
}
