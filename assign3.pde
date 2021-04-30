final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;

final int GRASS_HEIGHT = 15;
final int START_BUTTON_W = 144;
final int START_BUTTON_H = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;

final int SPACING = 80;
final int SOIL_H_INT = SPACING * 2;
final int SOIL_COL = 8;
final int SOIL_ROW = 24;
final int STONE_COL = 8;
final int STONE_ROW = 8;
final int PLAYER_HEALTH_MAX = 5;

PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage bg, imgPlayerHealth, cabbage, soldier;
PImage groundhogIdle, groundhogDown, groundhogLeft, groundhogRight;
PImage [] soil = new PImage [6];
PImage [] stone = new PImage [2];

float playerHealthX, playerHealthY;
float playerHealth_Int = 2;
float playerHealth_Start = 10;
float playerHealth_Spacing = 20;
float cabbageX, cabbageY;
float soldierX, soldierY;
float soldierSpeed = 2;
float soilX, soilY;
float stoneX, stoneY;
float groundhogX, groundhogY;
float floorSpeed = 80;
float floorRoll = 0;
float actionFrame = 15;
int downMove = 0;
int rightMove = 0;
int leftMove = 0;

boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

// For debug function; DO NOT edit or remove this!
int playerHealth = 0;
float cameraOffsetY = 0;
boolean debugMode = false;

void setup() {
	size(640, 480);
  frameRate(60);

	//game elements
	bg = loadImage("img/bg.jpg");
  imgPlayerHealth = loadImage("img/life.png");
  cabbage = loadImage("img/cabbage.png");
  soldier = loadImage("img/soldier.png");
  
  //game state
	title = loadImage("img/title.jpg");
	gameover = loadImage("img/gameover.jpg");
	startNormal = loadImage("img/startNormal.png");
	startHovered = loadImage("img/startHovered.png");
	restartNormal = loadImage("img/restartNormal.png");
	restartHovered = loadImage("img/restartHovered.png");
  groundhogIdle = loadImage("img/groundhogIdle.png");
  groundhogDown = loadImage("img/groundhogDown.png");
  groundhogLeft = loadImage("img/groundhogLeft.png");
  groundhogRight = loadImage("img/groundhogRight.png");
  
  //soil
  for(int i = 0; i < soil.length; i++){
    soil[i] = loadImage("img/soil" + i + ".png");
  }
  
  //stone
  for(int j = 0; j < stone.length; j++){
    stone[j] = loadImage("img/stone" + (j+1) + ".png");
  }
  
  //player health 
  playerHealth = int(playerHealth_Int);
  constrain(playerHealth,0 ,PLAYER_HEALTH_MAX);
  
  //groundhog
  groundhogX = SPACING * 4;
  groundhogY = SPACING * 1; 
  
  //cabbage random appearance
  cabbageX = SPACING * (floor(random(8))); //80*(0~7)
  cabbageY = SPACING * 2 + SPACING * (floor(random(4)));//80*(0~3)
  
  //soldier random floor appearance
  soldierX = SPACING * (floor(random(8))); 
  soldierY = SPACING * 2 + SPACING * (floor(random(4)));  
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

		if(START_BUTTON_X + START_BUTTON_W > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_H > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(startHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
			}

		}else{

			image(startNormal, START_BUTTON_X, START_BUTTON_Y);

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

    pushMatrix();
    translate(0, floorRoll);

		// Grass
		fill(124, 204, 25);
		noStroke();
		rect(0, 160 - GRASS_HEIGHT, width, GRASS_HEIGHT);
  
		// Soil
    for(int i = 0; i < SOIL_COL; i++){      
        for(int j = 0; j < SOIL_ROW; j++){
          soilX = i * SPACING;
          soilY = SOIL_H_INT + j * SPACING ;
          if( (j/4) < 1){
            image(soil[0], soilX, soilY);
          }else if( (j/4) < 2){
            image(soil[1], soilX, soilY);
          }else if( (j/4) < 3){
            image(soil[2], soilX, soilY);
          }else if( (j/4) < 4){
            image(soil[3], soilX, soilY);
          }else if( (j/4) < 5){
            image(soil[4], soilX, soilY);
          }else{image(soil[5], soilX, soilY);}         
        }
      }
      
     //Stone
     //floor 1-8
     for(int col = 0; col < STONE_COL; col++){
       stoneX = col * SPACING;
       stoneY = SOIL_H_INT + col * SPACING;
       image(stone[0], stoneX, stoneY);
     }
     
     //floor9-16
     for(int row = 0; row < 8; row++){
       if(row == 0||row == 3|| row == 4||row == 7){
         for(int col = 0; col < 2; col++){
             stoneX = SPACING * (col*4 + 1);
             stoneY = SOIL_H_INT + (8+row) * SPACING;
             image(stone[0], stoneX, stoneY);
             image(stone[0], stoneX + SPACING, stoneY);
         }
       }else{
         for(int col = 0; col < 2; col++){
             stoneX = SPACING * (col*4);
             stoneY = SOIL_H_INT + (8+row) * SPACING;
             image(stone[0], stoneX, stoneY);
             image(stone[0], stoneX + 3*SPACING, stoneY);
         }
       }
     }
     
     //floor17-24
       //stone1
       for(int row = 0; row < 8; row++){
         if(row % 3 == 0){
           for(int col = 0; col < 3; col++){
             stoneX = SPACING * (1 + col*3);
             stoneY = SOIL_H_INT + (16+row) * SPACING;
             image(stone[0], stoneX, stoneY);
             image(stone[0], stoneX + SPACING, stoneY);
           }
         }else if(row % 3 == 1){
           for(int col = 0; col < 3; col++){
             stoneX = SPACING * (col*3);
             stoneY = SOIL_H_INT + (16+row) * SPACING;
             image(stone[0], stoneX, stoneY);
             image(stone[0], stoneX + SPACING, stoneY);
           }         
         }else{
           for(int col = 0; col < 3; col++){
             stoneX = SPACING * (col*3);
             stoneY = SOIL_H_INT + (16+row) * SPACING;
             image(stone[0], stoneX, stoneY);
             image(stone[0], stoneX + 2 * SPACING, stoneY);
           }       
         }     
       }
       
       //stone2
       for(int row = 0; row < 8; row++){
         if(row % 3 == 0){
           for(int col = 0; col < 2; col++){
             stoneX = SPACING * (2 + col*3);
             stoneY = SOIL_H_INT + (16+row) * SPACING;
             image(stone[1], stoneX, stoneY);
           }
         }else if(row % 3 == 1){
           for(int col = 0; col < 3; col++){
             stoneX = SPACING * (1 + col*3);
             stoneY = SOIL_H_INT + (16+row) * SPACING;
             image(stone[1], stoneX, stoneY);
           }         
         }else{
           for(int col = 0; col < 3; col++){
             stoneX = SPACING * (col*3);
             stoneY = SOIL_H_INT + (16+row) * SPACING;
             image(stone[1], stoneX, stoneY);
           }       
         }     
       }
    
    //draw cabbage
    image(cabbage, cabbageX, cabbageY);

    // draw soldier & soldier movement
    image(soldier, soldierX, soldierY);
    soldierX += soldierSpeed;
    if(soldierX >= width){
       soldierX = -soldier.width;
    }
    
		// Player movement    
    if (downMove > 0) {
      if (downMove == 1) {
        groundhogY = round(groundhogY + SPACING/actionFrame);
        image(groundhogIdle, groundhogX, groundhogY);
      } else {
        groundhogY = groundhogY + SPACING/actionFrame;
        image(groundhogDown, groundhogX, groundhogY);
      }
      downMove -= 1;
    }else if(leftMove > 0) {
      if (leftMove == 1) {
        groundhogX = round(groundhogX - SPACING/actionFrame);
        image(groundhogIdle, groundhogX, groundhogY);
      } else {
        groundhogX = groundhogX - SPACING/actionFrame;
        image(groundhogLeft, groundhogX, groundhogY);
      }
      leftMove -= 1;
    }else if(rightMove > 0) {
      if (rightMove == 1) {
        groundhogX = round(groundhogX + SPACING/actionFrame);
        image(groundhogIdle, groundhogX, groundhogY);
      } else {
        groundhogX = groundhogX + SPACING/actionFrame;
        image(groundhogRight, groundhogX, groundhogY);
      }
      rightMove -= 1;
    }else if(downMove == 0 && leftMove == 0 && rightMove == 0){
      image(groundhogIdle, groundhogX, groundhogY);
    }
             
    //Player boundary detection    
    if(groundhogX > width - groundhogIdle.width){
      groundhogX = width - groundhogIdle.width;
    }
    
    if(groundhogX < 0){
      groundhogX = 0;
    }
        
    popMatrix();
     
		// Health UI    
    for(int i = 0; i < playerHealth; i++){
      playerHealthX = playerHealth_Start + i * (playerHealth_Spacing + imgPlayerHealth.width);
      playerHealthY = playerHealth_Start;
      image(imgPlayerHealth, playerHealthX, playerHealthY);
    }
    
    //hit detection for cabbage
    if(groundhogX < cabbageX + cabbage.width
       && groundhogX + cabbage.width > cabbageX
       && groundhogY < cabbageY + cabbage.width
       && groundhogY + cabbage.width > cabbageY){
         cabbageX = -cabbage.width;
         cabbageY = -cabbage.width;
         playerHealth++; 
       } 
       
    //hit detection for soldier
    if(groundhogX < soldierX + soldier.width
       && groundhogX + groundhogIdle.width > soldierX
       && groundhogY < soldierY + soldier.width
       && groundhogY + groundhogIdle.width > soldierY){
         groundhogX = SPACING * 4;
         groundhogY = SPACING * 1;
         playerHealth--;
         floorRoll = 0;
       }  
       
    //gameover detection
     if(playerHealth <= 0){gameState = GAME_OVER;}
     
    if(groundhogY >= SPACING * (26-1-4) || groundhogY <= SPACING){
      cameraOffsetY = 0;
    }
    
		break;

		case GAME_OVER: // Gameover Screen
		image(gameover, 0, 0);
		
		if(START_BUTTON_X + START_BUTTON_W > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_H > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
				
        floorRoll = 0;
        //player health initialize
        playerHealth = int(playerHealth_Int);
        
        //groundhog initialize
        groundhogX = SPACING * 4;
        groundhogY = SPACING * 1;  
        
        //cabbage random appearance
        cabbageX = SPACING * (floor(random(8))); //80*(0~7)
        cabbageY = SPACING *2 + SPACING * (floor(random(4)));//80*(0~3)
        
        //soldier random floor appearance
        soldierX = SPACING * (floor(random(8))); 
        soldierY = SPACING * 2 + SPACING * (floor(random(4)));  
			}
		}else{

			image(restartNormal, START_BUTTON_X, START_BUTTON_Y);

		}
		break;
		
	}

    // DO NOT REMOVE OR EDIT THE FOLLOWING 3 LINES
    if (debugMode) {
        popMatrix();
    }
}

void keyPressed(){
    if (downMove > 0 || leftMove > 0 || rightMove > 0) {return;}
    switch(keyCode){
      case DOWN: 
        if(groundhogY < SPACING * 26 - groundhogIdle.width){
          downPressed = true;
          downMove = int(actionFrame);
          if(groundhogY < SPACING * (26-1-4)){
            floorRoll -= floorSpeed;
          }
          
        }
        //downPressed = true;
        //groundhogY += groundhogSpeed;       
      break;
      
      case LEFT:  
        if(groundhogX > 0){
          leftPressed  = true;
          leftMove = int(actionFrame);
        }          
        //leftPressed = true;
        //groundhogX -= groundhogSpeed;          
      break;
        
      case RIGHT:
      if(groundhogX < width){
        rightPressed = true;
        rightMove = int(actionFrame);
      }
        //rightPressed = true;
        //groundhogX += groundhogSpeed;            
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

void keyReleased(){
  
      switch(keyCode){
      case DOWN:
        downPressed = false;
      break;
      
      case LEFT:
        leftPressed = false;
      break;
        
      case RIGHT:
        rightPressed = false;
      break;
    }  
    
}
