/*************************************** 
/*
/*Created and developed by Raymond Clark
/*
****************************************/

GameManager gameManager = new GameManager();

void setup() {
  gameManager.setupGame(1280,720);
}

void draw() {
  gameManager.playGame();
}
