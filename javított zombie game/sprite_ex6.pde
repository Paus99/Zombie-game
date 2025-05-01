import processing.sound.*;
SoundFile beep;
PFont f;
int gameState = 0; //0 startscreen, 1 gameplay, 2 beeing dead
float _speed = -8;
int _jumpCount = 0;
PImage cross;
PImage bg;  // Háttér
float bgX = 0;  // A háttér X pozíciója
float bgSpeed = 2;  // A háttér sebessége (milyen gyorsan mozogjon balra)

Zombie s;
Ground[] g;
int nGround = 0;
Boulder[] b;
int nBoulder = 8;

Landscape[] l1;
int nl1 = 0; 
Landscape[] l2;
int nl2 = 0;
Landscape[] l3;
int nl3 = 0;

void setup()
{
  size(1200,800);
  fullScreen();
  beep = new SoundFile(this,"beep.wav");
  f = createFont("Pixelmax-Regular.otf",100);
  bg = loadImage("Background1.png","Background2.png");  // A háttérkép betöltése
  reset();
}

void draw() {
  // A háttér folyamatos mozgása balra
  image(bg, bgX, 0, width, height);  // Az első háttérkép
  image(bg, bgX + width, 0, width, height);  // A második háttérkép, ami folytatja a scrollozást
  
  // Ha az első háttér elérte a képernyő bal szélét, visszaállítjuk
  bgX -= bgSpeed;
  if (bgX <= -width) {
    bgX = 0;
  }

  if (gameState == 0) startScreen();
  else if (gameState == 1) gamePlay();
  else if (gameState == 2) deadScreen();
}

void keyPressed()
{
  if(gameState == 0) 
  {
    reset();
    gameState = 1;
  }  
  if(gameState == 1) s.jump();
  if(gameState == 2) 
  {
    reset();
    gameState = 1;
  }
}

void reset()
{
  _speed = -8;
  cross = loadImage("Counter.png");
  bg = loadImage("Background1.png");  // Háttér betöltése

  s = new Zombie();
  s.location.x = (-width/2) + 100;
  s.location.y = (height/2) - 200;

  String[] files = {"Zombie.png","Zombie2.png", "Zombie3.png", "Zombie2.png"};
  s.addAnimation(files,10);
  String[] files1 = {"Zombie-backwards.png","Zombie-backwards2.png","Zombie-backwards3.png","Zombie-backwards2.png"};
  s.addAnimation(files1,10);
  String[] files2 = {"zombie-jump.png"};
  s.addAnimation(files2,10);
  String[] files3 = {"zombie-fall1.png","zombie-fall2.png"};
  s.addAnimation(files3,10);
  String[] files18 = {"Zombie-dead.png","Zombie-dead2.png"};
  s.addAnimation(files18,10); 
  s.currentAni = 0;

  nGround = ceil(width / 1000.0) + 1;
  g = new Ground[nGround];
  String[] files4 = {"Ground1.png"};  // Talajkép

  for (int i = 0; i < nGround; i++) {
    g[i] = new Ground();
    g[i].addAnimation(files4,10);  // Itt a talajkép van használva
    g[i].location.x = -(width/2.0) + (g[i].boxx * i);
  }

  String[] files10 = {"Boulder1.png"};
  String[] files11 = {"Boulder2.png"};
  String[] files12 = {"Boulder3.png"};
  String[] files13 = {"Boulder4.png"};
  String[] files14 = {"Boulder5.png"};

  b = new Boulder[nBoulder];
  for (int i = 0; i < nBoulder; i++) {
    b[i] = new Boulder();
    b[i].addAnimation(files10,10);
    b[i].addAnimation(files11,10);
    b[i].addAnimation(files12,10);
    b[i].addAnimation(files13,10);
    b[i].addAnimation(files14,10);
    b[i].location.x = (width / 2.0) + random(10, 4000);
    b[i].adjustReg();
  }

  // Csak egy tájréteg (l1)
  nl1 = ceil(width / 1000.0) + 1;
  l1 = new Landscape[nl1];
  String[] files15 = {"cloud1.png"};
  for (int i = 0; i < nl1; i++) {
    l1[i] = new Landscape();
    l1[i].location.x = (-width / 2.0) + (i * 1000.0);
    l1[i].addAnimation(files15, 10);
    l1[i].randomPlacement = true;
    l1[i].slowdown = 0.2;
  }

  // Kikapcsoljuk az l2 és l3 rétegeket
  nl2 = 0;
  l2 = new Landscape[0];
  nl3 = 0;
  l3 = new Landscape[0];
}

void startScreen()
{
  gamePlay();
  s.location.x = 10000; 
  noStroke();
  fill(255);
  textAlign(CENTER,CENTER);
  textFont(f);
  textSize(100);
  text("COLD RACE",0,-30);
  textSize(30);
  text("Press ANY key to start and jump",0,30);
}

void deadScreen()
{
  s.isDead = true;
  s.acceleration.y=-0.01;
  _speed = _speed*0.99;
  gamePlay();
  fill(255);
  textAlign(CENTER,CENTER);
  textFont(f);
  textSize(100);
  text("R.I.P.",0,0);
  textSize(30);
  text("Press ANY key to resurrection",0,60);
}

void gamePlay()
{
  // Világ középre tolása
  translate(width/2, height/2);

  // Tájréteg 1 (cloud1)
  for (int i = 0; i < nl1; i++) {
    l1[i].update();
    l1[i].check();
    l1[i].display();
  }

  // Tájrétegek 2 és 3 (ha nl2, nl3 = 0, ezek nem futnak le)
  for (int i = 0; i < nl3; i++) {
    l3[i].update();
    l3[i].check();
    l3[i].display();
  }

  // Talaj
  for (int i = 0; i < nGround; i++) {
    g[i].update();
    g[i].check();
    g[i].display();
  }

  // Gördülő sziklák
  for (int i = 0; i < nBoulder; i++) {
    b[i].update();
    b[i].check();
    b[i].display();
  }

  // Főhős
  s.update();
  s.check();
  s.display();

  // Tájréteg 2 (ha van)
  for (int i = 0; i < nl2; i++) {
    l2[i].update();
    l2[i].check();
    l2[i].display();
  }

  // HUD
  hud();
}

void hud()
{
  if(_jumpCount > 0)
  {
    image(cross,-cross.width/2,-height/2);
    textAlign(CENTER,CENTER);
    fill(255,100,100);
    textSize(30);
    pushMatrix();
    translate(0,(-height/2)+80);
    rotate(radians(-18));
    text(_jumpCount,0,0);
    popMatrix();
  }
}
