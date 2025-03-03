*-----------------------------------------------------------
* Subroutine    : Draw game info
* Description   : Draw info about the current battle e.g. your hp, hill hp, ant remaining, etc.
*-----------------------------------------------------------
DRAW_HUD:
    BSR     DRAW_WAVE_DATA          ; Draw Draw Score, HUD, Player X and Y
    BSR     drawHillHealth          ; draw hill hp
    BSR     drawAntHealth           ; ants health bar
    BSR     drawAntsRemaining       ; ants remaining bar
    RTS


DRAW_WAVE_DATA:
    EOR.L   D1,D1                      ; Clear contents of D1 
    EOR.L    D2,D2

    ; set font and back ground color
    MOVE.L  #deepgreen,D1
    MOVE.B  #tcFont,D0
    MOVE.L  #$00120000,D2
    TRAP    #15

    MOVE.L  #SKY,D1
    MOVE.B  #tcPenFil,D0
    TRAP    #15

* ------Current wave-------*
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0100,     D1          ; col 01, Row 00
    TRAP    #15                     ; Trap (Perform action)
    LEA     wave_MSG,   A1          
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)  
    
    ; Show wave num msg
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0A00,     D1          ; col 10, Row 0
    TRAP    #15                     ; Trap (Perform action)   
    EOR.L   D1,D1                      ; Clear contents of D1 
    MOVE.W  lvlIndex,      D1          ; Move Key Pressed to D1
    ADD.B   #1,D1
    MOVE.B  #03,        D0          ; Display the contents of D1
    TRAP    #15                     ; Trap (Perform action)

* ------Enemies defeated wave-------*
    MOVE.L  #deepgreen,D1
    MOVE.B  #tcFont,D0
    MOVE.L  #$00090000,D2
    TRAP    #15

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0203,     D1          ; col $02, Row 03 
    TRAP    #15                     ; Trap (Perform action)
    LEA     ENEMIESDEAD_MSG,    A1        
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)
    
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1703,     D1          ; col $17, Row 03
    TRAP    #15                     ; Trap (Perform action)
    MOVE.B  #03,        D0          ; Display number at D1.L
    CLR.L   D1                      ; Clear contents of D1 
    MOVE.B  ENEMIES_DEFEATED,     D1          ; Move Play on Ground ? to D1.L
    TRAP    #15                     ; Trap (Perform action)
    
* ------Enemies to defeat wave-------*

    ; number of enemies in wave msg
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0202,     D1          ; col $2, Row 02
    TRAP    #15                     ; Trap (Perform action)
    LEA     ENEMYCOUNT_MSG,    A1          
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)
    
    ; number of enemies in wave 
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1702,     D1          ; col $17, Row 02
    TRAP    #15                     ; Trap (Perform action)
    CLR.L   D1                      ; Clear contents of D1 
    MOVE.B  enemiesToDefeat,     D1          
    MOVE.B  #03,        D0          ; Display number at D1.L
    TRAP    #15                     ; Trap (Perform action)

    jsr drawBattlePrompts

    RTS
; draw hill health bar
drawHillHealth:
    move.l  #10,        D1          
    move.l  #425,       D2
    move.l  #440,       D4
    clr.l   d5
    clr.l   d6
    move.l     #maxHillHp,  d5
    move.b     hillHP, D6
    mulu.w  #2,d5
    mulu.w  #2,d6
    BSR     drawModularHbar         ; set d registers and run the draw bar subroutine
        
    ; set font 
    MOVE.L  #color5,D1
    MOVE.B  #tcFont,D0
    MOVE.L  #00090000,D2
    TRAP    #15

    ;set background 
    MOVE.L  #deepgreen,D1
    MOVE.B  #tcPenFil,D0
    TRAP    #15

    ; print hill health msg
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$021B,     D1          ; col 2 row 1b
    TRAP    #15                     ; Trap (Perform action)
    LEA     hillHP_MSG,  A1          ; Score Message
    bsr     print

    RTS

; draw the ants health bar
drawAntHealth:
    move.l  #10,        D1
    move.l  #335,       D2
    move.l  #350,       D4
    clr.l   d5
    clr.l   d6
    move.b     maxAntHp,  d5
    move.b     antHealth, D6
    mulu.w  #50,d5
    mulu.w  #50,d6
    BSR     drawModularHbar     ; set d registers and run the draw bar subroutine
        
    MOVE.L  #color5,D1
    MOVE.B  #tcFont,D0
    MOVE.L  #00090000,D2
    TRAP    #15

    MOVE.L  #deepgreen,D1
    MOVE.B  #tcPenFil,D0
    TRAP    #15

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0215,     D1           02, Row 01
    TRAP    #15                     ; Trap (Perform action)
    LEA     antHealth_MSG,  A1          
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)

    RTS

; draw ants remaining bar
drawAntsRemaining:
    move.l  #10,        D1
    move.l  #380,       D2
    move.l  #395,       D4
    clr.l   d5
    clr.l   d6
    move.b     maxRemainingAnts,  d5
    move.b     antsRemaining, D6
    mulu.w  #40,d5
    mulu.w  #40,d6
    BSR     drawModularHbar     ; set d registers and run the draw bar subroutine
        
    MOVE.L  #color5,D1
    MOVE.B  #tcFont,D0
    MOVE.L  #00090000,D2
    TRAP    #15

    MOVE.L  #deepgreen,D1
    MOVE.B  #tcPenFil,D0
    TRAP    #15

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0218,     D1           02, Row 01
    TRAP    #15                     ; Trap (Perform action)
    LEA     antsRem_MSG,  A1         
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)

    RTS