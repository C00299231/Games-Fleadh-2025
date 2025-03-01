DRAW_ENEMY:
    ; Set Pixel Colors
    MOVE.L  #RED,       D1          ; Set pen color
    MOVE.B  #80,        D0          ; Task for pen Color
    TRAP    #15                     ; Trap (Perform action)

    ; Reset Pixel Colors
    MOVE.L  #colorRed,     D1          ; Set Background color
    MOVE.B  #81,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    *-------------- draw ENEMY body -----------------*
    MOVE.L  ENEMY_X,   D1          ; X
    MOVE.L  ENEMY_Y,   D2
    SUBQ.L  #4,D2

    MOVE.L  ENEMY_X,   D3
    ADD.L   #ENMY_W_INIT, D3  
    MOVE.L  ENEMY_Y,   D4
    SUB.L   #ENMY_H_INIT,   D4      ; Height          ; Y
    
     ; Draw 
    MOVE.B  #87,        D0          ; Draw enemy
    TRAP    #15                     ; Trap (Perform action)

*-------------- draw ENEMY abdomen -----------------*
    MOVE.L  ENEMY_X,   D1          ; X
    MOVE.L  D1,   D3
    ADD.L   #ENMY_W_INIT,D1
    MOVE.L  ENEMY_Y,   D2
    SUBQ.L  #4,D2
    MOVE.L  ENEMY_X,   D3
    ADDI.L   #12,D3
    
    MOVE.L  ENEMY_Y,   D4
    SUB.L   #ENMY_H_INIT,   D4      ; Height          ; Y
    SUB.B   #3,D4
    
    ; Draw 
    MOVE.B  #87,        D0          ; Draw enemy
    TRAP    #15                     ; Trap (Perform action)

*-------------- draw ENEMY antena -----------------*    
    ; change thickness
    MOVE.l  #3,D1
    MOVE.B  #93,D0
    TRAP    #15

    MOVE.L  ENEMY_X,D1
    ADD.L   #3,D1
    MOVE.L  ENEMY_Y,D2
    SUB.L   #ENMY_H_INIT,D2
    MOVE.L  D1,D3
    SUB.L   #10,D3
    MOVE.L  D2,D4
    SUBI.L  #7,D4

    MOVE.B  #84,D0
    TRAP    #15

*-------------- draw ENEMY leg 1 -----------------*
    MOVE.L  ENEMY_X,D1
    MOVE.L  ENEMY_Y,D2
    MOVE.L  D1,D3
    ADD.L   #4,D3
    MOVE.L  D2,D4
    SUBI.L  #4,D4

    MOVE.B  #84,D0
    TRAP    #15

*-------------- draw ENEMY leg 2 -----------------*
    MOVE.L  ENEMY_X,D1
    ADD.L   #13,D1
    MOVE.L  ENEMY_Y,D2
    MOVE.L  D1,D3
    MOVE.L  D2,D4
    SUBI.L  #4,D4

    MOVE.B  #84,D0
    TRAP    #15

*-------------- draw ENEMY leg 3 -----------------*
    MOVE.L  ENEMY_X,D1
    ADD.L   #22,D1
    MOVE.L  ENEMY_Y,D4
    MOVE.L  D1,D3
    ADD.L   #3,D3
    MOVE.L  D4,D2
    SUBI.L  #4,D2

    MOVE.B  #84,D0
    TRAP    #15

    ; Set Pixel Colors
    MOVE.L  #BLACK,     D1          ; Set Pen color
    MOVE.B  #80,        D0          ; Task for Pen Color
    TRAP    #15                     ; Trap (Perform action)

*-------------- draw ENEMY eye -----------------*
    ; change thickness
    MOVE.l  #3,D1
    MOVE.B  #93,D0
    TRAP    #15

    MOVE.L  ENEMY_X,D1
    ADD.L   #3,D1
    MOVE.L  ENEMY_Y,D2
    SUB.L   #10,D2
    MOVE.L  D1,D3
    ADDQ.L  #1,D3
    MOVE.L  D2,D4

    MOVE.B  #84,D0
    TRAP    #15

    ; reset pen
    MOVE.l  #1,D1
    MOVE.B  #93,D0
    TRAP    #15

    RTS                             ; Return to subroutine


DRAW_BRUTEENEMY:
    ; Set Pixel Colors
    MOVE.L  #RED,       D1          ; Set pen color
    MOVE.B  #80,        D0          ; Task for pen Color
    TRAP    #15                     ; Trap (Perform action)

    ; Reset Pixel Colors
    MOVE.L  #colorRed,     D1          ; Set Background color
    TST.B   BRUTE_HIT
    IF <NE> THEN        ; brute is hit
        MOVE.L  #RED,     D1          ; Set Background color
    ENDI

    MOVE.B  #81,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)
    *-------------- draw BRUTE body -----------------*
    MOVE.L  BRUTE_X,   D1          ; X
    MOVE.L  BRUTE_Y,   D2
    SUBQ.L  #4,D2

    MOVE.L  BRUTE_X,   D3
    ADD.L   #BRUTE_W_INIT, D3  
    MOVE.L  BRUTE_Y,   D4
    SUB.L   #BRUTE_H_INIT,   D4      ; Height          ; Y
    
     ; Draw 
    MOVE.B  #87,        D0          ; Draw BRUTE
    TRAP    #15                     ; Trap (Perform action)

*-------------- draw BRUTE abdomen -----------------*
    MOVE.L  BRUTE_X,   D1          ; X
    MOVE.L  D1,   D3
    ADD.L   #BRUTE_W_INIT,D1
    MOVE.L  BRUTE_Y,   D2
    SUBQ.L  #5,D2
    MOVE.L  BRUTE_X,   D3
    ADDI.L   #22,D3
    
    MOVE.L  BRUTE_Y,   D4
    SUB.L   #BRUTE_H_INIT,   D4      ; Height          ; Y
    SUB.B   #3,D4
    
    ; Draw 
    MOVE.B  #87,        D0          ; Draw BRUTE
    TRAP    #15                     ; Trap (Perform action)

*-------------- draw BRUTE antena -----------------*    
    ; change thickness
    MOVE.l  #4,D1
    MOVE.B  #93,D0
    TRAP    #15

    MOVE.L  BRUTE_X,D1
    ADD.L   #3,D1
    MOVE.L  BRUTE_Y,D2
    SUB.L   #BRUTE_H_INIT,D2
    MOVE.L  D1,D3
    SUB.L   #10,D3
    MOVE.L  D2,D4
    SUBI.L  #8,D4

    MOVE.B  #84,D0
    TRAP    #15

*-------------- draw BRUTE leg 1 -----------------*
    MOVE.L  BRUTE_X,D1
    MOVE.L  BRUTE_Y,D2
    MOVE.L  D1,D3
    ADD.L   #4,D3
    MOVE.L  D2,D4
    SUBI.L  #5,D4

    MOVE.B  #84,D0
    TRAP    #15

*-------------- draw BRUTE leg 2 -----------------*
    MOVE.L  BRUTE_X,D1
    ADD.L   #20,D1
    MOVE.L  BRUTE_Y,D2
    MOVE.L  D1,D3
    MOVE.L  D2,D4
    SUBI.L  #5,D4

    MOVE.B  #84,D0
    TRAP    #15

*-------------- draw BRUTE leg 3 -----------------*
    MOVE.L  BRUTE_X,D1
    ADD.L   #32,D1
    MOVE.L  BRUTE_Y,D4
    MOVE.L  D1,D3
    ADD.L   #3,D3
    MOVE.L  D4,D2
    SUBI.L  #5,D2

    MOVE.B  #84,D0
    TRAP    #15

    ; Set Pixel Colors
    MOVE.L  #BLACK,     D1          ; Set Pen color
    MOVE.B  #80,        D0          ; Task for Pen Color
    TRAP    #15                     ; Trap (Perform action)

*-------------- draw BRUTE eye -----------------*
    ; change thickness
    MOVE.l  #3,D1
    MOVE.B  #93,D0
    TRAP    #15

    MOVE.L  BRUTE_X,D1
    ADD.L   #4,D1
    MOVE.L  BRUTE_Y,D2
    SUB.L   #13,D2
    MOVE.L  D1,D3
    ADDQ.L  #1,D3
    MOVE.L  D2,D4

    MOVE.B  #84,D0
    TRAP    #15

    ; reset pen
    MOVE.l  #1,D1
    MOVE.B  #93,D0
    TRAP    #15

    RTS                             ; Return to subroutine
