import java.util.Random;

public class Ghost {
  Ghost_Type type;
  Player target;
  boolean fear = false;

  //int step = 40;
  int step = 1;
  int size = 30;
  
  Index pos;
  Index realPos;
  
  Random rand = new Random();
  
  public Ghost(Ghost_Type gt, Player p, Index pos) {
    this.type = gt;
    this.target = p;
    this.pos = pos; // index based position
    this.realPos = pos.getPos(); // actual grid location
  }
  
  boolean hit(Player target) {
    return (dist(target.realPos.x, target.realPos.y, this.realPos.x, this.realPos.y) < target.size);
  }
  
  void move(LevelGrid level) {
    Step[] steps = level.getStepBFS(this.pos, this.target.pos);
    Index dest = level.getRandomLocation(millis() % frameCount);
    Step step = level.getNextStep(this.pos, dest);
    switch(this.type) {
       case FICKLE: {
         
         if (this.fear) {
           step = level.getNextStep(this.pos, new Index(0,0));
           takeStep(step);
           break;
         }
         
         if (steps.length >= 5) {
           takeStep(steps[0]);
         } else {
           takeStep(step);
         }
         break;
       }
       case CHASER: {
         //use bfs to determine the next best step to use to get to target
         
         if (this.fear) {
           step = level.getNextStep(this.pos, new Index(0,14));
           takeStep(step);
           break;
         }
         
         takeStep(steps[0]);
         break;
       }
       case AMBUSH: {
         if (this.fear) {
           step = level.getNextStep(this.pos, new Index(14,0));
           takeStep(step);
           break;
         }
         
         takeStep(steps[0]);
         break;
       }
       case STUPID: {
         if (this.fear) {
           step = level.getNextStep(this.pos, new Index(14,14));
           takeStep(step);
           break;
         }
         
         takeStep(step);
         break;
       }
       default: {
         break;
       }
     }
     this.realPos = this.pos.getPos();
  }
  
  void inFear() {
    this.fear = true;
  }
  
  void noFear() {
    this.fear = false;
  }
  
  void takeStep(Step step) {
    switch (step) {
      case UP:
          this.pos.x -= this.step;
          break;
      case DOWN:
          this.pos.x += this.step;
          break;
      case LEFT:
          this.pos.y -= this.step;
          break;
      case RIGHT:
          this.pos.y += this.step;
          break;
      default:
          break;
    }
  }
  
  void display() {
    //7, (6,7,8)
     noStroke();
     switch(this.type) {
       case FICKLE: {
         if (this.fear) {
           fill(100,100,200);
         } else {
           fill(255,150,0);
         }
         ellipse(this.realPos.x, this.realPos.y, size, size);
         break;
       }
       case CHASER: {
         if (this.fear) {
           fill(100,100,200);
         } else {
           fill(255,0,0);
         }
         ellipse(this.realPos.x, this.realPos.y, size, size);
         break;
       }
       case AMBUSH: {
         if (this.fear) {
           fill(100,100,200);
         } else {
           fill(0,255,255);
         }
         ellipse(this.realPos.x, this.realPos.y, size, size);
         break;
       }
       case STUPID: {
         if (this.fear) {
           fill(100,100,200);
         } else {
           fill(255,0,255);
         }
         ellipse(this.realPos.x, this.realPos.y, size, size);
         break;
       }
       default: {
         break;
       }
     }
  }
}

public enum Ghost_Type {
  FICKLE,   //If too far from Pac-Man, use CHASER, if close, use STUPID
  CHASER,   //BFS find the shortest distance to Pac-Man
  AMBUSH,   //Predicting where Pac-Man will move
  STUPID    //random walk
}
