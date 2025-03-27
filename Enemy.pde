// Base Enemy class
class Enemy {
  float x, y;
  float velX = 0;
  int enemyWidth = 30;  
  int enemyHeight = 40; 
  
  Enemy(float x, float y) {
    this.x = x;
    this.y = y - enemyHeight;  // reflects upside down
  }
  
  void update() {
    // different for every subclass hehe
  }
  
  void display() {
    // placeholder
    fill(255, 0, 0);
    rect(x, y, enemyWidth, enemyHeight);
  }
  
  
  boolean collidesWith(Player player) {
    // rectangle collision detection
    return (x < player.x + player.size &&
            x + enemyWidth > player.x &&
            y < player.y + player.size &&
            y + enemyHeight > player.y);
  }
  
  boolean collidesWith(Projectile projectile) {
    // circle-rectangle collision detection
    return (projectile.x > x &&
            projectile.x < x + enemyWidth &&
            projectile.y > y &&
            projectile.y < y + enemyHeight);
  }
}
