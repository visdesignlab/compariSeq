// by Alex Bigelow, Sean McKenna, Sam Quinan
// a simpler, more effective encoding of sequence logos


// class for data storage
class data{
  
  String d = "";
  
  int numLoc;
  int numSeq;
  
  String[] sequences;
  IntDict[] freqPerLoc;
  FloatDict[] relFreqPerLoc;
  int[] totFreqPerLoc;
  
  float highestProbableUncertainty;
  float[] uncertainty;
  float[] informationRaw;
  float[] information;
  
  data(String s){
    d = s;
    
    String[] lines = loadStrings(d);
    sequences = lines;
    numLoc = sequences[0].length();
    numSeq = sequences.length;
    
    computeFrequency();
    
    calculateContent();
  }
  
  void computeFrequency(){
    // initialize variables
    totFreqPerLoc = new int[numLoc];
    freqPerLoc = new IntDict[numLoc];
    relFreqPerLoc = new FloatDict[numLoc];
    for(int l = 0; l < numLoc; l++){
      totFreqPerLoc[l] = numSeq;
      freqPerLoc[l] = new IntDict();
      relFreqPerLoc[l] = new FloatDict();
    }
    
    // fill up the frequency count at each location
    // also keep running total of missing data (freqPerLoc)
    for(int s = 0; s < numSeq; s++){
      for(int l = 0; l < numLoc; l++){
        String val = str(sequences[s].charAt(l));
        
        // missing data
        if(val.equals("."))
          totFreqPerLoc[l] -= 1;
        
        // else check if been tracked and increase count
        else if(freqPerLoc[l].hasKey(val))
          freqPerLoc[l].increment(val);
          
        // else add to frequency dictionary
        else
          freqPerLoc[l].set(val, 1);
      }
    }
    
    // compute a relative frequency
    for(int l = 0; l < numLoc; l++){
      for(String key: freqPerLoc[l].keys()){
        float val = ( (float) freqPerLoc[l].get(key) ) / ( (float) totFreqPerLoc[l]);
        relFreqPerLoc[l].set(key, val);
      }
      
    // sort the relative frequency (for stacking)
    relFreqPerLoc[l].sortValuesReverse();
    //relFreqPerLoc[l].sortValues();
    }
  }
  
  // calculate the amount of information content stored per amino acid
  void calculateContent(){
    // initialize variables
    uncertainty = new float[numLoc];
    informationRaw = new float[numLoc];
    information = new float[numLoc];
    
    // calculate uncertainty per location
    for(int l = 0; l < numLoc; l++){
      uncertainty[l] = 0;
      FloatDict freq = relFreqPerLoc[l];
      
      // for each amino acid per location
      for(String key: freq.keys()){
        float val = freq.get(key);
        
        // perform change of base
        float log = log(val) / log(2.0);
        
        // add uncertainty
        uncertainty[l] += val * log;
      }
      
      // flip sign
      uncertainty[l] = -1.0 * uncertainty[l];
    }
    
    // calculate raw information per location
    for(int l = 0; l < numLoc; l++){
      highestProbableUncertainty = log(20.0) / log(2.0);
      
      // compute total number of bits per location
      // ignoring correction factor for now
      informationRaw[l] = highestProbableUncertainty - uncertainty[l];
    }
    
    // calculate corrected information per location (missing data correction)
    for(int l = 0; l < numLoc; l++){
      float correction = ( (float) totFreqPerLoc[l]) / ( (float) numSeq);
          
      // compute total number of bits per location (corrected)
      information[l] = correction * informationRaw[l];
    }
  }
};
