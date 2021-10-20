Gradient colourGradient;

void setup()
{
  size(400,400);
  surface.setTitle("Mandelbrot Set Plotter");
  //background(255, 255, 255);
  
  colourGradient = new Gradient();
  colourGradient.keyColours.put(0f, color(0, 0, 0));
  colourGradient.keyColours.put(.25f, color(255, 0, 0));
  colourGradient.keyColours.put(.50f, color(0, 255, 0));
  colourGradient.keyColours.put(.75f, color(0, 0, 255));
  colourGradient.keyColours.put(1f, color(255, 255, 255));
}

void draw()
{
  PlotMandelbrot(-.7,0,140,200, colourGradient);
  
  noLoop();
}

void PlotMandelbrot(float a_offset, float b_offset, float zoom, int iterations, Gradient gradient)
{
  color white = color(160, 160, 160);
  color black = color(0, 0, 0);
  
  for(int i = 0; i < pixelWidth * pixelHeight; i++)
  {
    int x = i % pixelWidth;
    int y = i / pixelWidth;
    
    float x_coord = (x - pixelWidth / 2 ) / zoom + a_offset;
    float y_coord = -(y - pixelHeight / 2) / zoom + b_offset; // -(y - height / 2) because in the complex plane imaginary axis points upward but in screen coords y axis points down
    
    Complex c = new Complex(x_coord, y_coord);
    Complex z = new Complex(0, 0);
    
    boolean bailout = false;
    float iterations_to_bailout = 0;
    for(int iteration = 0; iteration < iterations; iteration++)
    {
      // z = z^2 + c
      z = Add(Square(z), c);
      
      // if abs > 2 - bailout (it is proven that if the point shoots farther 2 then it is definitely not part of the Mandelbrot set)
      if(AbsSqr(z) > 2 * 2)
      {
        bailout = true;
        iterations_to_bailout = iteration;
        iteration = iterations;
      }
      // no bailout, point is part of the Mandelbrot set
    }
    
    if(!bailout)
    {
      // point is part of the Mandelbrot set, colour black
      set(x, y, black);
    }
    else
    {
      // point is not part of the Mandelbrot set
      
      // if no gradient is defined, colour "white"
      if(gradient == null)
      {
        // colour white
        set(x, y, white);
      }
      // if gradient is defined, use it to colour into a rainbow
      else
      {
        color colour = gradient.Evaluate(iterations_to_bailout / iterations);
        set(x, y, colour);
      }
    }
  }
}
