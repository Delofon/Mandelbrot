void DefaultEscapeTimeColouring(int x, int y, boolean bailout, int pixel_iterations, int max_iterations, Gradient gradient)
{
  color white = color(160, 160, 160);
  color black = color(0, 0, 0);
  
  if(!bailout)
  {
    // Point is part of the Mandelbrot set, colour black
    set(x, y, black);
  }
  else
  {
    // Point is not part of the Mandelbrot set
    
    if(gradient == null)
    {
      // If no gradient is defined, colour white
      set(x, y, white);
    }
    else
    {
      // If gradient is defined, use it to colour into a rainbow
      color colour = gradient.Evaluate((float)pixel_iterations / max_iterations);
      set(x, y, colour);
    }
  }
}
