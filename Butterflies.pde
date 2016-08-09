//Kinect               
import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;
Kinect kinect;
ArrayList <SkeletonData> bodies;

//Projection Mapping
//LOBO//import processing.opengl.*;
//LOBO//import codeanticode.glgraphics.*;
import deadpixel.keystone.*;   

//LOBO//GLGraphicsOffScreen offscreenA;
PGraphics offscreenA;

Keystone ks;
CornerPinSurface surfaceA;

//Setup
int nodeCount = 100;
Node[] myNodes = new Node[nodeCount];
Butterfly[] myButterflies = new Butterfly[nodeCount];

Attractor myAttractor;

boolean showRadius = true;
boolean showCenter = false;
boolean showDepth = true;
boolean switchKinect = true;

PImage bee;

void setup() {	
  size(1200, 900, P3D);  
  //bee = loadImage("bee.png");
  
	//Kinect
	if (switchKinect){
  	kinect = new Kinect(this);
    smooth();
    bodies = new ArrayList<SkeletonData>();
	}
	
	//Projection Mapping
  //LOBO//offscreenA = new GLGraphicsOffScreen(this, width-10, height-10);
  offscreenA = createGraphics(10, 10);
  
  ks = new Keystone(this);
  surfaceA = ks.createCornerPinSurface(width, height, 20);    

	for (int i = 0; i < nodeCount; i++){
		myNodes[i] = new Node(random(width),random(height)); 
		myNodes[i].velocity.x = 2;
		myNodes[i].velocity.y = 2; 
		/*myNodes[i].velocity.x = random(-3,3);
		myNodes[i].velocity.y = random(-3,3); */
		myNodes[i].damping = 0; 		
		myButterflies[i] = new Butterfly();
	}

	myAttractor = new Attractor (0,0);

}

void draw() {        
	//Kinect
	if (switchKinect){
		//tracker.track();  
	}
	//noCursor();  

	//Projection Mapping
  PVector mouse = surfaceA.getTransformedMouse();
  offscreenA.beginDraw();
  
	lights();
  background(100); 
  
  
	//Kinect
	if (switchKinect){
		//Show depth image
			if (showDepth){
        image(kinect.GetDepth(), 0, 0, 320, 240);
        image(kinect.GetImage(), 0, 240, 320, 240);
        image(kinect.GetMask(), 0, 480, 320, 240);
        for (int i=0; i<bodies.size (); i++) 
        {
          drawSkeleton(bodies.get(i));
          //drawPosition(bodies.get(i));
        }
				//LOBO//tracker.display();
			}
		//Let's draw the raw location
		//LOBO//PVector v1 = tracker.getPos();
		/*fill(50,100,250,200);
		noStroke();
		ellipse(v1.x,v1.y,20,20);*/
		//Let's draw the "lerped" location
		//LOBO//PVector v2 = tracker.getLerpedPos();
		/*fill(100,250,50,200);
		noStroke();
		ellipse(v2.x,v2.y,20,20);*/                                 
		// Display some info
		//LOBO//int t = tracker.getThreshold();
		fill(0);
		//LOBO//println("threshold: " + t + "    " +  "framerate: " + (int)frameRate);

		//myAttractor.x = Kinect.NUI_SKELETON_POSITION_HAND_RIGHT).x;
		//myAttractor.y = Kinect.NUI_SKELETON_POSITION_HAND_RIGHT).y;
    //myAttractor.x = mouseX;
    //myAttractor.y = mouseY;
    
	} else {
  
		myAttractor.x = mouseX;
		myAttractor.y = mouseY;
	}
	
  //println(myAttractor.x + " " + myAttractor.y);

	for (int i = 0; i<nodeCount; i++){
		myAttractor.attract(myNodes[i]);
		myNodes[i].update();		
		fill(255);
		if (showCenter){ 
			ellipseMode(CENTER);
			ellipse(myNodes[i].x,myNodes[i].y,10,10);
		}
		myButterflies[i].move(int(myNodes[i].x),int(myNodes[i].y)); 		
	}          

	if (showRadius){
		ellipseMode(CENTER);	
		fill(200,80);                 
		if (switchKinect){  		
			ellipse(myAttractor.x, myAttractor.y,5,5);
		} else {      
			ellipse(mouseX, mouseY,5,5);    
		}
		fill(200,80);                 
		if (switchKinect){  
			ellipse(myAttractor.x, myAttractor.y,5,5);  
		} else {
			ellipse(mouseX, mouseY,200,200);
		}
	}

	//Projection Mapping
  offscreenA.endDraw();  
  //background(0);  
  
  //LOBO//surfaceA.render(offscreenA.getTexture());
  surfaceA.render(offscreenA);
  //surfaceA.render(bee);

}


void keyPressed(){
	
  /*
	//Kinect - Change Threshhold with Up/Down Key
	int t = tracker.getThreshold();
  if (key == CODED) {
    if (keyCode == UP) {
      t+=5;
      tracker.setThreshold(t);
    } 
    else if (keyCode == DOWN) {
      t-=5;
      tracker.setThreshold(t);
    }
  }
	*/

  switch(key) {               

	//Show At  traction Radius
  case '1':
		if(showRadius)
			showRadius=false;
		else
		  showRadius=true;
    break;

  case '2':
		if(showCenter)
		  showCenter=false;
		else
		  showCenter=true;
    break;

   //Kinect  - Show Depth Image to adjust Threshhold         
  case '3':
		if(showDepth)
		  showDepth=false;
		else
		  showDepth=true;
    break;
          
 	//Projection Mapping
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped 
    // & moved
    ks.toggleCalibration();
    break;
  case 'a':
    // loads the saved layout
    ks.load();
    break;
  case 's':
    // saves the layout
    ks.save();
    break;
  }	                   
}

void drawPosition(SkeletonData _s) 
{
  noStroke();
  fill(0, 100, 255);
  String s1 = str(_s.dwTrackingID);
  text(s1, _s.position.x*width/2, _s.position.y*height/2);
}

void drawSkeleton(SkeletonData _s) 
{
  myAttractor.x =  _s.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].x*width;
  myAttractor.y = _s.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].y*height;
  println(myAttractor.x + " " + myAttractor.y);
  // Body
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_HEAD, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_CENTER);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_CENTER, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_LEFT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_CENTER, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_CENTER, 
  Kinect.NUI_SKELETON_POSITION_SPINE);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_LEFT, 
  Kinect.NUI_SKELETON_POSITION_SPINE);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT, 
  Kinect.NUI_SKELETON_POSITION_SPINE);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_SPINE, 
  Kinect.NUI_SKELETON_POSITION_HIP_CENTER);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_HIP_CENTER, 
  Kinect.NUI_SKELETON_POSITION_HIP_LEFT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_HIP_CENTER, 
  Kinect.NUI_SKELETON_POSITION_HIP_RIGHT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_HIP_LEFT, 
  Kinect.NUI_SKELETON_POSITION_HIP_RIGHT);

  // Left Arm
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_LEFT, 
  Kinect.NUI_SKELETON_POSITION_ELBOW_LEFT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_ELBOW_LEFT, 
  Kinect.NUI_SKELETON_POSITION_WRIST_LEFT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_WRIST_LEFT, 
  Kinect.NUI_SKELETON_POSITION_HAND_LEFT);

  // Right Arm
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT, 
  Kinect.NUI_SKELETON_POSITION_ELBOW_RIGHT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_ELBOW_RIGHT, 
  Kinect.NUI_SKELETON_POSITION_WRIST_RIGHT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_WRIST_RIGHT, 
  Kinect.NUI_SKELETON_POSITION_HAND_RIGHT);

  // Left Leg
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_HIP_LEFT, 
  Kinect.NUI_SKELETON_POSITION_KNEE_LEFT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_KNEE_LEFT, 
  Kinect.NUI_SKELETON_POSITION_ANKLE_LEFT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_ANKLE_LEFT, 
  Kinect.NUI_SKELETON_POSITION_FOOT_LEFT);

  // Right Leg
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_HIP_RIGHT, 
  Kinect.NUI_SKELETON_POSITION_KNEE_RIGHT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_KNEE_RIGHT, 
  Kinect.NUI_SKELETON_POSITION_ANKLE_RIGHT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_ANKLE_RIGHT, 
  Kinect.NUI_SKELETON_POSITION_FOOT_RIGHT);
}

void DrawBone(SkeletonData _s, int _j1, int _j2) 
{
  noFill();
  stroke(255, 255, 0);
  if (_s.skeletonPositionTrackingState[_j1] != Kinect.NUI_SKELETON_POSITION_NOT_TRACKED &&
    _s.skeletonPositionTrackingState[_j2] != Kinect.NUI_SKELETON_POSITION_NOT_TRACKED) {
    line(_s.skeletonPositions[_j1].x*width, 
    _s.skeletonPositions[_j1].y*height, 
    _s.skeletonPositions[_j2].x*width, 
    _s.skeletonPositions[_j2].y*height);
  }
}

void appearEvent(SkeletonData _s) 
{
  if (_s.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) 
  {
    return;
  }
  synchronized(bodies) {
    bodies.add(_s);
  }
}

void disappearEvent(SkeletonData _s) 
{
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_s.dwTrackingID == bodies.get(i).dwTrackingID) 
      {
        bodies.remove(i);
      }
    }
  }
}

void moveEvent(SkeletonData _b, SkeletonData _a) 
{
  if (_a.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) 
  {
    return;
  }
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_b.dwTrackingID == bodies.get(i).dwTrackingID) 
      {
        bodies.get(i).copy(_a);
        break;
      }
    }
  }
}