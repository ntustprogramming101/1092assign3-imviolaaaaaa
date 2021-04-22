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
PImage bg, imgPlayerHealth;
//PImage groundhogIdle, groundhogDown, groundhogLeft, groundhogRight;
PImage [] soil = new PImage [6];
PImage [] stone = new PImage [2];

float playerHealthX, playerHealthY;
float playerHealth_Int = 2;
float playerHealth_Start = 10;
float playerHealth_Spacing = 20;

float soilX, soilY;
float stoneX, stoneY;
float groundhogX, groundhogY;
float groundhogSpeed = SPACING;
//int GROUNDHOG_SIZE = groundhogIdle.width;

//boolean downPressed = false;
//boolean leftPressed = false;
//boolean rightPressed = false;

// For debug function; DO NOT edit or remove this!
int playerHealth = 0;
float cameraOffsetY = 0;
boolean debugMode = false;

void setup() {
	size(640, 480);

	//game elements
	bg = loadImage("img/bg.jpg");
  imgPlayerHealth = loadImage("img/life.png");
  
  //game state
	title = loadImage("img/title.jpg");
	gameover = loadImage("img/gameover.jpg");
	startNormal = loadImage("img/startNormal.png");
	startHovered = loadImage("img/startHovered.png");
	restartNormal = loadImage("img/restartNormal.png");
	restartHovered = loadImage("img/restartHovered.png");
  //groundhogIdle = loadImage("img/groundhogIdle.png");
  //groundhogDown = loadImage("img/groundhogDown.png");
  //groundhogLeft = loadImage("img/groundhogLeft.png");
  //groundhogRight = loadImage("img/groundhogRight.png");
  
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
    //
    if(soilY >= height - SPACING*4){
      soilY = height;
    }
		// Player
      //if(downPressed){
      //  image(groundhogDown, groundhogX, groundhogY);
      //}else if(rightPressed){
      //  image(groundhogRight, groundhogX, groundhogY);
      //}else if(leftPressed){
      //  image(groundhogLeft, groundhogX, groundhogY);
      //}else{image(groundhogIdle, groundhogX, groundhogY);
      //}   
      
		// Health UI    
    for(int i = 0; i < playerHealth; i++){
      playerHealthX = playerHealth_Start + i * (playerHealth_Spacing + imgPlayerHealth.width);
      playerHealthY = playerHealth_Start;
      image(imgPlayerHealth, playerHealthX, playerHealthY);
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
				
        //player health initialize
        playerHealth = int(playerHealth_Int);
        constrain(playerHealth,0 ,PLAYER_HEALTH_MAX);
        
        //groundhog initialize
        groundhogX = SPACING * 4;
        groundhogY = SPACING * 1;  
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

    //switch(keyCode){
    //  case DOWN:      
    //    downPressed = true;
    //    groundhogY += groundhogSpeed;

    //    if(groundhogY > height - groundhogSpeed){
    //      groundhogY = height - groundhogSpeed; 
    //    }
    //  break;
      
    //  case LEFT:        
    //    leftPressed = true;
    //    groundhogX -= groundhogSpeed;
        
    //    if(groundhogX < 0){
    //      groundhogX = 0; 
    //    }     
    //  break;
        
    //  case RIGHT:
    //    rightPressed = true;
    //    groundhogX += groundhogSpeed; 
        
    //    if(groundhogX > width - groundhogSpeed){
    //       groundhogX = width - groundhogSpeed; 
    //    }        
    //  break;        
    //}  
    
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

//void keyReleased(){
  
//      switch(keyCode){
//      case DOWN:
//        downPressed = false;
//      break;
      
//      case LEFT:
//        leftPressed = false;
//      break;
        
//      case RIGHT:
//        rightPressed = false;
//      break;
//    }  
    
//}
