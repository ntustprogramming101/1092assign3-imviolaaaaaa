PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage bg, cabbage, soldier, life;
PImage soil8x24, soil0, soil10, soil1, soil2, soil3, soil4, soil5;
PImage stone1, stone2;
PImage groundhogIdle, groundhogDown, groundhogLeft, groundhogRight;

final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;

final int GRASS_HEIGHT = 15;
final int BUTTON_W = startNormal.width; //144
final int BUTTON_H = startNormal.height; //60
final int BUTTON_X = 248;
final int BUTTON_Y = 360;

final int SPACING = soil0.width; //80

final int LIFE_H = 10;
final int LIFE_START = 10;
final int LIFE_SPACING = 20;
final int LIFE_MAX = 5;

final int SOLDIER_START_Y = 160;
final int SOLDIER_SIZE = soldier.width;
final int CABBAGE_SIZE = cabbage.width;
final int CABBAGE_START_Y = 160;
final int GROUNDHOG_SIZE = groundhogIdle.width;

boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

float groundhogX, groundhogY;
float groundhogSpeed = SPACING;
float cabbageX, cabbageY;
float soldierX, soldierY;
float soldierSpeed = 2;
float lifeX, lifeY;
float lifeNumber = 2;

// For debug function; DO NOT edit or remove this!
int playerHealth = 0;
float cameraOffsetY = 0;
boolean debugMode = false;

void setup() {
	size(640, 480);
	// Enter your setup code here (please put loadImage() here or your game will lag like crazy)
	bg = loadImage("img/bg.jpg");
  life = loadImage("img/life.png");
  soldier = loadImage("img/soldier.png");
  cabbage = loadImage("img/cabbage.png");
  
  groundhogIdle = loadImage("img/groundhogIdle.png");
  groundhogDown = loadImage("img/groundhogDown.png");
  groundhogLeft = loadImage("img/groundhogLeft.png");
  groundhogRight = loadImage("img/groundhogRight.png");
  
	title = loadImage("img/title.jpg");
	gameover = loadImage("img/gameover.jpg");
	startNormal = loadImage("img/startNormal.png");
	startHovered = loadImage("img/startHovered.png");
	restartNormal = loadImage("img/restartNormal.png");
	restartHovered = loadImage("img/restartHovered.png");
  
	soil8x24 = loadImage("img/soil8x24.png");
  soil0 = loadImage("img/soil0.png");
  soil1 = loadImage("img/soil1.png");
  soil2 = loadImage("img/soil2.png");
  soil3 = loadImage("img/soil3.png");
  soil4 = loadImage("img/soil4.png");
  soil5 = loadImage("img/soil5.png");
  
  stone1 = loadImage("img/stone1.png");
  stone2 = loadImage("img/stone2.png");
  
  //soldier random floor appearance
  soldierX = SPACING * (floor(random(8))); 
  soldierY = SOLDIER_START_Y + SPACING * (floor(random(4)));
  
  //cabbage random appearance
  cabbageX = SPACING * (floor(random(8))); //80*(0~7)
  cabbageY = CABBAGE_START_Y + SPACING * (floor(random(4)));//80*(0~3)
  
  //groundhog
  groundhogX = SPACING * 4;
  groundhogY = SPACING * 1;  
}

void draw() {
    /* ------ Debug Function ------ 

      Please DO NOT edit the code here.
      It's for reviewing other requirements when you fail to complete the camera moving requirement.

    */
    if (debugMode) {
      pushMatrix();
      translate(0, cameraOffsetY);
    }
    /* ------ End of Debug Function ------ */

    
	switch (gameState) {

		case GAME_START: // Start Screen
		image(title, 0, 0);

		if(BUTTON_X + BUTTON_W > mouseX
	    && BUTTON_X < mouseX
	    && BUTTON_Y + BUTTON_H > mouseY
	    && BUTTON_Y < mouseY) {

			image(startHovered, BUTTON_X, BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
			}

		}else{

			image(startNormal, BUTTON_X, BUTTON_Y);

		}
		break;

		case GAME_RUN: // In-Game

		// Background
		image(bg, 0, 0);

		// Sun
	    stroke(255,255,0);
	    strokeWeight(5);
	    fill(253,184,19);
	    ellipse(590,50,120,120);

		// Grass
		fill(124, 204, 25);
		noStroke();
		rect(0, 160 - GRASS_HEIGHT, width, GRASS_HEIGHT);

		// Soil - REPLACE THIS PART WITH YOUR LOOP CODE!
		image(soil8x24, 0, 160);

		// Player

		// Health UI
    constrain(lifeNumber, 0, LIFE_MAX);
    for(int i = 0; i < lifeNumber; i++){
      lifeX = LIFE_START + (life.width + LIFE_SPACING)*i;
      lifeY = LIFE_H;
      image(life, lifeX, lifeY);      
    }
    
    //gameover detection
       if(lifeNumber <= 0){
         gameState = GAME_OVER;
       }    
       
    //hit detection for cabbage
    if(groundhogX < cabbageX + CABBAGE_SIZE
         && groundhogX + GROUNDHOG_SIZE > cabbageX
         && groundhogY < cabbageY + CABBAGE_SIZE
         && groundhogY + GROUNDHOG_SIZE > cabbageY){
           cabbageX = -CABBAGE_SIZE;
           cabbageY = -CABBAGE_SIZE;
           lifeNumber++; 
         }    
         
     //draw cabbage
     image(cabbage, cabbageX, cabbageY);
      
      // draw soldier & soldier movement
      image(soldier, soldierX, soldierY);
      soldierX += soldierSpeed;
      if(soldierX >= width){
        soldierX = -SOLDIER_SIZE;
      }
      
      //hit detection for soldier
      if(groundhogX < soldierX + SOLDIER_SIZE
         && groundhogX + GROUNDHOG_SIZE > soldierX
         && groundhogY < soldierY + SOLDIER_SIZE
         && groundhogY + GROUNDHOG_SIZE > soldierY){
           groundhogX = SPACING * 4;
           groundhogY = SPACING * 1;
           lifeNumber--;
         }      
         
      // draw groundhog     
      if(downPressed){
        image(groundhogDown, groundhogX, groundhogY);
      }else if(rightPressed){
        image(groundhogRight, groundhogX, groundhogY);
      }else if(leftPressed){
        image(groundhogLeft, groundhogX, groundhogY);
      }else{image(groundhogIdle, groundhogX, groundhogY);
      }     
      
		break;

		case GAME_OVER: // Gameover Screen
		image(gameover, 0, 0);
		
		if(BUTTON_X + BUTTON_W > mouseX
	    && BUTTON_X < mouseX
	    && BUTTON_Y + BUTTON_H > mouseY
	    && BUTTON_Y < mouseY) {

			image(restartHovered, BUTTON_X, BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
				// Remember to initialize the game here!
        lifeNumber = 2;
             
        //soldier random floor appearance
        soldierX = SPACING * (floor(random(8))); 
        soldierY = SOLDIER_START_Y + SPACING * (floor(random(4)));
        
        //cabbage random appearance
        cabbageX = SPACING * (floor(random(8))); //80*(0~7)
        cabbageY = CABBAGE_START_Y + SPACING * (floor(random(4)));//80*(0~3)
			}
		}else{

			image(restartNormal, BUTTON_X, BUTTON_Y);

		}
		break;
		
	}

    // DO NOT REMOVE OR EDIT THE FOLLOWING 3 LINES
    if (debugMode) {
        popMatrix();
    }
}

void keyPressed(){
	// Add your moving input code here
    
    switch(keyCode){
      case DOWN:      
        downPressed = true;
        groundhogY += groundhogSpeed;

        if(groundhogY > height - groundhogSpeed){
          groundhogY = height - groundhogSpeed; 
        }
      break;
      
      case LEFT:        
        leftPressed = true;
        groundhogX -= groundhogSpeed;
        
        if(groundhogX < 0){
          groundhogX = 0; 
        }     
      break;
        
      case RIGHT:
        rightPressed = true;
        groundhogX += groundhogSpeed; 
        
        if(groundhogX > width - groundhogSpeed){
           groundhogX = width - groundhogSpeed; 
        }        
      break;
        
    }  
	// DO NOT REMOVE OR EDIT THE FOLLOWING SWITCH/CASES
    switch(key){
      case 'w':
      debugMode = true;
      cameraOffsetY += 25;
      break;

      case 's':
      debugMode = true;
      cameraOffsetY -= 25;
      break;

      case 'a':
      if(playerHealth > 0) playerHealth --;
      break;

      case 'd':
      if(playerHealth < 5) playerHealth ++;
      break;
    }
}
