float Lerp(float a, float b, float time)
{
  return a + (b - a) * time;
}
float InvLerp(float a, float b, float val)
{
  return (val - a) / (b - a);
}
float Clamp(float a, float b, float val)
{
  if(val < a)
    return a;
  if(val > b)
    return b;
  return val;
}
