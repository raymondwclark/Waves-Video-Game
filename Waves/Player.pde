class Player {
 PVector player = new PVector(300,300);
 PImage[] images;
 int frame;
 int imageCount;
 float positionX;
 float positionY;
 float theta;
 float a;
 float b;
 int size;
 int fireSpeed;
 int lastFired;
 boolean show;
 
 ArrayList<Bullet> bullets = new ArrayList<Bullet>();
 
  Player(String imagePrefix, int count) {
   size = 60;
   fireSpeed = 100;
   lastFired = millis();
   imageCount = count;
   images = new PImage[imageCount];
   
   for(int i = 0; i < imageCount; i++) {
    String filename = imagePrefix + nf(i,2) + ".png";
    images[i] = loadImage(filename); 
   }
   
  }
  
 
 void drawPlayer() { 
   show = !show;
   //println(show);
   float u = (mouseX-player.x);
   float b = (mouseY-player.y);
   float theta = atan2(u,b);
   if(frameCount%4 == 0) {
    frame = (frame+1) % imageCount;
   }
//rotates the player in congruence with the mouse position

  pushMatrix();
  translate(player.x, player.y);
  rotate((-theta+PI));
  translate(-player.x, -player.y);
  imageMode(CENTER);
  image(images[0], player.x-8, player.y,80,80);
  if(keyPressed) {
    image(images[frame],player.x-8,player.y,80,80);
  }
  ellipseMode(CENTER);
  if(mousePressed && show && frameCount%4 ==0) {
    strokeWeight(2);
    stroke(255,255,0);
    fill(255,255,0);
    ellipse(player.x,player.y-38,10,15);
    fill(255,255,0,100);
   noStroke();
   ellipse(player.x,player.y-45,25,30);    
  }
  popMatrix();
   
  if(player.y >= 720-size/2) {
    player.y = 720 - size/2;
  }
  if(player.y <= 75+size/2) {
   player.y = 75 + size/2; 
  }
  if(player.x <= 0+size/2) {
   player.x = 0+size/2; 
  }
  if(player.x >= 1280-size/2) {
   player.x = 1280 - size/2; 
  }  
 }

void shoot() {
  PVector mouse = new PVector(mouseX,mouseY);
    if(fireSpeed <= millis() - lastFired && mousePressed) {
     lastFired = millis();
     PVector direction = PVector.sub(mouse,player);
     direction.normalize();
     direction.mult(50);
     Bullet b = new Bullet(player,direction);
     bullets.add(b);
  } 
   for(Bullet b: bullets) {
    b.updateBullet();
    b.display(255,239,0); 
   }
    for(int i = bullets.size()- 1; i>=0;i--) {
    Bullet bullet = bullets.get(i); 
    if(bullet.x <= 0 || bullet.x >= 1280 || bullet.y <=90 || bullet.y >=720) {
     bullets.remove(bullet); 
    }
   }
 } 
 
 void moveDirections(float s) {
  if(keyPressed == true) {
   if(key == 'w' || key == 'W') {
     player.y-=s;
    }
    else if(key == 's' || key == 'S') {
      player.y+=s;
    }
    else if(key == 'a' || key == 'A') {
      player.x-=s;
    }
    else if(key == 'd' || key == 'D') {
      player.x+=s;
    }
    else if(key == 'a' && key == 'w') {//attempt at diagonal movement(not complete)
     player.y-=s;
     player.x-=s; 
    }
   }
  }
}
