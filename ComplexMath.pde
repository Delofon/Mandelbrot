class Complex
{
  // a + bi
  public BigDecimal a; // real component
  public BigDecimal b; // imaginary component
  
  public Complex()
  {
    a = BigDecimal.ZERO;
    b = BigDecimal.ZERO;
  }
  public Complex(BigDecimal a, BigDecimal b)
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
  return new Complex(a.a.add(b.a), a.b.add(b.b));
}

// (ac - bd) + (ad + bc)i
Complex Multiply(Complex a, Complex b)
{
  return new Complex(a.a.multiply(b.a).subtract(a.b.multiply(b.b)), a.a.multiply(b.b).add(a.b.multiply(b.a)));
}

// (a^2 - b^2) + 2abi 
Complex Square(Complex complex)
{
  return new Complex(complex.a.pow(2).subtract(complex.b.pow(2)), complex.a.multiply(new BigDecimal(2)).multiply(complex.b));
}

// The absolute value of the complex number is its distance D from the origin. Using Pythagoras's theorem,
// D ^ 2 = a ^ 2 + b ^ 2
BigDecimal AbsSqr(Complex complex)
{
  return complex.a.pow(2).add(complex.b.pow(2));
}

// The square root of above function:
// D = sqrt(a ^ 2 + b ^ 2)
BigDecimal Abs(Complex complex)
{
  return AbsSqr(complex).pow(-2);
}

// The conjugate of this complex number
// a - bi
Complex Conjugate(Complex complex)
{
  return new Complex(complex.a, complex.b.negate());
}
