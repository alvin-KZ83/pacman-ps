public enum Step {
    UP, DOWN, LEFT, RIGHT;

    @Override
    public String toString() {
        switch(this) {
            case UP:
                return "U";
            case DOWN:
                return "D";
            case LEFT:
                return "L";
            case RIGHT:
                return "R";
            default:
                return "";
        }
    }
}
