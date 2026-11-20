public void CGLine(float x1, float y1, float x2, float y2) {
  // TODO HW1
  // Please paste your code from HW1 CGLine.
  // 統一先四捨五入轉為整數像素座標
  int ix1 = Math.round(x1);
  int ix2 = Math.round(x2);
  int iy1 = Math.round(y1);
  int iy2 = Math.round(y2);
  if (ix1 == ix2 && iy1 == iy2) {
    drawPoint(ix1, iy1, color(0));
    return;
  }
  float dx = Math.abs(ix2 - ix1);
  float dy = Math.abs(iy2 - iy1);
  //判斷x,y誰移動較多
  if (dx >= dy) {

    //先確保 x1 < x2
    if (ix1 > ix2) {

      int tempx = ix1;
      ix1 = ix2;
      ix2 = tempx;
      int tempy = iy1;
      iy1 = iy2;
      iy2 = tempy;
    }
    float mx =(float) (iy2 - iy1) / (ix2 - ix1);

    for (int x = ix1; x <= ix2; x++ ) {
      float y = iy1 + mx*(x - ix1);
      int iy = Math.round(y);
      drawPoint(x, iy, color(0));
    }
  } else if (dy >= dx) {

    //4.逐漸增加y的情況
    if (iy1 > iy2) {

      int tempx = ix1;
      ix1 = ix2;
      ix2 = tempx;
      int tempy = iy1;
      iy1 = iy2;
      iy2 = tempy;
    }
    float my =(float) (ix2 - ix1) / (iy2 - iy1);
    for (int y = iy1; y <= iy2; y++ ) {
      float x = ix1 + my*(y - iy1);
      int ix = Math.round(x);
      drawPoint(ix, y, color(0));
    }
  }
}

public boolean outOfBoundary(float x, float y) {
  if (x < 0 || x >= width || y < 0 || y >= height)
    return true;
  return false;
}

public void drawPoint(float x, float y, color c) {
  int index = (int) y * width + (int) x;
  if (outOfBoundary(x, y))
    return;
  pixels[index] = c;
}

public float distance(Vector3 a, Vector3 b) {
  Vector3 c = a.sub(b);
  return sqrt(Vector3.dot(c, c));
}

boolean pnpoly(float x, float y, Vector3[] vertexes) {
  // TODO HW2
  // You need to check the coordinate p(x,v) if inside the vertices.
  // If yes return true, vice versa.
  int count = 0;
  for (int i = 0; i < vertexes.length; i++) {
    Vector3 A = vertexes[i];
    Vector3 B = vertexes[(i+1) % vertexes.length ];

    if ( (A.y > y) != (B.y > y) ) {
      float intersectX = A.x + ( (y - A.y) / (B.y - A.y) * (B.x - A.x));
      if (intersectX > x) {
        count++;
      }
    }
  }
  if (count % 2 == 0) {
    return false;
  } else {
    return true;
  }
}

public Vector3[] findBoundBox(Vector3[] v) {


  // TODO HW2
  // You need to find the bounding box of the vertices v.
  // r1 -------
  //   |   /\  |
  //   |  /  \ |
  //   | /____\|
  //    ------- r2

  Vector3 recordminV = new Vector3(0);
  Vector3 recordmaxV = new Vector3(999);
  for (int i = 0; i < v.length; i++) {
    if (recordminV.x > v[i].x) {
      recordminV.x = v[i].x;
    }
    if (recordminV.y > v[i].y) {
      recordminV.y = v[i].y;
    }
    if (recordmaxV.x < v[i].x) {
      recordmaxV.x = v[i].x;
    }
    if (recordmaxV.y < v[i].y) {
      recordmaxV.y = v[i].y;
    }
  }
  Vector3[] result = { recordminV, recordmaxV };
  return result;
}

public Vector3[] Sutherland_Hodgman_algorithm(Vector3[] points, Vector3[] boundary) {
  ArrayList<Vector3> input = new ArrayList<Vector3>();
  ArrayList<Vector3> output = new ArrayList<Vector3>();
  for (int i = 0; i < points.length; i += 1) {
    input.add(points[i]);
  }

  // TODO HW2
  // You need to implement the Sutherland Hodgman Algorithm in this section.
  // The function you pass 2 parameter. One is the vertexes of the shape "points".
  // And the other is the vertices of the "boundary".
  // The output is the vertices of the polygon.
  for (int i = 0; i < boundary.length; i++) {
    output = new ArrayList<Vector3>();
    Vector3 edgeA = boundary[i];
    Vector3 edgeB = boundary[(i+1) % boundary.length];
    for (int j = 0; j < input.size(); j++){
       Vector3 S = input.get(j);
       Vector3 E = input.get((j+1) % input.size());
       
       float crossS = ((edgeB.x - edgeA.x) * (S.y - edgeA.y)) - ((edgeB.y - edgeA.y) * (S.x - edgeA.x));
       float crossE = ((edgeB.x - edgeA.x) * (E.y - edgeA.y)) - ((edgeB.y - edgeA.y) * (E.x - edgeA.x));
       
       boolean insideS = (crossS <= 0);
       boolean insideE = (crossE <= 0);
      
       
       if(insideS && insideE){
         output.add(E);
       }
       else if(insideS && !insideE){
         float t = crossS / (crossS - crossE);
         float ix = S.x + t*(E.x - S.x); 
         float iy = S.y + t*(E.y - S.y);
         float iz = S.z + t*(E.z - S.z);
         Vector3 I = new Vector3(ix, iy, iz);
         output.add(I);
       }
       else if(!insideS && !insideE){
         
       }
       else{
         float t = crossS / (crossS - crossE);
         float ix = S.x + t*(E.x - S.x); 
         float iy = S.y + t*(E.y - S.y);
         float iz = S.z + t*(E.z - S.z);
         Vector3 I = new Vector3(ix, iy, iz);
         output.add(I);
         output.add(E);
       }
       
       
    }
    input = output;
    
  }


 

  Vector3[] result = new Vector3[output.size()];
  for (int i = 0; i < result.length; i += 1) {
    result[i] = output.get(i);
  }
  return result;
}
