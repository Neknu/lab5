float d = 40; // vertex diameter
int count = 0;
int MAX = 100;
int id;
vert[] verts = new vert[MAX];
int[][] matrix = new int[MAX][MAX];
int prev_click = -1;
int INF = 1000000000;

//BFS
int[] bfsQ; //array with vertex indexes in BFS order (BFS queue)
boolean bfs = false; //is bfs running now?
int bfsCount;  //total number of vertexes in bfs
int bfsCur; //number of  vertexes with already changed color
int del = 700; //delay in milliseconds

//DJKSTRA
boolean djk = false;
int[] distance;

void setup() {
  size(1280, 720);
}


int check(float x, float y) {
  boolean b = true;
  if(x-d < 0 || x+d > width || y-d < 0 || y+d > height)
    b = false;
  for (int i = 0; i < count; i ++) {
    if (dist(x, y, verts[i].x, verts[i].y) < d/2)
      return i;
    if (dist(x, y, verts[i].x, verts[i].y) < 2*d)
      b = false;
  }
  if (b == true) return -1;
  return -2;
}


void DoBFS(){
    if (bfsCur == bfsCount) {
    if(bfs == true)
    if(bfsCount == count)
      print("Граф зв'язний!\n");
    else
      print("Граф незв'язний!\n");
    bfs = false;
    }
    
  if (bfs) {
    verts[bfsQ[bfsCur]].col = color(255, 0, 0);
    if (bfsCur != 0)
      delay(del);
    bfsCur++;
  }

}

void DoDjkstra() {
  for(int i = 0; i < count; i++)
    verts[i].id = distance[i];
}

void ToDraw() {
  background(160);

  for (int i = 0; i < count; i++) {
    for (int j = i + 1; j < count; j++) {
      if (matrix[i][j] > 0)  {
        line(verts[i].x, verts[i].y, verts[j].x, verts[j].y);
        fill(255);
        text(matrix[i][j], (verts[i].x + verts[j].x) / 2, (verts[i].y + verts[j].y) / 2); 
      }
    }
  }
  for (int i = 0; i < count; i++) {
    verts[i].draw_one();
  }
}

void draw() {
  DoBFS();
  ToDraw();
}

int minDist(int curr, boolean visited[]) {
  int len = INF;
  int res = -1;
  for(int i = 0; i < count; i++)
  if(matrix[curr][i] > 0 && !visited[i] && matrix[curr][i] < len) {
    len = matrix[curr][i];
    res = i;
  }
  return res;
}

int[] Djkstra(int start) {
  boolean[] done = new boolean[MAX];
  boolean[] visited = new boolean[MAX];
  int[] queue = new int[MAX];
  int[] distance = new int[MAX];
  for(int i = 0; i < count; i++)
    distance[i] = INF;
  queue[0] = start;
  distance[start] = 0;
  int head = 0;
  int tail = 1;
  while(head != tail) {
    int curr = queue[head];
    if(done[curr]) {
      head++;
      continue;
    }
    done[curr] = true;
    head++;
    for(int i = 0; i < count; i++)
      visited[i] = false;
    int next = minDist(curr,visited);
    while(next != -1) {
      visited[next] = true;
      if(!done[next] && distance[curr] + matrix[curr][next] < distance[next]) {
        queue[tail] = next;
        distance[next] = distance[curr] + matrix[curr][next];
        tail++;
      }
      next = minDist(curr,visited);
    }
  }
  for(int i = 0; i < count; i++)
    print(distance[i] + " ");
  return distance;
}


int[] BFS(int start) {
  boolean[] visited = new boolean[MAX];
  int[] queue = new int[MAX];
  queue[0] = start;
  int head = 0;
  int tail = 1;
  while (head != tail) {
    int curr = queue[head];
    visited[curr] = true;
    head++;
    bfsCount++;
    for (int i = 0; i < count; i++) {
      if (matrix[curr][i] > 0 && !visited[i]) {
        queue[tail] = i;
        tail++;
      }
    }
  }
  return queue;
}


void mousePressed() {
  float x = mouseX;
  float y = mouseY;
  
  // stop djkstra
    if(djk) 
  for(int i = 0; i < count; i++)
    verts[i].id = i+1;
  djk = false;
  
  if (mouseButton == LEFT) {
    int check = check(x, y); // returns number of vertex, if we click on it or -1, if we can add new one
    if (check == -1) {
      verts[count] = new vert(x, y, color(0, 100, 100), count + 1);
      count++;
    }
    if (check >= 0) {
      if (prev_click == -1)
        prev_click = check;
      else {
        if (prev_click != check) {
          int rand = int(random(9) + 1);
          matrix[check][prev_click] = rand;
          matrix[prev_click][check] = rand;
          prev_click = -1;
        }
      }
    } else 
    prev_click = -1;
  }
  if (mouseButton == RIGHT) {
    if(key == '1' || key == '2') {
    if (check(x, y) >= 0)
    {
      bfsCount = 0;
      bfsCur = 0;
      bfsQ = BFS(check(x, y));
      bfs = true;
    }
  }
  if(key == '3') {
    if (check(x, y) >= 0)
    {
      Djkstra(check(x,y));
      distance = Djkstra(check(x,y));
      DoDjkstra();
      djk = true;
    }
  }
   //clear highlighting for multiple visualisations 
      for (int i = 0; i < count; i++)
        verts[i].col = color(0, 100, 100);
  }
}
