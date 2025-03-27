// Projectile class
class Projectile {
  float x, y;
  float velX;
  int size = 10;
  
  Projectile(float x, float y, boolean facingRight) {
    this.x = x;
    this.y = y;
    // checks which side its facing
    this.velX = facingRight ? 8 : -8;  // Move right or left based on player direction
  }
  
  void update() {
    x += velX;
  }
  
  void display() {

    fill(255, 255, 0);
    ellipse(x, y, size, size);
  }
  
  boolean isOffScreen() {
  // Convert to screen coordinates to check if off visible screen
  PVector screenPos = worldToScreen(x, y);
  return (screenPos.x < -size || screenPos.x > width + size);
}
}
