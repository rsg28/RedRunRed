// NEW FEATURES
// I added a powerup so that the player can have extra lives on the game


// Game constants
final int GRAVITY = 1;
final int GROUND_LEVEL = 500;
final int JUMP_FORCE = -15;

// Game state constants
final int GAME_INTRO = 0;
final int GAME_PLAY = 1;
final int GAME_VICTORY = 2;
final int GAME_OVER = 3;

// Current game state
int gameState = GAME_INTRO;

// Game Variables
Player player;
ArrayList<BasicEnemy> enemies;
ArrayList<Projectile> projectiles;
ArrayList<PowerUp> powerUps;

// Camera variables
float cameraX = 0;
float cameraY = 0;
float targetOffsetX = 200;  // How far from the left edge the player should be

// Gap variables
float gapX = 250;
float gapWidth = 100; 

// Platform variables
float platformX = 450;
float platformY = 300;
float platformWidth = 200;
float platformHeight = 30;

// Ladder variables
float ladderX = 600;
float ladderY = GROUND_LEVEL - 200; 
float ladderWidth = 40;
float ladderHeight = 200; 

void setup() {
  size(800, 600);
  
  // Initialize game objects
  player = new Player(100, GROUND_LEVEL);
  
  // Create a enemies ArrayList
  enemies = new ArrayList<BasicEnemy>();
  
  // Create BasicEnemy objects with explicit positions
  BasicEnemy enemy1 = new BasicEnemy(400, GROUND_LEVEL);
 
  BasicEnemy enemy2 = new BasicEnemy(600, GROUND_LEVEL);

  // Add the enemies to the ArrayList
  enemies.add(enemy1);
  enemies.add(enemy2);

  // Initialize items
  projectiles = new ArrayList<Projectile>();
  powerUps = new ArrayList<PowerUp>();
  powerUps.add(new AmmoPowerUp(platformX + platformWidth/2, platformY - 20));
  
  PFont font = createFont("Arial", 16);
  textFont(font);
  
  }
  

void draw() {
  
  // displays 
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

void playGame() {
  
  // Game background
  background(220);
  
  noStroke();
 
  // gap
  fill(50, 25, 0); // Dark brown
  rect(gapX, GROUND_LEVEL, gapWidth, height - GROUND_LEVEL);
  
  // ground
  fill(100, 200, 100);
  rect(0, GROUND_LEVEL, gapX, height - GROUND_LEVEL); // left
  rect(gapX + gapWidth, GROUND_LEVEL, width - (gapX + gapWidth), height - GROUND_LEVEL); // right
  
  // Draw platform
  rect(platformX, platformY, platformWidth, platformHeight);
  
  // Draw ladder
  fill(120, 80, 40); 
  rect(ladderX, ladderY, ladderWidth, ladderHeight);
  
  // Draw ladder sticks
  stroke(160, 120, 60); 
  strokeWeight(3);
  int spacing = 15;
  for (int y = (int)ladderY + spacing; y < ladderY + ladderHeight; y += spacing) {
    line(ladderX, y, ladderX + ladderWidth, y);
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
      // Lose a life and reset player position
      player.lives--;
      player.x = 100;
      
      // Check if player is out of lives
      if (player.lives <= 0) {
        // Game over
        setGameOver();
      }
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
  
  // Check for victory (player reaches right edge)
  if (player.x >= width - player.size) {
    gameState = GAME_VICTORY;
  }
  
  displayControls();
}

void keyPressed() {
  handleKeyPressed();
}

void keyReleased() {
  handleKeyReleased();
}


  
