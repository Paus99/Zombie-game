import processing.sound.*;
SoundFile beep;
PFont f;
int gameState = 0; //0 startscreen, 1 gameplay, 2 beeing dead
float _speed = -8;
int _jumpCount = 0;
PShape cross;


Zombie s;
Ground[] g;
int nGround = 0;
PImage bg;
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
  f = createFont("hvd.ttf",100);
  reset();
}

void draw()
{
  if(gameState == 0) startScreen();
  if(gameState == 1) gamePlay();
  if(gameState == 2) deadScreen(); 
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
  cross = loadShape("cross.svg");
  s = new Zombie();
  s.location.x=(-width/2)+100;
  s.location.y=(height/2)-200;
  String[] files = {"Zombie.png","Zombie2.png", "Zombie3.png", "Zombie2.png"}; //running
  s.addAnimation(files,10);
  String[] files1 = {"zombie1a.svg","zombie2a.svg"}; //running backwards
  s.addAnimation(files1,10);
  String[] files2 = {"zombieup.svg"};  //jump up
  s.addAnimation(files2,10);
  String[] files3 = {"zombiefall1.svg","zombiefall2.svg"}; //fallimg down
  s.addAnimation(files3,10);
  String[] files18 = {"zombiedead.svg"}; //beeing dead`
  s.addAnimation(files18,10); 
  s.currentAni=0;
  
  nGround = ceil(width/1000.0)+1; //number of ground element is acconted form screen size and ground element width
  g = new Ground[nGround];

  String[] files4 = {"Background1.png"};
  String[] files5 = {"Background2.png"};
  String[] files6 = {"Background3.png"};
  String[] files7 = {"Background4.png"};
  String[] files8 = {"Background5.png"};
  String[] files9 = {"Background6.png"};
  for(int i = 0; i < nGround; i = i + 1)
  {
    g[i] = new Ground();
    g[i].addAnimation(files4,10);
    g[i].addAnimation(files5,10);
    g[i].addAnimation(files6,10);
    g[i].addAnimation(files7,10);
    g[i].addAnimation(files8,10);
    g[i].addAnimation(files9,10);
    g[i].location.x = -(width/2.0)+(g[i].boxx * i);
  }
  
  String[] files10 = {"Boulder1.png"};
  String[] files11 = {"Boulder2.png"};
  String[] files12 = {"Boulder3.png"};
  String[] files13 = {"Boulder4.png"};
  String[] files14 = {"Boulder5.png"};

  b = new Boulder[nBoulder];
  for(int i = 0; i < nBoulder; i = i + 1)
  {
    b[i] = new Boulder();
    b[i].addAnimation(files10,10);
    b[i].addAnimation(files11,10);
    b[i].addAnimation(files12,10);
    b[i].addAnimation(files13,10);
    b[i].addAnimation(files14,10);
    b[i].location.x = (width/2.0)+random(10,4000);
    b[i].adjustReg();
  }
  
  nl1 = ceil(width/1000.0)+1;
  l1 = new Landscape[nl1];
  String[] files15 = {"cloud1.svg"};
  for(int i = 0; i < nl1; i = i + 1)
  {
    l1[i] = new Landscape();
    l1[i].location.x = (-width/2.0)+(i*1000.0);
    l1[i].addAnimation(files15,10);
    l1[i].randomPlacement=true;
    l1[i].slowdown = 0.2;
  
  }
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
  /*noStroke();
  fill(0);
  rect(0,0,width,height);
  fill(255);
  textAlign(CENTER,CENTER);
  text("RIP. Press ANY key to resurrection",width/2,height/2);*/
}

void gamePlay()
{
  noStroke();
  fill(color(247,179,178));
  rect(0,0,width,height);
  image(bg,0,0);
  translate(width/2,height/2);
  for(int i = 0; i < nl1; i = i + 1)
  {
    l1[i].update();
    l1[i].check();
    l1[i].display();
  }
  
  
  
  for(int i = 0; i < nl3; i = i + 1)
  {
    l3[i].update();
    l3[i].check();
    l3[i].display();
  }
  
  for(int i = 0; i < nGround; i = i + 1)
  {
    g[i].update();
    g[i].check();
    g[i].display();
  }
  
  for(int i = 0; i < nBoulder; i = i + 1)
  {
    b[i].update();
    b[i].check();
    b[i].display();
  }
  
  s.update();
  s.check();
  s.display();
  for(int i = 0; i < nl2; i = i + 1)
  {
    l2[i].update();
    l2[i].check();
    l2[i].display();
  }
  hud();
}

void hud()
{
  if(_jumpCount > 0)
  {
    shape(cross,-cross.width/2,-height/2);
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
