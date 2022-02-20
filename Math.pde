// https://en.wikipedia.org/wiki/Linear_interpolation
float Lerp(float a, float b, float time)
{
  return a + (b - a) * time;
}
float InvLerp(float a, float b, float val)
{
  return (val - a) / (b - a);
}

// If value is outside of number range then set it to the closest end of that range.
float Clamp(float a, float b, float val)
{
  if(val < a)
    return a;
  if(val > b)
    return b;
  return val;
}

// Same thing as above, but the number range is predefined to be [0; 1].
float Clamp01(float val)
{
  return Clamp(0, 1, val);
}
