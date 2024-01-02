import java.util.ArrayList;

class Index {
    int x, y;
    
    Index(int x, int y) {
        this.x = x;
        this.y = y;
    }

    ArrayList<Index> getAdjacent() {
        ArrayList<Index> adjacent = new ArrayList<>();
        if (this.y - 1 >= 0) { adjacent.add(new Index(this.x, this.y - 1)); };
        if (this.x + 1 < 15) { adjacent.add(new Index(this.x + 1, this.y)); }
        if (this.y + 1 < 15) { adjacent.add(new Index(this.x, this.y + 1)); }
        if (this.x - 1 >= 0) { adjacent.add(new Index(this.x - 1, this.y)); }
        return adjacent;
    }
    
    Index getPos() {
      Index position = new Index(40 * this.y + 20, 40 * this.x + 20);
      return position;
    }
}
