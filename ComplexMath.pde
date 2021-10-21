class Complex
{
  // a + bi
  public float a; // real component
  public float b; // imaginary component
  
  public Complex()
  {
    a = 0;
    b = 0;
  }
  public Complex(float a, float b)
  {
    this.a = a;
    this.b = b;
  }
}

// For functions operating on a single complex number, complex represents number a + bi
// For functions operating on two complex numbers, a represents number a + bi and b represents number c + di

// (a + c) + (b + d)i
Complex Add(Complex a, Complex b)
{
  return new Complex(a.a + b.a, a.b + b.b);
}

// (ac - bd) + (iad + ibc)
Complex Multiply(Complex a, Complex b)
{
  return new Complex(a.a * b.a - a.b * b.b, a.a * b.b + a.b * b.a);
}

// (a^2 - b^2) + i2ab 
Complex Square(Complex complex)
{
  return new Complex(complex.a * complex.a - complex.b * complex.b, 2 * complex.a * complex.b);
}

// The absolute value of the complex number is its distance D from the origin. Using Pythagoras's theorem,
// D ^ 2 = a ^ 2 + b ^ 2
float AbsSqr(Complex complex)
{
  return complex.a * complex.a + complex.b * complex.b;
}

// The square root of above function:
// D = sqrt(a ^ 2 + b ^ 2)
float Abs(Complex complex)
{
  return sqrt(AbsSqr(complex));
}
