void setup()
{
  size(400,400);
  surface.setTitle("Mandelbrot Set Plotter");
  background(255, 255, 255);
}

void draw()
{
  //loadPixels();
  PlotMandelbrot(-.7,0,140,200);
  //updatePixels();
  
  noLoop();
}

void PlotMandelbrot(float a_offset, float b_offset, float zoom, int iterations)
{
  color white = color(255, 255, 255);
  color black = color(0, 0, 0);
  
  for(int i = 0; i < width * height; i++)
  {
    int x = i % width;
    int y = i / width;
    
    float x_coord = (x - width / 2 ) / zoom + a_offset;
    float y_coord = (y - height / 2) / zoom + b_offset;
    
    Complex c = new Complex(x_coord, y_coord);
    Complex z = new Complex();
    
    boolean bailout = false;
    for(int iteration = 0; iteration < iterations; iteration++)
    {
      // z = z^2 + c
      z = Add(Square(z), c);
      
      // if abs > 2 - bailout (it is proven that if the point shoots farther 2 then it is definitely not part of the Mandelbrot set)
      if(AbsSqr(z) > 2 * 2)
      {
        bailout = true;
        iteration = iterations + 1;
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
      // point is not part of the Mandelbrot set, colour white
      set(x, y, white);
    }
  }
}
