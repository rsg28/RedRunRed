// Checkpoint class for save points in the game
class Checkpoint {
  float x, y;
  int size = 30;
  boolean isActive = false;
  boolean isReached = false;
  float bounceOffset = 0;
  float bounceSpeed = 0.05;
  float bounceAmount = 3;
  
  Checkpoint(float x, float y) {
    this.x = x;
    this.y = y - size; // Adjust Y position to be at the top of the checkpoint
    this.isActive = true;
  }
  
  void update() {
    // Make the checkpoint flag wave/bounce slightly
    bounceOffset = sin(frameCount * bounceSpeed) * bounceAmount;
  }
  
  void display() {
    pushMatrix();
    translate(x, y + bounceOffset);
    
    // Draw flagpole
    strokeWeight(2);
    stroke(100);
    line(0, 0, 0, size);
    
    // Draw flag
    noStroke();
    if (isReached) {
      // Green flag if checkpoint has been reached
      fill(0, 255, 0);
    } else {
      // White flag if not yet reached
      fill(255);
    }
    
    beginShape();
    vertex(0, 0);
    vertex(15, 5);
    vertex(0, 10);
    endShape(CLOSE);
    
    popMatrix();
  }
  
  boolean collidesWith(Player player) {
    return isActive && 
           !isReached &&
           (x - 5 < player.x + player.size &&
            x + 20 > player.x &&
            y < player.y + player.size &&
            y + size > player.y);
  }
  
  void activate(Player player) {
    if (!isReached) {
      isReached = true;
      // Optional: play a sound or show a visual effect
    }
  }
}