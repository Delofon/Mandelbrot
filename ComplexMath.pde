class Complex
{
  // a + bi
  public float a; // Real component, also designated as Re(complex)
  public float b; // Imaginary component, also designated as Im(complex)
  
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
  public Complex(Complex complex) // Copies the value of the other complex number. Used to give a new variable instead of modifying the reference.
  {
    this.a = complex.a;
    this.b = complex.b;
  }
}

// For functions operating on a single complex number, complex represents number a + bi
// For functions operating on two complex numbers, a represents number a + bi and b represents number c + di

// (a + c) + (b + d)i
Complex Add(Complex a, Complex b)
{
  return new Complex(a.a + b.a, a.b + b.b);
}

// (ac - bd) + (ad + bc)i
Complex Multiply(Complex a, Complex b)
{
  return new Complex(a.a * b.a - a.b * b.b, a.a * b.b + a.b * b.a);
}

// (a^2 - b^2) + 2abi 
Complex Square(Complex complex)
{
  return new Complex(complex.a * complex.a - complex.b * complex.b, 2 * complex.a * complex.b);
}

// General complex number exponentiation.
Complex Pow(Complex complex, int pow)
{
  Complex result = new Complex(complex.a, complex.b);
  for(int i = 0; i < pow - 1; i++)
  {
    result = Multiply(result, complex);
  }
  return result;
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

// The conjugate of this complex number
// a - bi
Complex Conjugate(Complex complex)
{
  return new Complex(complex.a, -complex.b);
}

// The opposite of this complex number
// -a - bi
Complex Opposite(Complex complex)
{
  return new Complex(-complex.a, -complex.b);
}

boolean ApproximatelyEqual(Complex a, Complex b)
{
  float epsilon = .0001f; // Supposed to be a small value like an actual epsilon, but you can change it to whatever you like.
  // Note that large values of epsilon will result in "blockiness" with hyperbolic edges. (an interesting observation if you'd ask me!)
  // If you see perfect polygons with curved edges, make this value smaller.
  
  float a_re = a.a;
  float a_im = a.b;
  
  float b_re = b.a;
  float b_im = b.b;
  
  boolean re_approx_eq = abs(a_re - b_re) < epsilon;
  boolean im_approx_eq = abs(a_im - b_im) < epsilon;
  
  return re_approx_eq && im_approx_eq;
}
