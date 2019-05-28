class vert {
  float x;
  float y;
  color col;
  int id;


  vert(float xx, float yy, color c, int number) {
    x = xx;
    y = yy;
    col = c;
    id = number;
  }
  
  void draw_one() {
    fill(col);
    ellipse(x, y, d, d);
    fill(255);
    textSize(d/2);
    text(id,x-d/8,y+d/8);
  }
}
