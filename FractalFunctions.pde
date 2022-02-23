Complex MandelbrotSet(Complex z, Complex c)
{
  // z = z ^ 2 + c - Mandelbrot set function
  return Add(Square(z), c);
}

// The above function has some redundant multiplications; by using this instead, you can omit them.
// You can also make similar optimized functions for other fractals.
Complex MandelbrotSetOptimized(Complex z, Complex c)
{
  float re = z.a * z.a - z.b * z.b + c.a;
  float im = (z.a + z.a) * z.b + c.b; 
  return new Complex(re, im);
}

Complex BurningShip(Complex z, Complex c)
{
  // z = (|Re(z)| + |Im(z)|i) ^ 2 + c - The Burning Ship function
  return z = Add(Square(new Complex(abs(z.a), abs(z.b))), c);
}

Complex MandelbarSet(Complex z, Complex c)
{
  // z = conj(z ^ 2) + c <=> z = Re(z ^ 2) - Im(z ^ 2)i + c - Mandelbar set or Tricorn fractal function
  return z = Add(Conjugate(Square(z)), c);
}

Complex MandelbarSetAlt(Complex z, Complex c)
{
  // z = conj(z) ^ 2 + c - While it looks different than the above as the conjugate of a different complex number is taken, infact it is the exact same equation.
  // Try to work it out on paper to see why ;p
  return z = Add(Square(Conjugate(z)), c);
}
