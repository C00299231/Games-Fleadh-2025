*-----------------------------------------------------------
* Title      :  Rotating points on a Cartesian Plane
* Written by :  Oliwier Jakubiec
* Date       :  18/01/2025
* Description:  Draws a square to the screen and rotates it about a center point (0,0)
*               a full 360 deg using Matrix rotation
*-----------------------------------------------------------

        ; Load the precomputed SINE and COSINE value tables into A1 and A2
        LEA         COS_TABLE,A3
        LEA         SINE_TABLE,A2
        
        ; Set color to #ffff00 (cyan)
        ; color set as $00BBGGRR
        MOVE.L      #GREEN,D1
        MOVE.L      #80,D0        
        TRAP        #15
        
        ; Turns on double buffer
        ; Causes graphics to be drawn to an off screen buffer instead of directly to
        ;   the screen
        MOVE.L      #17,D1
        MOVE.L      #92,D0
        TRAP        #15
        
        ; Set pen width in D1
        MOVE.L      #3,D1
        MOVE.L      #93,D0
        TRAP        #15
   
;   Main loop starts here
DRAWSQUARE:
        BSR     STARTINPUT
        ; Swap the current buffer screen to display the off-screen buffer
        MOVE.L       #94,D0
        TRAP         #15

        MOVE.w	    #$FF00,d1			* clear screen
        MOVEQ	    #11,d0			* position cursor
        TRAP		    #15

*--------------------------------------------*
        * Rotate all the points about the current angle
        
        ; rotate x1, y1
        MOVE.L      x1,D1       ; Move x1 and y1 into D1 and D2
        MOVE.L      y1,D2
        BSR         ROTATE      ; Branch to ROTATE
        MOVE.L      D5,Ax1      ; Move the computed rotated x1 and y1 into the 
        MOVE.L      D2,Ay1      ;   actual x1 and y1
        
        ; rotate x2, y2
        MOVE.L      x2,D1
        MOVE.L      y2,D2
        BSR         ROTATE
        MOVE.L      D5,Ax2
        MOVE.L      D2,Ay2
        
        ; rotate x3, y3
        MOVE.L      x3,D1
        MOVE.L      y3,D2
        BSR         ROTATE
        MOVE.L      D5,Ax3
        MOVE.L      D2,Ay3
        
        ; rotate x4, y4
        MOVE.L      x4,D1
        MOVE.L      y4,D2
        BSR         ROTATE
        MOVE.L      D5,Ax4
        MOVE.L      D2,Ay4

*------------------------------------------*
* Calculate where to draw each coord based off the screen width and height

        MOVE.L      Ax1,D7               ; Move Ax1 into D7
        BSR         CALCPOS_X            ; Branch to Subroutine to calculate X Position
        MOVE.L      D7,Ax1               ; Store the actual x position into Ax1
        
        MOVE.L      Ay1,D7               ; Move Ay1 into D7
        BSR         CALCPOS_Y            ; Branch to Subroutine to calculate Y Position
        MOVE.L      D7,Ay1               ; Store the actual y position into Ay1
        
        MOVE.L      Ax2,D7
        BSR         CALCPOS_X
        MOVE.L      D7,Ax2
        
        MOVE.L      Ay2,D7
        BSR         CALCPOS_Y
        MOVE.L      D7,Ay2
        
        MOVE.L      Ax3,D7
        BSR         CALCPOS_X
        MOVE.L      D7,Ax3
        
        MOVE.L      Ay3,D7
        BSR         CALCPOS_Y
        MOVE.L      D7,Ay3

        MOVE.L      Ax4,D7
        BSR         CALCPOS_X
        MOVE.L      D7,Ax4
        
        MOVE.L      Ay4,D7
        BSR         CALCPOS_Y
        MOVE.L      D7,Ay4
        
*---------------------------------------------*
* Drawing the points to the screen as lines from x1y1 to x2y2
* x1 is placed in D1, y1 into D2, x2 into D3, and y2 into D4

        
        MOVE.L  #WHITE,     D1
        MOVE.B  #21,        D0          ; Set Text Color
        MOVE.L  #$012A0000, D2
        TRAP    #15                     ; Trap (Perform action) 


        MOVE.B     #TC_CURSR_P,D0
        MOVE.L     #$0601,D1
        TRAP        #15
        
        LEA        TITLEMSG,A1
        MOVE.B     #13,D0
        TRAP       #15
     
        MOVE.L  #WHITE,     D1
        MOVE.B  #21,        D0          ; Set Text Color
        MOVE.L  #$01120000, D2
        TRAP    #15                     ; Trap (Perform action) 


        MOVE.B     #TC_CURSR_P,D0
        MOVE.L     #$0D0C,D1
        TRAP        #15
        
        LEA        PRESSSTART,A1
        MOVE.B     #13,D0
        TRAP       #15
     
        MOVE.L      #BROWN,D1
        MOVE.L      #81,D0
        TRAP        #15
        
        MOVE.L      #0,D1
        MOVE.L      #0,D2
        MOVE.L      #89,D0
        TRAP        #15
        
        ; Move points x1 y1 x2 y2 into registers
        MOVE.L      Ax1,D1
        MOVE.L      Ay1,D2
        MOVE.L      Ax2,D3
        MOVE.L      Ay2,D4
        ; draw line from x1y1 to x2y2   
        MOVE.L      #84,D0          
        TRAP        #15

        ; Move points x3 y3 x4 y4 into registers
        MOVE.L      Ax3,D1
        MOVE.L      Ay3,D2
        MOVE.L      Ax4,D3
        MOVE.L      Ay4,D4
        ; draw line from x3y3 to x4y4
        MOVE.L      #84,D0          
        TRAP        #15

        ; Move points x1 y1 x3 y3 into registers
        MOVE.L      Ax1,D1
        MOVE.L      Ay1,D2
        MOVE.L      Ax3,D3
        MOVE.L      Ay3,D4
        ; draw line from x1y1 to x3y3
        MOVE.L      #84,D0          
        TRAP        #15

        ; Move points x2 y2 x4 y4 into registers
        MOVE.L      Ax2,D1
        MOVE.L      Ay2,D2
        MOVE.L      Ax4,D3
        MOVE.L      Ay4,D4
        ; draw line from x2y2 to x4y4
        MOVE.L      #84,D0          
        TRAP        #15
        
        MOVE.L      #GREEN,D1
        MOVE.L      #81,D0
        TRAP        #15
        
        MOVE.L      #0,D1
        MOVE.L      #0,D2
        MOVE.L      #89,D0
        TRAP        #15


        
*------------------------------------*
* Adds a delay to the line so it doesnt rotate too fast

        ; set the duration of the timer
        MOVE.L      #80000,timer2
DELAY2:     
        SUBI.L      #1,timer2        ; decrement timer by 1 to simulate a delay
        CMP.L       #0,timer2        ; compare 0 to the value of timer
        BNE         DELAY2           ; branch back to DELAY if the previous compare was not equal
    

*-------------------------------------*
* Check and increment values

 ; increment the angle index by 4 as each element in the
 ; array is a Long so incrementing by 4 bytes gives the next element   
        ADDI.L      #4,angle        
        CMP.L       #148,angle      ; Compare angle to see if the last element has been reached
        BNE         DRAWSQUARE            ; If not then Branch back to the start of the loop
       
        MOVE.L      #0,angle        ; Else if its reached the last element then reset angle to 0
        JMP         DRAWSQUARE            ; Branch back to the start of the loop
                
****************************************
*****        SUBROUTINES        ********
****************************************

* Subroutine to calculate the X position
CALCPOS_X:
     MULS.W      sv,D7               ; Signed Multiply by the scalar value
     DIVS.W      #10000,D7           ; Signed divide by 10^4 to deal with the scaled SIN/COS values
     AND.L       #$0000FFFF,D7       ; AND operation to clear the high order word of D7 as thats where the remainder of the DIV operator is held
     ADD.L       cx,D7               ; Add the center-x value to the x point as currently its based off 0,0 still 
     
     RTS                             ; Return statement
     
* Subroutine to calculate the Y position     
CALCPOS_Y:  
     MULS.W      sv,D7               ; Signed Multiply by the scalar value
     DIVS.W      #10000,D7           ; Signed divide by 10^4 to deal with the scaled SIN/COS values
     AND.L       #$0000FFFF,D7       ; AND operation to clear the high order word of D7
     NEG         D7                  ; Negate D7 as a positive Y value actually moves points down the screen not up
     ADD.L       cy,D7               ; Add center-Y value to the y point
     AND.L       #$0000FFFF,D7       ; AND again the high order Word to deal with overflow from the previous NEG 

     RTS                             ; Return statement
  
* The rotate subroutine   
ROTATE:
        
        MOVE.L      angle,D0         ; Copy angle into D0
        MOVE.L      (A3,D0),cos      ; Copy the indexed value from the sin table using angle as the index, into sin
        MOVE.L      (A2,D0),sin      ; Copy the indexed value from the cosine table using angle as the index, into cos

        
* Calculate the new x value
* The matrix multiplication for the x value is xcos(Ø) - ysin(Ø) 
        MOVE.L      D1,D3            ; Copy d1,(x), into d3
        MOVE.L      D2,D4            ; Copy d2,(y), into d4
        MOVE.L      cos,D7           ; Move cos(angle) into D7
        MULS.W      D7,D3            ; Multiply x * cos(angle) and store in D3
        
        MOVE.L      sin,D6           ; Move sin(angle) into D6
        MULS.W      D6,D4            ; Multiply y * sin(angle) and store in D4
        
        SUB.L       D4,D3            ; Subtract D4 (ysin(angle)) from D3 (cos(angle))
        MOVE.L      D3,D5            ; Store new X in D5
        
* Calculate the new y value
* The matrix multiplication for the y value is xsin(Ø) + ycos(Ø) 
        MOVE.L      D1,D3            ; Copy d1,(x), into d3
        MOVE.L      D2,D4            ; Copy d2,(y), into d4
        MOVE.L      sin,D7           ; Move sin(angle) into D7
        MULS.W      D7,D3            ; Multiply x * sin(angle) and store in D3
        
        MOVE.L      cos,D6           ; Move cos(angle) into D6
        MULS.W      D6,D4            ; Multiply y * cos(angle) and store in D4
        
        ADD.L       D4,D3            ; Add D3 (xsin(angle)) and D4 (ycos(angle))
        MOVE.L      D3,D2            ; Store new Y in D2
        
        RTS                          ;Return Statement

STARTINPUT:
    ; Process Input
    CLR.L   D1                      ; Clear Data Register
    CLR.L   D2
    MOVE.B  #TC_KEYCODE,D0          ; Listen for Keys
    TRAP    #15                     ; Trap (Perform action)
    MOVE.B  D1,         D2          ; Move last key D1 to D2
    CMP.B   #00,        D2          ; Key is pressed
    BEQ     PROCESS_STARTINPUT           ; Process Key
    TRAP    #15                     ; Trap for Last Key
    ; Check if key still pressed
    CMP.B   #$FF,       D1          ; Is it still pressed
    BEQ     PROCESS_STARTINPUT           ; Process Last Key
    RTS                             ; Return to subroutine

*-----------------------------------------------------------
* Subroutine    : Process Input
* Description   : Branch based on keys pressed
*-----------------------------------------------------------
PROCESS_STARTINPUT:
    MOVE.L  D2,         CURRENT_KEY ; Put Current Key in Memory
    CMP.L   #49,        CURRENT_KEY 
    BEQ     GAMELOOP
    RTS                             ; Return to subroutine

   
*----------------------------------------*
* Variables and define stuff    
*----------------------------------------*

* Array of precomputed SINE values
* Each value is scaled up by 10^4 as decimals dont exist in m68k asm
* Goes from 0deg - 360deg in steps of 10 deg
SINE_TABLE 
    DC.L    0000, 1736, 3420, 5000, 6427, 7660, 8660, 9396, 9848, 10000     ; 0 - 1
    DC.L    9848, 9848, 9396, 8660, 7660, 6427, 5000, 3420, 1736, 0000      ; 1 - 0
    DC.L    $F938, $F2A4, $EC78, $E6E5, $E214, $DE2C, $DB4C, $D988, $D8F0   ; -0 - -1
    DC.L    $D988, $DB4C, $DE2C, $E214, $E6E5, $EC78, $F2A4, $F938          ' -1 - 0

* Array of precomputed COSINE values
* Also goes from 0deg - 360deg in steps of 10 deg
COS_TABLE   
    DC.L    10000, 9848, 9396, 8660, 7660, 6427, 5000, 3420, 1736, 0000     ; 1 - 0
    DC.L    $F938, $F2A4, $EC78, $E6E5, $E214, $DE2C, $DB4C, $D988, $D8F0   ; -0 - -1
    DC.L    $D988, $DB4C, $DE2C, $E214, $E6E5, $EC78, $F2A4, $F938          ; -1 - 0
    DC.L    0000, 1736, 3420, 5000, 6427, 7660, 8660, 9396, 9848, 10000     ; 0 - 1
    
sin     dc.l    1              * sine
cos     dc.l    1              * cosine
angle   dc.l    0              * angle

cy      dc.L    240      ;center y
cx      dc.L    325      ;center x
sv      dc.W    20       ;scale value

* Coordinates 
* NOT : Any coordinates larger than 2 might go off screen and cause it glitch out

x1   dc.l    -4          ; x1  -  values constant
y1   dc.l    0                  ; y1  -
x2   dc.l    0          ; x2  -
y2   dc.l    0                  ; y2  -

x3   dc.l    -2          ; x3  -  values constant
y3   dc.l    -2          ; y3  -
x4   dc.l    0          ; x4  -
y4   dc.l    -3          ; y4  -

eye1x   dc.l -1
eye1y   dc.l  0   

;eye2x   
;eye2y
Ax1   dc.l    1         ; Actual x1  -  value is computed
Ay1   dc.l    1         ; Actual y1
Ax2   dc.l    1         ; Actual x2
Ay2   dc.l    1         ; Actual y2

Ax3   dc.l    1         ; Actual x3
Ay3   dc.l    1         ; Actual y3
Ax4   dc.l    1         ; Actual x4
Ay4   dc.l    1         ; Actual y4


timer2   dc.l    0       ; Timer
*----------------------------------*
*               END                *
*----------------------------------*
       
    









*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
