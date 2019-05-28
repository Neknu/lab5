float d = 40; // vertex diameter
int count = 0;
int MAX = 10000;
int id;
vert[] verts = new vert[MAX];
int[][] matrix = new int[MAX][MAX];
int prev_click = -1;
int INF = 1000000000;
boolean[] visited = new boolean[MAX];
int del = 1000; //delay in milliseconds
int bold = 5; //for trees

//BFS
int[] bfsQ; //array with vertex indexes in BFS order (BFS queue)
boolean bfs = false; //is bfs running now?
int bfsCount;  //total number of vertexes in bfs
int bfsCur; //number of  vertexes with already changed color

//DJKSTRA
boolean djk = false;
int[] distance;

// second part with classes and lists
  Graph g = new Graph(MAX); 

//Bone tree
int boneCount;
int boneCurr;
boolean bn = false;
edge[] bone;

//KRUSKAL
boolean krskl = false;
edge[] kruskal;
int kruskalCount;
int kruskalCurr;
int[] treeNum;
  
void setup() {
  size(640, 360);
  print("This is hint of program working:\n");
  print("LeftClick to add vertex\n");
  print("Two LeftClicks to add edge\n");
  print("To visualize algorithms, select, at first, number(at keyboard):\n");
  print("1. - is the graph connected?\n");
  print("2. - BFS\n");
  print("3. - Dijkstra\n");
  print("4. - Topological Sort\n");
  print("5. - Bone Tree\n");
  print("6. - Kruskal\n");
  print("And to start visualisation RIGHTclick at vertex\n");
  print("Press Enter - for demo graph\n");
  print("Press CENTER mousebutton - for starting benchmark(also select algorithm with keyboard number)\n");
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


void createRandomGraph_benchmark(int N) {
  if(N<10) createRandomGraph(N);
  else {
  for(int i = 0; i < count; i ++){
    visited[i] = false;
    for(int j = 0; j < count; j++)
      matrix[i][j] = 0;
  }
    g = new Graph(MAX);
      count = N;
      g.count = count;
    int i = 0;
    int v1, v2;
    while(i < 3*N) {
      v1 = int(random(count));
      v2 = int(random(count));
      if(matrix[v1][v2] == 0) {
        int rand = int(random(9) + 1);
        matrix[v1][v2] = rand;
        matrix[v2][v1] = rand;
        g.addEdge(v1,v2);
        i++;
      }
    }
  }
}


void createRandomGraph(int N) {
  for(int i = 0; i < count; i ++){
    visited[i] = false;
    for(int j = 0; j < count; j++)
      matrix[i][j] = 0;
  }
    g = new Graph(MAX);
    g.count = 0;
    count = 0;
  if(N > 10) 
    print("too many vertices");
  else {
    float x, y;
    while(count < N) {
      x = random(width);
      y = random(height);
      int curr = check(x,y);
      if(curr == -1){
        verts[count] = new vert(x, y, color(0, 100, 100), count + 1);
      g.verts = verts;
      count++;
      g.count = count;
      }    
    }
    int i = 0;
    int v1, v2;
    while(i < N) {
      v1 = int(random(count));
      v2 = int(random(count));
      if(matrix[v1][v2] == 0) {
        int rand = int(random(9) + 1);
        matrix[v1][v2] = rand;
        matrix[v2][v1] = rand;
        g.addEdge(v1,v2);
        i++;
      }
    }
  }
}


void DoBFS(){
    if (bfsCur == bfsCount) {
    boolean zviaz = true;
    if(bfs == true) {
      for(int i = 0; i < count; i++)
        if(visited[i] == false)
        zviaz = false;
    if(zviaz == true)
      print("Граф зв'язний!\n");
    else
      print("Граф незв'язний!\n");
    bfs = false;
    }
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


void DoBone(){
   if(bn) {
    if(boneCurr == boneCount){
      bn = false;
      delay(4*del);
    }
    else {
      verts[bone[boneCurr].v1].col = color(0,0,255);
      verts[bone[boneCurr].v2].col = color(0,0,255);
      }
          print("\n");
      delay(del);
    boneCurr++;
  }
}

void changeBone() {
          if(bn) {
  for(int i = 0; i < boneCurr; i++){
      bone[i].draw_one();
  }
}
}
void DoKruskal(){
  if(krskl) {
    if(kruskalCurr == kruskalCount){
      krskl = false;
      delay(4*del);
    }
    else {
      changeTreeNum(treeNum[kruskal[kruskalCurr].v1], treeNum[kruskal[kruskalCurr].v2]);
      }
          print("\n");
      delay(del);
    kruskalCurr++;
  }
  
}

void changeKruskal() {
          if(krskl) {
  for(int i = 0; i < kruskalCurr; i++){
      kruskal[i].draw_one();
  }
      for(int j = 0; j < count; j++)
        verts[j].col = color(255 - 50*treeNum[j], 50*treeNum[j], 100 + 25*treeNum[j]);
  }
}

void ToDraw() {
  background(160);

  changeKruskal();
  changeBone();
  
  
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
  DoKruskal();
  DoBone();
  ToDraw();
}

int[] BFS(int start) {
  int[] queue = new int[MAX];
  for(int i = 0; i < count; i++)
    visited[i] = false;
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
        visited[i] = true;
        tail++;
      }
    }
  }
  return queue;
}

// class graph, list edges
int[] BFS_list(int start) {
  int[] queue = new int[MAX];
  for(int i = 0; i < count; i++)
    visited[i] = false;
  queue[0] = start;
  int head = 0;
  int tail = 1;
  while (head != tail) {
    int curr = queue[head];
    visited[curr] = true;
    head++;
    bfsCount++;
    int i;
    Iterator<Integer> it = g.adj[curr].iterator(); 
    while (it.hasNext()) {
      i = it.next();
      if (!visited[i]) {
        queue[tail] = i;
        visited[i] = true;
        tail++;
      }
    }
  }
  return queue;
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
  int[] queue = new int[MAX*2];
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

edge[] boneTree(int start) {
  edge[] edges = new edge[MAX*MAX];
    int[] queue = new int[MAX];
  for(int i = 0; i < count; i++)
    visited[i] = false;
  boneCount = 0;
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
        edges[boneCount] = new edge(matrix[curr][i], curr, i, bold);
        boneCount++;
        visited[i] = true;
        tail++;
      }
    }
  }
  return edges;
}

edge[] boneTree_list(int start) {
  edge[] edges = new edge[MAX*MAX];
    int[] queue = new int[MAX];
  for(int i = 0; i < count; i++)
    visited[i] = false;
  boneCount = 0;
  queue[0] = start;
  int head = 0;
  int tail = 1;
  while (head != tail) {
    int curr = queue[head];
    visited[curr] = true;
    head++;
    bfsCount++;
    int i;
    Iterator<Integer> it = g.adj[curr].iterator(); 
    while (it.hasNext()) {
      i = it.next();
      if (!visited[i]) {
        queue[tail] = i;
        edges[boneCount] = new edge(matrix[curr][i], curr, i, bold);
        boneCount++;
        visited[i] = true;
        tail++;
      }
    }
  }
  return edges;
}


 void bubbleSort(edge arr[], int n) 
    {  
        for (int i = 0; i < n; i++) 
            for (int j = 0; j < n-i-1; j++) 
                if (arr[j].weight > arr[j+1].weight) 
                { 
                    // swap arr[j+1] and arr[i] 
                    edge temp = arr[j]; 
                    arr[j] = arr[j+1]; 
                    arr[j+1] = temp; 
                } 
    } 

void changeTreeNum(int one, int two) {
  for(int i = 0; i < count; i++)
    if(treeNum[i] == two)
      treeNum[i] = one;
}


edge[] Kruskal() {
  edge[] edges = new edge[MAX*MAX];
  edge[] result = new edge[MAX*MAX];
  kruskalCount = 0;
  int k = 0;
  for(int i = 0; i < count; i++)
    for(int j = i + 1; j < count; j++) 
    if(matrix[i][j] > 0) {
      edges[k] = new edge(matrix[i][j], i, j, bold);
      k++;
    }
    bubbleSort(edges, k);
    treeNum = new int[MAX];
    for(int i = 0; i < count; i++)
      treeNum[i] = i;
    for(int i = 0; i < k; i++) {
      if(treeNum[edges[i].v1] != treeNum[edges[i].v2]) {
        
        changeTreeNum(treeNum[edges[i].v1], treeNum[edges[i].v2]);
        result[kruskalCount] = edges[i];
        kruskalCount++;
      }
    }
    for(int i = 0; i < count; i++)
    treeNum[i] = i;
    return result;
}

void keyPressed() {
  if(keyCode == ENTER)
    createRandomGraph(int(random(5) + 5));
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
      g.verts = verts;
      count++;
      g.count = count;
    }
    if (check >= 0) {
      if (prev_click == -1)
        prev_click = check;
      else {
        if (prev_click != check) {
          int rand = int(random(9) + 1);
          matrix[check][prev_click] = rand;
          matrix[prev_click][check] = rand;
          g.addEdge(prev_click, check); // one way edge
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
      //bfsQ = BFS_list(check(x, y)); // here oriented graph
      bfs = true;
    }
  }
  if(key == '3') {
    if (check(x, y) >= 0)
    {
      distance = Djkstra(check(x,y)); //here only matrix(weight)
      DoDjkstra();
      djk = true;
    }
  }
  if(key == '4') {
    if (check(x, y) >= 0)
    {
      g.topologicalSort(); //here only oriented
    }
  }
  if(key == '5') {
    if (check(x, y) >= 0)
    {
      bone = boneTree(check(x,y));
      //bone = boneTree_list(check(x,y));// here oriented graph
      bn = true;
      boneCurr = 0;
    }
  }
  if(key == '6') {
    if (check(x, y) >= 0)
    {
      kruskal = Kruskal(); //here only matrix(weight)
      krskl = true;
      kruskalCurr = 0;
    }
  }
   //clear highlighting for multiple visualisations 
      for (int i = 0; i < count; i++)
        verts[i].col = color(0, 100, 100);
  }
  if (mouseButton == CENTER) {
    benchmark();
  }
}

//without visualisation
void benchmark() {
  noLoop();
  int t1 = millis();
  createRandomGraph_benchmark(MAX);
  if(key == '1' || key == '2'){
    print("BFS BENCHMARK\n");
    BFS(1);
  }
  if(key == '3'){
    print("Dijkstra BENCHMARK\n");
    Djkstra(5);
  }
  if(key == '4'){
    print("TopologicalSort BENCHMARK\n");
    createRandomGraph_benchmark(MAX / 10); // because recursive algorithm
    g.topologicalSort();
  }
  if(key == '5'){
    print("BoneTree BENCHMARK\n");
    boneTree(1);
  }
  if(key == '6'){
    print("Kruskal BENCHMARK\n");
    Kruskal();
  }
  int t2 = millis();
  int res_time = t2-t1;
  print("it took me ", res_time," millisec", "\n");
  createRandomGraph(5); // just to continue program with random graph
  loop();
}
