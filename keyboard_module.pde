// Keyboard module for handling key inputs

// Handle key pressed events
void handleKeyPressed() {
  // Handle game state transitions first
  if (gameState == GAME_INTRO && (key == ENTER || key == RETURN)) {
    startGame();
    return;
  } else if (gameState == GAME_VICTORY && (key == ENTER || key == RETURN)) {
    resetGame();
    return;
  } else if (gameState == GAME_OVER && (key == ENTER || key == RETURN)) {
    resetGame();
    return;
  }

  // Only process gameplay inputs if in GAME_PLAY state
  if (gameState == GAME_PLAY) {
    if (key == CODED) {
      if (keyCode == LEFT) {
        player.movingLeft = true;
        player.facingRight = false;
      } else if (keyCode == RIGHT) {
        player.movingRight = true;
        player.facingRight = true;
      } else if (keyCode == UP) {
        if (player.isNearLadder) {
          // If near ladder, start climbing up
          player.isClimbing = true;
          player.movingUp = true;
          player.movingDown = false;
        } else if (player.isOnGround()) {
          // Otherwise jump if on ground
          player.jump();
        }
      } else if (keyCode == DOWN) {
        if (player.isNearLadder) {
          // If near ladder, start climbing down
          player.isClimbing = true;
          player.movingDown = true;
          player.movingUp = false;
          
          // Force a small initial downward movement to start climbing
          if (player.y < ladderY) {
            player.y = ladderY;
          }
        }
      }
    } else if (key == ' ') {
      // Toss projectile only if player has projectiles left
      if (player.projectilesLeft > 0) {
        projectiles.add(new Projectile(player.x, player.y, player.facingRight));
        player.projectilesLeft--;
        
        // Check if player is out of projectiles
        if (player.projectilesLeft <= 0) {
          setGameOver();
        }
      }
    }
  }
}

// Handle key released events
void handleKeyReleased() {
  // Only process gameplay inputs if in GAME_PLAY state
  if (gameState == GAME_PLAY) {
    if (key == CODED) {
      if (keyCode == LEFT) {
        player.movingLeft = false;
      } else if (keyCode == RIGHT) {
        player.movingRight = false;
      } else if (keyCode == UP) {
        player.movingUp = false;
        // Allow player to get off ladder when releasing up
        if (!player.movingDown) {
          player.isClimbing = false;
        }
      } else if (keyCode == DOWN) {
        player.movingDown = false;
        // Allow player to get off ladder when releasing down
        if (!player.movingUp) {
          player.isClimbing = false;
        }
      }
    }
  }
}
