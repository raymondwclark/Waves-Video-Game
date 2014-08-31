class Bullet extends PVector {
  PVector velocity;
  
  Bullet(PVector location, PVector velocity) {
    super(location.x,location.y);
    this.velocity = velocity.get();
  }
  
  void updateBullet() {
   add(velocity); 
  }
  
  void display(float a,float b, float c) {
   ellipseMode(CENTER);
   noStroke();
   fill(a,b,c);
   ellipse(x,y,4,4);   
  } 
}
