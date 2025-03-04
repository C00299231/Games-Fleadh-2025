; runs if hill hp went to 0
HILL_LOST:
    ; add enemies killed to total 
    clr.l   d3
    move.b  ENEMIES_DEFEATED, d3
    add.l   d3,totalKills

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$FF00,     D1          ; Fill Screen Clear
    TRAP	#15                     ; Trap (Perform action)
    BSR     PLAY_GAMEOVER

*------------Set Colours--------------*
    MOVE.L  #color5,     D1
    MOVE.B  #21,        D0          ; Set Text Color
    MOVE.L  #$01130005, D2
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #deepgreen,     D1
    MOVE.B  #81,        D0          ; Set Text Color
    TRAP    #15                     ; Trap (Perform action)

*------------ fill background --------------*
    jsr drawBg

*------------ Print hill lost message--------------*

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0803,     D1          ; col 8, row 3 
    TRAP    #15                     ; Trap (Perform action)
    LEA     HILLLOST_MSG,A1        ; Game Over Message
    BSR     print

*------------print amount of enemies defeated--------------*

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0606,     D1          ; col 06, Row 06
    TRAP    #15                     ; Trap (Perform action)
    LEA     ENEMIESDEAD_MSG,  A1          ; Score Message
    BSR     print

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1B06,     D1          ;col 27, Row 06
    TRAP    #15                     ; Trap (Perform action)
    MOVE.B  #03,        D0          ; Display number at D1.L
    MOVEQ.L #0,D1
    MOVE.B  ENEMIES_DEFEATED,D1         ; Move Score to D1.L
    TRAP    #15                     ; Trap (Perform action)
    
*------------print hill health --------------*

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0607,     D1          ;col 6, Row 07
    TRAP    #15                     ; Trap (Perform action)
    LEA     hillHP_MSG,  A1          ; Score Message
    BSR     print

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1B07,     D1          ;col 27, Row 07
    TRAP    #15                     ; Trap (Perform action)
    MOVEQ.L #0,D1
    MOVE.B  hillHP,D1         ; Move Score to D1.L
    MOVE.B  #03,        D0          ; Display number at D1.L
    TRAP    #15                     ; Trap (Perform action)
    
*------------ print back to map--------------*
DRAWBACKTOMAP:
    MOVE.L  #color5,     D1
    MOVE.B  #21,        D0          ; Set Text Color
    MOVE.L  #$03140000, D2
    TRAP    #15                     ; Trap (Perform action)

    ; Restart
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$070C,     D1          ;col 7, Row 012
    TRAP    #15                     ; Trap (Perform action)
    LEA     BACK_TO_MAP_MSG,  A1          ; Score Message
    MOVE    #13,        D0          ; No Line feedF=
    TRAP    #15                     ; Trap (Perform action)

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1F0C,     D1          ;col 31, Row 012
    TRAP    #15                     ; Trap (Perform action)
    MOVEQ.L #0,D1
    MOVE.B  backToMapCount,D1         ; Move Score to D1.L
    MOVE.B  #03,        D0          ; Display number at D1.L
    TRAP    #15                     ; Trap (Perform action)

    
    MOVE.B  #TC_REDRAW,        D0
    TRAP    #15
   
    ; delay time
    MOVE.b  #23,D0
    MOVE.L  #100,D1
    TRAP    #15

    ; sub from the counter
    SUB.B   #01,backToMapCount
    bsr     checkGameOver
   

    ; reset current health
    MOVE.l  #200,currentHealth
    bsr     initDraw
    ; back to top
    BRA     DRAWBACKTOMAP


; check if all 4 rounds are over if not then go back to map
checkGameOver:
    ; if the counter is 0 then go back to map
    TST.B   backToMapCount
    IF <EQ> THEN    
        ; if 0 hills were defended and its the last wave then go to game_over
        cmp.w   #3,lvlIndex
        IF <EQ> THEN
            tst.b   totalHillsDefended
            IF <EQ> THEN
                bra GAME_OVER
            ENDI
            bra WIN_SCREEN
        ENDI
        bra mapNotFirstInit
       
    ENDI

    RTS

; check if all 4 rounds are over if not then go back to map
checkGameWin:
    ; if the counter is 0 then go back to map
    TST.B   backToMapCount
    IF <EQ> THEN    
        ; if last wave go to win screen
        CMP.W   #3,lvlIndex
        BEQ     WIN_SCREEN
        bra mapNotFirstInit
    ENDI

    RTS
; game over screen
GAME_OVER:
    
    ; clear screen
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$FF00,     D1          ; Fill Screen Clear
    TRAP	#15                     ; Trap (Perform action)
    BSR     PLAY_GAMEOVER
    
*------------Set Colours--------------*
    MOVE.L  #color5,     D1
    MOVE.B  #21,        D0          ; Set Text Color
    MOVE.L  #$01130000, D2
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #color1,     D1
    MOVE.B  #81,        D0          ; Set Text Color
    TRAP    #15                     ; Trap (Perform action)

*------------ fill background --------------*
    jsr drawBg

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0F05,     D1           
    TRAP    #15                     ; Trap (Perform action)
    LEA     GAMEOVER_MSG,A1        ; Game Over Message
    BSR     print
   
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0607,     D1           
    TRAP    #15                     ; Trap (Perform action)
    LEA     FALLENKINGDOM_MSG,A1        ; Game Over Message
    BSR     print

    ; play loss sting
    jsr stop_sting
    jsr LOSS_STING_LOAD
    jsr play_sting


    MOVE.B  #TC_REDRAW,D0          ; Set Cursor Position
    TRAP	#15                     ; Trap (Perform action)

     ; delay time
    MOVE.b  #23,D0
    MOVE.L  #endGameDelay,D1
    TRAP    #15
    MOVE.b  #TC_CURSR_P,d0
    MOVE.W  #$FF00,     D1          ; Fill Screen Clear
    trap    #15

    MOVE.L  #color1,     D1
    MOVE.B  #81,        D0          ; Set Text Color
    TRAP    #15                     ; Trap (Perform action)

*------------ fill background --------------*

    jsr drawBg

    BRA     tallyScore

; wave cleared screen
WAVE_DEFEATED:

    ; add 1 to total hills defended
    addi.b #1, totalHillsDefended

    ; add kills to total
    clr.l   d3
    move.b  ENEMIES_DEFEATED, d3
    add.l   d3,totalKills

    ; if the hp of the hill is full add 1 to perfect defences
    move.b  hillHP,d3
    move.b  #maxHillHp,d4
    cmp.b   d4,d3
    IF <EQ> THEN
        addi.l  #1,perfectDefenceAmount
    ENDI
    
    ; clear screen
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$FF00,     D1          ; Fill Screen Clear
    TRAP	#15                     ; Trap (Perform action)
    BSR     PLAY_GAMEOVER

*------------Set Colours--------------*
    MOVE.L  #color5,     D1
    MOVE.B  #21,        D0          ; Set Text Color
    MOVE.L  #$01130005, D2
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #deepgreen,     D1
    MOVE.B  #tcPenFil,        D0          ; Set Text Color
    TRAP    #15                     ; Trap (Perform action)

*------------ fill background --------------*
    jsr drawBg

*------------ Print wave defeated message--------------*

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0E03,     D1           ;col 14, Row 03
    TRAP    #15                     ; Trap (Perform action)
    LEA     HILLDEFENDED_MSG,A1        ; Game Over Message
    BSR     print

*------------print amount of enemies defeated--------------*

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0606,     D1          ;col 6, Row 06
    TRAP    #15                     ; Trap (Perform action)
    LEA     ENEMIESDEAD_MSG,  A1          ; Score Message
    BSR     print

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1B06,     D1          ;col 27, Row 06
    TRAP    #15                     ; Trap (Perform action)
    MOVE.B  #03,        D0          ; Display number at D1.L
    MOVEQ.L #0,D1
    MOVE.B  ENEMIES_DEFEATED,D1         ; Move enemies killed to D1.L
    TRAP    #15                     ; Trap (Perform action)
    
*------------print hill health --------------*

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0607,     D1          ;col 6, Row 07
    TRAP    #15                     ; Trap (Perform action)
    LEA     hillHP_MSG,  A1          ; Score Message
    BSR     print

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1B07,     D1          ;col 27, Row 07
    TRAP    #15                     ; Trap (Perform action)
    MOVEQ.L #0,D1
    MOVE.B  hillHP,D1               ; Move hill hp to D1.L
    MOVE.B  #03,        D0          ; Display number at D1.L
    TRAP    #15                     ; Trap (Perform action)
    
*------------ print back to map--------------*
    MOVE.L  #color5,     D1
    MOVE.B  #21,        D0          ; Set Text Color
    MOVE.L  #$03140000, D2
    TRAP    #15                     ; Trap (Perform action)


    ; Restart
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$070C,     D1          ;col 7, Row 012
    TRAP    #15                     ; Trap (Perform action)
    LEA     BACK_TO_MAP_MSG,  A1          ; Score Message
    MOVE    #13,        D0          ; No Line feedFeed
    TRAP    #15                     ; Trap (Perform action)

MAPCOUNTDOWN:
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1F0C,     D1          ; col 1f, Row 0c
    TRAP    #15                     ; Trap (Perform action)
    MOVEQ.L #0,D1
    MOVE.B  backToMapCount,D1         ; Move counter to D1.L
    MOVE.B  #03,        D0          ; Display counter at D1.L
    TRAP    #15                     ; Trap (Perform action)
    
    ; redraw
    MOVE.B  #TC_REDRAW,        D0
    TRAP    #15
   
    ; delay time
    MOVE.b  #23,D0
    MOVE.L  #100,D1
    TRAP    #15

    ; sub 1 from the counter
    SUB.B   #01,backToMapCount
    ; check if counter is done and branch to map
    bsr    checkGameWin
    
    bsr     initDraw    
    MOVE.l  #200,currentHealth  ; reset current health
    ; back to top
    BRA     MAPCOUNTDOWN

; win screen after 4 rounds
WIN_SCREEN:
    ; set isWin to true
    move.b #1, isWin
    ; clear screen
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$FF00,     D1          ; Fill Screen Clear
    TRAP	#15                     ; Trap (Perform action)
    BSR     PLAY_GAMEOVER
    
*------------Set Colours--------------*
    MOVE.L  #color5,     D1
    MOVE.B  #21,        D0          ; Set Text Color
    MOVE.L  #$01130000, D2
    TRAP    #15                     ; Trap (Perform action)

    MOVE.L  #color1,     D1
    MOVE.B  #81,        D0          ; Set Text Color
    TRAP    #15                     ; Trap (Perform action)

*------------ fill background --------------*
    jsr drawBg
    
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0406,     D1           
    TRAP    #15                     ; Trap (Perform action)
    LEA     WIN_MSG,A1        ; Game Over Message
    BSR     print

    ; play loss sting
    jsr stop_sting
    jsr win_STING_LOAD
    jsr play_sting

    ; redraw
    MOVE.B  #TC_REDRAW,D0          ; Set Cursor Position
    TRAP	#15                     ; Trap (Perform action)

     ; delay time
    MOVE.b  #23,D0
    MOVE.L  #endGameDelay,D1
    TRAP    #15
    MOVE.b  #TC_CURSR_P,d0
    MOVE.W  #$FF00,     D1          ; Fill Screen Clear
    trap    #15

    ; change text colour
    MOVE.L  #color1,     D1
    MOVE.B  #81,        D0          ; Set Text Color
    TRAP    #15                     ; Trap (Perform action)

*------------ fill background --------------*
    jsr drawBg

    ; go to tally score
    BRA     tallyScore

; messages
HILLLOST_MSG            DC.B    'ANT HILL HAS BEEN OVERRUN!', 0         ; ant hill lost message
WIN_MSG                 DC.B    'THE ENEMY ARMY HAS BEEN DEFEATED!', 0  ; win message  
HILLDEFENDED_MSG        DC.B    'WAVE COMPLETE!', 0                     ; hill defended message
FALLENKINGDOM_MSG       DC.B    'YOUR ANT KINGDOM HAS FALLEN', 0        ; game over message
GAMEOVER_MSG            DC.B    'GAME OVER!', 0                         ; game over  
BACK_TO_MAP_MSG         DC.B    'Back to game ...', 0            ; return to map counter message