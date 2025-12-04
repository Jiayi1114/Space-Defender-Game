// 主程序文件
float playerX, playerY;
float playerSize = 30;
ArrayList<PVector> enemies;
ArrayList<PVector> bullets;
ArrayList<PVector> stars;
int score = 0;
int lives = 3;
int gameState = 0; // 0=菜单, 1=游戏中, 2=游戏结束

void setup() {
  size(800, 600);
  playerX = width/2;
  playerY = height - 80;
  enemies = new ArrayList<PVector>();
  bullets = new ArrayList<PVector>();
  stars = new ArrayList<PVector>();
  
  // 创建星星
  for (int i = 0; i < 100; i++) {
    stars.add(new PVector(random(width), random(height), random(1, 3)));
  }
}

void draw() {
  background(0);
  
  // 绘制星星
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
  // 开始按钮
  fill(0, 255, 100, 150);
  ellipse(width/2, 350, 80, 80);
  fill(0, 200, 80);
  triangle(width/2-15, 340, width/2-15, 360, width/2+20, 350);
}

void updateGame() {
  // 更新玩家位置
  playerX = mouseX;
  playerX = constrain(playerX, playerSize, width - playerSize);
  
  // 生成敌人
  if (frameCount % 60 == 0) {
    enemies.add(new PVector(random(50, width-50), -30));
  }
  
  // 更新子弹
  for (int i = bullets.size()-1; i >= 0; i--) {
    PVector b = bullets.get(i);
    b.y -= 8;
    if (b.y < 0) {
      bullets.remove(i);
    }
  }
  
  // 更新敌人
  for (int i = enemies.size()-1; i >= 0; i--) {
    PVector e = enemies.get(i);
    e.y += 2;
    
    // 检测子弹碰撞
    for (int j = bullets.size()-1; j >= 0; j--) {
      PVector b = bullets.get(j);
      if (dist(e.x, e.y, b.x, b.y) < 25) {
        enemies.remove(i);
        bullets.remove(j);
        score += 100;
        break;
      }
    }
    
    // 检测玩家碰撞
    if (dist(e.x, e.y, playerX, playerY) < 30) {
      enemies.remove(i);
      lives--;
      if (lives <= 0) {
        gameState = 2;
      }
    }
    
    // 移除超出屏幕的敌人
    if (e.y > height + 50) {
      enemies.remove(i);
    }
  }
}

void drawGame() {
  // 绘制玩家
  fill(100, 150, 255);
  triangle(playerX - playerSize, playerY + playerSize/2, 
           playerX, playerY - playerSize, 
           playerX + playerSize, playerY + playerSize/2);
  
  // 绘制敌人
  fill(255, 50, 50);
  for (PVector e : enemies) {
    ellipse(e.x, e.y, 25, 25);
  }
  
  // 绘制子弹
  fill(255, 255, 0);
  for (PVector b : bullets) {
    rect(b.x-2, b.y-10, 4, 15);
  }
  
  // 显示生命值
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
    // 重新开始
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
