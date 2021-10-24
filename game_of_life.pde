int rows = 32*2; int cols = 18*2;
int cellSize;
int fps;
int frame = 0;
boolean paused = true;

boolean cells[][] = new boolean[rows][cols];

void setup() {
  size(1600,900);
  background(255);
  frameRate(30); 
  
  cellSize = width / rows;
  fps = 30;
}

void drawGrid() {
  for (int r = 0; r < rows; r++) {
    stroke(0);
    // System.out.println(width + " " + height);
    line(r*cellSize, 0, r*cellSize, -height);
    for (int c = 0; c < cols; c++) {
      if (cells[r][c] == true) {
        fill(color(0, 0, 200));
      } else {
        fill(color(200, 0, 0));
      }
      rect(r*cellSize, c*cellSize, cellSize, cellSize);
    }
  }
}    

boolean validCell(int row, int col) {
  return row >= 0 && row < rows && col >= 0 && col < cols;
}

int numLivingNeighbors(int row, int col) {
  int aliveCount = 0;
  int adjacentDelta[][] = {{1, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, -1}, {-1, 0}, {-1, 1}, {0, 1}};
  
  for (int[] delta : adjacentDelta) {
    int neighborRow = row + delta[0];
    int neighborCol = col + delta[1];
    
    if (validCell(neighborRow, neighborCol)) {
      if (cells[neighborRow][neighborCol] == true) {
        aliveCount += 1;
      }
    }
  }
  
  return aliveCount;
}

void advanceGameState() {
  boolean newCells[][] = new boolean[rows][cols];
  
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      int livingNeighbors = numLivingNeighbors(r, c);
      boolean alive = cells[r][c];
      if (alive && (livingNeighbors == 2 || livingNeighbors == 3)) {
        newCells[r][c] = true;
      } 
      if (!alive && livingNeighbors == 3) {
        newCells[r][c] = true;
      }
    }
  }
  
  cells = newCells;
}

void draw() {
  drawGrid();
  if (keyPressed) {
    if (key == ' ') {
      paused = !paused;
    }
  }
 
  if (!paused) {
    // Every half second...
    if (frame % (fps / 2) == 0) {
       advanceGameState(); 
    }
    
    frame += 1;
  }
}

void mouseClicked() {
  if (paused) {
    int r = floor(mouseX / cellSize);
    int c = floor(mouseY / cellSize);
    
    cells[r][c] = !cells[r][c];
  }
}
