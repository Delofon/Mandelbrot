class Gradient
{
  // Key colours are like key frames in animating and video editing software. The gradient basically represents the timeline between different colours
  HashMap<Float, Integer> keyColours;
  
  public Gradient()
  {
    keyColours = new HashMap<Float, Integer>();
  }
  
  // Complicated gradient stuff
  color Evaluate(float time)
  {
    // Safe time
    time = Clamp01(time);
    
    // If time lands on a key colour, retrieve it
    if(keyColours.containsKey(time))
      return keyColours.get(time);
    
    // Find previous and next key colours and their according keys
    float leftKey = Float.NEGATIVE_INFINITY;
    float rightKey = Float.POSITIVE_INFINITY;
    
    Float[] keys = keyColours.keySet().toArray(new Float[0]);
    
    for(int i = 0; i < keys.length; i++)
    {
      if(keys[i] < time)
      {
        if(keys[i] > leftKey)
          leftKey = keys[i];
      }
      
      else 
      { 
        if(keys[i] < rightKey)
          rightKey = keys[i];
      }
    }
    
    color leftColour = keyColours.get(leftKey);
    color rightColour = keyColours.get(rightKey);
    
    // I'm not sure exactly which of the ways is the conventional one - the straight-forward lerp or the overcomplicated one.
    // However, from my observations, the overcomplicated lerp produces better results, so I'll stick with it instead.
    
    //int r = floor(Lerp(red(leftColour), red(rightColour), time));
    //int g = floor(Lerp(green(leftColour), green(rightColour), time));
    //int b = floor(Lerp(blue(leftColour), blue(rightColour), time));
    
    // Prepare for lerping by normalizing the colour values
    float l_r = red(leftColour) / 255, l_g = green(leftColour) / 255, l_b = blue(leftColour) / 255;
    float r_r = red(rightColour) / 255, r_g = green(rightColour) / 255, r_b = blue(rightColour) / 255;
    
    // Lerp
    
    float left_lerp = InvLerp(rightKey, leftKey, time);
    float right_lerp = InvLerp(leftKey, rightKey, time);
    
    float l_r_lerp = l_r * left_lerp;
    float l_g_lerp = l_g * left_lerp;
    float l_b_lerp = l_b * left_lerp;
    
    float r_r_lerp = r_r * right_lerp;
    float r_g_lerp = r_g * right_lerp;
    float r_b_lerp = r_b * right_lerp;
    
    // Add resulting values together and that will be your colour in normalized values
    
    float r_lerp = l_r_lerp + r_r_lerp;
    float g_lerp = l_g_lerp + r_g_lerp;
    float b_lerp = l_b_lerp + r_b_lerp;
    
    // Denormalize for use with the Processing 2D rendering system
    
    int r = floor(r_lerp * 255);
    int g = floor(g_lerp * 255);
    int b = floor(b_lerp * 255);
    
    return color(r, g, b);
  }
}
