public class Player {

  int step = 1;
  int size = 30;
  int mode = 0;
  
  int xSpeed = 0;
  int ySpeed = 0;
  
  Index pos;
  Index realPos;
  
  public Player(Index pos) {
    this.pos = pos;
    this.realPos = pos.getPos();
  }
  
  boolean hit(Player target) {
    return (dist(target.realPos.x, target.realPos.y, this.realPos.x, this.realPos.x) < target.size);
  }
  
  void move(Step s, LevelGrid level) {
    switch(s) {
      case UP: {
        if (player.pos.x == 0
                    || level.Level[player.pos.x - player.step][player.pos.y] == 0) { break; }
        this.pos.x -= this.step;
        break;
      } 
      case DOWN: {
        if (player.pos.x == 14
                    || level.Level[player.pos.x + player.step][player.pos.y] == 0) { break; }
        this.pos.x += this.step;
        break;
      } 
      case LEFT: {
        if (player.pos.y == 0
                    || level.Level[player.pos.x][player.pos.y - player.step] == 0) { break; }
        this.pos.y -= this.step; 
        break;
      } 
      case RIGHT: {
        if (player.pos.y == 14
                    || level.Level[player.pos.x][player.pos.y + player.step] == 0) { break; }
        this.pos.y += this.step;
        break;
      }
      default: {
        break;
      }
    }
    this.realPos = this.pos.getPos();
  }
  
  void display(Play p, double mod) {
    noStroke();
    if (p == Play.NPC) {
      fill(150,150,150);
      arc(this.realPos.x, this.realPos.y, size, size, (float) -(PI - (0.3 * Math.cos(mod) + 0.3)), (float) (PI - (0.3 * Math.cos(mod) + 0.3)));
    } else {
      if (this.mode != 0) {
        float r = (float) +(127 * Math.cos(radians(frameCount)) + 127);
        float g = (float) +(127 * Math.cos(radians(frameCount) + HALF_PI) + 127);
        float b = (float) +(127 * Math.cos(radians(frameCount) + PI) + 127);
        fill(r,g,b);
      } else {
        fill(255,255,0);
      }
      arc(this.realPos.x, this.realPos.y, size, size, (float) -(PI - (0.3 * Math.cos(mod) + 0.3)), (float) (PI - (0.3 * Math.cos(mod) + 0.3)));
      //the first one -(PI - (0.3cos(x) + 0.3))
      //the second one (PI - (0.3cos(x) + 0.3))
    }
  }
}

enum Play {
  NPC,PC
}
