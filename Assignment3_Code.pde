import java.util.Random; 

// Data Structure - Grid For Holding Cells
ArrayList< ArrayList<Cell>> cells;

// Adjustable Parameters:
// Cell Size
int CELL_SIZE = 15;
// Percentage Chance For Another Tunnel
float TUNNEL_P = 0.7;
// Percentage Chance Room Is Big (Versus Small)
float BIG_P = 0.75;
// Percentage Chance Room Is Deep Water ( Versus Cave or Shallow Water )
float DEEP_P = 0.3;
// Percentage Chance Room Is Shallow Water ( Versus Cave or Deep Water )
float SHALLOW_P = 0.2;

// Random Coral Size For Coral Reef
float coralSize; 

/**
 * Sets Up & Generates Map
 */
void setup() {
  // Set Up Canvas
  size(640, 480);
  // Set up "cells" array list
  cells = new ArrayList< ArrayList<Cell>>();
  for (int i = 0; i < (640/CELL_SIZE); i++ ) {
    cells.add( new ArrayList<Cell>() );
    for (int j = 0; j < (480/CELL_SIZE); j++ ) {
      cells.get(i).add( new Cell( i*CELL_SIZE, j*CELL_SIZE ));
      cells.get(i).get(j).setType(0);
    } 
  } 
  
  // x is 0
  // y is halfway down the map
  // direction is 3, east
  // steps taken are 0
  cells.get(0).get((480/CELL_SIZE)/2).setType(1.1);
  generateMap(0,(480/CELL_SIZE)/2,3,0);
  Random rand = new Random();
  coralSize = rand.nextFloat();
      
}  

/**
 * Draws Items To Canvas
 */
void draw() {
  drawMap();
}  

/**
 * Draws Map
 */
void drawMap() {
  for (int i = 0; i < (640/CELL_SIZE); i++ ) {
    for (int j = 0; j < (480/CELL_SIZE); j++ ) {
      cells.get(i).get(j).fillCell();
    } 
  }
}  


/**
 * Method For Generating The Map. NOTE: I am using a shape grammer so the "Placement Algorithm" &
 * "Connection Algorithm" are the same.
 */
// direction 1 = west, direction 2 = north, direction 3 = east, direction 4 = south 
void generateMap(int x, int y, int direction, float steps ) {
    
  // Random number between 0 and 1.
  // Determines whether the next cell is a walkway or not. 
  Random rand = new Random();
  float p2 = rand.nextFloat();
  
  // Next Randome number between 0 and 1.
  // If the next cell isn't a walkway, is it a room?
  float p3 = rand.nextFloat();
  
  // If percentage is within range to make valid path.
  if ( TUNNEL_P > p2 ) {
    
    // Check if path is physically possible:
    if ( !isValidPath(x,y,direction) ) {
        fail(x, y);
        return;
     // If it is, make path.   
     }  else {
       // If your direction is west:
       if (direction == 1 ) {
         // Make the next cell a walkway
         cells.get(x - 1).get(y).setType(1.1);
         // Call the next cell recursively
         generateMap(x - 1, y, direction, steps + 1);
       // If your direction is north:  
       } else if(direction == 2) {
         // Make the next cell a walkway
         cells.get(x).get(y - 1).setType(1.2);
         // Call the next cell recursively
         generateMap(x, y - 1, direction, steps + 1);
       // If your direction is east:  
       } else if (direction == 3 ) {
         // Make the next cell a walkway
         cells.get(x + 1).get(y).setType(1.1);
         // Call the next cell recursively
         generateMap(x + 1, y, direction, steps + 1);
       // If your direction is south:  
       } else if (direction == 4) {
         // Make the next cell a walkway
         cells.get(x).get(y + 1).setType(1.2);
         // Call the next cell recursively
         generateMap(x, y + 1, direction, steps + 1);
       } else {
         fail(x,y);
       }  
     }   

  } else if (BIG_P > p3) {
   
    if ( createValidBigRoom(x,y,direction) )  {
      
      int[] next = getAllWalkways(x, y, direction);
      if ( next == null ) {
        return;
      } 
      
      if ( next[0] < 0 || next[0] >= 640/CELL_SIZE || next[1] < 0 || next[1] >= 480/CELL_SIZE ) {
        // nothing
      } else if ( cells.get(next[0]).get(next[1]).getType() != 0 ) {
        // nothing
      } else {
        int nextx = next[0];
        int nexty = next[1];
        int nextD = next[2];
        if ( nextD == 1 || nextD == 3 ) {
          cells.get(nextx).get(nexty).setType(1.1);
        } else {
          cells.get(nextx).get(nexty).setType(1.2);
        }
        generateMap(nextx, nexty, nextD, 0);
      }  
      
      if ( next[3] < 0 || next[3] >= 640/CELL_SIZE || next[4] < 0 || next[4] >= 480/CELL_SIZE ) {
        // nothing
      } else if ( cells.get(next[3]).get(next[4]).getType() != 0 ) {
        // nothing 
      } else {
        int nextx = next[3];
        int nexty = next[4];
        int nextD = next[5];
        if ( nextD == 1 || nextD == 3 ) {
          cells.get(nextx).get(nexty).setType(1.1);
        } else {
          cells.get(nextx).get(nexty).setType(1.2);
        }
        generateMap(nextx, nexty, nextD, 0);
      }  
      
      if ( next[6] < 0 || next[6] >= 640/CELL_SIZE || next[7] < 0 || next[7] >= 480/CELL_SIZE ) {
        // nothing
      } else if ( cells.get(next[6]).get(next[7]).getType() != 0 ) {
        // nothing   
      } else {
        int nextx = next[6];
        int nexty = next[7];
        int nextD = next[8];
        if ( nextD == 1 || nextD == 3 ) {
          cells.get(nextx).get(nexty).setType(1.1);
        } else {
          cells.get(nextx).get(nexty).setType(1.2);
        }
        generateMap(nextx, nexty, nextD, 0);
      }  
      
      
      
    }  else {
      // Valid big room failed.
      fail(x, y);
      return;
    }  
    return;
  // Else, if percentage is within range to make a valid small room.
  } else {
    
    // If valid small room is made:
    if ( createValidSmallRoom(x,y,direction) )  {
      
      // Get a direction to leave room.
      int newDirection = ( direction + 2 ) % 4 ;
      while ( newDirection == ( direction + 2 ) % 4 ) {
        newDirection = rand.nextInt(3) + 1;
      } 
      
      int[] next = getNextWalkway(x, y, direction, newDirection);
      if ( next == null ) {
        return;
      }  
      if ( next[0] < 0 || next[0] >= 640/CELL_SIZE ) {
        return;
      }
      if ( next[1] < 0 || next[1] >= 480/CELL_SIZE ) {
        return;
      } 
      if ( cells.get(next[0]).get(next[1]).getType() != 0 ) {
        return;
      } 
      int nextx = next[0];
      int nexty = next[1];
      if ( newDirection == 1 || newDirection == 3 ) {
        cells.get(nextx).get(nexty).setType(1.1);
      } else {
        cells.get(nextx).get(nexty).setType(1.2);
      }  
      generateMap(nextx, nexty, newDirection, 0);
      
    } else {
      // Valid small room failed.
      fail(x, y);
      return;
    }  
    
  }
  
}  

/**
 * Checks If It Is Valid To Move In A Particular Direction
 */
// direction 1 = west, direction 2 = north, direction 3 = east, direction 4 = south 
boolean isValidPath(int x, int y, int direction ) {
  // If your direction is west:
  if (direction == 1 ) {
    // Make sure the move is valid.
    if ( (x - 1) < 0 || (x - 2) < 0 || cells.get(x - 2).get(y).getType() != 0 || cells.get(x - 1).get(y).getType() != 0) {
        return false;
    }  
    return true;
   // If your direction is north: 
  } else if (direction == 2 ) {
    // Make sure the move is valid.
    if ( (y - 1) < 0 || (y - 2) < 0 || cells.get(x).get(y-2).getType() != 0 || cells.get(x).get(y-1).getType() != 0  ) {
       return false;
    }  
    return true;
  // If your direction is east:   
  } else if (direction == 3 ) {
    // Make sure the move is valid.
    if ( (x + 1) > 640/CELL_SIZE || (x + 2) >= 640/CELL_SIZE || cells.get(x + 2).get(y).getType() != 0 || cells.get(x + 1).get(y).getType() != 0) {
      return false;
     }     
     return true;
  // If your direction is south:   
  } else if (direction == 4 ) {
    // Make sure the move is valid.
    if ( (y + 1) > 480/CELL_SIZE || (y + 2) >= 480/CELL_SIZE || cells.get(x).get(y+2).getType() != 0 || cells.get(x).get(y+1).getType() != 0 ) {
      return false;
     }
     return true;  
  } else {
    return false;
  }  
  
}

/**
 * Creates A Small Room If It's Valid
 */
// direction 1 = west, direction 2 = north, direction 3 = east, direction 4 = south 
boolean createValidSmallRoom(int x, int y, int direction) {
  
  Random rand = new Random();
  float p = rand.nextFloat();
  int room = 0;
  if ( p < SHALLOW_P ) {
    room = 1;
  } if ( p > ( 1 - DEEP_P ) ) {
    room = 2;
  }  
  
  // If your direction is west:  
  if ( direction == 1 ) {
    if ( (x - 1) < 0 || ( x - 2 ) < 0 ) {
      return false;
    } else if ( ( y - 1 ) < 0 ) { 
      return false;
    } else if (  cells.get(x - 1).get(y).getType() != 0 ) {
      return false;
    } else if (  cells.get(x - 2).get(y).getType() != 0 ) {
      return false;
    } else if (  cells.get(x - 1).get(y - 1).getType() != 0 ) {
      return false;
    } else if (  cells.get(x - 2).get(y - 1).getType() != 0 ) { 
      return false;
    } else {
      cells.get(x - 1).get(y).setType(2);
      cells.get(x - 1).get(y).setRoom(room);
      cells.get(x - 2).get(y).setType(2);
      cells.get(x - 2).get(y).setRoom(room);
      cells.get(x - 1).get(y - 1).setType(2);
      cells.get(x - 1).get(y - 1).setRoom(room);
      cells.get(x - 2).get(y - 1).setType(2);
      cells.get(x - 2).get(y - 1).setRoom(room);
      return true;
    }  
 
  // If your direction is north:  
  } else if ( direction == 2 ) {
    if ( (y - 1) < 0 || ( y - 2 ) < 0 ) {
      return false;
    } else if ( ( x + 1 ) >= 640/CELL_SIZE ) { 
      return false;
    } else if (  cells.get(x).get(y - 1).getType() != 0 ) {
      return false;
    } else if (  cells.get(x).get(y - 2).getType() != 0 ) {
      return false;
    } else if (  cells.get(x + 1).get(y - 1).getType() != 0 ) {
      return false;
    } else if (  cells.get(x + 1).get(y - 2).getType() != 0 ) { 
      return false;
    } else {
      cells.get(x).get(y - 1).setType(2);
      cells.get(x).get(y - 1).setRoom(room);
      cells.get(x).get(y - 2).setType(2);
      cells.get(x).get(y - 2).setRoom(room);
      cells.get(x + 1).get(y - 1).setType(2);
      cells.get(x + 1).get(y - 1).setRoom(room);
      cells.get(x + 1).get(y - 2).setType(2);
      cells.get(x + 1).get(y - 2).setRoom(room);
      return true;
    }   
    
  // If your direction is east:    
  } else if ( direction == 3 ) {
    if ( (x + 1) >= 640/CELL_SIZE || ( x + 2 ) >= 640/CELL_SIZE ) {
      return false;
    } else if ( ( y + 1 ) >= 480/CELL_SIZE ) { 
      return false;
    } else if (  cells.get(x + 1).get(y).getType() != 0 ) {
      return false;
    } else if (  cells.get(x + 2).get(y).getType() != 0 ) {
      return false;
    } else if (  cells.get(x + 1).get(y + 1).getType() != 0 ) {
      return false;
    } else if (  cells.get(x + 2).get(y + 1).getType() != 0 ) { 
      return false;
    } else {
      cells.get(x + 1).get(y).setType(2);
      cells.get(x + 1).get(y).setRoom(room);
      cells.get(x + 2).get(y).setType(2);
      cells.get(x + 2).get(y).setRoom(room);
      cells.get(x + 1).get(y + 1).setType(2);
      cells.get(x + 1).get(y + 1).setRoom(room);
      cells.get(x + 2).get(y + 1).setType(2);
      cells.get(x + 2).get(y + 1).setRoom(room);
      return true;
    }       
    
  // If your direction is south:    
  } else if ( direction == 4 ) {
    if ( (y + 1 ) >= 480/CELL_SIZE || ( y + 2 ) >= 480/CELL_SIZE ) {
      return false;
    } else if ( ( x - 1 ) < 0 ) { 
      return false;
    } else if (  cells.get(x).get(y + 1).getType() != 0 ) {
      return false;
    } else if (  cells.get(x).get(y + 2).getType() != 0 ) {
      return false;
    } else if (  cells.get(x - 1).get(y + 1).getType() != 0 ) {
      return false;
    } else if (  cells.get(x - 1).get(y + 2).getType() != 0 ) { 
      return false;
    } else {
      cells.get(x).get(y + 1).setType(2);
      cells.get(x).get(y + 1).setRoom(room);
      cells.get(x).get(y + 2).setType(2);
      cells.get(x).get(y + 2).setRoom(room);
      cells.get(x - 1).get(y + 1).setType(2);
      cells.get(x - 1).get(y + 1).setRoom(room);
      cells.get(x - 1).get(y + 2).setType(2);
      cells.get(x - 1).get(y + 2).setRoom(room);
      return true;
    }       
    
  } else {
    return false;
  }  
  
}  

/**
 * Creates A Big Room If It's Valid
 */
// direction 1 = west, direction 2 = north, direction 3 = east, direction 4 = south 
boolean createValidBigRoom(int x, int y, int direction) {
  
  Random rand = new Random();
  float p = rand.nextFloat();
  int room = 0;
  if ( p < SHALLOW_P ) {
    room = 1;
  } if ( p > ( 1 - DEEP_P ) ) {
    room = 2;
  }  
  
  // If your direction is west:  
  if ( direction == 1 ) {
    if ( (x - 1) < 0 || ( x - 2 ) < 0 || ( x - 3 ) < 0 ) {
      return false;
    } else if ( ( y - 1 ) < 0 || (y + 1 ) >= 480/CELL_SIZE ) { 
      return false;
    } else if (  cells.get(x - 1).get(y).getType() != 0 ) {
      return false;
    } else if (  cells.get(x - 2).get(y).getType() != 0 ) {
      return false;
    } else if (  cells.get(x - 3).get(y).getType() != 0 ) {
      return false;  
    } else if (  cells.get(x - 1).get(y - 1).getType() != 0 ) {
      return false;
    } else if (  cells.get(x - 2).get(y - 1).getType() != 0 ) { 
      return false;
    } else if (  cells.get(x - 3).get(y - 1).getType() != 0 ) { 
      return false;  
    } else if (  cells.get(x - 1).get(y + 1).getType() != 0 ) {
      return false;
    } else if (  cells.get(x - 2).get(y + 1).getType() != 0 ) { 
      return false;
    } else if (  cells.get(x - 3).get(y + 1).getType() != 0 ) { 
      return false;  
    } else {
      cells.get(x - 1).get(y).setType(2);
      cells.get(x - 1).get(y).setRoom(room);
      cells.get(x - 2).get(y).setType(2);
      cells.get(x - 2).get(y).setRoom(room);
      cells.get(x - 3).get(y).setType(2);
      cells.get(x - 3).get(y).setRoom(room);
      cells.get(x - 1).get(y - 1).setType(2);
      cells.get(x - 1).get(y - 1).setRoom(room);
      cells.get(x - 2).get(y - 1).setType(2);
      cells.get(x - 2).get(y - 1).setRoom(room);
      cells.get(x - 3).get(y - 1).setType(2);
      cells.get(x - 3).get(y - 1).setRoom(room);
      cells.get(x - 1).get(y + 1).setType(2);
      cells.get(x - 1).get(y + 1).setRoom(room);
      cells.get(x - 2).get(y + 1).setType(2);
      cells.get(x - 2).get(y + 1).setRoom(room);
      cells.get(x - 3).get(y + 1).setType(2);
      cells.get(x - 3).get(y + 1).setRoom(room);
      return true;
    }  
 
  // If your direction is north:  
  } else if ( direction == 2 ) {
    if ( (y - 1) < 0 || ( y - 2 ) < 0 || (y - 3 ) < 0 ) {
      return false;
    } else if ( ( x + 1 ) >= 640/CELL_SIZE || ( x - 1 ) < 0 ) { 
      return false;
    } else if (  cells.get(x).get(y - 1).getType() != 0 ) {
      return false;
    } else if (  cells.get(x).get(y - 2).getType() != 0 ) {
      return false;
    } else if (  cells.get(x).get(y - 3).getType() != 0 ) {
      return false;  
    } else if (  cells.get(x + 1).get(y - 1).getType() != 0 ) {
      return false;
    } else if (  cells.get(x + 1).get(y - 2).getType() != 0 ) { 
      return false;
    } else if (  cells.get(x + 1).get(y - 3).getType() != 0 ) { 
      return false;  
    } else if (  cells.get(x - 1).get(y - 1).getType() != 0 ) {
      return false;
    } else if (  cells.get(x - 1).get(y - 2).getType() != 0 ) { 
      return false;
    } else if (  cells.get(x - 1).get(y - 3).getType() != 0 ) { 
      return false;    
    } else {
      cells.get(x).get(y - 1).setType(2);
      cells.get(x).get(y - 1).setRoom(room);
      cells.get(x).get(y - 2).setType(2);
      cells.get(x).get(y - 2).setRoom(room);
      cells.get(x).get(y - 3).setType(2);
      cells.get(x).get(y - 3).setRoom(room);
      cells.get(x + 1).get(y - 1).setType(2);
      cells.get(x + 1).get(y - 1).setRoom(room);
      cells.get(x + 1).get(y - 2).setType(2);
      cells.get(x + 1).get(y - 2).setRoom(room);
      cells.get(x + 1).get(y - 3).setType(2);
      cells.get(x + 1).get(y - 3).setRoom(room);
      cells.get(x - 1).get(y - 1).setType(2);
      cells.get(x - 1).get(y - 1).setRoom(room);
      cells.get(x - 1).get(y - 2).setType(2);
      cells.get(x - 1).get(y - 2).setRoom(room);
      cells.get(x - 1).get(y - 3).setType(2);
      cells.get(x - 1).get(y - 3).setRoom(room);
      return true;
    }   
    
  // If your direction is east:    
  } else if ( direction == 3 ) {
    if ( ( x + 1 ) >= 640/CELL_SIZE || ( x + 2 ) >= 640/CELL_SIZE || ( x + 3 ) >= 640/CELL_SIZE ) {
      return false;
    } else if ( ( y + 1 ) >= 480/CELL_SIZE || ( y - 1 ) < 0 ) { 
      return false;
    } else if (  cells.get(x + 1).get(y).getType() != 0 ) {
      return false;
    } else if (  cells.get(x + 2).get(y).getType() != 0 ) {
      return false;
    } else if (  cells.get(x + 3).get(y).getType() != 0 ) {
      return false;  
    } else if (  cells.get(x + 1).get(y + 1).getType() != 0 ) {
      return false;
    } else if (  cells.get(x + 2).get(y + 1).getType() != 0 ) { 
      return false;
    } else if (  cells.get(x + 3).get(y + 1).getType() != 0 ) { 
      return false;
    } else if (  cells.get(x + 1).get(y - 1).getType() != 0 ) {
      return false;
    } else if (  cells.get(x + 2).get(y - 1).getType() != 0 ) { 
      return false;
    } else if (  cells.get(x + 3).get(y - 1).getType() != 0 ) { 
      return false;  
    } else {
      cells.get(x + 1).get(y).setType(2);
      cells.get(x + 1).get(y).setRoom(room);
      cells.get(x + 2).get(y).setType(2);
      cells.get(x + 2).get(y).setRoom(room);
      cells.get(x + 3).get(y).setType(2);
      cells.get(x + 3).get(y).setRoom(room);
      cells.get(x + 1).get(y + 1).setType(2);
      cells.get(x + 1).get(y + 1).setRoom(room);
      cells.get(x + 2).get(y + 1).setType(2);
      cells.get(x + 2).get(y + 1).setRoom(room);
      cells.get(x + 3).get(y + 1).setType(2);
      cells.get(x + 3).get(y + 1).setRoom(room);
      cells.get(x + 1).get(y - 1).setType(2);
      cells.get(x + 1).get(y - 1).setRoom(room);
      cells.get(x + 2).get(y - 1).setType(2);
      cells.get(x + 2).get(y - 1).setRoom(room);
      cells.get(x + 3).get(y - 1).setType(2);  
      cells.get(x + 3).get(y - 1).setRoom(room);    
      return true;
    }       
    
  // If your direction is south:    
  } else if ( direction == 4 ) {
    if ( (y + 1 ) >= 480/CELL_SIZE || ( y + 2 ) >= 480/CELL_SIZE || ( y + 3 ) >= 480/CELL_SIZE ) {
      return false;
    } else if ( ( x - 1 ) < 0 || ( x + 1 ) > 640 /CELL_SIZE ) { 
      return false;
    } else if (  cells.get(x).get(y + 1).getType() != 0 ) {
      return false;
    } else if (  cells.get(x).get(y + 2).getType() != 0 ) {
      return false;
    } else if (  cells.get(x).get(y + 3).getType() != 0 ) {
      return false;  
    } else if (  cells.get(x - 1).get(y + 1).getType() != 0 ) {
      return false;
    } else if (  cells.get(x - 1).get(y + 2).getType() != 0 ) { 
      return false;
    } else if (  cells.get(x - 1).get(y + 3).getType() != 0 ) { 
      return false;
    } else if (  cells.get(x + 1).get(y + 1).getType() != 0 ) {
      return false;
    } else if (  cells.get(x + 1).get(y + 2).getType() != 0 ) { 
      return false;
    } else if (  cells.get(x + 1).get(y + 3).getType() != 0 ) { 
      return false;  
    } else {
      cells.get(x).get(y + 1).setType(2);
      cells.get(x).get(y + 1).setRoom(room);
      cells.get(x).get(y + 2).setType(2);
      cells.get(x).get(y + 2).setRoom(room);
      cells.get(x).get(y + 3).setType(2);
      cells.get(x).get(y + 3).setRoom(room);
      cells.get(x - 1).get(y + 1).setType(2);
      cells.get(x - 1).get(y + 1).setRoom(room);
      cells.get(x - 1).get(y + 2).setType(2);
      cells.get(x - 1).get(y + 2).setRoom(room);
      cells.get(x - 1).get(y + 3).setType(2);
      cells.get(x - 1).get(y + 3).setRoom(room);
      cells.get(x + 1).get(y + 1).setType(2);
      cells.get(x + 1).get(y + 1).setRoom(room);
      cells.get(x + 1).get(y + 2).setType(2);
      cells.get(x + 1).get(y + 2).setRoom(room);
      cells.get(x + 1).get(y + 3).setType(2);
      cells.get(x + 1).get(y + 3).setRoom(room);
      return true;
    }       
    
  } else {
    return false;
  }  
  
}  

/**
 * Get's The Location Of The Walkway For A Small Room
 */
// direction 1 = west, direction 2 = north, direction 3 = east, direction 4 = south 
int[] getNextWalkway(int x, int y, int direction, int newDirection) {
  if ( direction == 1 ) {
    if ( newDirection == 1 ) {
      int[] ret = new int[2];
      ret[0] = x - 3;
      ret[1] = y - 1;
      return ret;
    } else if ( newDirection == 2 ) {
      int[] ret = new int[2];
      ret[0] = x - 2;
      ret[1] = y - 2;
      return ret;      
    } else if ( newDirection == 4 ) {
      int[] ret = new int[2];
      ret[0] = x - 2;
      ret[1] = y + 1;
      return ret;      
    } else {
      return null;
    }  
  } else if ( direction == 2 ) {
    if ( newDirection == 1 ) {
      int[] ret = new int[2];
      ret[0] = x - 1;
      ret[1] = y - 2;
      return ret;
    } else if ( newDirection == 2 ) {
      int[] ret = new int[2];
      ret[0] = x + 1;
      ret[1] = y - 3;
      return ret;
    } else if ( newDirection == 3 ) {
      int[] ret = new int[2];
      ret[0] = x + 2;
      ret[1] = y - 2;
      return ret;
    } else {
      return null;
    }      
  } else if ( direction == 3 ) {
    if ( newDirection == 2 ) {
      int[] ret = new int[2];
      ret[0] = x + 2;
      ret[1] = y - 1;
      return ret;      
    } else if ( newDirection == 3 ) {
      int[] ret = new int[2];
      ret[0] = x + 3;
      ret[1] = y + 1;
      return ret;      
    } else if ( newDirection == 4 ) {
      int[] ret = new int[2];
      ret[0] = x + 2;
      ret[1] = y + 2;
      return ret;      
    } else {
      return null;
    }      
  } else if ( direction == 4 ) {
    if ( newDirection == 1 ) {
      int[] ret = new int[2];
      ret[0] = x - 2;
      ret[1] = y + 2;
      return ret;
    } else if ( newDirection == 3 ) {
      int[] ret = new int[2];
      ret[0] = x + 1;
      ret[1] = y + 2;
      return ret;      
    } else if ( newDirection == 4 ) {
      int[] ret = new int[2];
      ret[0] = x - 1;
      ret[1] = y + 3;
      return ret;      
    } else {
      return null;
    }      
  } else {
    return null;
  }  
}  

/**
 * Get's The Location Of The Walkways For A Big Room
 */
// direction 1 = west, direction 2 = north, direction 3 = east, direction 4 = south 
int[] getAllWalkways(int x, int y, int direction) {
  if ( direction == 1 ) {
    
      int[] ret = new int[9];
      // Accross
      ret[0] = x - 4;
      ret[1] = y;
      ret[2] = 1;
      // Up
      ret[3] = x - 2;
      ret[4] = y - 2;
      ret[5] = 2;
      // Down
      ret[6] = x - 2;
      ret[7] = y + 2;
      ret[8] = 4;
      return ret;      
    
  } else if ( direction == 2 ) {
    
      int[] ret = new int[9];
      // Left
      ret[0] = x - 2;
      ret[1] = y - 2;
      ret[2] = 1;
      // Accross
      ret[3] = x;
      ret[4] = y - 4;
      ret[5] = 2;
      // Right
      ret[6] = x + 2;
      ret[7] = y - 2;
      ret[8] = 3;
      return ret;
       
  } else if ( direction == 3 ) {
    
      int[] ret = new int[9];
      // Up
      ret[0] = x + 2;
      ret[1] = y - 2;
      ret[2] =  2;
      // Accross      
      ret[3] = x + 4;
      ret[4] = y;
      ret[5] = 3;
      // Down     
      ret[6] = x + 2;
      ret[7] = y + 2;
      ret[8] = 4;
      return ret;      
         
  } else if ( direction == 4 ) {
    
      int[] ret = new int[9];
      // Left
      ret[0] = x - 2;
      ret[1] = y + 2;
      ret[2] = 1;
      // Right
      ret[3] = x + 2;
      ret[4] = y + 2;
      ret[5] = 3;
      // Accross
      ret[6] = x;
      ret[7] = y + 4;
      ret[8] = 4;
      return ret;      
          
  } else {
    return null;
  }  
}  
 /**
  * Fails The Current Cell
  */
void fail(int x, int y) {
  cells.get(x).get(y).setType(3);
}  

/**
 * Cell Class
 */
class Cell {
  
  float type;
  int size;
  int x;
  int y;
  // 0 = underwater cave // 1 = deep underwater pool // 2 = shallow coral reef
  int room;

  
  Cell(int x, int y) {
    this.type = 0;
    this.size = CELL_SIZE;
    this.x = x;
    this.y = y;
    this.room = 0;
  }
  
  void setType(float t) {
    this.type = t;
  }  
  
  float getType() {
    return this.type;
  } 
  
  int getRoom() {
    return this.room;
  }  
  
  void setRoom(int r ) {
    this.room = r;
  }  
  
  void fillCell() {
    if (this.type == 0) {
      drawType0(this.x, this.y, this.size);
    } 
    if (this.type == 1) {
      drawType1(this.x, this.y, this.size);
    } 
    if (this.type == 1.1) {
      drawType1A(this.x, this.y, this.size);
    }  
    if (this.type == 1.2) {
      drawType1B(this.x, this.y, this.size);
    } 
    if (this.type == 2) {
      drawType2(this.x, this.y, this.size, this.room);
    }  
    if (this.type == 3) {
      drawType3(this.x, this.y, this.size);
    }  
  }  
  
}

/** Draw Different Types Of Cells */

// Type 0: Empty Space
void drawType0(int x, int y, int size) {
  noStroke();
  fill(0);
  rect(x,y, size, size);
}  

// Type 1A: A Doorway
void drawType1(int x, int y, int size) {
  fill(200);
  noStroke();
  rect(x,y, size, size);
}

// Type 1A: A Walkway ( Horizontal )
void drawType1A(int x, int y, int size) {
  fill(150);
  noStroke();
  rect(x,y, size, size);
  fill(60);
  rect(x, y, size, size/4);
  rect(x, y + (size/4)*4, size, size/4);
} 

// Type 1B: A Walkway ( Vertical )
void drawType1B(int x, int y, int size) {
  fill(150);
  noStroke();
  rect(x,y, size, size);
  fill(60);
  rect(x, y, size/4, size);
  rect(x + (size/4)*4, y , size/4, size);
} 

// Type 2: A Room
void drawType2(int x, int y, int size, int room) {
  if ( room == 0 ) {
    noStroke();
    fill(200);
    rect(x,y, size, size);
    stroke(175);
    line(x, y, x + size, y + size);
  }
  if ( room == 1 ) {
    noStroke();
    color c = color(204, 255, 255);
    fill(c);
    rect(x,y, size, size);
    c = color(225,166,132);
    fill(c);
    circle(x + size/2, y + size/2, coralSize*CELL_SIZE*0.8);
  } 
  if ( room == 2 ) {
    noStroke();
    color c = color(50, 55, 100);
    fill(c);
    rect(x,y, size, size);
    c = color(20, 55, 100);
    fill(c);
    rect(x + size/2,y + size/2, size/4, size/4);
  }  
  
}  

// Type 3: A Dead End
void drawType3(int x, int y, int size) {
  fill(50);
  noStroke();
  rect(x,y, size, size);
}  
