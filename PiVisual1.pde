/*
*  Audio Visualizer: Uses FFT analysis to agitate bouncing balls across the spectrum.
*  Balls will grow in size and move faster based on the amplitude of their 
*  corresponding FFT band. Balls will bounce off other balls and screen edge,
*  scattering across screen as amplitude causes more collisions
*  
*  Robert Fullum 2020
*/
import processing.sound.*;

// Audio
AudioIn audioIn;
FFT fft;
int fftResolution = 7;    // the power you're raising 2 to
int bands = (int)pow(2, fftResolution);  
float smoothingFactor = 0.2f;
float[] spectrum = new float[bands];

// Balls
int numBalls = bands;
float spring = 0.05f;
float gravity = 0.03;
float friction = -0.9;
float ballDiameter = 20.0f;//width / (float)numBalls;

Ball[] balls = new Ball[numBalls];

color c1 = color(252, 101, 0);
color c2 = color(0, 252, 250);


void setup()
{
  fullScreen(P2D);
  
  audioIn = new AudioIn(this, 0);
  fft = new FFT(this, bands);
  
  audioIn.start();
  fft.input(audioIn);
  
  for (int i=0; i<numBalls; i++)
  {
    float xCoord = norm(i, 0, numBalls) * width;
    balls[i] = new Ball( xCoord, height / 2.0f, ballDiameter, i, balls, lerpColor(c1, c2, norm(i, 0.0f, numBalls)) );
  }
}

void draw()
{
  background(0);
  
  float fftDiameter[] = new float[bands];
  
  // FFT
  fft.analyze();
  for (int i=0; i<bands; i++)
  {
    spectrum[i] += (fft.spectrum[i] - spectrum[i]) * smoothingFactor;
    fftDiameter[i] = ballDiameter + (spectrum[i] * 100.0f);
  }
  
  for (Ball ball : balls)
  {
    float fftVelocity = spectrum[ball.id] * 10.0 + 1;
    
    ball.resize(fftDiameter[ball.id]);
    ball.collide();
    ball.move(fftVelocity);
    ball.display();
  }
}
