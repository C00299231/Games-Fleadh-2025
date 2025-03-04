*-----------------------------------------------------------
* Title      : battle view 
* Written by : Oliwier Jakubiec
* Date       : 05/02/2025
* Description: battle main file
*-----------------------------------------------------------

*-----------------------------------------------------------
* Subroutine    : Initialise battle
* Description   : Initialise game data into memory such as 
* sounds and screen size
*-----------------------------------------------------------
INITRUN:
    move.w #2, lvlType
    
    BSR     stop_song
    BSR     BATTLE_SONG_LOAD

    bsr PLAY_SONG

    ; Set up Screen Size
    MOVE.B  #TC_SCREEN, D0          ; access screen information
    MOVE.L  #TC_S_SIZE, D1          ; placing 0 in D1 triggers loading screen size information
    TRAP    #15                     ; interpret D0 and D1 for screen size
    MOVE.W  D1,         SCREEN_H    ; place screen height in memory location
    SWAP    D1                      ; Swap top and bottom word to retrive screen size
    MOVE.W  D1,         SCREEN_W    ; place screen width in memory location

    ; init player
    BSR     INIT_PLAYER
    BSR     initThrow
    
    ; Initial Position for Enemy
    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    ADD.L   #100,D1
    MOVE.L  D1,         ENEMY_X     ; Enemy X Position

    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    MOVE.L  D1,         ENEMY_Y     ; Enemy Y Position

    ; Initial Position for Flying Enemy
    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    ADD.L   #100,D1
    MOVE.L  D1,         FLYINGENEMY_X     ; flying Enemy X Position

    EOR.L     D1,D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    SUB.W   #60,        D1          ; sub to move y pos up
    MOVE.L  D1,         FLYINGENEMY_Y     ; flying Enemy Y Position
    
    ; Initial Position for Health pack
    MOVE.L  #380,         HEALTH_X     ; health X Position
    MOVE.L  #90,         HEALTH_Y     ; health Y Position

    ; Initial health x y
    MOVE.B  maxAntHp,        antHealth

    ; reset draw and spawn health to 0
    MOVE.B  #00,        DRAW_HEALTHPACKS
    MOVE.B  #00,        SPAWN_HEALTHPACKS

    ; move attack x and y to 0,0
    MOVE.L  #0,         ATTACK_X
    MOVE.L  #0,         ATTACK_Y
    
    ; set booleans to false
    MOVE.B  #00,        CURRENTLYATTACKING
    MOVE.B  #00,        ENEMY_HIT
    MOVE.B  #00,        FLYENEMY_HIT

    ; set up the wave enemies count
    ADD.B   #enemyPerWave,         enemiesToDefeat
    MOVE.B  #0,         ENEMIES_DEFEATED
    MOVE.B  #0,         enemiesPassed
    MOVE.B  #4,         backToMapCount
    
    ; move the current hill no. hp into this hill hp
    MOVE.B  (a6),   hillHP
    
    MOVE.B     #100,    hillHP
    
    ; Init brute
    ; Initial Position for BRUTE
    EOR.L     D1,D1                      ; Clear contents of D1 
    MOVE.W  SCREEN_W,   D1          ; Place Screen width in D1
    ADD.L   #100,D1
    MOVE.L  D1,         BRUTE_X     

    EOR.L     D1,D1                      ; Clear contents of D1 
    MOVE.W  SCREEN_H,   D1          ; Place Screen width in D1
    DIVU    #02,        D1          ; divide by 2 for center on Y Axis
    MOVE.L  D1,         BRUTE_Y     

    ; reset brute bools
    MOVE.B      #0,     BRUTE_DEAD          
    MOVE.B      #0,     BRUTE_HIT           
    MOVE.B      #3,     BRUTE_HP            

    ; Enable the screen back buffer
    MOVE.B  #TC_DBL_BUF,D0          ; 92 Enables Double Buffer
    MOVE.B  #17,        D1          ; Combine Tasks
    TRAP	#15                     ; Trap (Perform action)
        
    ; Clear the screen 
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$FF00,     D1          ; Fill Screen Clear
    TRAP	#15                     ; Trap (Perform action)

    bra gameloop

*-----------------------------------------------------------
* Subroutine    : Game
* Description   : Game including main GameLoop. GameLoop is like
* a while loop in that it runs forever until interupted
* (Input, Update, Draw). 
*-----------------------------------------------------------
GAME:

GAMELOOP:

    MOVEQ		#8,d0				* get time in 1/100 ths seconds
	TRAP		#15

	MOVE.l	d1,-(sp)			* push time on the stack
    MOVE.l	(sp)+,d7			* restore time in 1/100 ths from stack
    jsr wait_100ms
    bra continueLoop

wait_100ms:
	MOVEQ		#8,d0				* get time in 1/100 ths seconds
	TRAP		#15

	SUB.l		d7,d1				* subtract previous time from current time
	CMP.b		#$02,d1			    * compare with 2/100ths
	BMI.s		wait_100ms			* loop if time not up yet
    rts

continueLoop:   ; after wait is done
    BSR     BATTLEINPUT                   ; Check Keyboard Input
    BSR     checkPaused             ; check if the game is paused
    BSR     UPDATE                  ; Update positions 
    BSR     IS_PLAYER_ON_GND        ; Check if player is on ground
    BSR     CHECK_COLLISIONS        ; Check for Collisions
    BSR     DRAWBATTLE                  ; Draw the Scene
                
    BRA     GAMELOOP    ; Loop back to GameLoop
    
*-----------------------------------------------------------
* Subroutine    : Input
* Description   : Process Keyboard Input
*-----------------------------------------------------------
BATTLEINPUT:
    move.l CURRENT_KEY, D0
    move.l D0,lastkey 

    MOVE.B  #TC_KEYCODE, D0             ; Check for pressed keys      
    MOVE.L  #runActionKeys, D1          ; Check for A, D, K, and Spacebar
    TRAP    #15                         ; Trap (Perform action)
    ; returns the FF in the position of the pressed keys in d1
    MOVE.L  D1,         CURRENT_KEY     ; Put Current Keys in Memory

    ; check if A is pressed
    BTST.L  #24,D1      ; bit test the 24th bit
    IF <NE> THEN        ; if its not 0 the move left
        BSR    MOVE_PLAYER_LEFT
    ENDI
    ; check if D is pressed
    MOVE.L  CURRENT_KEY, D1
    BTST.L  #16,D1
    IF <NE> THEN
        BSR    MOVE_PLAYER_RIGHT
    ENDI

    ; check if K is pressed
    MOVE.L  CURRENT_KEY, D1
    BTST.L  #8,D1
    IF <NE> THEN
        BSR    PERFORM_ATTACK
    ENDI

    ; check if space is pressed
    MOVE.L  CURRENT_KEY, D1
    BTST.L  #0,D1
    IF <NE> THEN
        BSR    JUMP
    ENDI

    ; seperate check for keys for other inputs that dont need to be check at the same time
    MOVE.B  #TC_KEYCODE, D0          ; Check for pressed keys
    MOVE.L  #$1B4a, D1                 ; check J
    TRAP    #15                     ; Trap (Perform action)
    MOVE.L  D1,         CURRENT_KEY     ; Put Current Key in Memory

    ; if j is pressed do thrown attack
    MOVE.L  CURRENT_KEY, D1
    BTST.L  #0,D1
    IF <NE> THEN
        BSR    PERFORM_THROW
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

    ; pause
    move.l  d2,         currentKey
    CMP.l   #escapekey,    currentKey ; Is Current Key Escape
    BEQ     escapePressed

    cmpi.l #key0, currentKey ; fullscreen
    beq key0pressed

    tst.b   isPaused
    bne     pausedInput

    RTS                             ; Return to subroutine

*----------
; check if still paused
checkPaused:
    TST.B  isPaused
    BNE    stillPaused
    RTS

; go back to game loop after drawing
stillPaused:
    BSR    DRAWBATTLE
    BRA    GAMELOOP

*-----------------------------------------------------------
* Subroutine    : Update
* Description   : Main update loop update Player and Enemies
*-----------------------------------------------------------
UPDATE:
    ; update player position
    include "battle/battleUpdate.x68"

*-----------------------------------------------------------
* Subroutine    : Draw
* Description   : Draw Screen
*-----------------------------------------------------------
DRAWBATTLE: 
    include "battle/drawBattle.x68"

*-----------------------------------------------------------
* Subroutine    : Draw Player
* Description   : Draw Player Ant
*-----------------------------------------------------------
    include "battle/playerAnt.X68"
*-----------------------------------------------------------
* Subroutine    : Draw Enemy
* Description   : Draw Enemy Ant
*-----------------------------------------------------------
    include "battle/battleEnemy.X68"

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
    include     "battle/battlecollisions.x68"     

*-----------------------------------------------------------
* Subroutine    : End of round
* Description   : checks how the wave concluded
*-----------------------------------------------------------

    include     "battle/endOfWave.x68"


*-----------------------------------------------------------
* Section       : Messages
* Description   : Messages to Print on Console, names should be
* self documenting
*-----------------------------------------------------------

ENEMIESDEAD_MSG         DC.B    'Enemies Defeated:', 0                  ; enemies defeated message
ENEMYCOUNT_MSG          DC.B    'Wave enemy count:', 0                  ; wave enemies message

HILLLOST_MSG            DC.B    'ANT HILL HAS BEEN OVERRUN!', 0         ; ant hill lost message
WIN_MSG                 DC.B    'THE ENEMY ARMY HAS BEEN DEFEATED!', 0  ; win message  
HILLDEFENDED_MSG        DC.B    'WAVE COMPLETE!', 0                     ; hill defended message
FALLENKINGDOM_MSG       DC.B    'YOUR ANT KINGDOM HAS FALLEN', 0        ; game over message
GAMEOVER_MSG            DC.B    'GAME OVER!', 0                         ; game over  
BACK_TO_MAP_MSG         DC.B    'Returning to map in ...', 0            ; return to map counter message

antHealth_MSG           DC.B    'Health : ',0                           ; health message
antsRem_MSG             DC.B    'Ants Remaining : ',0                   ; ants remaining message
hillHP_MSG              DC.B    'Hill Health: ',0                       ; hill health message
wave_MSG                DC.B    'Wave: ',0                              ; wave message

hillHP                  DC.B     100     
enemyPerWave            EQU      20            
IN_ENEMY                DC.B     00                  ; marker for if the player is in the enemy
IN_HPACK                DC.B     00                  ; marker for if the player is in the health pack
DRAW_HEALTHPACKS        DC.B     00                  ; marker for if the healthpacks are showing
SPAWN_HEALTHPACKS       DC.B     00                  ; marker for if the healthpacks are spawning


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
* Section       : Character Data
* Description   : Player and Enemy Position Memory Locations
*-----------------------------------------------------------

ENEMY_X         DS.L    01  ; Reserve Space for Enemy X Position
ENEMY_Y         DS.L    01  ; Reserve Space for Enemy Y Position

HEALTH_X         DS.L    01  ; Reserve Space for Health+ X Position
HEALTH_Y         DS.L    01  ; Reserve Space for Health Y Position

FLYINGENEMY_X         DS.L    01  ; Reserve Space for Flying Enemy X Position
FLYINGENEMY_Y         DS.L    01  ; Reserve Space for Flying Enemy Y Position

BRUTE_X          DS.L        01
BRUTE_Y          DS.L        01

ENMY_W_INIT      EQU         27          ; Enemy initial Width
ENMY_H_INIT      EQU         13          ; Enemy initial Height

FLY_ENMY_W_INIT  EQU         30          ; flying Enemy initial Width
FLY_ENMY_H_INIT  EQU         13          ; Enemy flying initial Height

BRUTE_W_INIT     EQU         50          ; BRute Enemy initial Width
BRUTE_H_INIT     EQU         25          ; Brute Enemy initial Height

HEALTH_PACK_W    EQU         12          ; Enemy initial Width
HEALTH_PACK_H    EQU         12          ; Enemy initial Height

ENEMY_HIT           DC.B    00
FLYENEMY_HIT        DC.B    00
BRUTE_DEAD          DC.B    00
BRUTE_HIT           DC.B    00
BRUTE_HP            DC.b    03

JUMP_WAV        DC.B    'sounds/jump.wav',0        
GAMEOVER_WAV    DC.B    'sounds/gameOver.wav',0    
HITHURT_WAV     DC.B    'sounds/hitHurt.wav',0     
HIT_WAV         DC.B    'sounds/hit.wav',0         
POWERUP_WAV     DC.B    'sounds/powerUP.wav',0     
ROAR_WAV        DC.B    'sounds/roar-8-bit.wav',0 
HILLHURT_WAV        DC.B    'sounds/hillHurt.wav',0 

; songs
BATTLE_SONG_WAV DC.B    'sounds/antopia-battle.wav',0
MAP_SONG_WAV    DC.B    'sounds/antopia-map.wav',0
MENU_SONG_WAV   dc.B    'sounds/antopia-menu.wav',0

; STINGS
LOSS_STING_WAV  DC.b    'sounds/antopia-loss-sting.wav',0
WIN_STING_WAV   DC.B    'sounds/antopia-win-sting.wav',0
wordOrder dc.b 0

*-----------------------------------------------------------
* Section       : health data
* Description   : health related data
*-----------------------------------------------------------
antHealth         DC.B        03  ; reserves space for antHealth
antsRemaining     DC.B        00  ; reserves space for ants
maxHillHp         EQU        100  ; set max hill hp
maxAntHp          DC.B        3   ; reserve space for max ant health
maxRemainingAnts         DC.B        5  ; reserve space for max ants remaining
totalHillsDefended       DC.b        0  ; space for hills defended

*-----------------------------------------------------------
* Section       : melee attack 
* Description   : data for melee attack 
*-----------------------------------------------------------
CURRENTLYATTACKING   DC.B    00     
ATTACK_COOLDOWN      DC.W    00
ATTACK_TIME          DC.W    00
ATTACK_X             DC.L    00
ATTACK_Y             DC.L    00
ATTACK_HEIGHT        EQU     20
ATTACK_WIDTH         EQU     35 

ENEMIES_DEFEATED    DC.B    00
enemiesPassed       DC.b    00
enemiesToDefeat     DC.B    00

; all timers and cooldowns
respawnTime             dc.W        0
backToMapCount          dc.b        3
healthCooldown          DC.W        0
hillHurtTimer           dc.b        0
timer                   DC.L        0
healthCooldownOver      DC.B        0

*---------- END---------------*





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
