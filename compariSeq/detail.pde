// by Alex Bigelow, Sean McKenna, Sam Quinan
// a simpler, more effective encoding of sequence logos


// class for detail chart

class detail{
  
  float barW;
  float barX;
  float barY;
  float barH;
  
  // chart position, size, & color
  float barSpace = 30.0;
  color barCol = color(255, 255, 255);
  color barStroke = color(217,217,217);
  int ptsSize = 25;
  
  detail(){
    // nothing yet
  }
  
  void drawDetail(int l, int x, int y, int w, int h){
    // chart display
    drawChart(l, x, y, w, h);
    // amino acid display
    drawAminoAcids(l, x, y, w, h);
  }
  
  void drawChart(int l, int x, int y, int w, int h){
    barW = ( (float) (h)) / 3.0 - barSpace;
    barX = x;
    barY = y;
    barH = w;
    noStroke();
    fill(barCol);
    float valA = dataA.information[l];
    float adjA = barH * valA / dataA.highestProbableUncertainty;
    rect(barX, barY, adjA, barW);
    float valB = dataB.information[l];
    float adjB = barH * valB / dataB.highestProbableUncertainty;
    rect(barX, barY + barW + barSpace, adjB, barW);
    float valC = dataC.information[l];
    float adjC = barH * valC / dataC.highestProbableUncertainty;
    rect(barX, barY + barW * 2 + barSpace * 2, adjC, barW);
    
    stroke(77);
    fill(77);
    textAlign(CENTER, CENTER);
    text(l + 1, x - barW, y + h / 2 - barW / 2);
  }
  
  void drawAminoAcids(int l, int x, int y, int w, int h){
    float ptW = barW;
    float ptX = x;
    float ptY = y + ptW + barSpace / 4;
    float ptH = w;
    
    stroke(113);
    noFill();
    line(ptX, ptY, ptX + ptH, ptY);
    
    FloatDict freqA = dataA.relFreqPerLoc[l];
    freqA.sortValues();
    for(String key: freqA.keys()){
      
      float adj = ptH * freqA.get(key);
      
      color c = colors[aminoAcids.get(key)];
      if(hover && !k.contains(key))
        fill(177);
      else
        fill(c);
      noStroke();
      
      float xPos = ptX + adj;
      float yPos = ptY;
      
      float size = ptW * sqrt(sqrt(freqA.get(key) * dataA.information[l] / dataA.highestProbableUncertainty));
      
      ellipse(xPos, yPos, size, size);
      
      fill(color(255, 255, 255));
      if(freqA.get(key) > letterThreshold){
        textAlign(CENTER, CENTER);
        text(key, xPos, yPos - fontSize / 10.0);
      }
    }
    
    ptY += barW + barSpace;
    stroke(113);
    noFill();
    line(ptX, ptY, ptX + ptH, ptY);
    
    FloatDict freqB = dataB.relFreqPerLoc[l];
    freqB.sortValues();
    for(String key: freqB.keys()){
      
      float adj = ptH * freqB.get(key);
      
      color c = colors[aminoAcids.get(key)];
      if(hover && !k.contains(key))
        fill(177);
      else
        fill(c);
      noStroke();
      
      float xPos = ptX + adj;
      float yPos = ptY;
      
      float size = ptW * sqrt(sqrt(freqB.get(key) * dataA.information[l] / dataA.highestProbableUncertainty));
      
      ellipse(xPos, yPos, size, size);
      
      fill(color(255, 255, 255));
      if(freqB.get(key) > letterThreshold){
        textAlign(CENTER, CENTER);
        text(key, xPos, yPos - fontSize / 10.0);
      }
    }
    
    ptY += barW + barSpace;
    stroke(113);
    noFill();
    line(ptX, ptY, ptX + ptH, ptY);
    
    FloatDict freqC = dataC.relFreqPerLoc[l];
    freqC.sortValues();
    for(String key: freqC.keys()){
      
      float adj = ptH * freqC.get(key);
      
      color c = colors[aminoAcids.get(key)];
      if(hover && !k.contains(key))
        fill(177);
      else
        fill(c);
      noStroke();
      
      float xPos = ptX + adj;
      float yPos = ptY;
      
      float size = ptW * sqrt(sqrt(freqC.get(key) * dataA.information[l] / dataA.highestProbableUncertainty));
      
      ellipse(xPos, yPos, size, size);
      
      fill(color(255, 255, 255));
      if(freqC.get(key) > letterThreshold){
        textAlign(CENTER, CENTER);
        text(key, xPos, yPos - fontSize / 10.0);
      }
    }
  }
};
