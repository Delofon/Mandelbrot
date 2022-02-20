void UnoptimizedEscapeTime(float a_offset, float b_offset, float zoom, int max_iterations, Gradient gradient)
{
  for(int i = 0; i < pixelWidth * pixelHeight; i++)
  {
    // Get pixel coordinates in the window
    int x = i % pixelWidth;
    int y = i / pixelWidth;
    
    // Get pixel coordinates in the complex plane
    float x_coord = (x - pixelWidth / 2 ) / zoom + a_offset;
    float y_coord = (y - pixelHeight / 2) / zoom + b_offset;
    
    // Initialize a complex number that this pixel represents
    Complex c = new Complex(x_coord, y_coord);
    // The number being iterated over in the Mandelbrot set function. Different values of z produce a variety of interesting distortions of the Mandelbrot set. Value of c skips first iteration
    Complex z = new Complex(0, 0);
    
    // Variables for helping in colouring the image
    boolean bailout = false;
    int pixel_iterations = 0;
    // Iterate over the z for iterations amount of times
    for(int iteration = 0; iteration < max_iterations; iteration++)
    {
      // Uncomment only one of these functions. Uncommenting multiple will produce weird and unexpected (but fascinating) results!
      
      z = MandelbrotSet(z, c);
      //z = BurningShip(z, c);
      //z = MandelbarSet(z, c);
      //z = RandomFrac(z, c);
      
      // If abs > 2 - bailout (it is proven that if the point shoots farther 2 then it is definitely not part of the Mandelbrot set)
      if(AbsSqr(z) > 2 * 2)
      {
        bailout = true;
        pixel_iterations = iteration;
        iteration = max_iterations; // escape the loop
      }
      // No bailout, point is part of the Mandelbrot set
    }
    
    DefaultEscapeTimeColouring(x, y, bailout, pixel_iterations, max_iterations, gradient);
  }
}
