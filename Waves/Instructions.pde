/*************************************** 
/*
/*Created and developed by Raymond Clark
/*
****************************************/

class Instructions{
 
  
  Instructions() {
  }
  
  void display() {
   textSize(20);
   textAlign(LEFT);
   fill(255);
   noStroke();
   text("1. Use WASD to move.",10,height/20);
   text("2. Hold down the mouse button to shoot.",10,height/10);
   text("3. Survive.",10, height/6.8);     
  }
  
}
