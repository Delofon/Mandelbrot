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

// straight-forward
Complex Add(Complex a, Complex b)
{
  return new Complex(a.a + b.a, a.b + b.b);
}

// ac + iad + ibc - bd
Complex Multiply(Complex a, Complex b)
{
  return new Complex(a.a * b.a - a.b * b.b, a.a * b.b + a.b * b.a);
}

// a^2 + i2ab - b^2
Complex Square(Complex complex)
{
  return new Complex(complex.a * complex.a - complex.b * complex.b, 2 * complex.a * complex.b);
}

float Abs(Complex complex)
{
  return sqrt(AbsSqr(complex));
}

float AbsSqr(Complex complex)
{
  return complex.a * complex.a + complex.b * complex.b;
}
