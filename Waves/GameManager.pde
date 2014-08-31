class GameManager {

  Player mainPlayer;
  Instructions instruction = new Instructions();

  float buttonColor;
  Table table;
  boolean paused = false;


  PImage bgImage;
  PImage mainMenu;

  ArrayList<Enemy> enemies = new ArrayList<Enemy>();
  ArrayList<Patrol_Enemy> patrolEnemies = new ArrayList<Patrol_Enemy>();
  ArrayList<HealthPack> healthPack = new ArrayList<HealthPack>();

  int count = 0;
  int level = 0;
  int waveNumber = 1;
  int numOfEnemies = 1;
  int score;
  int num;
  float theta  = 0;
  float theta1 = 10;

  boolean powerUp = false;
  boolean shoot = false;
  boolean listEmpty = false;
  boolean collision = false;
  boolean hasBeenShot = false;
  boolean following = true;
  boolean waiting = false;

  float h = 100;
  float health = constrain(h, 0, 100);
  float MAX_HEALTH = 100;
  float rectWidth = 200;
  float bgColor = 70;

  GameManager() {
  }
  void setupGame(int x, int y) {
    mainPlayer = new Player("character_",3);
    table = loadTable("Kills.csv");
    
    size(x, y);
    noStroke();
    frameRate(60);
    cursor(CROSS);
    smooth(); 

    for (int i = 0; i < 1; i++) {
      enemies.add(new Enemy());
    }
    for (int i = 0; i < 1; i++) {
      patrolEnemies.add(new Patrol_Enemy());
    }

    for (int i = 0; i < 1; i++) {
      healthPack.add(new HealthPack());
    }
  }

  void shooting() {
    strokeWeight(2);
    fill(255);
    stroke(255);
  } 

  void drawEnemies() {
    for (int i = enemies.size()-1; i >=0; i--) {
      Enemy enemy = enemies.get(i);
      enemy.drawEnemy();
      enemy.follow(mainPlayer.player.x, mainPlayer.player.y);
    } 

    for (int i = patrolEnemies.size()-1; i >= 0; i--) {
      Patrol_Enemy patrolEnemy = patrolEnemies.get(i);
      patrolEnemy.patroling = true;
      patrolEnemy.shoot(mainPlayer.player, mainPlayer.player.x, mainPlayer.player.y,mainPlayer.player.x,mainPlayer.player.y);
      patrolEnemy.display();
    }
  }



  void playGame() {
    if (level == 0) {
      background(26, 74, 156);
      menu();
      instruction.display();
    }

    if (level == 1) {
      background(bgColor); 
      blackbar();
      println(frameRate);
      textAlign(CENTER);
      textSize(20);
      fill(255);
      text("wave: " + waveNumber, width/27, height/11);
      text("highscore: " + score, width/5,height/20);
      
      mousePress();
      mainPlayer.drawPlayer();
      mainPlayer.moveDirections(10);
      collision();      
      loadHealthPack();
      listIsEmpty();
      drawEnemies();
      addMoreEnemies();
      gameOver();
      setHighScore();
      
      fill(255);
      textSize(20);
      textAlign(CENTER);
      if (count == 1) {
        text(count + " kill", width/27, height/20);
      }
      else {
        text(count + " kills", width/27, height/20);
      }
      if (shoot) {
        mainPlayer.shoot();
        beenShot();
      }
    }

    if (level == 3) {
      background(26, 74, 156);
      restartMenu();
    }

    if (level == 4) {
      background(26, 74, 156);
      highscoresMenu();
      num = table.getInt(0, 0);
      String kill;
      if (num == 1) {
        kill = "kill";
      }
      else {
        kill = "kills";
      }
      textAlign(CENTER);
      textSize(60);
      fill(0);
      text(num,width/2,height/2);
    }
  }
   

  void loadHealthPack() {
    if (health<50) {
      for (int i = 0; i < healthPack.size(); i++) {
        HealthPack healthP = healthPack.get(i);
        healthP.display();
        if (dist(mainPlayer.player.x, mainPlayer.player.y, healthP.healthPosX, healthP.healthPosY) <= 30) {
          health = 100; 
          healthPack.remove(healthP);
        }
      }
    }
  }

  void levelCleared() {
    if (enemies.size() == 0 && patrolEnemies.size() == 0) {
      background(0);
      textAlign(CENTER);
      textSize(35);
      fill(255, 234, 10);
      text("Level Cleared", width/2, height/2);
      noLoop();
    }
  }

  void collision() {
    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy enemy = enemies.get(i);
      if (dist(enemy.myEnemy.x, enemy.myEnemy.y, mainPlayer.player.x, mainPlayer.player.y)<=40) {
        collision = true; 
        health-=1;
      }
    }  
    for (int j = patrolEnemies.size()-1; j >= 0; j--) {
      Patrol_Enemy penemy = patrolEnemies.get(j);
      if (penemy.shootCollide) {
        health--;
        penemy.shootCollide = false;
      }

      if (dist(penemy.myPatrolEnemy.x, penemy.myPatrolEnemy.y, mainPlayer.player.x, mainPlayer.player.y)<=40) {
        collision = true;
        health-=1;
      }
    }
      if (health<25) {
        fill(255, 0, 0);
      }
      else if (health<50) {
        fill(255, 200, 0);
      }
      else {
        fill(0, 255, 0);
    }
    stroke(255);
    strokeWeight(2);
    float drawWidth = (health/MAX_HEALTH) * rectWidth;
    rect(1050, 10, drawWidth, 50);
    text("health ", 1000, 40);
    strokeWeight(2);
    noFill();
    rect(1050, 10, rectWidth, 50);
    if(health < 0) {
     health = 0; 
    }
    
  }
  
  void gameOver() {
    if (health == 0) {
      level = 3;
    }
  }

  void reset() {
    hasBeenShot = false;
    following = true;
    count = 0;
    shoot = false;
    collision = false;
    h = 100;
    health = constrain(h, 0, 100);
    MAX_HEALTH = 100;
    rectWidth = 200; 
    mainPlayer.player.x = width/2;
    mainPlayer.player.y = height/2;
    numOfEnemies = 1;
    waveNumber = 1;

    for (int i = enemies.size()-1;i>=0;i--) {
      Enemy enemy = enemies.get(i);
      enemy.myEnemy.x = random(600);
      enemy.myEnemy.y = random(600);
      enemy.speed = 1;
      enemies.remove(enemy);
    }
    for (int j = patrolEnemies.size()-1;j>=0;j--) {
      Patrol_Enemy patrolEnemy = patrolEnemies.get(j);
      patrolEnemy.myPatrolEnemy.x = random(2, 600);
      patrolEnemy.myPatrolEnemy.y = random(2, 600); 
      patrolEnemy.speed = random(2.5, 3);
      patrolEnemy.speed = random(2.5, 3);
      patrolEnemies.remove(patrolEnemy);
    }
    for (int i = 0; i < numOfEnemies; i++) {
      enemies.add(new Enemy());
    }
    for (int j = 0; j < numOfEnemies; j++) {
      patrolEnemies.add(new Patrol_Enemy());
    }
  }

  void beenShot() {
    
    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy enemy = enemies.get(i);
      for (Bullet b : mainPlayer.bullets) {
        if (b.x>=(enemy.myEnemy.x-20)&&b.x<=(enemy.myEnemy.x+20)&&b.y>=(enemy.myEnemy.y-20)&&b.y<=(enemy.myEnemy.y+20)) {
          hasBeenShot = true;   
          if (hasBeenShot) {
            following = false;
            fill(255, 0, 0);
            ellipseMode(CENTER);
            ellipse(enemy.myEnemy.x, enemy.myEnemy.y, 60, 60);
            enemies.remove(enemy);
            count+=1;
          }
        }
      }
    }

    for (int j = patrolEnemies.size() - 1; j >= 0; j--) {
      Patrol_Enemy penemy = patrolEnemies.get(j);
      for (Bullet b : mainPlayer.bullets) {
        if (b.x>=(penemy.myPatrolEnemy.x-20)&&b.x<=(penemy.myPatrolEnemy.x+20)&&b.y>=(penemy.myPatrolEnemy.y-20)&&b.y<=(penemy.myPatrolEnemy.y+20)) {
          hasBeenShot = true; 
          if (hasBeenShot) {
            ellipseMode(CENTER);
            fill(13, 255, 125);
            ellipse(penemy.myPatrolEnemy.x, penemy.myPatrolEnemy.y, 60, 60);
            patrolEnemies.remove(penemy);
            count+=1;
          }
        }
      }
    }
  }

  void addMoreEnemies() {
    if (enemies.size() == 0 && patrolEnemies.size() == 0) {
      numOfEnemies+=2;
      waveNumber++;

      for (int i = 0; i < numOfEnemies; i++) {
        enemies.add(new Enemy());
        patrolEnemies.add(new Patrol_Enemy());
      }
    }
  }


  void listIsEmpty() {
    if (enemies.size() == 0 && patrolEnemies.size() == 0) {
      listEmpty = true;
    }
  }

  void mousePress() {
    if (mousePressed) {
      shoot = true;
    }
  }



  void menu() {
    float buttonColor2 = 0;
    float exitColor = 0;

    if (mouseX > (width/2)-35 && mouseX < (width/2)+35 && mouseY < (height/3) + 10 && mouseY > (height/3) - 30) {
      buttonColor = 255;
      cursor(HAND);
    }
    else {
      buttonColor = 0;
      cursor(CROSS);
    }
    if (mouseX > (width/2)-35 && mouseX < (width/2)+35 && mouseY < (height/3) + 10 && mouseY > (height/3) - 30 && mousePressed) {
      buttonColor = 255;
      level = 1;
      cursor(CROSS);
    }

    if (mouseX > (width/2)-90 && mouseX < (width/2)+90 && mouseY < (height/2) + 10 && mouseY > (height/2) - 30) {
      buttonColor2 = 255;
      cursor(HAND);
    }

    if (mouseX > (width/2)-90 && mouseX < (width/2)+90 && mouseY < (height/2) + 10 && mouseY > (height/2) - 30 && mousePressed) {
      buttonColor2 = 255;
      level = 4;
      cursor(CROSS);
    }
    
    if(mouseX > (width/1.03)-35 && mouseX < (width/1.03)+35 && mouseY < (height/1.01) + 10 && mouseY > (height/1.01) - 30) {
     cursor(HAND);
     exitColor = 255; 
    }
    
    if(mouseX > (width/1.03)-35 && mouseX < (width/1.03)+35 && mouseY < (height/1.01) + 10 && mouseY > (height/1.01) - 30 && mousePressed) {
      exit();
    }
    
    float x = (sin(theta) + 1) * 150;
    theta+= .08;
    theta1 += .2;
    float s = (cos(theta1)+1) * 15;
     if(score > num) {
       textAlign(CENTER);
       textSize(s);
       fill(0);
       text("new ",width/2.5,(height/2)-5);
     }
    
    stroke(0);
    strokeWeight(3);
    fill(buttonColor);
    textAlign(CENTER);
    textSize(30);
    text("PLAY", width/2, height/3);
    fill(buttonColor2);
    text("HIGHSCORE", width/2, height/2);
    fill(exitColor);
    text("EXIT",width/1.03,height/1.01);
    textSize(100);
    fill(x);
    text("WAVES",width/7.8,height);
    
  } 

  void highscoresMenu() {
    float buttonColor3 = 0;
    if (mouseX > (width/2)-30 && mouseX < (width/2)+30 && mouseY < (height/4) + 10 && mouseY > (height/4) - 30) {
      buttonColor3 = 255;
      cursor(HAND);
    }

    else {  
      buttonColor3 = 0;
      cursor(CROSS);
    }

    if (mouseX > (width/2)-30 && mouseX < (width/2)+30 && mouseY < (height/4) + 10 && mouseY > (height/4) - 30 && mousePressed) {
      buttonColor3 = 255;
      level = 0;
      cursor(HAND);
    }

    fill(buttonColor3);
    stroke(0);
    strokeWeight(3);
    textAlign(CENTER);
    textSize(20);
    text("BACK", width/2, height/4);
  }

  void restartMenu() {
    float buttonColor5 = 0;
    float buttonColor6 = 0;
    if (mouseX > (width/2)-50 && mouseX < (width/2)+50 && mouseY < (height/2) + 10 && mouseY > (height/2) - 30) {
      buttonColor5 = 255;
      cursor(HAND);
    }
    else {
      buttonColor5 = 0;
      cursor(CROSS);
    }
    if (mouseX > (width/2)-50 && mouseX < (width/2)+50 && mouseY < (height/2) + 10 && mouseY > (height/2) - 30 && mousePressed) {
      buttonColor5 = 255;
      reset();
      level = 1;
      cursor(CROSS);
    }
    
    if(mouseX > (width/2)-20 && mouseX < (width/2)+20 && mouseY < (height/1.58) + 10 && mouseY > (height/1.58) - 30) {
      buttonColor6 = 255;
      cursor(HAND);
    }
    

    if (mouseX > (width/2)-20 && mouseX < (width/2)+20 && mouseY < (height/1.58) + 10 && mouseY > (height/1.58) - 30 && mousePressed) {
      level = 0;
      reset();
    }

    fill(buttonColor);
    stroke(0);
    textSize(20);
    strokeWeight(3);
    fill(buttonColor5);
    textAlign(CENTER);
    
    text("RESTART", width/2, height/2);  
    fill(buttonColor5);
    fill(buttonColor6);
    textAlign(CENTER);
    text("QUIT", width/2, height/1.58);
    fill(0);
    textSize(30);
    text("GAME OVER", width/2, height/5);
  }

  void blackbar() {
    fill(0);
    noStroke();
    rectMode(CORNER);
    rect(0, 0, width, 75);
  }

  void setHighScore() {
    score = table.getInt(0, 0);
    if (count > score) {
      score = count;
      table.setInt(0, 0, score);
      saveTable(table, "Kills.csv");
    } 
  }
}

