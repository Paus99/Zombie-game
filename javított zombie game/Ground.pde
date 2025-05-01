class Ground extends Sprite
{
   float slowdown = 1.0;
   Ground()
   {
     super();
     this.boxx = 1000;
     this.boxy = 600;
     this.reg.x = 0;
     this.reg.y = 0;
     this.velocity.x = _speed*this.slowdown;
     this.location.y = (height/2.0)-this.boxy;
   }
   
   void check()
   {
     this.velocity.x = _speed*this.slowdown;
     if(this.location.x <= -this.boxx-(width/2.0))
     {
       this.location.x = -(width/2.0)+(this.boxx * (nGround-1));
       this.currentAni = floor(random(0,this.nAni));
     }
   }
 
}
