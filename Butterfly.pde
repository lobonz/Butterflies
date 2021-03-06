class Butterfly{
	float posX;
	float posY;
	int speed;               
	int ang; 
	int flapSpeed = 20;
	int flap = 1;  
	int w = 20;
	
	Butterfly(){
		this.posX = width/2+random(0,100);
		this.posY = height/2+random(0,100);
		this.speed = 1;		
		this.ang = 0;
	}                

	void move(int moveX, int moveY){
		pushMatrix();
    posX = sin(radians(ang))*60+moveX;
    posY = cos(radians(ang))*30+moveY;
		ang++;
		translate(posX,posY);    

		noStroke();
		lights();
		fill(200,250);
		sphere(3);
		popMatrix();
                       
		flap = flap + flapSpeed;

		pushMatrix();
		translate(posX,posY,-w/2);    
		rotateX(radians(90));
		rotateY(sin(radians(flap)));
//		rect(0,0, w, w);
		fill(255,230);
		ellipseMode(CORNER);
		ellipse(0,0, w, w);
		popMatrix(); 

		pushMatrix();
		translate(posX,posY,-w/2);    
		rotateX(radians(90));    
		rotateY(sin(radians(flap))* -1);
		fill(255,230);
		ellipseMode(CORNER);
  	ellipse(-w,0, w, w);
		popMatrix(); 
		 		        
	}
}