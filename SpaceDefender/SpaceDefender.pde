float playerX, playerY;
float playerSize = 30;
ArrayList<PVector> enemies;
ArrayList<PVector> bullets;
ArrayList<PVector> stars;
int score = 0;
int lives = 3;
int gameState = 0; // 0=menu, 1=playing, 2=ending

void setup() {
  size(800, 600);
  playerX = width/2;
  playerY = height - 80;
  enemies = new ArrayList<PVector>();
  bullets = new ArrayList<PVector>();
  stars = new ArrayList<PVector>();
  
  // creat star
  for (int i = 0; i < 100; i++) {
    stars.add(new PVector(random(width), random(height), random(1, 3)));
  }
}

void draw() {
  background(0);
  
  // draw star
  for (PVector star : stars) {
    fill(200);
    ellipse(star.x, star.y, star.z, star.z);
  }
  
  if (gameState == 0) {
    drawMenu();
  } else if (gameState == 1) {
    updateGame();
    drawGame();
  } else if (gameState == 2) {
    drawGameOver();
  }
}

void drawMenu() {
  // star button
  fill(0, 255, 100, 150);
  ellipse(width/2, 350, 80, 80);
  fill(0, 200, 80);
  triangle(width/2-15, 340, width/2-15, 360, width/2+20, 350);
}

void updateGame() {
  // update player position
  playerX = mouseX;
  playerX = constrain(playerX, playerSize, width - playerSize);
  
  // enemy
  if (frameCount % 60 == 0) {
    enemies.add(new PVector(random(50, width-50), -30));
  }
  
  // update bullet
  for (int i = bullets.size()-1; i >= 0; i--) {
    PVector b = bullets.get(i);
    b.y -= 8;
    if (b.y < 0) {
      bullets.remove(i);
    }
  }
  
  // update enemy
  for (int i = enemies.size()-1; i >= 0; i--) {
    PVector e = enemies.get(i);
    e.y += 2;
    
    // check bullet collision
    for (int j = bullets.size()-1; j >= 0; j--) {
      PVector b = bullets.get(j);
      if (dist(e.x, e.y, b.x, b.y) < 25) {
        enemies.remove(i);
        bullets.remove(j);
        score += 100;
        break;
      }
    }
    
    // check player collision
    if (dist(e.x, e.y, playerX, playerY) < 30) {
      enemies.remove(i);
      lives--;
      if (lives <= 0) {
        gameState = 2;
      }
    }
    
    // remove enemy outside screen
    if (e.y > height + 50) {
      enemies.remove(i);
    }
  }
}

void drawGame() {
  // draw player
  fill(100, 150, 255);
  triangle(playerX - playerSize, playerY + playerSize/2, 
           playerX, playerY - playerSize, 
           playerX + playerSize, playerY + playerSize/2);
  
  // draw enemy
  fill(255, 50, 50);
  for (PVector e : enemies) {
    ellipse(e.x, e.y, 25, 25);
  }
  
  // draw bullet
  fill(255, 255, 0);
  for (PVector b : bullets) {
    rect(b.x-2, b.y-10, 4, 15);
  }
  
  // life
  for (int i = 0; i < lives; i++) {
    drawHeart(30 + i * 40, 30);
  }
}

void drawGameOver() {
  fill(255, 0, 0, 100);
  ellipse(width/2, height/2, 300, 300);
  fill(0, 255, 200, 150);
  ellipse(width/2, height/2 + 150, 80, 80);
}

void drawHeart(float x, float y) {
  fill(255, 100, 100);
  beginShape();
  vertex(x, y);
  bezierVertex(x - 10, y - 15, x - 25, y - 5, x, y + 15);
  bezierVertex(x + 25, y - 5, x + 10, y - 15, x, y);
  endShape(CLOSE);
}

void mousePressed() {
  if (gameState == 0 && dist(mouseX, mouseY, width/2, 350) < 40) {
    gameState = 1;
  } else if (gameState == 1) {
    bullets.add(new PVector(playerX, playerY - 40));
  } else if (gameState == 2 && dist(mouseX, mouseY, width/2, height/2 + 150) < 40) {
    // restart
    enemies.clear();
    bullets.clear();
    score = 0;
    lives = 3;
    gameState = 1;
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    enemies.clear();
    bullets.clear();
    score = 0;
    lives = 3;
    gameState = 1;
  }
}
