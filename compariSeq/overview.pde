// by Alex Bigelow, Sean McKenna, Sam Quinan
// a simpler, more effective encoding of sequence logos


// class for overview chart

class overview{
  
  data d;
  float barW;
  float barX;
  float barY;
  float barH;
  int tot;
  
  // chart position, size, & color
  float barSpace = 2.0;
  color barCol = color(255, 255, 255);
  color barStroke = color(217,217,217);
  int ptsSize = 10;
  
  overview(data data){
    d = data;
    tot = d.numLoc;
  }
  
  void drawOverview(int x, int y, int w, int h){
    // chart display
    drawChart(x, y, w, h);
    // amino acid display
    drawAminoAcids(x, y, w, h);
  }
  
  void drawChart(int x, int y, int w, int h){
    barW = ( (float) (h)) / ( (float) tot) - barSpace;
    barX = x;
    barY = y;
    barH = w;
    for(int l = 0; l < d.numLoc; l++){
      noStroke();
      fill(barCol);
      float val = d.information[l];
      float adj = barH * val / d.highestProbableUncertainty;
      rect(barX, barY + barW * l + barSpace * l, adj, barW);
    }
  }
  
  void drawAminoAcids(int x, int y, int w, int h){
    float ptW = barW;
    float ptX = x;
    float ptY = y;
    float ptH = w - ptW / 2.0;
    for(int l = 0; l < d.numLoc; l++){
      FloatDict freq = d.relFreqPerLoc[l];
      freq.sortValuesReverse();
      
      // for each amino acid per location
      float currAngle = radians(90.0);
      float pieLabelOffset = ptW + fontSize / 1.5;
      for(String key: freq.keys()){
        
        // set amino acid color
        color c = colors[aminoAcids.get(key)];
        if(hover && !k.contains(key))
          fill(177);
        else
          fill(c);
        
        // determine amino acid coordinates
        float xPos = ptX + ptW / 2;
        float yPos = ptY + ptW * l + barSpace * l + ptW / 2;
        
        // determine size of amino acid glyph
        float size = ptW * sqrt(sqrt(freq.get(key) * d.information[l] / d.highestProbableUncertainty));
        
        // draw each amino acid (pie chart)
        float angle = radians(freq.get(key) * 360.0);
        noStroke();
        arc(xPos, yPos, ptW, ptW, currAngle - angle, currAngle);
        currAngle -= angle;
        
        if(freq.get(key) > letterThreshold){
          textAlign(CENTER, CENTER);
          //pushMatrix();
          //translate(xPos - pieLabelOffset, ptY - fontSize / 5.0);
          //rotate(radians(270.0));
          text(key, ptX + pieLabelOffset, yPos - fontSize / 8.0);
          //popMatrix();
          pieLabelOffset += 1.25 * fontSize;
        }
      }
    }
  }
  
  int getLocation(int y){
    int i = (int) (y / (barW + barSpace));
    if(i < 0 || i >= tot)
    return -1;
      else
    return i;
  }
};
