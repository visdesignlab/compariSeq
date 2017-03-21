// by Alex Bigelow, Sean McKenna, Sam Quinan
// a simpler, more effective encoding of sequence logos


// imports & data:
  
  // import library to output PDF screenshots
  import processing.pdf.*;
  
  // data files
  String dataFileA = "panel-a.txt";
  String dataFileB = "panel-b.txt";
  String dataFileC = "panel-c.txt";
  String fileLocation = "data/";


// booleans to activate and deactivate features:
  
  // take a screenshot of the current view
  // can take with 'p' during runtime
  boolean printScreen = false;
  

// data storage:
  
  // one for each species
  data dataA;
  data dataB;
  data dataC;
  overview oA;
  overview oB;
  overview oC;
  detail d;
  PImage legend;
  int loc1;
  int loc2;
  boolean hover = false;
  String k = "";

// drawing options:
  
  // size and color of screen
  int w = 1400; // this has to be set manually below as well in Processing 3
  int h = 800; // this has to be set manually below as well in Processing 3
  color bg = color(217, 217, 217);
  
  // size and color of points
  IntDict aminoAcids = new IntDict();
  color[] colors = new color[21]; // adding a null point for undetermined amino acids, 'X'
  
  // thresholding amino acids by pixels
  float aminoThreshold = 0.15;
  
  // whether to draw labels
  float letterThreshold = 0.20;
  
  // line weight (for stacking)
  float stackWeight = 4.0;
  
  // font for amino acids
  int fontSize = 18;
  PFont font;



// initial setup
void setup(){
  size(1400, 800);
  
  // set up font
  font = createFont("GillSans-Bold", fontSize);
  textFont(font);
  
  // set up amino acid colors
  setColors();
  
  dataA = new data(fileLocation + dataFileA);
  dataB = new data(fileLocation + dataFileB);
  dataC = new data(fileLocation + dataFileC);
  
  // load in data
  // loadData();
  
  // compute frequency
  // computeFrequency();
  
  // calculate information content
  // calculateContent();
  oA = new overview(dataA);
  oB = new overview(dataB);
  oC = new overview(dataC);
  
  d = new detail();
  
  legend = loadImage("data/legend.png");
  
  loc1 = 3;
  loc2 = 6;
}



// begin draw cycle
void draw(){
  
  // take a screenshot, if necessary
  if(printScreen){
    PGraphics pdf = beginRecord(PDF, "seq-chart.pdf");
    pdf.textMode(SHAPE);
    textFont(font);
  }
  
  // detect mouse hover on legend
  int gap = 20;
  mouseHover(mouseX - (w - gap * 2 - 300), mouseY - (h - gap - 254));
  
  // wipe background each time
  background(bg);
  
  
  // overview
  int overview = w / 2;
  oA.drawOverview(gap, gap, overview / 3, h - gap * 2);
  oB.drawOverview(gap * 2 + overview / 3, gap, overview / 3, h - gap * 2);
  oC.drawOverview(gap * 3 + 2 * overview / 3, gap, overview / 3, h - gap * 2);
  
  // detail
  d.drawDetail(loc1, overview + gap * 5, gap * 3, overview - gap * 7, overview / 4);
  d.drawDetail(loc2, overview + gap * 5, gap * 15, overview - gap * 7, overview / 4);
  
  image(legend, w - gap * 2 - 300, h - gap - 254);
  
  noFill();
  stroke(77);
  rect(gap / 2.0, gap + 21.1111 * loc1 - 1, overview + gap * 2.5, 19.1111 + 2);
  rect(gap / 2.0, gap + 21.1111 * loc2 - 1, overview + gap * 2.5, 19.1111 + 2);
  
  // finish taking the screenshot
  if(printScreen){
    endRecord();
    printScreen = false;
  }
}


void mouseClicked(){
  if(mouseButton == LEFT){
    int l = -1;
    if(mouseX < 40 + w / 6)
      l = oA.getLocation(mouseY - 20);
    else if(mouseX < 60 + w / 3)
      l = oB.getLocation(mouseY - 20);
    else if(mouseX < 80 + 2 * w / 3)
      l = oC.getLocation(mouseY - 20);
    if(l >= 0 && loc2 != l)
      loc1 = l;
  }else if(mouseButton == RIGHT){
    int l = -1;
    if(mouseX < 40 + w / 6)
      l = oA.getLocation(mouseY - 20);
    else if(mouseX < 60 + w / 3)
      l = oB.getLocation(mouseY - 20);
    else if(mouseX < 80 + 2 * w / 3)
      l = oC.getLocation(mouseY - 20);
    if(l >= 0 && loc1 != l)
      loc2 = l;
  }
}


// enable screenshot with p, swap stacking with s, swap scale of y-axis with b, swap drawing a pie chart with i
void keyPressed(){
  if(keyCode == 'p' || keyCode == 'P'){
    printScreen = true;
  }
}


// detect mouse hover on legend in image coordinates
void mouseHover(int x, int y){
  
  // in legend
  if(x > 0 && y > 0){
    
    // first row
    if(y >= 0 && y <= 36){
      if(x >= 230 && x <= 261){
        k = "N";
        hover = true;
      }else if(x >= 269 && x <= 300){
        k = "Q";
        hover = true;
      }else{
        k = "NQ";
        hover = true;
      }
    
    // second row
    }else if(y >= 51 && y <= 88){
      if(x >= 230 && x <= 261){
        k = "E";
        hover = true;
      }else if(x >= 269 && x <= 300){
        k = "D";
        hover = true;
      }else{
        k = "ED";
        hover = true;
      }
      
    // third row
    }else if(y >= 106 && y <= 142){
      if(x >= 193 && x <= 223){
        k = "K";
        hover = true;
      }else if(x >= 232 && x <= 262){
        k = "H";
        hover = true;
      }else if(x >= 269 && x <= 300){
        k = "R";
        hover = true;
      }else{
        k = "KHR";
        hover = true;
      }
    
    // fourth row
    }else if(y >= 162 && y <= 198){
      if(x >= 117 && x <= 147){
        k = "G";
        hover = true;
      }else if(x >= 154 && x <= 184){
        k = "Y";
        hover = true;
      }else if(x >= 192 && x <= 223){
        k = "T";
        hover = true;
      }else if(x >= 230 && x <= 261){
        k = "C";
        hover = true;
      }else if(x >= 269 && x <= 300){
        k = "S";
        hover = true;
      }else{
        k = "GYTCS";
        hover = true;
      }
    
    // fifth row
    }else if(y >= 217 && y <= 254){
      if(x >= 0 && x <= 30){
        k = "M";
        hover = true;
      }else if(x >= 37 && x <= 68){
        k = "W";
        hover = true;
      }else if(x >= 75 && x <= 106){
        k = "I";
        hover = true;
      }else if(x >= 114 && x <= 145){
        k = "P";
        hover = true;
      }else if(x >= 152 && x <= 182){
        k = "A";
        hover = true;
      }else if(x >= 190 && x <= 220){
        k = "F";
        hover = true;
      }else if(x >= 229 && x <= 259){
        k = "L";
        hover = true;
      }else if(x >= 269 && x <= 300){
        k = "V";
        hover = true;
      }else{
        k = "MWIPAFLV";
        hover = true;
      }
    
    // nothing hovered on!
    }else{
      hover = false;
    }
  }else{
    hover = false;
  }
}


// set up the colors for each amino acid
void setColors(){
  aminoAcids.set("R", 0);
  colors[0] = color(65, 97, 128);
  aminoAcids.set("H", 1);
  colors[1] = color(95, 134, 175);
  aminoAcids.set("K", 2);
  colors[2] = color(111, 169, 209);
  aminoAcids.set("Q", 3);
  colors[3] = color(91, 63, 87);
  aminoAcids.set("N", 4);
  colors[4] = color(129, 114, 129);
  aminoAcids.set("D", 5);
  colors[5] = color(139, 65, 56);
  aminoAcids.set("E", 6);
  colors[6] = color(206, 134, 136);
  aminoAcids.set("S", 7);
  colors[7] = color(13, 69, 35);
  aminoAcids.set("C", 8);
  colors[8] = color(31, 103, 67);
  aminoAcids.set("T", 9);
  colors[9] = color(46, 148, 74);
  aminoAcids.set("Y", 10);
  colors[10] = color(121, 188, 66);
  aminoAcids.set("G", 11);
  colors[11] = color(172, 211, 143);
  aminoAcids.set("V", 12);
  colors[12] = color(143, 89, 40);
  aminoAcids.set("L", 13);
  colors[13] = color(197, 125, 43);
  aminoAcids.set("F", 14);
  colors[14] = color(217, 113, 45);
  aminoAcids.set("A", 15);
  colors[15] = color(203, 161, 50);
  aminoAcids.set("P", 16);
  colors[16] = color(226, 183, 38);
  aminoAcids.set("I", 17);
  colors[17] = color(235, 233, 44);
  aminoAcids.set("W", 18);
  colors[18] = color(228, 216, 94);
  aminoAcids.set("M", 19);
  colors[19] = color(255, 248, 141);
  // for an undetermined amino acid, not fully supported yet
  aminoAcids.set("X", 20);
  colors[20] = color(0, 0, 0);
}