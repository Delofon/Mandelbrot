Complex MandelbrotSet(Complex z, Complex c)
{
  // z = z ^ 2 + c - Mandelbrot set function
  return Add(Square(z), c);
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

Complex RandomFrac(Complex z, Complex c)
{
  // z = conj(z) ^ 2 + c - Random fractal, looks like Mandelbar
  return z = Add(Square(Conjugate(z)), c);
}
