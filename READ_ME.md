# "Run, Red, Run!" - Complete Code Documentation

This document provides a comprehensive explanation of the code for "Run, Red, Run!", a 2D platformer game built in Processing. The game is based on the Little Red Riding Hood story with a twist, where Red must deliver magical healing cupcakes to her sick grandmother.

## Table of Contents

1. [Game Overview](#game-overview)
2. [File Structure](#file-structure)
3. [Core Game Mechanics](#core-game-mechanics)
4. [Classes](#classes)
   - [Player](#player)
   - [Enemy](#enemy)
   - [BasicEnemy](#basicenemy)
   - [PowerUp](#powerup)
   - [AmmoPowerUp](#ammopowerup)
   - [Projectile](#projectile)
   - [Checkpoint](#checkpoint)
5. [Game States](#game-states)
6. [Camera System](#camera-system)
7. [Collision Detection](#collision-detection)
8. [Keyboard Input](#keyboard-input)
9. [Display Functions](#display-functions)
10. [World Generation](#world-generation)
11. [Game Loop](#game-loop)

## Game Overview

"Run, Red, Run!" is a side-scrolling platformer where the player controls Red as she delivers magical healing cupcakes to her sick grandmother. The player can navigate platforms, climb ladders, avoid or defeat enemies by throwing cupcakes, and collect power-ups. The game includes a checkpoint system, a camera that follows the player, and various game states (intro, play, victory, game over).

## File Structure

The game is separated into multiple `.pde` files, each containing different components:

- `RUN_RED_RUN.pde`: Main game file with setup, draw loop, and game logic
- `Player.pde`: Player class definition and behavior
- `Enemy.pde`: Base enemy class
- `BasicEnemy.pde`: Specific enemy implementation
- `PowerUp.pde`: Base power-up class
- `AmmoPowerUp.pde`: Specific power-up implementation
- `Projectile.pde`: Projectile (cupcake) class
- `Checkpoint.pde`: Checkpoint system
- `displays.pde`: Screen display functions
- `keyboard_module.pde`: Keyboard input handling

## Core Game Mechanics

### Physics System

```processing
final int GRAVITY = 1;
final int GROUND_LEVEL = 500;
final int JUMP_FORCE = -15;
```

The game uses a simple physics system with:
- Gravity (constant downward force)
- Ground collision (prevents falling through the ground)
- Jumping (applying upward velocity)
- Platform collision (allows standing on platforms)

### Level Design

The game world is divided into:
- Ground level (base floor)
- Gaps (holes to avoid)
- Platforms (elevated areas to reach)
- Ladders (for vertical movement)

The level is extended with arrays for multiple instances of these elements:

```processing
float[][] additionalPlatforms = { ... };
float[][] additionalGaps = { ... };
float[][] additionalLadders = { ... };
```

### Game Progress

Progress is tracked through:
- Lives (player starts with 3)
- Projectiles/Cupcakes (player starts with 10)
- Checkpoints (save positions throughout the level)

## Classes

### Player

```processing
class Player {
  float x, y;            // Position
  float velX, velY;      // Velocity
  int size;              // Player size
  boolean movingLeft, movingRight, movingUp, movingDown;  // Movement flags
  boolean facingRight;   // Direction facing
  int lives;             // Lives remaining
  int projectilesLeft;   // Cupcakes remaining
  boolean isNearLadder, isClimbing;  // Ladder interaction
  
  // Methods
  void update() { ... }  // Update player position and state
  void display() { ... } // Draw player on screen
  void jump() { ... }    // Make player jump
  boolean isOnGround() { ... } // Check if player is on ground
  void loseLife() { ... } // Handle death and respawn
}
```

The Player class handles:
- Movement (left/right, jumping, climbing)
- Collision detection with ground, platforms, gaps, and ladders
- Drawing the player character (a red triangle)
- Death and respawn mechanics via checkpoints
- Tracking lives and projectiles

### Enemy

```processing
class Enemy {
  float x, y;           // Position
  float velX;           // Horizontal velocity
  int enemyWidth, enemyHeight;  // Size
  
  // Methods
  void update() { ... }  // Update enemy (overridden by subclasses)
  void display() { ... } // Draw enemy (overridden by subclasses)
  boolean collidesWith(Player player) { ... }  // Detect player collision
  boolean collidesWith(Projectile projectile) { ... }  // Detect projectile collision
}
```

The Enemy base class provides:
- Basic position tracking
- Collision detection with player and projectiles
- Placeholder update and display methods for subclasses

### BasicEnemy

```processing
class BasicEnemy extends Enemy {
  // Constructor
  BasicEnemy(float x, float y) {
    super(x, y);
  }
  
  // Override display method
  void display() {
    fill(0, 0, 255);
    rect(x, y, enemyWidth, enemyHeight);
  }
}
```

The BasicEnemy class:
- Extends the Enemy base class
- Implements a simple blue rectangle enemy
- Uses the base collision detection

### PowerUp

```processing
class PowerUp {
  float x, y;          // Position
  int size;            // Size
  boolean active;      // Is the power-up still active
  float bounceOffset, bounceSpeed, bounceAmount;  // Animation variables
  
  // Methods
  void update() { ... }  // Update animation
  void display() { ... } // Draw power-up (overridden by subclasses)
  boolean collidesWith(Player player) { ... }  // Detect player collision
  void collect(Player player) { ... }  // Handle collection (overridden by subclasses)
}
```

The PowerUp base class provides:
- Position tracking
- Bouncing animation
- Collision detection
- Collection handling

### AmmoPowerUp

```processing
class AmmoPowerUp extends PowerUp {
  int extraAmmo = 3;  // Amount of ammo to add
  
  // Constructor
  AmmoPowerUp(float x, float y) {
    super(x, y);
  }
  
  // Override display method
  void display() { ... }  // Draw ammo box
  
  // Override collect method
  void collect(Player player) {
    // Give player extra projectiles
    player.projectilesLeft += extraAmmo;
    super.collect(player);  // Deactivate power-up
  }
}
```

The AmmoPowerUp class:
- Extends the PowerUp base class
- Gives 3 extra cupcakes when collected
- Draws as a small box

### Projectile

```processing
class Projectile {
  float x, y;          // Position
  float velX;          // Horizontal velocity
  int size;            // Size
  
  // Constructor
  Projectile(float x, float y, boolean facingRight) {
    this.x = x;
    this.y = y;
    // Set velocity based on direction
    this.velX = facingRight ? 8 : -8;
  }
  
  // Methods
  void update() { ... }  // Update position
  void display() { ... } // Draw projectile
  boolean isOffScreen() { ... }  // Check if off screen
}
```

The Projectile class:
- Represents cupcakes thrown by the player
- Travels in the direction the player is facing
- Drawn as a yellow circle
- Is removed when off-screen or hits an enemy

### Checkpoint

```processing
class Checkpoint {
  float x, y;          // Position
  int size;            // Size
  boolean isActive;    // Is the checkpoint active
  boolean isReached;   // Has the player reached this checkpoint
  float bounceOffset, bounceSpeed, bounceAmount;  // Animation variables
  
  // Methods
  void update() { ... }  // Update animation
  void display() { ... } // Draw checkpoint flag
  boolean collidesWith(Player player) { ... }  // Detect player collision
  void activate(Player player) { ... }  // Mark as reached
}
```

The Checkpoint class:
- Provides save points throughout the level
- Changes color when reached (white to green)
- Allows player to respawn at the last checkpoint reached

## Game States

The game has four distinct states:

```processing
final int GAME_INTRO = 0;    // Introduction screen
final int GAME_PLAY = 1;     // Main gameplay
final int GAME_VICTORY = 2;  // Level complete
final int GAME_OVER = 3;     // Game over
```

These states control what's displayed and updated:
- GAME_INTRO: Shows the title and instructions
- GAME_PLAY: The main game loop, updates all objects
- GAME_VICTORY: Shows a victory message when the player reaches the end
- GAME_OVER: Shows a game over message when the player loses

## Camera System

```processing
// Camera variables
float cameraX = 0;
float cameraY = 0;
float targetOffsetX = 200;  // How far from the left edge the player should be

// Camera update function
void updateCamera() {
  // Calculate target based on player position
  float targetX = player.x - targetOffsetX;
  
  // Keep camera in bounds
  targetX = max(0, targetX);
  targetX = min(targetX, LEVEL_WIDTH - width);
  
  // Smooth movement
  cameraX = lerp(cameraX, targetX, 0.1);
}

// Apply camera transformation
void applyCamera() {
  pushMatrix();
  translate(-cameraX, 0);
}

// Restore original transformation
void restoreCamera() {
  popMatrix();
}
```

The camera system:
- Follows the player horizontally
- Keeps the player offset from the left edge to see more ahead
- Uses smooth interpolation for a polished feel
- Has helper functions to convert between screen and world coordinates

## Collision Detection

The game uses rectangle collision detection for most objects:

```processing
// Example from Enemy class
boolean collidesWith(Player player) {
  return (x < player.x + player.size &&
          x + enemyWidth > player.x &&
          y < player.y + player.size &&
          y + enemyHeight > player.y);
}
```

For projectiles (which are circles), a simplified collision is used:

```processing
// Example from Enemy class
boolean collidesWith(Projectile projectile) {
  return (projectile.x > x &&
          projectile.x < x + enemyWidth &&
          projectile.y > y &&
          projectile.y < y + enemyHeight);
}
```

Platform and ground collision is handled in the Player class update method.

## Keyboard Input

Input handling is separated into its own module:

```processing
// Handle key pressed events
void handleKeyPressed() {
  // Handle game state transitions
  if (gameState == GAME_INTRO && key == ENTER) {
    startGame();
  }
  // ... other state transitions
  
  // Handle gameplay inputs
  if (gameState == GAME_PLAY) {
    if (key == CODED) {
      if (keyCode == LEFT) {
        player.movingLeft = true;
        player.facingRight = false;
      }
      // ... other movement keys
    } else if (key == ' ') {
      // Toss projectile
      if (player.projectilesLeft > 0) {
        projectiles.add(new Projectile(player.x, player.y, player.facingRight));
        player.projectilesLeft--;
      }
    }
  }
}

// Handle key released events
void handleKeyReleased() {
  // Stop movement when keys are released
  if (gameState == GAME_PLAY) {
    if (key == CODED) {
      if (keyCode == LEFT) {
        player.movingLeft = false;
      }
      // ... other movement keys
    }
  }
}
```

This system:
- Handles game state transitions (ENTER key)
- Controls player movement (arrow keys)
- Handles projectile throwing (spacebar)
- Properly manages key release to stop movement

## Display Functions

The display functions are separated into their own file:

```processing
// Display introduction screen
void displayIntro() { ... }

// Display victory screen
void displayVictory() { ... }

// Display game over screen
void displayGameOver() { ... }

// Display controls on game screen
void displayControls() { ... }
```

These functions:
- Show appropriate text and background for each game state
- Display HUD elements during gameplay (lives, cupcakes)
- Show different game over messages based on how the player lost

## World Generation

The world is created in `setup()` and `resetGame()`:

```processing
void setup() {
  size(800, 600);
  
  // Initialize player
  player = new Player(100, GROUND_LEVEL);
  
  // Create enemies
  enemies = new ArrayList<BasicEnemy>();
  enemies.add(new BasicEnemy(400, GROUND_LEVEL));
  // ... more enemies
  
  // Initialize items
  projectiles = new ArrayList<Projectile>();
  powerUps = new ArrayList<PowerUp>();
  // ... add power-ups
  
  // Initialize checkpoints
  checkpoints = new ArrayList<Checkpoint>();
  for (int i = 0; i < checkpointPositions.length; i++) {
    checkpoints.add(new Checkpoint(checkpointPositions[i][0], checkpointPositions[i][1]));
  }
}
```

This approach:
- Creates a level with predefined element positions
- Uses arrays to define multiple instances of platforms, gaps, ladders
- Places enemies and power-ups at strategic locations

## Game Loop

The game loop is managed in the `draw()` function:

```processing
void draw() {
  // Display based on game state
  if (gameState == GAME_INTRO) {
    displayIntro();
  } 
  else if (gameState == GAME_VICTORY) {
    displayVictory();
  }
  else if (gameState == GAME_OVER) {
    displayGameOver();
  }
  else {
    playGame();
  }
}
```

The `playGame()` function:
- Updates camera position
- Draws the level (ground, gaps, platforms, ladders)
- Updates and displays all game objects
- Handles collisions
- Checks victory condition

This creates a complete game loop that:
1. Takes input
2. Updates game state
3. Renders the current frame
4. Repeats

## Conclusion

"Run, Red, Run!" demonstrates several important game development concepts:
- Object-oriented design with inheritance
- State management
- Physics and collision detection
- Camera systems
- User input handling
- Visual feedback
- Game progression (checkpoints)

The code is well-structured with separate files for different components, making it easier to understand and maintain.
