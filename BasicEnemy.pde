
class BasicEnemy extends Enemy {
  
  BasicEnemy(float x, float y) {
    super(x, y);
  }
  
  
  void display() {
    
    fill(0, 0, 255);
    rect(x, y, enemyWidth, enemyHeight);
 
    }
    
}
