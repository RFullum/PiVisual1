//  -Even out amp response through spectrum
//  -See about fixing the overlapping during collision

class Ball
{
  float x;
  float y;
  float diameter;
  float vx = 0.0f;
  float vy = 0.0f;
  
  int id;
  
  color ballColor;
  
  Ball[] others;
  
  Ball(float xin, float yin, float din, int idin, Ball[] oin, color cin)
  {
    x = xin;
    y = yin;
    diameter = din;
    id = idin;
    others = oin;
    ballColor = cin;
  }
  
  void collide()
  {
    for (int i = id + 1; i < numBalls; i++)
    {
      float dx = others[i].x - x;
      float dy = others[i].y - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = (others[i].diameter / 2.0f) + (diameter / 2.0f);
      
      if (distance < minDist)
      {
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - others[i].x) * spring;
        float ay = (targetY - others[i].y) * spring;
        
        vx -= ax;
        vy -= ay;
        others[i].vx += ax;
        others[i].vy += ay;
      }
    }
  }
  
  void move(float fftV)
  {
    vy += gravity;
    x += vx * fftV;
    y += vy * fftV;
    
    if (x + (diameter / 2.0f) > width)
    {
      x = width - (diameter / 2.0f);
      vx *= friction;
    }
    else if (x - (diameter / 2.0f) < 0.0f)
    {
      x = diameter / 2.0f;
      vx *= friction;
    }
    
    if (y + (diameter / 2.0f) > height)
    {
      y = height - (diameter / 2.0f);
      vy *= friction;
    }
    else if (y - (diameter / 2.0f) < 0.0f)
    {
      y = diameter / 2.0f;
      vy *= friction;
    }
  }
  
  void resize(float newDiameter)
  {
    diameter = newDiameter;
  }
  
  void display()
  {
    noStroke();
    fill(ballColor);
    ellipse(x, y, diameter, diameter);
  }
}
