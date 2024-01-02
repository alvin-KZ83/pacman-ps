import processing.sound.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import processing.sound.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import java.util.*;
Random rand;
LevelGrid level = new LevelGrid();

Queue<Step> stepQ = new LinkedList<>();
ArrayList<Dots> dots = new ArrayList();

int score = 0;
int shadow_delay = 3;

int super_duration = 5;

Player shadow;
Player player;

Ghost fickle;
Ghost chaser;
Ghost ambush;
Ghost stupid;

int start;
float size;

boolean paused = false;

int bpmSong = 70;
int bps = bpmSong / 60;
int bpm = 60 / (bps);

PImage img;

Minim minim;
AudioPlayer audio;

Dots beatCircle;
PFont font;

void setup() {
  size(600,700);
  player = new Player(new Index(9, 7));
  shadow = new Player(new Index(9, 7));
  fickle = new Ghost(Ghost_Type.FICKLE, player, new Index(7, 6));
  chaser = new Ghost(Ghost_Type.CHASER, player, new Index(9, 4));
  ambush = new Ghost(Ghost_Type.AMBUSH, player, new Index(7, 7));
  stupid = new Ghost(Ghost_Type.STUPID, player, new Index(7, 8));
  start = second();
  
  for (int i = 0; i < 15; i++) {
    for (int j = 0; j < 15; j++) {
      if (level.Level[i][j] != 0) {
        dots.add(new Dots(new Index(i, j), level.Level[i][j]));
      }
    }
  }
  
  minim = new Minim(this);
  audio = minim.loadFile("Deep Sea Bass.wav");
  font = createFont("ARCADECLASSIC", 20, true);
  //level.randomLevel(); STILL BREAKING
}

void draw() {
  background(0, 0, 50);
  player.display(Play.PC, frameCount/2);
  shadow.display(Play.NPC, frameCount/2);
  
  audio.play();
  
  for (int i = 0; i < 15; i++) {
    for (int j = 0; j < 15; j++) {
      if (level.Level[i][j] == 0) {
        level.display(level.Level[i][j], new Index(i, j));
      }
    }
  }
  
  textFont(font, 50);
  fill(255);
  text("Score " + String.format("%3d", score) + "!", 40, height - 50);
  
  for (int i = 0; i < dots.size(); i++) {
    Dots dot = dots.get(i);
    dot.display();
      if (dot.hit(player)) {
        if (dot.type == 2) { 
          player.mode = 1;
          
          bpmSong *= 3;
          
          fickle.inFear();
          chaser.inFear();
          ambush.inFear();
          stupid.inFear();
          
          super_duration = 5;
          score += 8; 
        }
        dots.remove(dot);
        score += 2;
        print("Current: " + score + " PTS.\n");
      }
  }
  
  fickle.display();
  chaser.display();
  ambush.display();
  stupid.display();
  size = 30;
    
  if (frameCount % bpm > 0 && frameCount % bpm < 2) {    
    size = 50;
    
    float r = (float) (127 * Math.cos(radians(frameCount)) + 127);
    float g = (float) (127 * Math.cos(radians(frameCount) + HALF_PI) + 127);
    float b = (float) (-127 * Math.cos(radians(frameCount)) + 127);
    
    fill(r,g,b);
    ellipse(300, 650, 50, 50);
    
    if (player.mode == 1) {
      super_duration -= 1;
    }
    
    if (super_duration <= 0) {
      player.mode = 0;
      
      bpmSong /= 3;
      
      fickle.noFear();
      chaser.noFear();
      ambush.noFear();
      stupid.noFear();
      
      super_duration = 5;
    }
    
    shadow_delay -= 1;
    
    if (shadow_delay <= 0) {
      if (!stepQ.isEmpty()) {
        Step s = stepQ.peek();
        stepQ.remove();
        shadow.move(s, level);
      }
    }
    
    chaser.move(level);
    stupid.move(level);
    fickle.move(level);
    ambush.move(level);
 }
      
  if (fickle.hit(player)) {
    if (fickle.fear) {
      fickle.pos = new Index(7, 6);
    } else {
      textFont(font, 100);
      fill(255);
      text("Game Over",75,300);
      audio.pause();
      audio.rewind();
      noLoop();
    }
  }
  
  if (chaser.hit(player)) {
    if (chaser.fear) {
      chaser.pos = new Index(7, 7);
    } else {
      textFont(font, 100);
      fill(255);
      text("Game Over",75,300);
      audio.pause();
      audio.rewind();
      noLoop();
    }
  }
  
  if (ambush.hit(player)) {
    if (ambush.fear) {
      ambush.pos = new Index(7, 7);
    } else {
      textFont(font, 100);
      fill(255);
      text("Game Over",75,300);
      audio.pause();
      audio.rewind();
      noLoop();
    }
  }
  
  if (stupid.hit(player)) {
    if (stupid.fear) {
      stupid.pos = new Index(7, 8);
    } else {
      textFont(font, 100);
      fill(255);
      text("Game Over",75,300);
      audio.pause();
      audio.rewind();
      noLoop();
    }
  }
}

void keyPressed() {
        switch (key) {
            case 'w': {
                ////move up
                stepQ.add(Step.UP);
                //if (frameCount % bpm < bps) {
                  player.move(Step.UP, level);
                //}
                break;
            } case 'a': {
                //move left
                stepQ.add(Step.LEFT);
                //if (frameCount % bpm > 0 && frameCount % bpm < 2) {
                  player.move(Step.LEFT, level);
                //}
                break;
            } case 'd': {
                ////move right
                stepQ.add(Step.RIGHT);
                //if (frameCount % bpm > 0 && frameCount % bpm < 2) {
                  player.move(Step.RIGHT, level);
                //}
                break;
            } case 's': {
                ////move down
                stepQ.add(Step.DOWN);
                //if (frameCount % bpm > 0 && frameCount % bpm < 2) {
                  player.move(Step.DOWN, level);
                //}
                break;
            } case 'p': {
                paused = !paused;
                if (paused) {
                  audio.pause();
                  textFont(font, 100);
                  fill(255);
                  text("Game Paused",20,350);
                  noLoop();
                } else {
                  audio.loop();
                  loop();
                }  
                break;
            } default: {
                break;
            }
        }
}
