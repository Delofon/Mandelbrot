// The naive method of computing the Mandelbrot set: iterate for each pixel, check if it's bailout and colour according to the number of iterations it took to bailout.
void UnoptimizedEscapeTime(float a_offset, float b_offset, float zoom, int max_iterations, Gradient gradient)
{
  // These are my defaults. You can change the RGB values to anything you like - it can not at all be white or black!
  color white = color(160, 160, 160);
  color black = color(0, 0, 0);
  
  for(int i = 0; i < pixelWidth * pixelHeight; i++)
  {
    // Get pixel coordinates in the window
    int x = i % pixelWidth;
    int y = i / pixelWidth;
    
    // Get pixel coordinates in the complex plane
    float x_coord = (x - pixelWidth / 2 ) / zoom + a_offset;
    float y_coord = (y - pixelHeight / 2) / zoom + b_offset;
    
    // Initialize a complex number parameter that this pixel represents
    Complex c = new Complex(x_coord, y_coord);
    // The number being iterated over in the Mandelbrot set function. Different values of z produce a variety of interesting distortions of the Mandelbrot set. Value of c skips first iteration.
    Complex z = new Complex(0, 0);
    
    // Variables for helping in colouring the image
    boolean bailout = false;
    int pixel_iterations = 0;
    
    // Iterate over the z for iterations amount of times
    for(int iteration = 0; iteration < max_iterations; iteration++)
    {
      // Uncomment only one of these functions. Uncommenting multiple will produce weird and unexpected (but fascinating) results!
      
      z = MandelbrotSet(z, c);
      //z = MandelbrotSetOptimized(z, c);
      //z = BurningShip(z, c);
      //z = MandelbarSet(z, c);
      //z = MandelbarSetAlt(z, c);
      
      // If abs > 2 - bailout (it is proven that if the point shoots farther 2 then it is definitely not part of the Mandelbrot set)
      if(AbsSqr(z) > 2 * 2)
      {
        bailout = true;
        pixel_iterations = iteration - 1;
        iteration = max_iterations - 1; // escape the loop
      }
      // No bailout, point is part of the Mandelbrot set
    }
    
    // The following is the default colouring method for the Mandelbrot set.
    // Colours the outside of the Mandelbrot set in sort of "bands". If the amount of max_iterations is large,
    // then the images of the large scale structure (small zoom) will "fade out". Check it by incrementing the amount of iterations.
    
    if(!bailout)
    {
      // Point is part of the Mandelbrot set, colour black
      set(x, y, black);
      continue; // Continue to the next pixel, there is no point in colouring this pixel in any other way
    }
    
    // Point is not part of the Mandelbrot set
      
    if(gradient == null)
    {
      // If no gradient is defined, colour white
      set(x, y, white);
      continue; // And continue like before
    }
  
    // If gradient is defined, use it to colour into a rainbow
    color colour = gradient.Evaluate((float)pixel_iterations / max_iterations);
    set(x, y, colour);
  }
}

// Same story as above, but optimized for checking for periods if you are inside the set.
// (yes, sometimes in the Mandelbrot set the value "repeats" - that's a period, and the collection of points that the iterations trace is called an orbit.)
// (In other words, this also checks if we're in an orbit and skips the entire redundant calculations. Thus, saves time on calculating the points)
// (inside the Mandelbrot set.)
void PeriodicityCheckingEscapeTime(float a_offset, float b_offset, float zoom, int max_iterations, Gradient gradient)
{
  color white = color(160, 160, 160);
  color black = color(0, 0, 0);
  
  for(int i = 0; i < pixelWidth * pixelHeight; i++)
  {
    int x = i % pixelWidth;
    int y = i / pixelWidth;
    
    float x_coord = (x - pixelWidth / 2 ) / zoom + a_offset;
    float y_coord = (y - pixelHeight / 2) / zoom + b_offset;
    
    Complex c = new Complex(x_coord, y_coord);
    Complex z = new Complex(0, 0);
    
    // Before entering the loop, we also need to declare some additional variables.
    Complex z_old = new Complex(0, 0); // do not change the starting value! If set to z, the periodicity check will always return true no matter what!
    int period = 0;
    
    boolean bailout = false;
    int pixel_iterations = 0;
    for(int iteration = 0; iteration < max_iterations; iteration++)
    {
      // Uncomment only one of these functions. Uncommenting multiple will produce weird and unexpected (but fascinating) results!
      
      //z = MandelbrotSet(z, c);
      z = MandelbrotSetOptimized(z, c);
      //z = BurningShip(z, c);
      //z = MandelbarSet(z, c);
      //z = MandelbarSetAlt(z, c);
      
      if(AbsSqr(z) > 2 * 2)
      {
        bailout = true;
        pixel_iterations = iteration;
        iteration = max_iterations - 1; // escape the loop
      }
      
      // If period is detected, escape the loop in a similar yet different way like above.
      if(ApproximatelyEqual(z, z_old))
      {
        bailout = false;
        pixel_iterations = max_iterations - 1;
        iteration = max_iterations - 1;
      }
      
      // Reset the values for period checking. Change the number if you want to check for different periods.
      if(period > 20)
      {
        period = 0;
        z_old = new Complex(z);
      }
    }
    
    if(!bailout)
    {
      set(x, y, black);
      continue; // Continue to the next pixel, there is no point in colouring this pixel in any other way
    }
      
    if(gradient == null)
    {
      set(x, y, white);
      return; // And continue like before
    }
  
    color colour = gradient.Evaluate((float)pixel_iterations / max_iterations);
    set(x, y, colour);
  }
}

// Same as above, however utilising a little bit different colouring method.
// It is also known as histogram colouring method.
// It colours the set in the same bands as the above method does, but does not fade out on large max_iterations.
void PeriodicityCheckingHistogramColouringEscapeTime(float a_offset, float b_offset, float zoom, int max_iterations, Gradient gradient)
{
  // Unlike with basic escape time colouring, histogram colouring happens in four passes.
  
  // Pass 1: Bailout iteration calculation
  int[] iterations = new int[pixelWidth * pixelHeight]; // Store bailout iterations for each pixel.
  
  for(int i = 0; i < pixelWidth * pixelHeight; i++)
  {
    // Good ol escape time.
    int x = i % pixelWidth;
    int y = i / pixelWidth;
    
    float x_coord = (x - pixelWidth / 2 ) / zoom + a_offset;
    float y_coord = (y - pixelHeight / 2) / zoom + b_offset;
    
    Complex c = new Complex(x_coord, y_coord);
    Complex z = new Complex(0, 0);
    
    Complex z_old = new Complex(0, 0);
    int period = 0;
    
    for(int iteration = 0; iteration < max_iterations; iteration++)
    {
      // Uncomment only one of these functions. Uncommenting multiple will produce weird and unexpected (but fascinating) results!
      
      //z = MandelbrotSet(z, c);
      z = MandelbrotSetOptimized(z, c);
      //z = BurningShip(z, c);
      //z = MandelbarSet(z, c);
      //z = MandelbarSetAlt(z, c);
      
      if(AbsSqr(z) > 2 * 2)
      {
        // This is the same as setting pixel_iterations before, instead now we do it in an array.
        iterations[x + y * pixelWidth] = iteration; // Notice that when bailout happens iteration is always smaller than max_iterations. This will be needed for the third pass.
        iteration = max_iterations - 1; // escape the loop
      }

      if(ApproximatelyEqual(z, z_old))
      {
        iterations[x + y * pixelWidth] = max_iterations - 1;
        iteration = max_iterations - 1;
      }
      
      // Change the number if you want to check for different periods.
      if(period > 200)
      {
        period = 0;
        z_old = new Complex(z);
      }
    }
  }
    
  // This array relates iteration (aka index) to the amount of pixels with that amount of iterations.
  int[] pixels_per_iteration = new int[max_iterations];
  
  // Pass 2: Populate the said array with said values
  for(int i = 0; i < pixelWidth * pixelHeight; i++)
  {
    int iteration = iterations[i];
    pixels_per_iteration[iteration]++;
  }
  
  // Declare the variable to store the total amount of pixels that reached bailout.
  int total_bailout_pixels = 0;
  
  // Pass 3: Evaluate the amount of bailout pixels
  for(int i = 0; i < max_iterations; i++)
    total_bailout_pixels += pixels_per_iteration[i]; // Since i has to be smaller than max_iterations, the points inside the set will not be added in.
  
  // Pass 4: Colour the set
  for(int i = 0; i < pixelWidth * pixelHeight; i++)
  {
    int x = i % pixelWidth;
    int y = i / pixelWidth;      
    
    int iteration = iterations[i];
    float colourTime = 0f;
    
    for(int iter = 0; iter < iteration; iter++)
    {
      colourTime += (float)pixels_per_iteration[iter] / total_bailout_pixels;
    }
    
    color colour = gradient.Evaluate(colourTime);
    set(x, y, colour);
  }
}
