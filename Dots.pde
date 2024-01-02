public class Dots {
  Index pos;
  Index realPos;
  int type;
  int size;
  
  public Dots(Index pos, int type) {
    this.pos = pos;
    this.realPos = pos.getPos();
    this.type = type;
  }
  
  public Dots(Index pos, int type, int size) {
    this.pos = pos;
    this.realPos = pos.getPos();
    this.type = type;
    this.size = size;
  }
  
  void display() {
    switch(this.type) {
      case 1: {
        fill(200);
        ellipse(this.realPos.x, this.realPos.y, 10, 10);
        break;
      }
      case 2: {
        fill(200);
        ellipse(this.realPos.x, this.realPos.y, 20, 20);
        break;
      }
      default: {
        fill(200,100,100);
        ellipse(this.realPos.x, this.realPos.y, size, size);
        break;
      }
    }
  }
  
  boolean hit(Player p) {
    return (dist(p.realPos.x, p.realPos.y, this.realPos.x, this.realPos.y) < p.size/2);
  }
}
