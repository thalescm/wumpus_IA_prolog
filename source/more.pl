Programming Assignment 2a - The Wumpus World 

Due: Tuesday October 27, 1998 
  

Implement the Wumpus world as described in your text (Section 6.2 and section
7.4-7.6). Make sure to include effect and frame axioms or alternatively 
successor-state axioms. You may assume that 'Wumpus-land' is a 4 x 4 array. 
Input to the program will include locations of the Wumpus as well 
as any pits and gold. For example: 

At( Wumpus , [1,3] ) 
At( Pit, [2,2]) 
At(Pit, [4,3]) 

Some things to remember : 

Your 'agent' *may not* query about the location of the Wumpus or pits or gold, 
but must *infer* where they are. 

Your program should return a 5-tuple after each action indicating the presence 
of a stench,breeze,glitter,scream, or a bump. For this portion of your program 
(and this portion only), the program may query about the position of pits, gold,
 and the Wumpus. 

The agent begins in the square [1,1] and return to this square before 'jumping'. 
A jump in any other square should have no effect (except to cost 1 point). 

Your program should output all actions the agents takes as well as the final
point count when the game terminates. 

Your program should be able to handle *any* input. 

Sample Data 

Run 1: 
    At( Wumpus , [1 , 3] ) 
    At( Gold , [3 , 4] ) 
    At( Pit , [3 , 3] ) 
    At( Pit , [3 , 1] ) 
    At( Pit , [4 , 4] ) 

Run 2: 
    At( Wumpus, [1,3]) 
    At( Gold, [4,4]) 
    At( Pit,  [3,3]) 
    At( Pit, [3,4]) 
    At( Pit, [4,3]) 
  
