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
  
  // Animation variables
  PImage standingImg;
  PImage walkImg;
  PImage walk2Img;
  PImage jumpImg;
  PImage tossImg;
  PImage hitImg;
  int animationFrame = 0;
  int frameCounter = 0;
  boolean isTossing = false;
  boolean isHit = false;
  int tossTimer = 0;
  int hitTimer = 0;
  int walkAnimationSpeed = 8; // frames between walk animation changes
  
  Player(float x, float y) {
    this.x = x;
    this.y = y;
    
    // Load player assets
    standingImg = loadImage("assets/Standing.png");
    walkImg = loadImage("assets/Walk.png");
    walk2Img = loadImage("assets/Walk2.png");
    jumpImg = loadImage("assets/Jump.png");
    tossImg = loadImage("assets/Toss.png");
    hitImg = loadImage("assets/Hit.png");
  }
  
  void update() {
    // Movement
    if (movingLeft) velX = -5;
    else if (movingRight) velX = 5;
    else velX = 0;
    
    // Check if player is near any ladder
    boolean nearLadder = false;
    
    // Check main ladder
    boolean aboveLadder = (x + size/2 > ladderX && 
                          x + size/2 < ladderX + ladderWidth && 
                          y + size >= ladderY - 20 && 
                          y <= ladderY);
                          
    boolean onLadder = (x + size > ladderX && 
                       x < ladderX + ladderWidth &&
                       y + size > ladderY && 
                       y < ladderY + ladderHeight);
    
    // Check additional ladders
    for (int i = 0; i < additionalLadders.length; i++) {
      float lx = additionalLadders[i][0];
      float ly = additionalLadders[i][1];
      float lw = additionalLadders[i][2];
      float lh = additionalLadders[i][3];
      
      boolean aboveAdditionalLadder = (x + size/2 > lx && 
                                     x + size/2 < lx + lw && 
                                     y + size >= ly - 20 && 
                                     y <= ly);
                                     
      boolean onAdditionalLadder = (x + size > lx && 
                                   x < lx + lw &&
                                   y + size > ly && 
                                   y < ly + lh);
      
      if (aboveAdditionalLadder || onAdditionalLadder) {
        nearLadder = true;
        break;
      }
    }
    
    // Set final ladder status
    isNearLadder = onLadder || aboveLadder || nearLadder;
    
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
    
    // Don't let the player cross the left edge of the screen
    if (x < 0) x = 0;
    
    // Don't let player go past the right edge of the level
    if (x > LEVEL_WIDTH - size) {
      x = LEVEL_WIDTH - size;
    }
    
    // Check if player is on any platform or ground
    boolean onAnyPlatform = false;
    
    // Check main platform
    if (y + size >= platformY && y + size <= platformY + 5 && 
        x + size > platformX && x < platformX + platformWidth) {
      y = platformY - size;
      velY = 0;
      onAnyPlatform = true;
    }
    
    // Check additional platforms
    for (int i = 0; i < additionalPlatforms.length; i++) {
      if (y + size >= additionalPlatforms[i][1] && 
          y + size <= additionalPlatforms[i][1] + 5 && 
          x + size > additionalPlatforms[i][0] && 
          x < additionalPlatforms[i][0] + additionalPlatforms[i][2]) {
        y = additionalPlatforms[i][1] - size;
        velY = 0;
        onAnyPlatform = true;
        break;
      }
    }
    
    // Calculate player center position
    float centerX = x + size/2;
    
    // Check if player is over any gap
    boolean overAnyGap = false;
    
    // Check main gap
    if (centerX > gapX && centerX < gapX + gapWidth) {
      overAnyGap = true;
    }
    
    // Check additional gaps
    for (int i = 0; i < additionalGaps.length; i++) {
      if (centerX > additionalGaps[i][0] && 
          centerX < additionalGaps[i][0] + additionalGaps[i][1]) {
        overAnyGap = true;
        break;
      }
    }
    
    // Ground collision - only stop falling if NOT over any gap OR on any platform
    if ((!overAnyGap && y > GROUND_LEVEL - size) || onAnyPlatform) {
      if (!onAnyPlatform) {
        y = GROUND_LEVEL - size;
      }
      velY = 0;
    }
    
    // If player falls
    if (y > height) {
      loseLife();
    }
    
    // Update animation states
    updateAnimationState();
  }
  
  void updateAnimationState() {
    // Update walk animation frame counter
    if (velX != 0) {
      frameCounter++;
      if (frameCounter >= walkAnimationSpeed) {
        animationFrame = (animationFrame + 1) % 2; // Switch between 0 and 1
        frameCounter = 0;
      }
    } else {
      // Reset to standing when not moving
      animationFrame = 0;
      frameCounter = 0;
    }
    
    // Update toss animation timer
    if (isTossing) {
      tossTimer--;
      if (tossTimer <= 0) {
        isTossing = false;
      }
    }
    
    // Update hit animation timer
    if (isHit) {
      hitTimer--;
      if (hitTimer <= 0) {
        isHit = false;
      }
    }
  }
  
  void display() {
    pushMatrix();
    translate(x, y);
    
    // Flip if facing left
    if (!facingRight) {
      scale(-1, 1);
      translate(-size, 0);
    }
    
    // Determine which sprite to display based on state
    PImage currentSprite;
    
    if (isHit) {
      // Hit animation takes precedence
      currentSprite = hitImg;
    } else if (isTossing) {
      // Tossing animation
      currentSprite = tossImg;
    } else if (velY < 0 || (!isOnGround() && !isClimbing)) {
      // Jumping/falling
      currentSprite = jumpImg;
    } else if (velX != 0) {
      // Walking animation
      currentSprite = (animationFrame == 0) ? walkImg : walk2Img;
    } else {
      // Standing still
      currentSprite = standingImg;
    }
    
    // Draw the sprite
    image(currentSprite, 0, 0, size, size);
    
    popMatrix();
  }
  
  void jump() {
    if (isOnGround()) {
      velY = JUMP_FORCE;
    }
  }
  
  void toss() {
    // Set tossing animation
    isTossing = true;
    tossTimer = 15; // Animation lasts for 15 frames
  }
  
  void getHit() {
    // Set hit animation
    isHit = true;
    hitTimer = 30; // Animation lasts for 30 frames
  }
  
  boolean isOnGround() {
    // Calculate player center X position
    float centerX = x + size/2;
    
    // Check if player is over any gap
    boolean overGap = false;
    
    // Check main gap
    if (centerX > gapX && centerX < gapX + gapWidth) {
      overGap = true;
    }
    
    // Check additional gaps
    for (int i = 0; i < additionalGaps.length; i++) {
      if (centerX > additionalGaps[i][0] && centerX < additionalGaps[i][0] + additionalGaps[i][1]) {
        overGap = true;
        break;
      }
    }
    
    // Check if player is on any platform
    boolean onPlatform = false;
    
    // Check main platform
    if (y + size >= platformY && y + size <= platformY + 5 && 
        x + size > platformX && x < platformX + platformWidth) {
      onPlatform = true;
    }
    
    // Check additional platforms
    for (int i = 0; i < additionalPlatforms.length; i++) {
      if (y + size >= additionalPlatforms[i][1] && 
          y + size <= additionalPlatforms[i][1] + 5 && 
          x + size > additionalPlatforms[i][0] && 
          x < additionalPlatforms[i][0] + additionalPlatforms[i][2]) {
        onPlatform = true;
        break;
      }
    }
    
    // Player is on ground if they're at ground level AND not over a gap OR if on platform
    return ((y >= GROUND_LEVEL - size) && !overGap) || onPlatform;
  }
  
  // reset to start
  void loseLife() {
    lives--;
    
    // Trigger hit animation
    getHit();
    
    // Respawn at the current checkpoint if one is active
    if (currentCheckpoint != null && currentCheckpoint.isReached) {
      x = currentCheckpoint.x;
      y = currentCheckpoint.y;
    } else {
      // Otherwise respawn at the start
      x = 100;
      y = GROUND_LEVEL - size;
    }
    
    velY = 0;
    
    // Check if player is out of lives
    if (lives <= 0) {
      setGameOver();
    }
  }
}