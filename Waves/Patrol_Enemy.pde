/*************************************** 
/*
/*Created and developed by Raymond Clark
/*
****************************************/

class Patrol_Enemy {
  PVector myPatrolEnemy; 
  float speed;
  int size;
  int xdirection,ydirection;
  int shootSpeed;
  int lastFire;
  PImage enemyPatrol = loadImage("enemyPatrol.png");
  boolean shootCollide;
  ArrayList<Bullet> enemyBullets = new ArrayList<Bullet>();
  boolean patroling;
   
  Patrol_Enemy() {
     size = 20;
     shootSpeed = (int)random(1000,1500);
     lastFire = millis();
     myPatrolEnemy = new PVector(random(size,1280-size),random(90+size,720-size));
     speed = random(5.5,7.5);   
     xdirection = 1;
     ydirection = 1;
     shootCollide = false;  
  }
  
  void patrol() {
   myPatrolEnemy.x = myPatrolEnemy.x + (speed * xdirection);
   myPatrolEnemy.y = myPatrolEnemy.y + (speed * ydirection); 
   
   if (myPatrolEnemy.x > width-size || myPatrolEnemy.x < size) {
    xdirection *= -1;
   }
   if (myPatrolEnemy.y > height-size || myPatrolEnemy.y < 90) {
    ydirection *= -1;
   }
  }
  
  void shoot(PVector loc, float x, float y,float p,float b) {
    PVector hehe = new PVector(x,y);
    if(shootSpeed <= millis() - lastFire) {
     lastFire = millis();
     PVector direction = PVector.sub(hehe,myPatrolEnemy);
     direction.normalize();
     direction.mult(10);
     Bullet a = new Bullet(myPatrolEnemy,direction);
     enemyBullets.add(a);
  } 
   for(Bullet a: enemyBullets) {
    a.updateBullet();
    a.display(255,84,0); 
    if(a.x >= (x-30) && a.x <= (x+30) && a.y >= (y-30) && a.y <=(y+30)) {
      shootCollide = true;
    }
    
   }
   for(int i = enemyBullets.size()- 1; i>=0;i--) {
    Bullet bullet = enemyBullets.get(i); 
    if(bullet.x <= 0 || bullet.x >= 1280 || bullet.y <=90 || bullet.y >=720 || dist(bullet.x, bullet.y, p, b)<=20) {
     enemyBullets.remove(bullet); 
    }
   }
  }
  
  void display() {
   imageMode(CENTER);
   image(enemyPatrol,myPatrolEnemy.x,myPatrolEnemy.y);
   if(patroling) {
      patrol(); 
   } 
  }
}

