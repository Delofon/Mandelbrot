Gradient colourGradient;

float x_offset = -.7;
float y_offset = 0;
float _zoom = 350;

// relative
float x_speed = 1;
float y_speed = 1;

float zoom_step = .1;

float prevWheel;

int _iterations = 100;
int _iter_step = 10;

void setup()
{
  size(400, 400);
  surface.setTitle("Mandelbrot Set Plotter");
  //background(255, 255, 255);
  
  colourGradient = new Gradient();
  colourGradient.keyColours.put(0f, color(0, 0, 0));
  colourGradient.keyColours.put(.25f, color(0, 0, 255));
  colourGradient.keyColours.put(.50f, color(0, 255, 0));
  colourGradient.keyColours.put(.75f, color(255, 0, 0));
  colourGradient.keyColours.put(1f, color(0, 0, 0));
  
  // do not want to recalculate the Mandelbrot set each frame. Your computer will get upset!
  noLoop();
}

void draw()
{
  PlotMandelbrot(x_offset, y_offset, _zoom, _iterations, colourGradient);
}

void keyPressed()
{
  if(key == '+')
  {
    _iterations
  }
  
  if(key == '-')
  {
    _iterations -= _iter_step;
  }
  
  if(key == 'r')
  {
    x_offset = 0;
    y_offset = 0;
    _zoom = 100;
  }
  
  float x_axis = int(key == 'd') - int(key == 'a');
  float y_axis = int(key == 'w') - int(key == 's');
  
  x_offset += x_axis * x_speed / _zoom;
  y_offset += y_axis * y_speed / _zoom;
  
  redraw();
}

void mousePressed()
{  
  float x_coord = (mouseX - pixelWidth / 2 ) / _zoom + x_offset;
  float y_coord = -(mouseY - pixelHeight / 2) / _zoom + y_offset;
  
  x_offset = x_coord;
  y_offset = y_coord;
  
  redraw();
}

void mouseWheel(MouseEvent event)
{
  float wheel = event.getCount();
  
  _zoom -= wheel * zoom_step * _zoom;
  
  if(_zoom < 0)
    _zoom = 0;
  
  prevWheel = wheel;
  
  redraw();
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
    float y_coord = -(y - pixelHeight / 2) / zoom + b_offset; // -(y - pixelHeight / 2) because in the complex plane imaginary axis points upward but in screen coords y axis points down
    
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
