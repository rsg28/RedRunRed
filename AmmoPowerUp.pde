// Ammo PowerUp class that extends the base PowerUp
class AmmoPowerUp extends PowerUp {
  int extraAmmo = 3;  
  
  AmmoPowerUp(float x, float y) {
    super(x, y);
  }
  
  //Override
  void display() {
    if (!active) return;
    
    // Draw box
    
    pushMatrix();
    translate(x, y + bounceOffset);
    
    fill(100, 100, 80);
    rect(0, 0, 20, 16);
    
    popMatrix();
  }
  
  //Override
  void collect(Player player) {
    if (!active) return;
    
    // Give player extra projectiles
    player.projectilesLeft += extraAmmo;
   // remember to put up a sign saying you have extra ammo here later 
    
   
    super.collect(player);
  }
}
