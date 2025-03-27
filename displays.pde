
// Display introduction screen
void displayIntro() {
  background(50, 100, 200);
  
  // Title
  fill(255);
  textSize(48);
  textAlign(CENTER);
  text("Run, Red, Run!", width/2, height/4);
  
  textSize(40);
  text("(The Cupcakes Are Getting Cold)", width/2, height/3);
  
  // Game instructions
  textSize(20);
  text(
    "Help Little Red deliver her magical healing cupcakes to Granny! \n\n" +
    "CONTROLS:\n" +
    "Arrow keys: movement \n" +
    "Spacebar: Toss cupcake\n\n" +
    "You only have 10 cupcakes \n" +
    "don't toss them all!", width/2, height/2 - 50);
  
  // prompt
  textSize(24);
  fill(255, 0, 0);
  text("Press ENTER to start", width/2, height - 100);
}

// Display victory screen
void displayVictory() {
  background(0, 255, 0);
  fill(0);
  textSize(48);
  textAlign(CENTER, CENTER);
  text("LEVEL COMPLETE!", width/2, height/2 - 20);
  
  textSize(24);
  text("Press ENTER to continue", width/2, height/2 + 50);
}

// Display game over screen
void displayGameOver() {
  background(255, 0, 0);
  fill(255);
  textSize(48);
  textAlign(CENTER, CENTER);
  
  //  different messages based on why game ended
  if (player.lives <= 0) {
    text("GAME OVER", width/2, height/2);
    textSize(24);
    text("You ran out of lives!", width/2, height/2 + 40);
    
  } else if (player.projectilesLeft <= 0) {
    text("OUT OF CUPCAKES", width/2, height/2 - 20);
    textSize(24);
    text("You ran out of cupcakes!", width/2, height/2 + 35);
  }
  
  textSize(24);
  text("Press ENTER to try again", width/2, height/2 + 80);
}

void displayControls() {
  // Display lives as text - uses screen coordinates (not affected by camera)
  fill(255, 0, 0);
  textSize(18);
  textAlign(LEFT);
  text("Lives: " + player.lives, 30, 50);
  
  // Display projectiles counter
  fill(255, 255, 0);
  textSize(18);
  textAlign(LEFT);
  text("Cupcakes: " + player.projectilesLeft + "/10", 30, 80);
}