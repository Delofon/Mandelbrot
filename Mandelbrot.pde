Gradient colourGradient;

float x_offset = -.7;
float y_offset = 0;
float _zoom = 350;

// relative
float x_speed = 1;
float y_speed = 1;

float zoom_step = .1;

float prevWheel;

int _max_iterations = 100;
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
  float start = millis();
  UnoptimizedEscapeTime(x_offset, y_offset, _zoom, _max_iterations, colourGradient);
  computation_time_ms = millis() - start;
}

void keyPressed()
{
  // Add iterations
  if(key == '+' || key == '=')
  {
    _max_iterations += _iter_step;
  }
  // Subtract iterations
  if(key == '-')
  {
    _max_iterations -= _iter_step;
    // If iterations is less than 0 then pressing + to add may confuse the user
    if(_max_iterations < 0)
    {
      _max_iterations = 0;
    }
  }
  
  // Reset the settings
  if(key == 'r')
  {
    x_offset = 0;
    y_offset = 0;
    _zoom = 100;
    _max_iterations = 100;
  }
  
  // Print the settings
  if(key == 'f')
  {
    println("Real: " + x_offset);
    println("Imaginary: " + -y_offset);
    println("Zoom: " + _zoom);
    println("Iterations: " + _max_iterations);
    println("Computation time (seconds): " + computation_time_ms / 1000);
  }
  
  // Move the complex plane if any of these keys were pressed
  float x_axis = int(key == 'd') - int(key == 'a');
  float y_axis = int(key == 's') - int(key == 'w');
  
  x_offset += x_axis * x_speed / _zoom;
  y_offset += y_axis * y_speed / _zoom;
  
  redraw();
}

void mousePressed()
{
  // Move the complex plane to the point where the mouse clicked
  x_offset += (mouseX - pixelWidth / 2 ) / _zoom;
  y_offset += (mouseY - pixelHeight / 2) / _zoom;
  
  redraw();
}

void mouseWheel(MouseEvent event)
{
  float wheel = event.getCount();
  
  // Zoom in/out according to mouse wheel.
  _zoom -= wheel * zoom_step * _zoom;
  
  if(_zoom < 0)
    _zoom = 0;
  
  prevWheel = wheel;
  
  redraw();
}
