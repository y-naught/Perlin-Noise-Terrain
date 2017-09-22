Terrain t;
PImage img;

//create artificial height and width so we can't see the edges after we rotate
int h = 8000;
int w = 5000;

void setup() {
  fullScreen(P3D);
  t = new Terrain(20);
  //stroke(255);
  noStroke();
  fill(0);
  frameRate(24);
  
  //load an image to apply a texture to each triangle
  img = loadImage("TextureBW.jpg");
}

void draw() {
  background(0);
  //light the scene(two point lights to increase luminance / adjust the color
  pointLight(255, 255, 255, 0, 8, height - 781);
  pointLight(255, 225, 225, 0, 8, height - 781);
  directionalLight(100, 255, 255, -1, -0.5, -1);
  
  //translate to the center of the screen so the object rotates about the center
  translate(width/ 2, height / 2);
  rotateX(PI / 3.0);

  //translate the grid back so it draws in the center of the screen
  translate(-w / 2, -1080 * 3, 307);
  
  //run the methods every frame
  t.update();
  t.display(img);
}


class Terrain {
  float numX;
  float numY;
  float d;
  float sclZ;
  float movement = 0.0;
  
  //create a depth array to map to for consistency in the terrain
  float [][] zvalue;
  
  // the constructor takes a density variable
  Terrain(float density) {
    numX = w / density;
    numY = h / density;
    d = density;
  }

  //updates the movement of the perlin noise on the depth array
  void update() {
    float offY = movement;
    zvalue = new float[int(numX)][int(numY)];
    
    //run the y on the outside so it maps the values horizontally
    for (int y = 0; y < numY; y++) {
      float offX = 0;
      for (int x = 0; x < numX; x++) {
        zvalue[x][y] = map(noise(offX, offY), 0, 1, -50, 100);
        offX += 0.12;
      }
      offY += 0.12;
    }
    movement += -0.12;
  }

  //draw a triangle strip for each set of rows
  //apply the texture at the beginning of each shape
  void display(PImage img) {
    for (int x = 0; x < w - d; x+=d) {
      beginShape(TRIANGLE_STRIP);
      texture(img);
      for (int y = 0; y < h; y+=d) {
        vertex(x, y, zvalue[int(x/d)][int(y/d)], 0, 0);
        vertex(x + d, y, zvalue[int(x/d) + 1][int(y/d)], 100, 100);
      }
      endShape();
    }
  }
}