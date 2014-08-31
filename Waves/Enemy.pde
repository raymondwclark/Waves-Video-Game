class Enemy {
 PVector myEnemy = new PVector(random(1280),random(90,720));
 float speed = random(4,5);
 float size; 
 PImage enemy = loadImage("enemy.png");
 PImage enemydead = loadImage("enemyDead.png");

  
  Enemy() {
   size = 20;   
  }
 
  void follow(float px,float py) {
   
    double dx = px - myEnemy.x;
    double dy = py - myEnemy.y;
    double distance = Math.sqrt(dx*dx + dy*dy);
    double multiplier = speed / distance;
    double velocityX = dx * multiplier;
    double velocityY = dy * multiplier;
    myEnemy.x+=velocityX;
    myEnemy.y+=velocityY;  
  } 
  
  void drawEnemy() {
   imageMode(CENTER);
   image(enemy,myEnemy.x,myEnemy.y);    
  }
  
  void drawDeadEnemy() {
    imageMode(CENTER);
    image(enemydead,myEnemy.x,myEnemy.y);
  }
}
