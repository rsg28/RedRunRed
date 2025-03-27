// NEW FEATURES
// I added a powerup so that the player can have extra lives on the game
// I added a camera system that follows the player
// I added checkpoints so the player respawns at the last checkpoint on death
// I added sprite animations for the player character

// Asset management
boolean assetsLoaded = false;
PImage[] playerAssets = new PImage[6]; // Array to hold all player assets

// Game constants
final int GRAVITY = 1;
final int GROUND_LEVEL = 500;
final int JUMP_FORCE = -15;
final int LEVEL_WIDTH = 2400;  // The total world width

// Game state constants
final int GAME_INTRO = 0;
final int GAME_PLAY = 1;
final int GAME_VICTORY = 2;
final int GAME_OVER = 3;

// Current game state
int gameState = GAME_INTRO;

// Camera variables
float cameraX = 0;
float cameraY = 0;
float targetOffsetX = 200;  // How far from the left edge the player should be

// Game Variables
Player player;
ArrayList<BasicEnemy> enemies;
ArrayList<Projectile> projectiles;
ArrayList<PowerUp> powerUps;

// Checkpoint variables
ArrayList<Checkpoint> checkpoints;
Checkpoint currentCheckpoint = null;

// Checkpoint positions - add more as needed
float[][] checkpointPositions = {
  {450, GROUND_LEVEL},    // Near first platform
  {1000, GROUND_LEVEL},   // Middle of level
  {1800, 250},            // On high platform
  {2200, GROUND_LEVEL}    // Near end of level
};

// Gap variables
float gapX = 250;
float gapWidth = 100; 

// Platform variables
float platformX = 450;
float platformY = 300;
float platformWidth = 200;
float platformHeight = 30;

// Multiple platforms in expanded world
float[][] additionalPlatforms = {
  {800, 400, 150, 30},
  {1100, 300, 200, 30},
  {1500, 350, 180, 30},
  {1800, 250, 250, 30},
  {2100, 350, 200, 30}
};

// Multiple gaps in expanded world
float[][] additionalGaps = {
  {700, 120},
  {1000, 150},
  {1400, 100},
  {1700, 180},
  {2000, 140}
};

// Ladder variables
float ladderX = 600;
float ladderY = GROUND_LEVEL - 200; 
float ladderWidth = 40;
float ladderHeight = 200; 

// Additional ladders
float[][] additionalLadders = {
  {1200, GROUND_LEVEL - 300, 40, 300},
  {1900, GROUND_LEVEL - 250, 40, 250}
};

// Preload assets function
void preload() {
  // Create the assets directory if it doesn't exist
  File assetsDir = new File(dataPath("assets"));
  if (!assetsDir.exists()) {
    assetsDir.mkdir();
  }
  
  try {
    // Load all player assets
    playerAssets[0] = loadImage("assets/Standing.png");
    playerAssets[1] = loadImage("assets/Walk.png");
    playerAssets[2] = loadImage("assets/Walk2.png");
    playerAssets[3] = loadImage("assets/Jump.png");
    playerAssets[4] = loadImage("assets/Toss.png");
    playerAssets[5] = loadImage("assets/Hit.png");
    
    // Set the flag indicating all assets are loaded
    assetsLoaded = true;
  } catch (Exception e) {
    println("Error loading assets: " + e.getMessage());
    assetsLoaded = false;
  }
}

void setup() {
  size(800, 600);
  
  // Load assets first
  preload();
  
  // Initialize game objects
  player = new Player(100, GROUND_LEVEL);
  
  // Add a check for assets
  if (!assetsLoaded) {
    println("Warning: Some assets failed to load. Using fallback graphics.");
  }
  
  // Create a enemies ArrayList
  enemies = new ArrayList<BasicEnemy>();
  
  // Create enemies across the expanded world
  enemies.add(new BasicEnemy(400, GROUND_LEVEL));
  enemies.add(new BasicEnemy(600, GROUND_LEVEL));
  enemies.add(new BasicEnemy(900, GROUND_LEVEL));
  enemies.add(new BasicEnemy(1300, GROUND_LEVEL));
  enemies.add(new BasicEnemy(1150, 300 - 40)); // enemy on platform
  enemies.add(new BasicEnemy(1600, GROUND_LEVEL));
  enemies.add(new BasicEnemy(1900, 250 - 40)); // enemy on platform
  enemies.add(new BasicEnemy(2200, GROUND_LEVEL));

  // Initialize items
  projectiles = new ArrayList<Projectile>();
  
  // Create power-ups across the expanded world
  powerUps = new ArrayList<PowerUp>();
  powerUps.add(new AmmoPowerUp(platformX + platformWidth/2, platformY - 20));
  powerUps.add(new AmmoPowerUp(1150, 300 - 20));
  powerUps.add(new AmmoPowerUp(1850, 250 - 20));
  powerUps.add(new AmmoPowerUp(2150, 350 - 20));
  
  // Initialize checkpoints
  checkpoints = new ArrayList<Checkpoint>();
  for (int i = 0; i < checkpointPositions.length; i++) {
    checkpoints.add(new Checkpoint(checkpointPositions[i][0], checkpointPositions[i][1]));
  }
  
  PFont font = createFont("Arial", 16);
  textFont(font);
}

void draw() {
  // Display asset error if assets failed to load
  if (!assetsLoaded && gameState == GAME_INTRO) {
    displayAssetError();
    return;
  }
  
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

void displayAssetError() {
  background(0);
  fill(255, 0, 0);
  textSize(24);
  textAlign(CENTER, CENTER);
  text("ERROR: Could not load game assets.", width/2, height/2 - 40);
  text("Make sure the assets folder exists and contains:", width/2, height/2);
  text("Standing.png, Walk.png, Walk2.png, Jump.png, Toss.png, Hit.png", width/2, height/2 + 40);
  
  textSize(16);
  text("Press ENTER to continue with simplified graphics", width/2, height/2 + 100);
}

void playGame() {
  // Game background
  background(220);
  
  // Update camera position first
  updateCamera();
  
  // Apply camera transformation - everything drawn after this will be affected by camera
  applyCamera();
  
  noStroke();
 
  // Draw the main gap
  fill(50, 25, 0); // Dark brown
  rect(gapX, GROUND_LEVEL, gapWidth, height - GROUND_LEVEL);
  
  // Draw additional gaps
  for (int i = 0; i < additionalGaps.length; i++) {
    rect(additionalGaps[i][0], GROUND_LEVEL, additionalGaps[i][1], height - GROUND_LEVEL);
  }
  
  // Draw ground
  fill(100, 200, 100);
  rect(0, GROUND_LEVEL, gapX, height - GROUND_LEVEL); // left of first gap
  
  // Draw ground between gaps
  float lastGapEnd = gapX + gapWidth;
  for (int i = 0; i < additionalGaps.length; i++) {
    float gapStart = additionalGaps[i][0];
    rect(lastGapEnd, GROUND_LEVEL, gapStart - lastGapEnd, height - GROUND_LEVEL);
    lastGapEnd = gapStart + additionalGaps[i][1];
  }
  
  // Draw ground after the last gap to the end of the level
  rect(lastGapEnd, GROUND_LEVEL, LEVEL_WIDTH - lastGapEnd, height - GROUND_LEVEL);
  
  // Draw main platform
  fill(150, 150, 150);
  rect(platformX, platformY, platformWidth, platformHeight);
  
  // Draw additional platforms
  for (int i = 0; i < additionalPlatforms.length; i++) {
    rect(additionalPlatforms[i][0], additionalPlatforms[i][1], 
         additionalPlatforms[i][2], additionalPlatforms[i][3]);
  }
  
  // Draw main ladder
  fill(120, 80, 40); 
  rect(ladderX, ladderY, ladderWidth, ladderHeight);
  
  // Draw ladder rungs
  stroke(160, 120, 60); 
  strokeWeight(3);
  int spacing = 15;
  for (int y = (int)ladderY + spacing; y < ladderY + ladderHeight; y += spacing) {
    line(ladderX, y, ladderX + ladderWidth, y);
  }
  
  // Draw additional ladders
  for (int i = 0; i < additionalLadders.length; i++) {
    // Draw ladder base
    fill(120, 80, 40);
    rect(additionalLadders[i][0], additionalLadders[i][1], 
         additionalLadders[i][2], additionalLadders[i][3]);
    
    // Draw ladder rungs
    for (int y = (int)additionalLadders[i][1] + spacing; 
         y < additionalLadders[i][1] + additionalLadders[i][3]; 
         y += spacing) {
      line(additionalLadders[i][0], y, 
           additionalLadders[i][0] + additionalLadders[i][2], y);
    }
  }

  // Update and display checkpoints
  for (Checkpoint checkpoint : checkpoints) {
    checkpoint.update();
    checkpoint.display();
    
    // Check collision with player
    if (checkpoint.collidesWith(player)) {
      checkpoint.activate(player);
      currentCheckpoint = checkpoint;
    }
  }

  // Update and display power-ups
  for (int i = powerUps.size() - 1; i >= 0; i--) {
    PowerUp powerUp = powerUps.get(i);
    powerUp.update();
    powerUp.display();
    
    // Check collision with player
    if (powerUp.collidesWith(player)) {
      powerUp.collect(player);
    }
  }
  
  // Update and display game objects
  player.update();
  player.display();
  
  //Update and display enemies
  for (int i = enemies.size() - 1; i >= 0; i--) {
    Enemy enemy = enemies.get(i);
    enemy.update();
    enemy.display();
    
    // Check collision with player
    if (enemy.collidesWith(player)) {
      player.getHit(); // Trigger hit animation
      player.loseLife();
    }
    
    // Check collision with projectiles
    for (int j = projectiles.size() - 1; j >= 0; j--) {
      Projectile projectile = projectiles.get(j);
      if (enemy.collidesWith(projectile)) {
        enemies.remove(i);
        projectiles.remove(j);
        break;
      }
    }
  }
  
  // Update and display projectiles
  for (int i = projectiles.size() - 1; i >= 0; i--) {
    Projectile projectile = projectiles.get(i);
    projectile.update();
    projectile.display();
    
    // Remove projectiles that are off-screen
    if (projectile.isOffScreen()) {
      projectiles.remove(i);
    }
  }
  
  // Restore original transformation
  restoreCamera();
  
  // Draw HUD (not affected by camera)
  displayControls();
  
  // Check for victory (player reaches right edge)
  float levelEndX = LEVEL_WIDTH - 100; // Set this to your actual level endpoint
  if (player.x >= levelEndX) {
    gameState = GAME_VICTORY;
  }
}

// Function to update the camera position
void updateCamera() {
  // Calculate target camera position (keeping player at targetOffsetX)
  float targetX = player.x - targetOffsetX;
  
  // Constrain camera so it doesn't show past the left edge of the level
  targetX = max(0, targetX);
  
  // Constrain camera so it doesn't show past the right edge of the level
  targetX = min(targetX, LEVEL_WIDTH - width);
  
  // Smooth camera movement (lerp = linear interpolation)
  cameraX = lerp(cameraX, targetX, 0.1);
}

// Apply camera transformation
void applyCamera() {
  pushMatrix();
  translate(-cameraX, 0);
}

// Restore transformation after drawing game objects
void restoreCamera() {
  popMatrix();
}

// Helper function to convert screen coordinates to world coordinates
PVector screenToWorld(float screenX, float screenY) {
  return new PVector(screenX + cameraX, screenY);
}

// Helper function to convert world coordinates to screen coordinates
PVector worldToScreen(float worldX, float worldY) {
  return new PVector(worldX - cameraX, worldY);
}

void keyPressed() {
  handleKeyPressed();
}

void keyReleased() {
  handleKeyReleased();
}

void resetGame() {
  gameState = GAME_PLAY;
  player = new Player(100, GROUND_LEVEL);
  player.lives = 3;
  player.projectilesLeft = 10;
  
  // Reset camera position
  cameraX = 0;
  
  // Create a completely new enemies ArrayList
  enemies = new ArrayList<BasicEnemy>();
  
  // Create enemies across the expanded world
  enemies.add(new BasicEnemy(400, GROUND_LEVEL));
  enemies.add(new BasicEnemy(600, GROUND_LEVEL));
  enemies.add(new BasicEnemy(900, GROUND_LEVEL));
  enemies.add(new BasicEnemy(1300, GROUND_LEVEL));
  enemies.add(new BasicEnemy(1150, 300 - 40)); // enemy on platform
  enemies.add(new BasicEnemy(1600, GROUND_LEVEL));
  enemies.add(new BasicEnemy(1900, 250 - 40)); // enemy on platform
  enemies.add(new BasicEnemy(2200, GROUND_LEVEL));

  // Initialize items
  projectiles = new ArrayList<Projectile>();
  
  // Create power-ups across the expanded world
  powerUps = new ArrayList<PowerUp>();
  powerUps.add(new AmmoPowerUp(platformX + platformWidth/2, platformY - 20));
  powerUps.add(new AmmoPowerUp(1150, 300 - 20));
  powerUps.add(new AmmoPowerUp(1850, 250 - 20));
  powerUps.add(new AmmoPowerUp(2150, 350 - 20));
  
  // Reset checkpoints
  checkpoints = new ArrayList<Checkpoint>();
  for (int i = 0; i < checkpointPositions.length; i++) {
    checkpoints.add(new Checkpoint(checkpointPositions[i][0], checkpointPositions[i][1]));
  }
  currentCheckpoint = null;
}

// Start a new game
void startGame() {
  gameState = GAME_PLAY;
  resetGame();
}

// Update the game state for game over
void setGameOver() {
  gameState = GAME_OVER;
}