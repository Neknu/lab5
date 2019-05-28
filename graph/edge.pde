class edge{
  int weight;
  int v1;
  int v2;
  int bold;
  
  edge(int w, int first, int second, int b) {
    weight = w;
    v1 = first;
    v2 = second;
    bold = b;
  }
  void draw_one() {
    strokeWeight(bold);
    line(verts[v1].x, verts[v1].y, verts[v2].x, verts[v2].y);
    strokeWeight(1);
  }
}
