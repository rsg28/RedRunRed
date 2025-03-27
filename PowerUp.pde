// Base PowerUp class
class PowerUp {
  float x, y;
  int size = 25;
  boolean active = true;
  float bounceOffset = 0;
  float bounceSpeed = 0.05;
  float bounceAmount = 5;
  
  PowerUp(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void update() {
    // Make the power-up bounce a little 
    bounceOffset = sin(frameCount * bounceSpeed) * bounceAmount;
  }
  
  void display() {
    // overridden by subclasses
    if (!active) return;
  }
  
  boolean collidesWith(Player player) {
    // rectangle collision detection
    return active && 
           (x - size/2 < player.x + player.size &&
            x + size/2 > player.x &&
            y - size/2 + bounceOffset < player.y + player.size &&
            y + size/2 + bounceOffset > player.y);
  }
  
  void collect(Player player) {
    // overridden 
    if (!active) return;
    
    // deactivates the power-up
    active = false;
  }
}
