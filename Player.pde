
class Player {
  float x, y;
  float velX = 0, velY = 0;
  int size = 30;
  boolean movingLeft = false;
  boolean movingRight = false;
  boolean movingUp = false;
  boolean movingDown = false;
  boolean facingRight = true;
  int lives = 3;  
  int projectilesLeft = 10; 
  boolean isNearLadder = false;
  boolean isClimbing = false;
  
  Player(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void update() {
    
    // Movement
    if (movingLeft) velX = -5;
    else if (movingRight) velX = 5;
    else velX = 0;
    
    boolean aboveLadder = (x + size/2 > ladderX && 
                          x + size/2 < ladderX + ladderWidth && 
                          y + size >= ladderY - 20 && 
                          y <= ladderY);
                          
    boolean onLadder = (x + size > ladderX && 
                       x < ladderX + ladderWidth &&
                       y + size > ladderY && 
                       y < ladderY + ladderHeight);
                       
    isNearLadder = onLadder || aboveLadder;
    
    // Handle climbing
    if (isNearLadder && isClimbing) {
      
      // When climbing
      if (movingUp) velY = -3;
      else if (movingDown) velY = 3;
      else velY = 0;

    } else {
      // Apply normal gravity when not climbing
      velY += GRAVITY;
    }
    
    // Update position
    x += velX;
    y += velY;
    
    // Dont let the player cross the left edge of the screen
    if (x < 0) x = 0;
    
    // Calculate player center position
    float centerX = x + size/2;
    
    // Check if player is over the gap
    boolean overGap = (centerX > gapX && centerX < gapX + gapWidth);
    
    // Check if player is on the platform
    boolean onPlatform = (y + size >= platformY && y + size <= platformY + 5 && 
                         x + size > platformX && x < platformX + platformWidth);
    
    // Ground collision - only stop falling if NOT over the gap OR on platform
    if ((!overGap && y > GROUND_LEVEL - size) || onPlatform) {
      if (onPlatform) {
        y = platformY - size;
      } else {
        y = GROUND_LEVEL - size;
      }
      velY = 0;
    }
    
    // If player falls
    if (y > height) {
      loseLife();
    }
    
    // If player falls into the gap but not past bottom of screen
    if (overGap && y > GROUND_LEVEL && y < height - size) {

    }
    
    // ladder detection
    if (isNearLadder) {
    }
  }
  
  void display() {

    fill(255, 0, 0);
    noStroke();
    
    if (facingRight) {
      triangle(
        x, y,
        x, y + size,
        x + size, y + size/2
      );
    } else {
      triangle(
        x + size, y,
        x + size, y + size,
        x, y + size/2
      );
    }
  }
  
  void jump() {
    if (isOnGround()) {
      velY = JUMP_FORCE;
    }
  }
  
  boolean isOnGround() {
    // Calculate player center X position
    float centerX = x + size/2;
    
    // Check if player is over the gap
    boolean overGap = (centerX > gapX && centerX < gapX + gapWidth);
    
    // Check if player is on the platform
    boolean onPlatform = (y + size >= platformY && y + size <= platformY + 5 && 
                          x + size > platformX && x < platformX + platformWidth);
    
    // Player is on ground if they're at ground level AND not over a gap OR if on platform
    return ((y >= GROUND_LEVEL - size) && !overGap) || onPlatform;
  }
  
  // reset to start
  void loseLife() {
    lives--;
    x = 100;
    y = GROUND_LEVEL - size;
    velY = 0;
    
    
    // Check if player is out of lives
    if (lives <= 0) {
      setGameOver();
    }
  }
}
