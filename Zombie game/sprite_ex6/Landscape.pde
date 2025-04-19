class Landscape extends Sprite
{
  boolean randomPlacement = false;
  float slowdown = 1.0;
  
  Landscape()
  {
    super();
    this.boxx = 1000;
    this.boxy = 500;
    this.velocity.x = _speed*this.slowdown;
    this.location.y = 0;
  }
  
  void check()
  {
    this.velocity.x = _speed*this.slowdown;
    if(this.location.x <= -boxx-(width/2.0))
    {
      this.currentAni = floor(random(0,this.nAni));
      if(randomPlacement)
      {
        this.location.x = (width/2.0)+random(3000);
      }
      else
      {
        this.location.x = (boxx*float(nGround-1))-(width/2.0);
      }
    }
  }
}
