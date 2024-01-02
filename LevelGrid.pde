import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Queue;
import java.util.Stack;

public class LevelGrid {
    final static int DOOR = -1; //TODO implement the door for other gates
    final static int WALL = 0;
    final static int FOOD = 1;
    final static int GOOD = 2;

    int[][] Level = {
            {2,1,1,1,1,1,1,1,1,1,1,1,1,1,2},
            {1,0,0,0,0,0,1,0,1,0,0,0,0,0,1},
            {1,1,1,1,1,0,1,0,1,0,1,1,1,1,1},
            {1,0,0,1,1,1,1,1,1,1,1,1,0,0,1},
            {1,0,1,1,1,0,0,0,0,0,1,1,1,0,1},
            {1,1,1,0,1,1,1,1,1,1,1,0,1,1,1},
            {1,0,0,0,1,0,0,1,0,0,1,0,0,0,1},
            {1,1,2,0,1,0,1,1,1,0,1,0,2,1,1},
            {1,0,0,0,1,0,0,0,0,0,1,0,0,0,1},
            {1,1,1,0,1,1,1,1,1,1,1,0,1,1,1},
            {1,0,1,1,1,0,0,0,0,0,1,1,1,0,1},
            {1,0,0,1,1,1,1,1,1,1,1,1,0,0,1},
            {1,1,1,1,1,0,1,0,1,0,1,1,1,1,1},
            {1,0,0,0,0,0,1,0,1,0,0,0,0,0,1},
            {2,1,1,1,1,1,1,1,1,1,1,1,1,1,2}
    };
    
    ArrayList<Index> validLocations;
    
    public void randomLevel() {
      /*
       * The area at the center should NOT be changed!
       * 
       *    (6,5)
       *    0 0 1 0 0
       *    0 1 1 1 0
       *    0 0 0 0 0
       *        (8,9)
       *    15
       */ 
              
      int wallCount = 120;
      int foodCount = 80;
      int goodCount = 10;
       
      ArrayList<Integer> list = new ArrayList();
      for (int i = 0 ; i < 210; i++) {
        if (wallCount >= 0) {
          list.add(0);
          wallCount -= 1;
        } else if (foodCount >= 0) {
          list.add(1);
          foodCount -= 1;
        } else if (goodCount >= 0) {
          list.add(2);
          goodCount -= 1;
        }
      }
       
      int min = 0;
      int max = list.size() - 1;
      Random rand = new Random(frameCount);
       
      for (int i = 0; i < 15; i++) {
        for (int j = 0; j < 15; j++) {
          this.Level[i][j] = -2;
        }
      }
      
      this.Level[5][4] = 1;
      this.Level[5][5] = 1;
      this.Level[5][6] = 1;
      this.Level[5][7] = 1;
      this.Level[5][8] = 1;
      this.Level[5][9] = 1;
      this.Level[5][10] = 1;
       
      this.Level[6][5] = 0;
      this.Level[6][6] = 0;
      this.Level[6][7] = 1;
      this.Level[6][8] = 0;
      this.Level[6][9] = 0;
      
      this.Level[7][5] = 0;
      this.Level[7][6] = 1;
      this.Level[7][7] = 1;
      this.Level[7][8] = 1;
      this.Level[7][9] = 0;
      
      this.Level[8][5] = 0;
      this.Level[8][6] = 0;
      this.Level[8][7] = 0;
      this.Level[8][8] = 0;
      this.Level[8][9] = 0;
      
      this.Level[9][4] = 1;
      this.Level[9][5] = 1;
      this.Level[9][6] = 1;
      this.Level[9][7] = 1;
      this.Level[9][8] = 1;
      this.Level[9][9] = 1;
      this.Level[9][10] = 1;
      
      for (int i = 0; i < 15; i++) {
        for (int j = 0; j < 15; j++) {
          if (this.Level[i][j] == -2) {
            this.Level[i][j] = list.get(rand.nextInt((max - min) + 1) + min);
          }
        }
      }
      
    }
    
    public LevelGrid() {
        this.validLocations = new ArrayList<>();
        for (int i = 0; i < 15; i++) {
            for (int j = 0; j < 15; j++) {
                if (Level[i][j] != 0) this.validLocations.add(new Index(i,j));
            }
        }
    }
    
    public Index getRandomLocation(long seed) {
        int min = 0;
        int max = validLocations.size() - 1;
        Random rand = new Random(seed);
        return validLocations.get(rand.nextInt((max - min) + 1) + min);
    }
    
    public Index getNearestLocation(Index start, int radius) {
      int upX = start.x - radius;
      int downX = start.x + radius;
      int rightY = start.y + radius;
      int leftY = start.y - radius;
      
      if (upX >= 0) {
        return new Index(upX, start.y);
      } else if (rightY <= 14) {
        return new Index(start.x, rightY);
      } else if (downX <= 14) {
        return new Index(downX, start.y);
      } else if (leftY >= 0) {
        return new Index(start.x, leftY);
      } else {
        return start;
      }
      
    }
    
    void display(int type, Index index) {
      switch(type) {
        case WALL: {
          fill(0,0,100);
          rect(index.getPos().x - 15, index.getPos().y - 15, 30, 30);
          break;
        }
        case FOOD: {
          //fill(200);
          //ellipse(index.getPos().x, index.getPos().y, 10, 10);
          break;
        }
        case GOOD: {
          //fill(200);
          //ellipse(index.getPos().x, index.getPos().y, 20, 20);
          break;
        }
        default: {
          break;
        }
      }
  }

    public Index[][] BFS(Index start, Index end) {
        Queue<Index> Q = new LinkedList<>();
        Index[][] edgeTo = new Index[15][15];

        boolean[][] visited = new boolean[15][15];

        for (boolean[] booleans : visited) {
            for (boolean b : booleans) {
                b = false;
            }
        }

        Q.add(start);

        while(!Q.isEmpty()) {
            Index current = Q.peek();
            Q.remove();
            if (current.x == end.x && current.y == end.y) {
                //find the shortest path
                //what ever the edgeTo has is what can reach that index
                //the index of edgeTo is the destination!
                return edgeTo;
            }
            for (Index i : current.getAdjacent()) {
                if (!visited[i.x][i.y]  && Level[i.x][i.y] != WALL) {
                    Q.add(i);
                    visited[i.x][i.y] = true;
                    edgeTo[i.x][i.y] = current;
                }
            }
        }

        return edgeTo;
    }

    public Step[] getStepBFS(Index start, Index end) {
        Queue<Index> Q = new LinkedList<>();
        Index[][] edgeTo = new Index[15][15];

        boolean[][] visited = new boolean[15][15];

        for (boolean[] booleans : visited) {
            for (boolean b : booleans) {
                b = false;
            }
        }

        Q.add(start);

        while(!Q.isEmpty()) {
            Index current = Q.peek();
            Q.remove();
            if (current.x == end.x && current.y == end.y) {
                //find the shortest path
                //what ever the edgeTo has is what can reach that index
                //the index of edgeTo is the destination!
                return getSteps(edgeTo, start, end);
            }
            for (Index i : current.getAdjacent()) {
                if (!visited[i.x][i.y]  && Level[i.x][i.y] != WALL) {
                    Q.add(i);
                    visited[i.x][i.y] = true;
                    edgeTo[i.x][i.y] = current;
                }
            }
        }
        return null;
    }
    
    public Step getNextStep(Index start, Index end) {
        print(start.x + "," + start.y + "\n");
        print(end.x + "," + end.y + "\n");
        Queue<Index> Q = new LinkedList<>();
        Index[][] edgeTo = new Index[15][15];

        boolean[][] visited = new boolean[15][15];

        for (boolean[] booleans : visited) {
            for (boolean b : booleans) {
                b = false;
            }
        }

        Q.add(start);

        while(!Q.isEmpty()) {
            Index current = Q.peek();
            Q.remove();
            if (current.x == end.x && current.y == end.y) {
                //find the shortest path
                //what ever the edgeTo has is what can reach that index
                //the index of edgeTo is the destination!
                return getSteps(edgeTo, start, end)[0];
            }
            for (Index i : current.getAdjacent()) {
                if (!visited[i.x][i.y]  && Level[i.x][i.y] != WALL && i.x >= 0 && i.x < 15 && i.y >= 0 && i.y < 15) {
                    Q.add(i);
                    visited[i.x][i.y] = true;
                    edgeTo[i.x][i.y] = current;
                }
            }
        }
        return null;
    }

    public Step[] getSteps(Index[][] edgeTo, Index start, Index end) {
        Index currPos = end;
        Stack<Step> steps = new Stack<>();
        Step[] stepOrder;
        while (currPos != start) {
            Index dest = edgeTo[currPos.x][currPos.y];
            int diffX = dest.x - currPos.x;
            int diffY = dest.y - currPos.y;
            if (diffX == 0) {
                //moving left and right
                if (diffY > 0) {
                    steps.push(Step.LEFT);
                } else {
                    steps.push(Step.RIGHT);
                }
            } else {
                //moving up and down
                if (diffX > 0) {
                    steps.push(Step.UP);
                } else {
                    steps.push(Step.DOWN);
                }
            }
            currPos = dest;
            /*
                example: if start is 14,14 and end is 12,12
                we use the end location as the path finder
                from edgeTo[12][12] contains the value that can reach [12][12]
                so we backtrack to that location
                if that location is [12][13] then dest - curr = + j -> the step is left
                if dest - curr = - j -> the step is right
             */
        }

        stepOrder = new Step[steps.size()];

        for (int i = 0; i < steps.size(); i++) {
            stepOrder[i] = steps.get(steps.size() - 1 - i);
        }

        return stepOrder;
    }
    
    public Index getFinalLocation(Step[] steps, int n) {
        int x = 0;
        int y = 0;
        for (int i = 0; i < steps.length; i++) {
            switch(steps[i]) {
                case UP:
                    x -= 1;
                    break;
                case DOWN:
                    x += 1;
                    break;
                case LEFT:
                    y -= 1;
                    break;
                case RIGHT:
                    y += 1;
                    break;
                default:
                    break;
            }
        }
        return new Index(x, y);
    }
    
    public Index getLocationWithinStep(Index start, Index end) {
        Queue<Index> Q = new LinkedList<>();
        Index[][] edgeTo = new Index[15][15];

        boolean[][] visited = new boolean[15][15];

        for (boolean[] booleans : visited) {
            for (boolean b : booleans) {
                b = false;
            }
        }

        Q.add(start);

        while(!Q.isEmpty()) {
            Index current = Q.peek();
            Q.remove();
            if (current.x == end.x && current.y == end.y) {
                //find the shortest path
                //what ever the edgeTo has is what can reach that index
                //the index of edgeTo is the destination!
                Index modifier = getFinalLocation(getSteps(edgeTo, start, end), edgeTo.length / 2);
                start.x += modifier.x;
                start.y += modifier.y;
                return start; // check the other methods 4head
            }
            for (Index i : current.getAdjacent()) {
                if (!visited[i.x][i.y]  && Level[i.x][i.y] != WALL) {
                    Q.add(i);
                    visited[i.x][i.y] = true;
                    edgeTo[i.x][i.y] = current;
                }
            }
        }
        return null;
    }
}
