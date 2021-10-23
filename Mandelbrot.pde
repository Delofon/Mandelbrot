Gradient colourGradient;

BigDecimal x_offset = new BigDecimal(-.7);
BigDecimal y_offset = new BigDecimal(0);
BigDecimal _zoom = new BigDecimal(350);

// relative
float x_speed = 1;
float y_speed = 1;

float zoom_step = .1;

float prevWheel;

int _iterations = 10;
int _iter_step = 10;

float computation_time_ms = 0; // Fun little value

void setup()
{
  size(400, 400);
  surface.setTitle("Mandelbrot Set Plotter");
  background(255, 255, 255);
  
  // Create a gradient between: black, blue, green, red and black
  colourGradient = new Gradient();
  colourGradient.keyColours.put(0f, color(0, 0, 0));
  colourGradient.keyColours.put(.25f, color(0, 0, 255));
  colourGradient.keyColours.put(.50f, color(0, 255, 0));
  colourGradient.keyColours.put(.75f, color(255, 0, 0));
  colourGradient.keyColours.put(1f, color(0, 0, 0));
  
  // Do not want to recalculate the Mandelbrot set each frame. Your computer will get upset!
  noLoop();
}

void draw()
{
  MandelbrotUnoptimizedEscapeTime(x_offset, y_offset, _zoom, _iterations, colourGradient);
}

void keyPressed()
{
  // Add iterations
  if(key == '+' || key == '=')
  {
    _iterations += _iter_step;
  }
  // Subtract iterations
  if(key == '-')
  {
    _iterations -= _iter_step;
    // If iterations is less than 0 then pressing + to add may confuse the user
    if(_iterations < 0)
    {
      _iterations = 0;
    }
  }
  
  // Reset the settings
  if(key == 'r')
  {
    x_offset = new BigDecimal(0);
    y_offset = new BigDecimal(0);
    _zoom = new BigDecimal(100);
    _iterations = 100;
  }
  
  // Print the settings
  if(key == 'f')
  {
    println("Real: " + x_offset);
    println("Imaginary: " + y_offset.negate());
    println("Zoom: " + _zoom);
    println("Iterations: " + _iterations);
    println("Computation time (seconds): " + computation_time_ms / 1000);
  }
  
  // Move the complex plane if any of these keys were pressed
  float x_axis = int(key == 'd') - int(key == 'a');
  float y_axis = int(key == 's') - int(key == 'w');
  
  x_offset = x_offset.add(new BigDecimal(x_axis * x_speed).divide(_zoom));
  y_offset = y_offset.add(new BigDecimal(y_axis * y_speed).divide(_zoom));
  
  redraw();
}

void mousePressed()
{
  // Move the complex plane to the point where the mouse clicked
  BigDecimal x_coord = new BigDecimal(mouseX - pixelWidth / 2 ).divide(_zoom).add(x_offset);
  BigDecimal y_coord = new BigDecimal(mouseY - pixelWidth / 2 ).divide(_zoom).add(y_offset);
  
  x_offset = x_coord;
  y_offset = y_coord;
  
  redraw();
}

void mouseWheel(MouseEvent event)
{
  float wheel = event.getCount();
  
  // Zoom in/out according to mouse wheel.
  _zoom = _zoom.subtract(_zoom.multiply(new BigDecimal(zoom_step * wheel)));
  
  if(_zoom.compareTo(BigDecimal.ZERO) == -1)
    _zoom = BigDecimal.ZERO;
  
  prevWheel = wheel;
  
  redraw();
}

void MandelbrotUnoptimizedEscapeTime(BigDecimal a_offset, BigDecimal b_offset, BigDecimal zoom, int iterations, Gradient gradient)
{
  color white = color(160, 160, 160);
  color black = color(0, 0, 0);
  
  float start = millis();
  
  for(int i = 0; i < pixelWidth * pixelHeight; i++)
  {
    // Get pixel coordinates in the window
    int x = i % pixelWidth;
    int y = i / pixelWidth;
    
    // Get pixel coordinates in the complex plane
    BigDecimal x_coord = new BigDecimal(x - pixelWidth / 2 ).divide(zoom, MathContext.DECIMAL128).add(a_offset);
    BigDecimal y_coord = new BigDecimal(y - pixelHeight / 2).divide(zoom, MathContext.DECIMAL128).add(b_offset);
    
    // Initialize a complex number that this pixel represents
    Complex c = new Complex(x_coord, y_coord);
    // The number being iterated over in the Mandelbrot set function. Different values of z produce a variety of interesting distortions of the Mandelbrot set
    Complex z = new Complex(new BigDecimal(0), new BigDecimal(0));
    
    // Variables for helping in colouring the image
    boolean bailout = false;
    float iterations_to_bailout = 0;
    // Iterate over the z for iterations amount of times
    for(int iteration = 0; iteration < iterations; iteration++)
    {
      // Uncomment only one of these functions. Uncommenting multiple will produce weird and unexpected (but fascinating) results!
      
      // z = z ^ 2 + c - Mandelbrot set function
      z = Add(Square(z), c);
      
      // z = (|Re(z)| + |Im(z)|i) ^ 2 + c - The Burning Ship function
      //z = Add(Square(new Complex(abs(z.a), abs(z.b))), c);
      
      // z = conj(z ^ 2) + c <=> z = Re(z ^ 2) - Im(z ^ 2)i + c - Mandelbar set or Tricorn fractal function
      //z = Add(Conjugate(Square(z)), c);
      
      // If abs > 2 - bailout (it is proven that if the point shoots farther 2 then it is definitely not part of the Mandelbrot set)
      if(AbsSqr(z).compareTo(new BigDecimal(2 * 2)) == 1)
      {
        bailout = true;
        iterations_to_bailout = iteration;
        iteration = iterations; // escape the loop
      }
      // No bailout, point is part of the Mandelbrot set
    }
    
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
        color colour = gradient.Evaluate(iterations_to_bailout / iterations);
        set(x, y, colour);
      }
    }
    
    computation_time_ms = millis() - start;
  }
}
