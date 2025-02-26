*-----------------------------------------------------------
* Title      : Game Starter Kit
* Written by : Philip Bourke
* Date       : 05/02/2025
* Description: Project Starter Kit
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

*-----------------------------------------------------------
* Section       : Trap Codes
* Description   : Trap Codes used throughout StarterKit
*-----------------------------------------------------------
* Trap CODES
TC_SCREEN   EQU         33          ; Screen size information trap code
TC_S_SIZE   EQU         00          ; Places 0 in D1.L to retrieve Screen width and height in D1.L
                                    ; First 16 bit Word is screen Width and Second 16 bits is screen Height
TC_KEYCODE  EQU         19          ; Check for pressed keys
TC_DBL_BUF  EQU         92          ; Double Buffer Screen Trap Code
TC_CURSR_P  EQU         11          ; Trap code cursor position

TC_REDRAW   EQU         94          ; Redraw Screen
TC_EXIT     EQU         09          ; Exit Trapcode

*-----------------------------------------------------------
* Section       : Charater Setup
* Description   : Size of Player and Enemy and properties
* of these characters e.g Starting Positions and Sizes
*-----------------------------------------------------------
PLYR_W_INIT EQU         20          ; Players initial Width
PLYR_H_INIT EQU         12          ; Players initial Height

PLYR_DFLT_V EQU         00          ; Default Player Velocity
PLYR_JUMP_V EQU         -19          ; Player Jump Velocity
PLYR_DFLT_G EQU         01          ; Player Default Gravity

GND_TRUE    EQU         01          ; Player on Ground True
GND_FALSE   EQU         00          ; Player on Ground False

GAMEOVER_INDEX   EQU             00          ; Player Run Sound Index  
JMP_INDEX   EQU             01          ; Player Jump Sound Index  
HITHURT_INDEX  EQU          02          ; Player Opps Sound Index
POWERUP_INDEX  EQU          03          ; Player Opps Sound Index
LEVELCHANGE_INDEX  EQU      04          ; Player Opps Sound Index

ENMY_W_INIT EQU         12          ; Enemy initial Width
ENMY_H_INIT EQU         12          ; Enemy initial Height
ENEMY_H_INIT EQU         12          ; Enemy initial Height

FLY_ENMY_W_INIT  EQU         20          ; Enemy initial Width
FLY_ENMY_H_INIT  EQU         12          ; Enemy initial Height

HEALTH_PACK_W    EQU         12          ; Enemy initial Width
HEALTH_PACK_H    EQU         12          ; Enemy initial Height

LOOKRIGHT   EQU         02          ; Look Right
LOOKLEFT    EQU         01          ; Look Left
*-----------------------------------------------------------
* Section       : Graphic Colors
* Description   : Screen Pixel Color
*-----------------------------------------------------------
WHITE           EQU     $00FFFFFF
BLACK           EQU     $00000000
RED             EQU     $000000FF
BLUE            EQU     $00FF0000
GREEN           EQU     $00566D19
LIFEGREEN       EQU     $0044FF44
BROWN           EQU     $0019506D         ; Brown   
SKY             EQU     $00FFE2B0         ; Sky Blue

*-----------------------------------------------------------
* Section       : Keyboard Keys
* Description   : Spacebar and Escape or two functioning keys
* Spacebar to JUMP and Escape to Exit Game
*-----------------------------------------------------------
SPACEBAR    EQU         $20         ; Spacebar ASCII Keycode
ESCAPE      EQU         $1B         ; Escape ASCII Keycode
Rkey           EQU         $52         ; R ASCII Keycode
Akey           EQU         $41         ; A ASCII Keycode
Skey           EQU         $53         ; S ASCII Keycode
Dkey           EQU         $44         ; D ASCII Keycode
Lkey           EQU         $4C         ; L ASCII Keycode

*-----------------------------------------------------------
* Subroutine    : Initialise
* Description   : Initialise game data into memory such as 
* sounds and screen size
*-----------------------------------------------------------
INITIALISE:
    ; Initialise Sounds
    BSR     JUMP_LOAD               ; Load Jump Sound into Memory
    BSR     GAMEOVER_LOAD                ; Load Run Sound into Memory
    BSR     HITHURT_LOAD               ; Load Opps (Collision) Sound into Memory
    BSR     POWERUP_LOAD               ; Load Opps (Collision) Sound into Memory
    BSR     LVLCHANGE_LOAD               ; Load Opps (Collision) Sound into Memory

    ; Screen Size
    MOVE.B  #TC_SCREEN, D0          ; access screen information
    MOVE.L  #TC_S_SIZE, D1          ; placing 0 in D1 triggers loading screen size information
    TRAP    #15                     ; interpret D0 and D1 for screen size
    MOVE.W  D1,         SCREEN_H    ; place screen height in memory location
    SWAP    D1                      ; Swap top and bottom word to retrive screen size
    MOVE.W  D1,         SCREEN_W    ; place screen width in memory location

    ; Place the Player at the center of the screen
    EOR.L    D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on X Axis
    MOVE.L  D1,         PLAYER_X    ; Players X Position

    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    MOVE.L  D1,         PLAYER_Y    ; Players Y Position

    ; Set the player starting width and height
    MOVE.B  #PLYR_W_INIT,        PLAYER_WIDTH ; Players Width
    MOVE.B  #PLYR_H_INIT,        PLAYER_HEIGHT ; Players Width

    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    MOVE.L  D1,         PLAYER_Y    ; Players Y Position

    ; Initialise Player Score
    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.L  #00,        D1          ; Init Score
    MOVE.L  D1,         PLAYER_SCORE

    ; Initialise Player Velocity
    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.B  #PLYR_DFLT_V,D1         ; Init Player Velocity
    MOVE.L  D1,         PLYR_VELOCITY

    ; Initialise Player Gravity
    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.L  #PLYR_DFLT_G,D1         ; Init Player Gravity
    MOVE.L  D1,         PLYR_GRAVITY

    ; Initialize Player on Ground
    MOVE.L  #GND_TRUE,  PLYR_ON_GND ; Init Player on Ground

    ; Initial Position for Enemy
    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    MOVE.L  D1,         ENEMY_X     ; Enemy X Position

    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    MOVE.L  D1,         ENEMY_Y     ; Enemy Y Position

    ; Initialise the starting enemy width and height
    MOVE.W  #12,        ENEMY_WIDTH ; Enemy Width
    MOVE.W  #12,        ENEMY_HEIGHT ; Enemy Height

    ; Initial Position for Flying Enemy
    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    MOVE.L  D1,         FLYINGENEMY_X     ; Enemy X Position

    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    SUB.W   #60,        D1
    MOVE.L  D1,         FLYINGENEMY_Y     ; Enemy Y Position
    
    ; Initial Flying enemy width and height
    MOVE.W  #20,        FLYENEMY_WIDTH ; Enemy Width
    MOVE.W  #12,        FLYENEMY_HEIGHT ; Enemy Height
    ; Initial Position for Health pack
    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    SUB.L   #-1,        D1
    MOVE.L  D1,         HEALTH_X     ; Enemy X Position

    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    MOVE.L  D1,         HEALTH_Y     ; Enemy Y Position


    LEA    LEVELS,      A2
    MOVE.B  #05,        LIVES
    MOVE.B  #02,        POINTS
    MOVE.B  #00,        DRAW_HEALTHPACKS
    MOVE.B  #00,        SPAWN_HEALTHPACKS
    MOVE.W  #320,       Z
    MOVE.W  #4,         SCALER   
    MOVE.W  #-80,       WIDTH     

    CLR.L   D1
    ; load tree 
    MOVE.L  #50,D0
    TRAP    #15
    LEA     title,A1
    MOVE.L  #51,D0
    TRAP    #15
    
    LEA     SPRITE_DATA,A1
    MOVE.L  #1974,D2
    MOVE.L  #53,D0
    TRAP #15


    ; Enable the screen back buffer(see easy 68k help)
    MOVE.B  #TC_DBL_BUF,D0          ; 92 Enables Double Buffer
    MOVE.B  #17,        D1          ; Combine Tasks
    TRAP	#15                     ; Trap (Perform action)
        
    ; Clear the screen (see easy 68k help)
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$FF00,     D1          ; Fill Screen Clear
    TRAP	#15                     ; Trap (Perform action)


*-----------------------------------------------------------
* Subroutine    : Game
* Description   : Game including main GameLoop. GameLoop is like
* a while loop in that it runs forever until interupted
* (Input, Update, Draw). The Enemies Run at Player Jump to Avoid
*-----------------------------------------------------------
GAME:
   
STARTSCREEN:
         
    ;MOVE.L     #$01090000,D2
    ;MOVE.L     #$00FFFFFF,D1
    ;MOVE.B     #21,D0
    ;TRAP       #15
     
     ;INCLUDE    "ROTATINGSQUARE.X68"
     ;MOVE.B     #04,D0
     ;TRAP       #15
    
GAMELOOP:
    ; Main Gameloop
    MOVE.L      #3000,timer
DELAY:     
    SUBI.L      #1,timer            ; decrement timer by 1 to simulate a delay
    TST.L       timer            ; compare 0 to the value of timer
    BNE         DELAY               ; branch back to DELAY if the previous compare was not equal

    BSR     INPUT                   ; Check Keyboard Input
    BSR     UPDATE                  ; Update positions and points
    BSR     IS_PLAYER_ON_GND        ; Check if player is on ground
    BSR     CHECK_COLLISIONS        ; Check for Collisions
    BSR     DRAW                    ; Draw the Scene
                ; Loop back to GameLoop
    BRA     GAMELOOP    
    
*-----------------------------------------------------------
* Subroutine    : Input
* Description   : Process Keyboard Input
*-----------------------------------------------------------
INPUT:
    MOVE.B  #TC_KEYCODE, D0          ; Check for pressed keys
    MOVE.L  #$41444C20, D1          ; Check for A, D and Spacebar
    TRAP    #15                     ; Trap (Perform action)
    MOVE.L  D1,         CURRENT_KEY ; Put Current Key in Memory

    BTST.L  #24,D1
    IF <NE> THEN
        BSR    MOVE_PLAYER_LEFT
    ENDI

    MOVE.L  CURRENT_KEY, D1
    BTST.L  #16,D1
    IF <NE> THEN
        BSR    MOVE_PLAYER_RIGHT
    ENDI

    MOVE.L  CURRENT_KEY, D1
    BTST.L  #8,D1
    IF <NE> THEN
        BSR    PERFORM_ATTACK
    ENDI

    MOVE.L  CURRENT_KEY, D1
    BTST.L  #0,D1
    IF <NE> THEN
        BSR    JUMP
    ENDI
    
    ; Process Input
    CLR.L   D1                      ; Clear Data Register
    CLR.L   D2
    MOVE.B  #TC_KEYCODE,D0          ; Listen for Keys
    TRAP    #15                     ; Trap (Perform action)
    MOVE.B  D1,         D2          ; Move last key D1 to D2
    CMP.B   #00,        D2          ; Key is pressed
    BEQ     PROCESS_INPUT           ; Process Key
    TRAP    #15                     ; Trap for Last Key
    ; Check if key still pressed
    CMP.B   #$FF,       D1          ; Is it still pressed
    BEQ     PROCESS_INPUT           ; Process Last Key
    RTS                             ; Return to subroutine
*-----------------------------------------------------------
* Subroutine    : Process Input
* Description   : Branch based on keys pressed
*-----------------------------------------------------------
PROCESS_INPUT:
    MOVE.L  D2,         CURRENT_KEY ; Put Current Key in Memory

    CMP.L   #ESCAPE,    CURRENT_KEY ; Is Current Key Escape
    BEQ     EXIT                    ; Exit if Escape
    TST.B   LIVES
    BEQ     PROCESS_RESTART
    BRA     IDLE                    ; Or Idle
    RTS                             ; Return to subroutine

PROCESS_RESTART:
    CMP.L   #Rkey,  CURRENT_KEY ; Is Current Key R
    BEQ     INITIALISE
    RTS                             ; Return to subroutine
*-----------------------------------------------------------
* Subroutine    : Update
* Description   : Main update loop update Player and Enemies
*-----------------------------------------------------------
UPDATE:
    ; Update the Players Positon based on Velocity and Gravity
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.L  PLYR_VELOCITY, D1       ; Fetch Player Velocity
    MOVE.L  PLYR_GRAVITY, D2        ; Fetch Player Gravity
    ADD.L   D2,         D1          ; Add Gravity to Velocity
    MOVE.L  D1,         PLYR_VELOCITY ; Update Player Velocity
    ADD.L   PLAYER_Y,   D1          ; Add Velocity to Player
    MOVE.L  D1,         PLAYER_Y    ; Update Players Y Position
    MOVE.L  D1,         ATTACK_Y 


    ; Move the Enemy
    CLR.L   D1                      ; Clear the contents of D0
    MOVE.L  ENEMY_X,    D1          ; Move the Enemy X Position to D0
    CMP.L   #00,        D1
    BLE     RESET_ENEMY_POSITION    ; Reset Enemy if off Screen
    BSR     MOVE_ENEMY              ; Move the Enemy

    ; Move flying enemy
    CLR.L   D1                      ; Clear the contents of D0
    MOVE.L  FLYINGENEMY_X,    D1          ; Move the Enemy X Position to D0
    CMP.L   #00,        D1
    BLE     RESET_FLYENEMY_POSITION    ; Reset Enemy if off Screen

    CMP.L   #00,        HEALTH_X
    BLE     RESET_HEALTH_POSITION
    BSR     MOVE_HEALTHPACK

    EOR.L   D1,D1
    MOVE.W  WIDTH,D1
    CMP.W   Z,D1
    BGE     RESET_TREE
    BSR     MOVE_TREE

    BSR     CHECK_ATTACK_COOLDOWN

    TST.W   ATTACK_TIME
    BNE     ATTACK_TIME_SUB
    MOVE.B  #00,        CURRENTLYATTACKING
    MOVE.L  #480,        ATTACK_Y

    RTS                             ; Return to subroutine  

CHECK_ATTACK_COOLDOWN:
    CMP.W   #0, ATTACK_COOLDOWN
    BGT     ATTACK_COOLDOWN_SUB
    RTS

ATTACK_TIME_SUB:
    SUB.W   #02,        ATTACK_TIME
    RTS   
ATTACK_COOLDOWN_SUB:
    SUB.W   #02,        ATTACK_COOLDOWN
    RTS                            

MOVE_PLAYER_LEFT:
    MOVE.B  #LOOKLEFT,        PLAYER_DIR
    MOVE.L  PLAYER_X,   D1          ; Fetch Player X Position
    SUB.L   #02,        D1          ; Move Player Left
    MOVE.L  D1,         PLAYER_X    ; Update Players X Position
    SUB.L   #02,        ATTACK_X
    RTS                             ; Return to subroutine    

MOVE_PLAYER_RIGHT:
    MOVE.B  #LOOKRIGHT,        PLAYER_DIR
    MOVE.L  PLAYER_X,   D1          ; Fetch Player X Position
    ADD.L   #02,        D1          ; Move Player Right
    MOVE.L  D1,         PLAYER_X    ; Update Players X Position
    ADD.L   #02,        ATTACK_X
    RTS                             ; Return to subroutine

RESET_TREE:
    MOVE.W  #640,Z
    RTS

MOVE_TREE:
    SUB.W  #01,Z
    RTS

MOVE_HEALTHPACK:
    SUB.L   #02,        HEALTH_X
    RTS

*-----------------------------------------------------------
* Subroutine    : Move Enemy
* Description   : Move Enemy Right to Left
*-----------------------------------------------------------
MOVE_ENEMY:
    LEA     LEVELS,      A2
    MOVE.L  PLAYER_SCORE,   D5
    MOVE.L  (A2)+,       D6
    CMP.L   D6,   D5
    BGT     MOVE_ENEMY_L4
    MOVE.L  (A2)+,       D6
    CMP.L   D6,   D5
    BGT     MOVE_ENEMY_L3
    MOVE.L  (A2)+,       D6
    CMP.L   D6,   D5
    BGT     MOVE_ENEMY_L2
    SUB.L   #03,        FLYINGENEMY_X
    SUB.L   #02,        ENEMY_X     ; Move enemy by X Value
    RTS

MOVE_ENEMY_L2:
    SUB.L   #03,        FLYINGENEMY_X
    SUB.L   #04,        ENEMY_X     ; Move enemy by X Value
    MOVE.B  #03,        POINTS
    RTS

MOVE_ENEMY_L3:
    SUB.L   #07,        FLYINGENEMY_X
    SUB.L   #05,        ENEMY_X     ; Move enemy by X Value
    MOVE.B  #05,        POINTS
    RTS

MOVE_ENEMY_L4:
    SUB.L   #10,        FLYINGENEMY_X
    SUB.L   #08,        ENEMY_X     ; Move enemy by X Value
    MOVE.B  #10,        POINTS
    RTS
*-----------------------------------------------------------
* Subroutine    : Reset Enemy
* Description   : Reset Enemy if to passes 0 to Right of Screen
*-----------------------------------------------------------
RESET_ENEMY_POSITION:
    CLR.L   D1       
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    MOVE.L  D1,         ENEMY_Y     ; Enemy Y Position
    MOVE.B  #0,         ENEMY_HIT

    EOR.L  D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    MOVE.L  D1,         ENEMY_X     ; Enemy X Position
    RTS

RESET_FLYENEMY_POSITION:
    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    SUB.W   #60,        D1
    MOVE.L  D1,         FLYINGENEMY_Y     ; Enemy Y Position
    MOVE.B  #0,         FLYENEMY_HIT

    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    MOVE.L  D1,         FLYINGENEMY_X     ; FLY Enemy X Position
    RTS
    
RESET_HEALTH_POSITION:
    MOVE.B  #01,        DRAW_HEALTHPACKS
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    MOVE.L  D1,         HEALTH_X     ; healthpack X Position
    RTS

CONTINUE:
    RTS

PERFORM_ATTACK:
    TST.W    ATTACK_COOLDOWN
    BNE      CONTINUE
    
    MOVE.B   #01, CURRENTLYATTACKING
    MOVE.W   #50, ATTACK_TIME
    MOVE.W   #76, ATTACK_COOLDOWN

    MOVE.L   PLAYER_X,ATTACK_X
    ADDI.L   #PLYR_W_INIT,ATTACK_X
    MOVE.L   PLAYER_Y,ATTACK_Y
    ;SUBI.L   #PLYR_H_INIT-20,ATTACK_Y
*-----------------------------------------------------------
* Subroutine    : Draw
* Description   : Draw Screen
*-----------------------------------------------------------
DRAW: 
    ; Enable back buffer
    MOVE.B  #TC_REDRAW,        D0
    TRAP    #15

    ; Clear the screen
    MOVE.B	#TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W	#$FF00,     D1          ; Clear contents
    TRAP    #15                     ; Trap (Perform action)

    MOVE.B  #1,D1
    MOVE.B  #93,D0
    TRAP    #15
    BSR     DRAW_BACKGROUND         
    BSR     DRAW_PLYR_DATA          ; Draw Draw Score, HUD, Player X and Y
    BSR     DRAW_PLAYER             ; Draw Player
    BSR     DRAW_ENEMY              ; Draw Enemy
    BSR     DRAW_FLYENEMY
    BSR     DRAW_HEALTHPACK
    BSR     DRAW_FLOOR              ; Draw Floor
    RTS                             ; Return to subroutine


DRAW_BACKGROUND:
    CLR.L       D1
    MOVE.L      #SKY,D1
    MOVE.B      #81,D0
    TRAP        #15

    MOVE.L      #00, D1
    MOVE.L      #00, D2
    MOVE.L      #89, D0
    TRAP        #15
    
    MOVE.L     #BROWN,D1
    MOVE.L     #$01110000,D2
    MOVE.B     #21,D0
    TRAP       #15
    

    EOR.L      D1,D1
    MOVE.B     #5,D2
    MOVE.W     #$300B,TRUNK
TREE_LOOP:
    MOVE.L     #TC_CURSR_P,D0
    MOVE.W     TRUNK,D1
    SUBQ.W      #01,TRUNK
    TRAP       #15
   
    LEA         TREET, A1
    MOVE.L      #14, D0
    TRAP        #15

    SUBQ.B      #01,D2
    CMP.B       #00,D2
    BNE         TREE_LOOP

    MOVE.L     #GREEN,D1
    MOVE.L     #$01110000,D2
    MOVE.B     #21,D0
    TRAP       #15

    MOVE.B     #5,D3
TREE_LEAVES_Y:
    MOVE.B     #$2D,TRUNK
    MOVE.B     #8,D2
TREE_LEAVES_X:
    MOVE.L     #TC_CURSR_P,D0
    MOVE.W     TRUNK,D1
    ADDQ.B     #01,TRUNK
    TRAP       #15
   
    MOVE.L      #$40, D1
    MOVE.L      #6, D0
    TRAP        #15

    SUBQ.B      #01,D2
    CMP.B       #00,D2
    BNE         TREE_LEAVES_X
    SUB.B       #01,D3
    SUB.W       #01,TRUNK
    CMP.B       #00,D3
    BNE         TREE_LEAVES_Y
    RTS
*-----------------------------------------------------------
* Subroutine    : Draw Player Data
* Description   : Draw Player X, Y, Velocity, Gravity and OnGround
*-----------------------------------------------------------
DRAW_PLYR_DATA:
    EOR.L   D1,D1                      ; Clear contents of D1 (XOR is faster)
    EOR.L    D2,D2


    MOVE.L  #BLACK,     D1
    MOVE.B  #21,        D0          ; Set Text Color
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #SKY,       D1          ; Set Text Color
    MOVE.L  #81,        D0          ; Set Text Color
    TRAP    #15                     ; Trap (Perform action)

    ; Player Score Message
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0201,     D1          ; Col 02, Row 01
    TRAP    #15                     ; Trap (Perform action)
    LEA     SCORE_MSG,  A1          ; Score Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)

    ; Player Score Value
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0901,     D1          ; Col 09, Row 01
    TRAP    #15                     ; Trap (Perform action)
    MOVE.B  #03,        D0          ; Display number at D1.L
    MOVE.L  PLAYER_SCORE,D1         ; Move Score to D1.L
    TRAP    #15                     ; Trap (Perform action)
    
    ; Player X Message
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0202,     D1          ; Col 02, Row 02
    TRAP    #15                     ; Trap (Perform action)
    LEA     X_MSG,      A1          ; X Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)
    
    ; Player X
    MOVE.B  #TC_CURSR_P, D0          ; Set Cursor Position
    MOVE.W  #$0502,     D1          ; Col 05, Row 02
    TRAP    #15                     ; Trap (Perform action)
    MOVE.B  #03,        D0          ; Display number at D1.L
    MOVE.L  HEALTH_X,   D1          ; Move X to D1.L
    TRAP    #15                     ; Trap (Perform action)
    
    ; Player Y Message
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1002,     D1          ; Col 10, Row 02
    TRAP    #15                     ; Trap (Perform action)
    LEA     Y_MSG,      A1          ; Y Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)
    
    ; Player Y
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1202,     D1          ; Col 12, Row 02
    TRAP    #15                     ; Trap (Perform action)
    MOVE.B  #03,        D0          ; Display number at D1.L
    MOVE.L  FLYINGENEMY_Y,   D1          ; Move X to D1.L
    TRAP    #15                     ; Trap (Perform action) 

    ; Player Velocity Message
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0203,     D1          ; Col 02, Row 03
    TRAP    #15                     ; Trap (Perform action)
    LEA     V_MSG,      A1          ; Velocity Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)
    
    ; Player Velocity
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0503,     D1          ; Col 05, Row 03
    TRAP    #15                     ; Trap (Perform action)
    MOVE.B  #03,        D0          ; Display number at D1.L
    MOVE.L  PLYR_VELOCITY,D1        ; Move X to D1.L
    TRAP    #15                     ; Trap (Perform action)
    
    ; Player Gravity Message
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1003,     D1          ; Col 10, Row 03
    TRAP    #15                     ; Trap (Perform action)
    LEA     VARMSG,      A1          ; G Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)
    
    ; Player Gravity
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1903,     D1          ; Col 12, Row 03
    TRAP    #15                     ; Trap (Perform action)
    MOVE.B  #03,        D0          ; Display number at D1.L
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.B  ATTACK_COOLDOWN,D1         ; Move Gravity to D1.L
    TRAP    #15                     ; Trap (Perform action)

    ; Player On Ground Message
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0204,     D1          ; Col 10, Row 03
    TRAP    #15                     ; Trap (Perform action)
    LEA     GND_MSG,    A1          ; On Ground Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)
    
    ; Player On Ground
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1504,     D1          ; Col 06, Row 04
    TRAP    #15                     ; Trap (Perform action)
    MOVE.B  #03,        D0          ; Display number at D1.L
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.B  ENEMIES_DEFEATED,     D1          ; Move Play on Ground ? to D1.L
    TRAP    #15                     ; Trap (Perform action)

    ; Show Keys Pressed
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$2001,     D1          ; Col 20, Row 1
    TRAP    #15                     ; Trap (Perform action)
    LEA     KEYCODE_MSG, A1         ; Keycode
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)

    ; Show KeyCode
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$3001,     D1          ; Col 30, Row 1
    TRAP    #15                     ; Trap (Perform action)    
    MOVE.L  CURRENT_KEY,D1          ; Move Key Pressed to D1
    MOVE.B  #03,        D0          ; Display the contents of D1
    TRAP    #15                     ; Trap (Perform action)

    ; Show Lives msg
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0207,     D1          ; Col 02, Row 06
    TRAP    #15                     ; Trap (Perform action)
    LEA     LIVES_MSG,   A1          ; Draw
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)  
    
    ; Show Lives msg
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0A07,     D1          ; Col 30, Row 1
    TRAP    #15                     ; Trap (Perform action)   
    EOR.L   D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.B  LIVES,      D1          ; Move Key Pressed to D1
    MOVE.B  #03,        D0          ; Display the contents of D1
    TRAP    #15                     ; Trap (Perform action)

    RTS
*-----------------------------------------------------------
* Subroutine    : Player is on Ground
* Description   : Check if the Player is on or off Ground
*-----------------------------------------------------------
IS_PLAYER_ON_GND:
    ; Check if Player is on Ground
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    CLR.L   D2                      ; Clear contents of D2 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1  
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    MOVE.L  PLAYER_Y,   D2          ; Player Y Position
    CMP     D1,         D2          ; Compare middle of Screen with Players Y Position 
    BGE     SET_ON_GROUND           ; The Player is on the Ground Plane
    BLT     SET_OFF_GROUND          ; The Player is off the Ground
    RTS                             ; Return to subroutine


*-----------------------------------------------------------
* Subroutine    : On Ground
* Description   : Set the Player On Ground
*-----------------------------------------------------------
SET_ON_GROUND:
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    MOVE.L  D1,         PLAYER_Y    ; Reset the Player Y Position
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.L  #00,        D1          ; Player Velocity
    MOVE.L  D1,         PLYR_VELOCITY ; Set Player Velocity
    MOVE.L  #GND_TRUE,  PLYR_ON_GND ; Player is on Ground
    RTS

*-----------------------------------------------------------
* Subroutine    : Off Ground
* Description   : Set the Player Off Ground
*-----------------------------------------------------------
SET_OFF_GROUND:
    MOVE.L  #GND_FALSE, PLYR_ON_GND ; Player if off Ground
    RTS                             ; Return to subroutine
*-----------------------------------------------------------
* Subroutine    : Jump
* Description   : Perform a Jump
*-----------------------------------------------------------
JUMP:
    CMP.L   #GND_TRUE,PLYR_ON_GND   ; Player is on the Ground ?
    BEQ     PERFORM_JUMP            ; Do Jump
    BRA     JUMP_DONE               ;
PERFORM_JUMP:
    BSR     PLAY_JUMP               ; Play jump sound
    MOVE.L  #PLYR_JUMP_V,PLYR_VELOCITY ; Set the players velocity to true
    RTS                             ; Return to subroutine
JUMP_DONE:
    RTS                             ; Return to subroutine

*-----------------------------------------------------------
* Subroutine    : Idle
* Description   : Perform a Idle
*----------------------------------------------------------- 
IDLE:
    RTS                             ; Return to subroutine

*-----------------------------------------------------------
* Subroutines   : Sound Load and Play
* Description   : Initialise game sounds into memory 
* Current Sounds are RUN, JUMP and Opps for Collision
*-----------------------------------------------------------
GAMEOVER_LOAD:
    LEA     GAMEOVER_WAV,    A1          ; Load Wav File into A1
    MOVE    #GAMEOVER_INDEX, D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

PLAY_GAMEOVER:
    MOVE    #GAMEOVER_INDEX, D1          ; Load Sound INDEX
    MOVE    #75,        D0          ; Play Sound
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

JUMP_LOAD:
    LEA     JUMP_WAV,   A1          ; Load Wav File into A1
    MOVE    #JMP_INDEX, D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

PLAY_JUMP:
    MOVE    #JMP_INDEX, D1          ; Load Sound INDEX
    MOVE    #75,        D0          ; Play Sound
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

HITHURT_LOAD:
    LEA     HITHURT_WAV,   A1          ; Load Wav File into A1
    MOVE    #HITHURT_INDEX,D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

PLAY_HITHURT:
    MOVE    #HITHURT_INDEX,D1          ; Load Sound INDEX
    MOVE    #75,        D0          ; Play Sound
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

POWERUP_LOAD:
    LEA     POWERUP_WAV,   A1          ; Load Wav File into A1
    MOVE    #POWERUP_INDEX,D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

PLAY_POWERUP:
    MOVE    #POWERUP_INDEX,D1          ; Load Sound INDEX
    MOVE    #75,        D0          ; Play Sound
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

LVLCHANGE_LOAD:
    LEA     LEVELCHANGE_WAV,   A1          ; Load Wav File into A1
    MOVE    #LEVELCHANGE_INDEX,D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

PLAY_LVLCHANGE:
    MOVE    #LEVELCHANGE_INDEX,D1          ; Load Sound INDEX
    MOVE    #75,        D0          ; Play Sound
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

*-----------------------------------------------------------
* Subroutine    : Draw Player
* Description   : Draw Player Square
*-----------------------------------------------------------
DRAW_PLAYER:
    ; Set Pixel Colors
    MOVE.L  #BLACK,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)
    ; Reset Pixel Colors
    MOVE.L  #BLACK,     D1          ; Set Background color
    MOVE.B  #81,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    ; Set X, Y, Width and Height
    MOVE.L  PLAYER_X,   D1          ; X
    MOVE.L  PLAYER_Y,   D2
    
    MOVE.L  PLAYER_X,   D3
    EOR.L   D4,D4
    MOVE.B   PLAYER_WIDTH,   D4      ; Width
    ADD.L   D4,D3
    MOVE.L  PLAYER_Y,   D4 
    SUB.B   PLAYER_HEIGHT,   D4      ; Height          ; Y
    
    ; Draw Player
    MOVE.B  #87,        D0          ; Draw Player
    TRAP    #15                     ; Trap (Perform action)
    TST.B   CURRENTLYATTACKING
    BNE     DRAW_ATTACK
    RTS                             ; Return to subroutine

DRAW_ATTACK:

    ; Set Pixel Colors
    MOVE.L  #WHITE,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)
    ; Reset Pixel Colors
    MOVE.L  #WHITE,     D1          ; Set Background color
    MOVE.B  #81,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  ATTACK_X,   D1          ; X
    MOVE.L  ATTACK_Y,   D2
    
    MOVE.L  ATTACK_X,   D3
    ADD.L   #ATTACK_WIDTH,   D3      ; Width
    MOVE.L  ATTACK_Y,   D4 
    SUB.L   #ATTACK_HEIGHT,   D4      ; Height          ; Y
    
    ; Draw Player
    MOVE.B  #87,        D0          ; Draw Player
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

*-----------------------------------------------------------
* Subroutine    : Draw Enemy
* Description   : Draw Enemy Square
*-----------------------------------------------------------
DRAW_ENEMY:
    ; Set Pixel Colors
    MOVE.L  ENEMYCOLOR,       D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    ; Reset Pixel Colors
    MOVE.L  ENEMYCOLOR,     D1          ; Set Background color
    MOVE.B  #81,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    ; Set X, Y, Width and Height
    MOVE.L  ENEMY_X,    D1          ; X
    MOVE.L  ENEMY_Y,    D2          ; Y
    MOVE.L  ENEMY_X,    D3
    ADD.W   ENEMY_WIDTH,   D3      ; Width
    MOVE.L  ENEMY_Y,    D4 
    SUB.W   ENEMY_HEIGHT,   D4      ; Height
    
    ; Draw Enemy    
    MOVE.B  #87,        D0          ; Draw Enemy
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

DRAW_FLYENEMY:
    ; Set Pixel Colors
    MOVE.L  FLYENEMYCOLOR,       D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    ; Reset Pixel Colors
    MOVE.L  FLYENEMYCOLOR,     D1          ; Set Background color
    MOVE.B  #81,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    ; Set X, Y, Width and Height
    MOVE.L  FLYINGENEMY_X,    D1          ; X
    MOVE.L  FLYINGENEMY_Y,    D2          ; Y
    MOVE.L  FLYINGENEMY_X,    D3
    ADD.W   FLYENEMY_WIDTH,   D3      ; Width
    MOVE.L  FLYINGENEMY_Y,    D4 
    SUB.W   FLYENEMY_HEIGHT,   D4      ; Height
    
    ; Draw Enemy    
    MOVE.B  #87,        D0          ; Draw Enemy
    TRAP    #15                     ; Trap (Perform action)
    RTS  

DRAW_HEALTHPACK:

    CMP.B   #00,     SPAWN_HEALTHPACKS
    BEQ     DRAW_HEALTHPACK_DONE
    CMP.B   #00,     DRAW_HEALTHPACKS
    BEQ     DRAW_HEALTHPACK_DONE
    
    ;BSR     RANDOM_NUMBER
    ;CMP.L   #$80,  D1
    ;BGT     DRAW_HEALTHPACK_DONE

    MOVE.B  #01,        DRAW_HEALTHPACKS
    MOVE.W  SCREEN_H,     D1
    DIVU.W    #02,        D1
    AND.L   #$0000FFFF,   D1
    MOVE.L  D1,         HEALTH_Y
    ; Set Pixel Colors
    MOVE.L  #BLACK,       D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    ; Reset Pixel Colors
    MOVE.L  #LIFEGREEN,     D1          ; Set Background color
    MOVE.B  #81,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    ; Set X, Y, Width and Height
    MOVE.L  HEALTH_X,    D1          ; X
    MOVE.L  HEALTH_Y,    D2          ; Y
    MOVE.L  HEALTH_X,    D3
    ADD.L   #HEALTH_PACK_W,   D3      ; Width
    MOVE.L  HEALTH_Y,    D4 
    SUB.L   #HEALTH_PACK_H,   D4      ; Height
    
    ; Draw Enemy    
    MOVE.B  #87,        D0          ; Draw Enemy
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

DRAW_HEALTHPACK_DONE:
    MOVE.L  #-1, HEALTH_Y
    RTS

DRAW_FLOOR:
    ; Set Pixel Colors
    MOVE.L  #GREEN,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #GREEN,     D1
    MOVE.B  #81,        D0
    TRAP    #15

    
    ; Set X, Y, X2, and Y2
    MOVE.L  #0,   D1          ; X
    MOVE.L  #241,  D2          ; Y
    MOVE.L  #640,   D3           
    MOVE.L  #480,   D4 
    
    ; Draw grass
    MOVE.B  #87,        D0          ; Draw Line
    TRAP    #15                     ; Trap (Perform action)

    ; Set Pixel Colors
    MOVE.L  #BROWN,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #BROWN,     D1
    MOVE.B  #81,        D0
    TRAP    #15

* -----------------------------------------------------------
* Find level and draw dirt
* -----------------------------------------------------------
    LEA     LEVELS,      A2
    MOVE.L  PLAYER_SCORE,   D5
    ;CMP.L   (A2)+,       D5
    ;BGT     DRAW_FLOOR_L5
    ;CMP.L   (A2)+,       D5
    ;BGT     DRAW_FLOOR_L4
    ;CMP.L   (A2)+,       D5
    ;BGT     DRAW_FLOOR_L3
    ;CMP.L   (A2)+,       D5
    ;BGT     DRAW_FLOOR_L2
    BRA     DRAW_FLOOR_L1

DRAW_FLOOR_L5:
    MOVE.W  #12,SCALER
    MOVE.L  #480,   D2          ; Y
    ;MOVE.L  #135, FLYINGENEMY_Y
    ;MOVE.W  #40, FLYENEMY_HEIGHT
    ;MOVE.W  #65, FLYENEMY_WIDTH
    ;MOVE.W  #40, ENEMY_HEIGHT
    ;MOVE.W  #40, ENEMY_WIDTH
    BRA     DRAWDIRT
    
DRAW_FLOOR_L4:
    MOVE.W  #10,SCALER
    MOVE.L  #480,   D2          ; Y
    ;MOVE.L  #140, FLYINGENEMY_Y
    ;MOVE.W  #45, FLYENEMY_HEIGHT
    ;MOVE.W  #55, FLYENEMY_WIDTH
    ;MOVE.W  #30, ENEMY_HEIGHT
    ;MOVE.W  #30, ENEMY_WIDTH
    BRA     DRAWDIRT
DRAW_FLOOR_L3:
    MOVE.W  #8,SCALER
    MOVE.L  #430,   D2          ; Y
    ;MOVE.L  #160, FLYINGENEMY_Y
    ;MOVE.W  #25, FLYENEMY_HEIGHT
    ;MOVE.W  #35, FLYENEMY_WIDTH
    ;MOVE.W  #25, ENEMY_HEIGHT
    ;MOVE.W  #25, ENEMY_WIDTH
    BRA     DRAWDIRT
DRAW_FLOOR_L2:
    MOVE.W  #6,SCALER
    MOVE.L  #330,   D2          ; Y
    MOVE.L  #170, FLYINGENEMY_Y
    MOVE.W  #15, FLYENEMY_HEIGHT
    MOVE.W  #25, FLYENEMY_WIDTH
    MOVE.W  #15, ENEMY_HEIGHT
    MOVE.W  #15, ENEMY_WIDTH

    BRA     DRAWDIRT
DRAW_FLOOR_L1:
    MOVE.L  #277,   D2          ; Y
    BRA     DRAWDIRT
DRAWDIRT:
    ; Set X, Y, X2, and Y2
    MOVE.L  #0,   D1          ; X
    MOVE.L  #640,   D3           
    MOVE.L  #480,   D4 
    
    ; Draw Dirt
    MOVE.B  #87,        D0          ; Draw Line
    TRAP    #15                     ; Trap (Perform action)


    ; Reset Pixel Colors
    MOVE.L  #$00000000,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    ; Reset Pixel Colors
    MOVE.L  #$00000000,     D1          ; Set Background color
    MOVE.B  #81,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    RTS                             ; Return to subroutine

*-----------------------------------------------------------
* Subroutine    : Collision Check
* Description   : Axis-Aligned Bounding Box Collision Detection
* Algorithm checks for overlap on the 4 sides of the Player and 
* Enemy rectangles
* PLAYER_X <= ENEMY_X + ENEMY_W &&
* PLAYER_X + PLAYER_W >= ENEMY_X &&
* PLAYER_Y <= ENEMY_Y + ENEMY_H &&
* PLAYER_H + PLAYER_Y >= ENEMY_Y
*-----------------------------------------------------------
CHECK_COLLISIONS:

    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2
PLAYER_X_LTE_TO_ENEMY_X_PLUS_W:
    MOVE.L  PLAYER_X,   D1          ; Move Player X to D1
    ADD.B   PLAYER_WIDTH,D1          ; Move Player Width to D1
    MOVE.L  ENEMY_X,    D2          ; Move Enemy X to D2
    CMP.L   D1,         D2          ; Do the Overlap ?
    BLE     PLAYER_X_PLUS_W_LTE_TO_ENEMY_X  ; Less than or Equal ?
    BRA     CHECK_FLYENEMY_COLLISIONS

PLAYER_X_PLUS_W_LTE_TO_ENEMY_X:     ; Check player is not  
    MOVE.L  PLAYER_X,   D1          ; Move Player X to D1
    MOVE.L  ENEMY_X,    D2          ; Move Enemy X to D2
    ADD.W   ENEMY_WIDTH,D2          ; Set Enemy width X + Width
    CMP.L   D1,         D2          ; Do they OverLap ?
    BGE     PLAYER_Y_LTE_TO_ENEMY_Y_PLUS_H  ; Less than or Equal
    BRA     CHECK_FLYENEMY_COLLISIONS  

PLAYER_Y_LTE_TO_ENEMY_Y_PLUS_H:     
    MOVE.L  PLAYER_Y,   D1          ; Move Player Y to D1
    MOVE.L  ENEMY_Y,    D2          ; Move Enemy Y to D2
    ADD.W   ENMY_H_INIT,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BLE     PLAYER_Y_PLUS_H_LTE_TO_ENEMY_Y  ; Less than or Equal
    BRA     CHECK_FLYENEMY_COLLISIONS

PLAYER_Y_PLUS_H_LTE_TO_ENEMY_Y:     ; Less than or Equal ?
    ADD.B   PLYR_H_INIT,D1          ; Add Player Height to D1
    MOVE.L  ENEMY_Y,    D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BGE     COLLISION               ; Collision !
    BRA     CHECK_FLYENEMY_COLLISIONS

*--------------------Checking for flying enemy collision---------------------
CHECK_FLYENEMY_COLLISIONS:
    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2
PLX_LTE_TO_FLYENEMY_X_PLUS_W:
    MOVE.L  PLAYER_X,   D1
    ADD.B   PLAYER_WIDTH,D1          ; Move Player Width to D1
    MOVE.L  FLYINGENEMY_X,    D2                    ; Move Enemy X to D2
    CMP.L   D1,         D2                          ; Do the Overlap ?
    BLE     PLX_PLUS_W_LTE_TO_FLYENEMY_X      ; Less than or Equal ?
    BRA     CHECK_HEALTH_COLLISIONS

PLX_PLUS_W_LTE_TO_FLYENEMY_X:           ; Check player is not  
    MOVE.L  PLAYER_X,   D1
    MOVE.L  FLYINGENEMY_X,    D2            ; Move Enemy X to D2
    ADD.W   FLYENEMY_WIDTH,  D2                    ; Set Enemy width X + Width
    CMP.L   D1,         D2                  ; Do they OverLap ?
    BGE     PLY_LTE_TO_FLYENEMY_Y_PLUS_H  ; Less than or Equal
    BRA     CHECK_HEALTH_COLLISIONS

PLY_LTE_TO_FLYENEMY_Y_PLUS_H:     
    MOVE.L  PLAYER_Y,   D1          ; Move Player Y to D1
    MOVE.L  FLYINGENEMY_Y,    D2          ; Move Enemy Y to D2
    ADD.W   FLYENEMY_HEIGHT,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BGE     PLY_PLUS_H_LTE_TO_FLYENEMY_Y  ; Less than or Equal
    BRA     CHECK_HEALTH_COLLISIONS

PLY_PLUS_H_LTE_TO_FLYENEMY_Y:     ; Less than or Equal ?
    ADD.B   PLAYER_HEIGHT,D1          ; Add Player Height to D1
    MOVE.L  FLYINGENEMY_Y,    D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BLE     COLLISION               ; Collision !
    BRA     CHECK_HEALTH_COLLISIONS

*--------------------Checking for Health collision---------------------
CHECK_HEALTH_COLLISIONS:
    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2
PLX_LTE_TO_HEALTH_X_PLUS_W:
    MOVE.L  PLAYER_X,   D1
    ADD.B   PLAYER_WIDTH,D1          ; Move Player Width to D1
    MOVE.L  HEALTH_X,    D2                    ; Move Enemy X to D2
    CMP.L   D1,         D2                          ; Do the Overlap ?
    BLE     PLX_PLUS_W_LTE_TO_HEALTH_X      ; Less than or Equal ?
    BRA     CHECK_ATTACK_COLLISIONS

PLX_PLUS_W_LTE_TO_HEALTH_X:           ; Check player is not  
    MOVE.L  PLAYER_X,   D1
    MOVE.L  HEALTH_X,    D2            ; Move Enemy X to D2
    ADD.L   #HEALTH_PACK_W,  D2                    ; Set Enemy width X + Width
    CMP.L   D1,         D2                  ; Do they OverLap ?
    BGE     PLY_LTE_TO_HEALTH_Y_PLUS_H  ; Less than or Equal
    BRA     CHECK_ATTACK_COLLISIONS
PLY_LTE_TO_HEALTH_Y_PLUS_H:     
    MOVE.L  PLAYER_Y,   D1          ; Move Player Y to D1
    MOVE.L  HEALTH_Y,    D2          ; Move Enemy Y to D2
    ADD.L   #HEALTH_PACK_H,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BGE     PLY_PLUS_H_LTE_TO_HEALTH_Y  ; Less than or Equal
    BRA     CHECK_ATTACK_COLLISIONS

PLY_PLUS_H_LTE_TO_HEALTH_Y:     ; Less than or Equal ?
    ADD.B   PLAYER_HEIGHT,D1          ; Add Player Height to D1
    MOVE.L  HEALTH_Y,    D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BLE     HEALTH_COLLISION               ; Collision !
    BRA     CHECK_ATTACK_COLLISIONS

*--------------------Checking for ATTACK collision---------------------
CHECK_ATTACK_COLLISIONS:
    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2
ATTACK_X_LTE_TO_ENEMY_X_PLUS_W:
    MOVE.L  ATTACK_X,   D1
    ADD.L   #ATTACK_WIDTH,D1          ; Move Player Width to D1
    MOVE.L  ENEMY_X,    D2                    ; Move Enemy X to D2
    CMP.L   D1,         D2                          ; Do the Overlap ?
    BLE     ATTACK_PLUS_W_LTE_TO_ENMY_X      ; Less than or Equal ?
    BRA     CHECK_ATTACK_FLY_COLLISIONS

ATTACK_PLUS_W_LTE_TO_ENMY_X:           ; Check player is not  
    MOVE.L  ATTACK_X,   D1
    MOVE.L  ENEMY_X,    D2            ; Move Enemy X to D2
    ADD.W   ENEMY_WIDTH,  D2                    ; Set Enemy width X + Width
    CMP.L   D1,         D2                  ; Do they OverLap ?
    BGE     ATK_LTE_TO_ENEMY_Y_PLUS_H  ; Less than or Equal
    BRA     CHECK_ATTACK_FLY_COLLISIONS

ATK_LTE_TO_ENEMY_Y_PLUS_H:     
    MOVE.L  ATTACK_Y,   D1          ; Move Player Y to D1
    MOVE.L  ENEMY_Y,    D2          ; Move Enemy Y to D2
    ADD.W   ENEMY_HEIGHT,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BGE     ATK_PLUS_H_LTE_TO_ATTACK_Y  ; Less than or Equal
    BRA     CHECK_ATTACK_FLY_COLLISIONS

ATK_PLUS_H_LTE_TO_ATTACK_Y:     ; Less than or Equal ?
    ADD.L   #ATTACK_Y,D1          ; Add Player Height to D1
    MOVE.L  ENEMY_Y,    D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BLE     ATTACK_COLLISION               ; Collision !
    BRA     CHECK_ATTACK_FLY_COLLISIONS

*--------------------Checking for ATTACK FLYING collision---------------------
CHECK_ATTACK_FLY_COLLISIONS:
    CLR.L   D1                      ; Clear D1
    CLR.L   D2                      ; Clear D2
ATK_X_LTE_TO_FLYENEMY_X_PLUS_W:
    MOVE.L  ATTACK_X,   D1
    ADD.L   #ATTACK_WIDTH,D1          ; Move Player Width to D1
    MOVE.L  FLYINGENEMY_X,    D2                    ; Move Enemy X to D2
    CMP.L   D1,         D2                          ; Do the Overlap ?
    BLE     ATTACK_PLUS_W_LTE_TO_FLYENMY_X     ; Less than or Equal ?
    BRA     COLLISION_CHECK_DONE

ATTACK_PLUS_W_LTE_TO_FLYENMY_X:           ; Check player is not  
    MOVE.L  ATTACK_X,   D1
    MOVE.L  FLYINGENEMY_X,    D2            ; Move Enemy X to D2
    ADD.W   FLYENEMY_WIDTH,  D2                    ; Set Enemy width X + Width
    CMP.L   D1,         D2                  ; Do they OverLap ?
    BGE     ATK_LTE_TO_FLYENEMY_Y_PLUS_H  ; Less than or Equal
    BRA     COLLISION_CHECK_DONE

ATK_LTE_TO_FLYENEMY_Y_PLUS_H:     
    MOVE.L  ATTACK_Y,   D1          ; Move Player Y to D1
    MOVE.L  FLYINGENEMY_Y,    D2          ; Move Enemy Y to D2
    ADD.W   FLYENEMY_HEIGHT,D2          ; Set Enemy Height to D2
    CMP.L   D1,         D2          ; Do they Overlap ?
    BGE     ATK_PLUS_H_LTE_TO_FLYENEMY_Y  ; Less than or Equal
    BRA     COLLISION_CHECK_DONE

ATK_PLUS_H_LTE_TO_FLYENEMY_Y:     ; Less than or Equal ?
    ADD.L   #ATTACK_Y,D1          ; Add Player Height to D1
    MOVE.L  FLYINGENEMY_Y,    D2          ; Move Enemy Height to D2  
    CMP.L   D1,         D2          ; Do they OverLap ?
    BLE     ATTACK_FLY_COLLISION               ; Collision !
    BRA     COLLISION_CHECK_DONE

;---

ATTACK_COLLISION:
    MOVE.L  #400, ENEMY_Y
    MOVE.B  #01,  ENEMY_HIT
    ADDI.B  #1,   ENEMIES_DEFEATED
    RTS

ATTACK_FLY_COLLISION:
    MOVE.L  #400, FLYINGENEMY_Y
    MOVE.B  #01,  FLYENEMY_HIT
    ADDI.B  #1,   ENEMIES_DEFEATED
    RTS

COLLISION_CHECK_DONE:               ; No Collision Update points
    CLR.B   IN_ENEMY
    CLR.B   IN_HPACK
    CLR.L   D1
    MOVE.B  POINTS,    D1          ; Move points upgrade to D1
    ADD.L   PLAYER_SCORE,D1         ; Add to current player score
    MOVE.L  D1, PLAYER_SCORE        ; Update player score in memory
    RTS                             ; Return to subroutine


COLLISION:
    CMP.B     #$01, IN_ENEMY
    BEQ     STILL_COLLIDED
    CMP.B   #01, DRAW_HEALTHPACKS
    BNE     RESET_HEALTH_POSITION
    MOVE.B  #01, DRAW_HEALTHPACKS 
    MOVE.B  #01, SPAWN_HEALTHPACKS 
    SUB.B   #1, LIVES
    MOVE.B  #$01, IN_ENEMY
    TST.B   LIVES
    BEQ     GAME_OVER
    BSR     PLAY_HITHURT               ; Play Opps Wav
    RTS                             ; Return to subroutine

HEALTH_COLLISION:
    CMP.B     #$01, IN_HPACK
    BEQ     STILL_COLLIDED
    MOVE.B  #00, DRAW_HEALTHPACKS
    BSR     PLAY_POWERUP               ; Play Opps Wav
    ADD.B   #1, LIVES
    CMP.B   #05, LIVES
    BGE     STOP_HPACK_SPAWN
    MOVE.B  #$01, IN_HPACK
    RTS

STOP_HPACK_SPAWN:
    MOVE.B  #00, SPAWN_HEALTHPACKS
    RTS

STILL_COLLIDED:
    RTS
*-----------------------------------------------------------
* Subroutine    : EXIT
* Description   : Exit message and End Game
*-----------------------------------------------------------

GAME_OVER:
    BSR     DRAW                    ; Redraw the Scene
    MOVE.B  #TC_REDRAW,        D0
    TRAP    #15
    BSR     PLAY_GAMEOVER
    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)

    MOVE.L  #WHITE,     D1
    MOVE.B  #21,        D0          ; Set Text Color
    MOVE.L  #$01130005, D2
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #BLACK,     D1
    MOVE.B  #81,        D0          ; Set Text Color
    TRAP    #15                     ; Trap (Perform action)

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$FF00,     D1          ; Fill Screen Clear
    TRAP	#15                     ; Trap (Perform action)

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1005,     D1          ; Col 10, Row 03
    TRAP    #15                     ; Trap (Perform action)
    LEA     GAMEOVER_MSG,A1        ; Game Over Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)

    ; Player Score Message
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0F06,     D1          ; Col 02, Row 01
    TRAP    #15                     ; Trap (Perform action)
    LEA     SCORE_MSG,  A1          ; Score Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)

    ; Player Score Value
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1706,     D1          ; Col 09, Row 01
    TRAP    #15                     ; Trap (Perform action)
    MOVE.B  #03,        D0          ; Display number at D1.L
    MOVE.L  PLAYER_SCORE,D1         ; Move Score to D1.L
    TRAP    #15                     ; Trap (Perform action)
    

    MOVE.L  #WHITE,     D1
    MOVE.B  #21,        D0          ; Set Text Color
    MOVE.L  #$03140000, D2
    TRAP    #15                     ; Trap (Perform action)


    ; Restart
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0B08,     D1          ; Col 09, Row 01
    TRAP    #15                     ; Trap (Perform action)
    LEA     RESTART_MSG,  A1          ; Score Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)

    
    MOVE.B  #TC_REDRAW,        D0
    TRAP    #15

INPUTLOOP:
    BSR     INPUT
    BRA     INPUTLOOP

EXIT:
    
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$FF00,     D1          ; Fill Screen Clear
    TRAP	#15                     ; Trap (Perform action)

    MOVE.B  #TC_REDRAW,        D0
    TRAP    #15

    MOVE.B  #TC_EXIT,   D0          ; Exit Code
    TRAP    #15                     ; Trap (Perform action)
    SIMHALT

*-----------------------------------------------------------
* Section       : Messages
* Description   : Messages to Print on Console, names should be
* self documenting
*-----------------------------------------------------------
SCORE_MSG       DC.B    'Score : ', 0       ; Score Message
KEYCODE_MSG     DC.B    'KeyCode : ', 0     ; Keycode Message
JUMP_MSG        DC.B    'Jump....', 0       ; Jump Message

IDLE_MSG        DC.B    'Idle....', 0       ; Idle Message
UPDATE_MSG      DC.B    'Update....', 0     ; Update Message
DRAW_MSG        DC.B    'Draw....', 0       ; Draw Message

X_MSG           DC.B    'X:', 0             ; X Position Message
Y_MSG           DC.B    'Y:', 0             ; Y Position Message
V_MSG           DC.B    'V:', 0             ; Velocity Position Message
VARMSG           DC.B    'DRAW', 0             ; Gravity Position Message
GND_MSG         DC.B    'ENEMIES DEFEATED:', 0           ; On Ground Position Message

EXIT_MSG        DC.B    'Exiting....', 0    ; Exit Message
GAMEOVER_MSG    DC.B    'Game Over!', 0      ; Game Over Message
RESTART_MSG    DC.B    'Press R to play again', 0      ; Game Over Message
TREET          DC.B     '##',0

PRESSSTART      DC.B    'Enter 1 to start',0
TITLEMSG        DC.B    'ANT DEFENDER',0
LIVES_MSG       DC.B    'Lives : ',0        ; lives message

IN_ENEMY        DC.B      00                  ; marker for if the player is in the enemy
IN_HPACK        DC.B      00                  ; marker for if the player is in the health pack
DRAW_HEALTHPACKS   DC.B  $00                  ; marker for if the healthpacks are showing
SPAWN_HEALTHPACKS   DC.B  $00                  ; marker for if the healthpacks are spawning

LEVEL_02        DC.W    2000
LEVEL_03        DC.W    10000

LEVELS:         DC.L    7000,4000,2000,1000

*-----------------------------------------------------------
* Section       : Screen Size
* Description   : Screen Width and Height
*-----------------------------------------------------------
SCREEN_W        DS.W    01  ; Reserve Space for Screen Width
SCREEN_H        DS.W    01  ; Reserve Space for Screen Height

*-----------------------------------------------------------
* Section       : Keyboard Input
* Description   : Used for storing Keypresses
*-----------------------------------------------------------
CURRENT_KEY     DS.L    01  ; Reserve Space for Current Key Pressed
LAST_KEY        DS.W    01  ; Reserve Space for Current Key Pressed

*-----------------------------------------------------------
* Section       : Character Positions
* Description   : Player and Enemy Position Memory Locations
*-----------------------------------------------------------
PLAYER_X        DS.L    01  ; Reserve Space for Player X Position
PLAYER_Y        DS.L    01  ; Reserve Space for Player Y Position
PLAYER_SCORE    DS.L    01  ; Reserve Space for Player Score

PLYR_VELOCITY   DS.L    01  ; Reserve Space for Player Velocity
PLYR_GRAVITY    DS.L    01  ; Reserve Space for Player Gravity
PLYR_ON_GND     DS.L    01  ; Reserve Space for Player on Ground

; 1, = left, 0 = right
PLAYER_DIR      DS.B    01  ; Reserve Space for Player Direction

ENEMY_X         DS.L    01  ; Reserve Space for Enemy X Position
ENEMY_Y         DS.L    01  ; Reserve Space for Enemy Y Position

HEALTH_X         DS.L    01  ; Reserve Space for Health+ X Position
HEALTH_Y         DS.L    01  ; Reserve Space for Health Y Position

FLYINGENEMY_X         DS.L    01  ; Reserve Space for Flying Enemy X Position
FLYINGENEMY_Y         DS.L    01  ; Reserve Space for Flying Enemy Y Position

ENEMYCOLOR        DC.L        $000000FF
FLYENEMYCOLOR     DC.L        $00FF0000

RANDOM            DS.L        01  ; Reserve Space for Random Number
LIVES             DC.B        05  ; reserves space for player lives
 
POINTS            DC.B        02          ; Points added

CURRENTLYATTACKING   DC.B    00
ATTACK_COOLDOWN      DC.W    00
ATTACK_TIME          DC.W    00
ATTACK_X             DC.L    00
ATTACK_Y             DC.L    00
ATTACK_HEIGHT        EQU     20
ATTACK_WIDTH         EQU     35 

ENEMIES_DEFEATED     DC.B    00
ENEMY_HIT           DC.B    00
FLYENEMY_HIT        DC.B    00

* Widths and heights of player, enemy and healthpack
*-----------------------------------------------------------
PLAYER_WIDTH      DC.B        12          ; Player Width
PLAYER_HEIGHT     DC.B        12          ; Player Height

ENEMY_WIDTH       DC.W        12          ; Enemy Width
ENEMY_HEIGHT      DC.W        12          ; Enemy Height

FLYENEMY_WIDTH    DC.W        20 
FLYENEMY_HEIGHT   DC.W        12 

        
*-----------------------------------------------------------
* Section       : Sounds
* Description   : Sound files, which are then loaded and given
* an address in memory, they take a longtime to process and play
* so keep the files small. Used https://voicemaker.in/ to 
* generate and Audacity to convert MP3 to WAV
*-----------------------------------------------------------
JUMP_WAV        DC.B    'jump.wav',0        ; Jump Sound
GAMEOVER_WAV         DC.B    'gameOver.wav',0         ; Run Sound
HITHURT_WAV        DC.B    'hitHurt.wav',0        ; Collision Opps
POWERUP_WAV        DC.B    'powerUP.wav',0        ; Collision Opps
LEVELCHANGE_WAV        DC.B    'levelChange.wav',0        ; Collision Opps

*---*
TRUNK   DC.W    $3A0C
X   DC.W    200
Y   DC.W    400
Z   DC.W    200
SCALER DC.W  4
ROWC    EQU    16
WIDTH   DC.W    $FFB0

title
	dc.b	'tree2.bmp',0
list
	dc.b	'*.bmp',0				* file type list
	ds.w	0					* ensure even


timer           DC.L    0
SPRITE_DATA:
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~