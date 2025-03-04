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

    ; draw everything
    BSR     DRAW_BACKGROUND         ; background
    BSR     DRAW_HILL               ; ant hill
    BSR     DRAW_TREES              ; tree
    BSR     DRAW_ENTRANCE_HOLE      ; entrance to ant hill
    BSR     DRAW_ENEMY              ; Draw Enemy
    BSR     DRAW_FLYENEMY           ; flying enemy
    BSR     DRAW_BRUTEENEMY         ; brute
    BSR     DRAW_HEALTHPACK         ; health apple
    BSR     DRAW_ENTRANCE           ; entrance the overlaps entrance hole
    BSR     DRAW_PLAYER             ; Draw Player
    BSR     DRAW_FLOOR              ; Draw Floor
    BSR     DRAW_HUD                ; Draw hud
    bsr     drawAchievement
    BSR     drawPause               ; draw if paused
    RTS                             ; Return to subroutine


DRAW_HILL:
    ; Set Pixel Colors
    MOVE.L  #brown,     D1
    jsr SetPenColour

    MOVE.L  #DIRT,     D1          ; Set Background color
    jsr setFillColour

    ; darken the hill if its hurt
    CMP.B   #0, hillHurtTimer
    IF <NE> THEN
     
        MOVE.L  #red,     D1          ; Set Background color
        jsr setFillColour
    ENDI

    ; leftmost chunk
    ; Set X, Y, X2, and Y2
    MOVE.L  #0,   D1          ; X
    MOVE.L  #241,  D2          ; Y
    MOVE.L  #30,   D3           
    MOVE.L  #120,   D4     
    
    MOVE.B  #87,        D0          ; Draw 
    TRAP    #15                     ; Trap (Perform action)
    
    ; second chunk
     ; Set X, Y, X2, and Y2
    MOVE.L  #0,   D1          ; X
    MOVE.L  #241,  D2          ; Y
    MOVE.L  #60,   D3           
    MOVE.L  #135,   D4 
    
    
    MOVE.B  #87,        D0          ; Draw
    TRAP    #15                     ; Trap (Perform action)

    ; third chunk
     ; Set X, Y, X2, and Y2
    MOVE.L  #0,   D1          ; X
    MOVE.L  #241,  D2          ; Y
    MOVE.L  #80,   D3           
    MOVE.L  #150,   D4 
    
    
    MOVE.B  #87,        D0          ; Draw 
    TRAP    #15                     ; Trap (Perform action)

    ; last chunk
     ; Set X, Y, X2, and Y2
    MOVE.L  #0,   D1          ; X
    MOVE.L  #241,  D2          ; Y
    MOVE.L  #100,   D3           
    MOVE.L  #200,   D4 
    
    
    MOVE.B  #87,        D0          ; Draw 
    TRAP    #15                     ; Trap (Perform action)

    ; change color for top entrance
    MOVE.L  #BLACK,     D1
    MOVE.B  #81,        D0
    TRAP    #15
    MOVE.L  #BLACK,     D1
    MOVE.B  #80,        D0
    TRAP    #15

    ; Set X, Y, X2, and Y2
    MOVE.L  #5,   D1          ; X
    MOVE.L  #130,  D2          ; Y
    MOVE.L  #25,   D3           
    MOVE.L  #120,   D4     

    
    MOVE.B  #87,        D0          ; Draw 
    TRAP    #15                     ; Trap (Perform action)

    RTS

; draw hill entrance
DRAW_ENTRANCE:
    ; Set Pixel Colors
    MOVE.L  #DIRT,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #DIRT,     D1
    MOVE.B  #81,        D0
    TRAP    #15

    ; if the hill is hurt then change the color
    CMP.B   #0, hillHurtTimer
    IF <NE> THEN
            ; Set Pixel Colors
        MOVE.L  #MIDBROWN,     D1          ; Set Background color
        MOVE.B  #80,        D0          ; Task for Background Color
        TRAP    #15                     ; Trap (Perform action)

        MOVE.L  #MIDBROWN,     D1
        MOVE.B  #81,        D0
        TRAP    #15
    ENDI

    ; Set X, Y, X2, and Y2
    MOVE.L  #1,   D1          ; X
    MOVE.L  #241,  D2          ; Y
    MOVE.L  #5,   D3           
    MOVE.L  #210,   D4     
    
    MOVE.B  #87,        D0          ; Draw 
    TRAP    #15                     ; Trap (Perform action)

    RTS

DRAW_ENTRANCE_HOLE:
    ; Set Pixel Colors
    MOVE.L  #BLACK,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #BLACK,     D1
    MOVE.B  #81,        D0
    TRAP    #15

    ; Set X, Y, X2, and Y2
    MOVE.L  #5,   D1          ; X
    MOVE.L  #241,  D2          ; Y
    MOVE.L  #20,   D3           
    MOVE.L  #211,   D4     
    
    MOVE.B  #87,        D0          ; Draw 
    TRAP    #15                     ; Trap (Perform action)
    RTS


; draw the background
DRAW_BACKGROUND:
    ; fill the sky 
    MOVE.L      #SKY,D1
    MOVE.B      #81,D0
    TRAP        #15

    MOVE.L      #00, D1
    MOVE.L      #00, D2
    MOVE.L      #89, D0
    TRAP        #15
    
    MOVE.L     #brown,D1
    MOVE.L     #$01110000,D2
    MOVE.B     #21,D0
    TRAP       #15

    RTS

; draw the tree
DRAW_TREES:
    
    ; set pen width
    MOVE.L  #1,D1
    MOVE.L  #93,D0
    TRAP    #15
    
    ; Set Pixel Colors
    MOVE.L  #trunko,     D1          ; Set Background color
    jsr setPenColour

    MOVE.L  #TRUNKO,     D1
    jsr setFillColour
    
    ; left trunk
    MOVE.L  #330,D1
    MOVE.L  #241,D2
    MOVE.L  #340,D3
    MOVE.L  #137,D4
    
    MOVE.B  #84,D0
    TRAP    #15
    
    ;top trunk
    MOVE.L  #368,D1
    MOVE.L  D4,D2
    MOVE.B  #85,D0
    TRAP    #15
    
    ; right trunk
    MOVE.L  #375,D1
    MOVE.L  #241,D2
    MOVE.B  #85,D0
    TRAP    #15
    
    ; bottom of trunk
    MOVE.L  #330,D1
    MOVE.L  #241,D2
    MOVE.B  #85,D0
    TRAP    #15
    
    ; fill in trunk of tree
    MOVE.L  #TRUNKI,     D1
    jsr setFillColour
    
    MOVE.L  #340,D1
    MOVE.L  #160,D2
    MOVE.B  #89,D0
    TRAP    #15
   
   ; reset pen size
    MOVE.L  #1,D1
    MOVE.L  #93,D0
    TRAP    #15

   ; Set Pixel Colors
    MOVE.L  #green1,     D1          ; Set Background color
    jsr setPenColour

    MOVE.L  #GREEN1,     D1
    jsr setFillColour

    ; draw leaves 1
    MOVE.L  #303,D1
    MOVE.L  #33,D2
    MOVE.L  #391,D3
    MOVE.L  #118,D4
    MOVE.B  #87,D0
    TRAP    #15

    ; draw leaves 2
    MOVE.L  #GREEN2,     D1
    MOVE.B  #81,        D0
    TRAP    #15

    MOVE.L  #338,D1
    MOVE.L  #42,D2
    MOVE.L  #427,D3
    MOVE.L  #133,D4
    MOVE.B  #87,D0
    TRAP    #15

    ; draw leaves 3
    MOVE.L  #GREEN3,     D1
    MOVE.B  #81,        D0
    TRAP    #15

    MOVE.L  #284,D1
    MOVE.L  #65,D2
    MOVE.L  #368,D3
    MOVE.L  #150,D4
    MOVE.B  #87,D0
    TRAP    #15

    ; draw leaves 4
    MOVE.L  #GREEN4,     D1
    MOVE.B  #81,        D0
    TRAP    #15

    MOVE.L  #340,D1
    MOVE.L  #76,D2
    MOVE.L  #423,D3
    MOVE.L  #158,D4
    MOVE.B  #87,D0
    TRAP    #15

    RTS

; draw the health 
DRAW_HEALTHPACK:

    TST.B   healthCooldownOver         ; check if the cooldown is over
    BEQ     DRAW_HEALTHPACK_DONE
    CMP.B   #00,     SPAWN_HEALTHPACKS  ; check if health pack is spawning
    BEQ     DRAW_HEALTHPACK_DONE
    CMP.B   #00,     DRAW_HEALTHPACKS   ; check if to draw the health
    BEQ     DRAW_HEALTHPACK_DONE
    
    ; Set Pixel Colors
    MOVE.L  #RED,       D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    ; Reset Pixel Colors
    MOVE.L  #RED,     D1          ; Set Background color
    MOVE.B  #81,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    ; Set X, Y, Width and Height
    MOVE.L  HEALTH_X,    D1          ; X
    MOVE.L  HEALTH_Y,    D2          ; Y
    MOVE.L  D1,    D3
    ADD.L   #HEALTH_PACK_W,   D3      ; Width
    MOVE.L  D2,    D4 
    SUB.L   #HEALTH_PACK_H,   D4      ; Height

    ; Draw  
    MOVE.B  #87,        D0          ; Draw
    TRAP    #15                     ; Trap (Perform action)

    ; Set Pixel Colors
    MOVE.L  #GREEN1,       D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    ; Reset Pixel Colors
    MOVE.L  #GREEN1,     D1          ; Set Background color
    MOVE.B  #81,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)
    
    ; change thickness
    MOVE.l  #2,D1
    MOVE.B  #93,D0
    TRAP    #15

    ; Set X, Y, Width and Height
    MOVE.L  HEALTH_X,    D1          ; X
    MOVE.L  HEALTH_Y,    D2          ; Y
    SUB.L   #HEALTH_PACK_H,   D2      ; Height
    MOVE.L  D1,    D3
    ADD.L   #3,D1
    ADD.L   #HEALTH_PACK_W,   D3      ; Width
    SUB.L   #5,D3
    MOVE.L  D2,    D4
    SUB.L   #5,     D4 

    ; Draw  
    MOVE.B  #87,        D0          ; Draw
    TRAP    #15                     ; Trap (Perform action)
    
    ; Set Pixel Colors
    MOVE.L  #BROWN,       D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    ; Reset Pixel Colors
    MOVE.L  #BROWN,     D1          ; Set Background color
    MOVE.B  #81,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)
    

    ; Set X, Y, Width and Height
    MOVE.L  HEALTH_X,    D1          ; X
    MOVE.L  HEALTH_Y,    D2          ; Y
    ADD.L   #6,D1
    MOVE.L  D1,    D3
    ADD.L   #3,D3
    SUB.L   #HEALTH_PACK_H,   D2      ; Height
    MOVE.L  D2,    D4
    SUB.L   #5, D4 

    ; Draw  
    MOVE.B  #84,        D0          ; Draw
    TRAP    #15                     ; Trap (Perform action)
    ; reset thickness
    MOVE.l  #1,D1
    MOVE.B  #93,D0
    TRAP    #15


    RTS                             ; Return to subroutine

; subroutine if the healthpack is not meant to be drawn
DRAW_HEALTHPACK_DONE:
    MOVE.L  #-1, HEALTH_Y       ; move off screen
    MOVE.W  healthCooldown,D2   ; if the healthcooldown is over then move back on screen 
    CMP.W   #0,  D2
    IF <EQ> THEN
        BSR     RESET_HEALTH_POSITION
    ENDI
    RTS

; draw the ground
DRAW_FLOOR:
    ; Set Pixel Colors
    MOVE.L  #brown,     D1          ; Set Background color
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
    MOVE.L  #deepgreen,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #deepgreen,     D1
    MOVE.B  #81,        D0
    TRAP    #15

    BRA     DRAWDIRT
    
; draw the dirt
DRAWDIRT:
    ; Set X, Y, X2, and Y2
    MOVE.L  #0,   D1          ; X
    MOVE.L  #640,   D3  
    MOVE.L  #277,   D2         
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
    
    