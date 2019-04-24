import processing.io.*;

float ascent,descent,textHeight,textPosY;
int countdown = 30;
int state = 0;
float second = 0;
int min = 0;
float countup = 0;
int toumei = 255;
String putstr;

void setup(){
  GPIO.pinMode(2,GPIO.INPUT);
  frameRate(10);
  fullScreen();
  background(0);
  fill(0);
  textSize(height/3);
  textAlign(CENTER,TOP);
  ascent = textAscent();
  descent = textDescent();
  textHeight = ascent + descent;
  textPosY = int(height-textHeight)/2;
}

void draw(){
  switch(state){
    case 0:
      screenReset();
      text("Ready",width/2,textPosY);
      state++;
      break;
    case 1:
      if(key == '\n'){
        state++;
      }
      break;
    case 2:
      screenReset();
      text((countdown+9)/10,width/2,textPosY);
      countdown--;
      if(countdown == 0){
        state++;
      }
      break;
    case 3:
      count();
      screenReset();
      fill(255,toumei);
      text("Start",width/2,textPosY);
      toumei -= 25;
      if(toumei < 0){
        state++;
      }
      break;
    case 4:
      count();
      strBond();
      screenReset();
      fill(255,toumei);
      text(putstr,width/2,textPosY);
      toumei += 25;
      if(toumei > 255){
        state++;
      }
      break;
    case 5:
      screenReset();
      count();
      strBond();
      text(putstr,width/2,textPosY);
      if(GPIO.digitalRead(2) == GPIO.LOW){
        state++;
      }
      if(countup>=179.9){
        state+=2;
      }
      break;
    case 6:
      fill(255,0,0);
      text(putstr,width/2,textPosY);
      fill(255);
      text("Finish!",width/2,textPosY+height/3);
      break;
    case 7:
      fill(255,0,0);
      text(putstr,width/2,textPosY);
      fill(255);
      text("Time Up!",width/2,textPosY+height/3);
      break;
    case -1:
      countdown = 30;
      countup = 0;
      state = 0;
      second = 0;
      min = 0;
      toumei = 255;
      break;
  }
}

void keyPressed(){
  if(key == 'z'){
    exit();
  }else if(key == 'r'){
    state = -1;
  }
}

void screenReset(){
  fill(0);
  noStroke();
  rect(0,0,width,height);
  fill(255);
}

void count(){
  countup += 0.1;
  second = countup%60;
  if(second >= 59.9){
    second = 0;
  }
  min = int(countup/60);
}
void strBond(){
  putstr = nf(countup%60 >= 59.9?min+1:min,2) + ":" + nf(second,2,2);
}
