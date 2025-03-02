DIFFICULTY_SELECT: 
    move.b #tcdbl,d0
    move.b #17, d1
    trap    #15

    move.w #3, lvlType

DRAW_DIFFSELECT:
    BSR     CLEAR_SCREEN
    
    *------------ fill background --------------*
    MOVE.W      #0,D1
    MOVE.W      #0,d2
    MOVE.B      #89,D0
    TRAP        #15
    
    
    ; Message
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$1E02,     D1          
    TRAP    #15                     ; Trap (Perform action)
    LEA     CHOOSE_LEVEL_MSG,  A1   ; Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)

    ; DRAW EASY BOX
    ; Set Pixel Colors
    MOVE.L  #GREEN,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)
    MOVE.L  #50, D1 ; X
    MOVE.L  #150, D2 ; Y
    MOVE.L D1, D3
    MOVE.L D2, D4
    ADD.L #BOX_SIZE, D3 ; Width
    ADD.L #BOX_SIZE, D4 ; Height
    MOVE.B  #87,        D0          ; Draw box
    TRAP    #15                     ; Trap (Perform action)
    
    tst.b   selectedIndex
    IF <EQ> THEN
        move.l  d1, (sp)+
        MOVE.L  #WHITE,     D1          ; Set Background color
        MOVE.B  #80,        D0          ; Task for Background Color
        TRAP    #15                     ; Trap (Perform action)
        
        move.l #87, d0
        move.l -(sp), d1
        add.l #10, d1
        add.l #10, d2
        sub.l #10, d3
        sub.l #10, d4

        trap #15
    ENDI
    ; DRAW MEDIUM BOX
    ; Set Pixel Colors
    MOVE.L  #color5,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)
    MOVE.L  #245, D1 ; X
    MOVE.L  #150, D2 ; Y
    MOVE.L D1, D3
    MOVE.L D2, D4
    ADD.L #BOX_SIZE, D3 ; Width
    ADD.L #BOX_SIZE, D4 ; Height
    MOVE.B  #87,        D0          ; Draw box
    TRAP    #15                     ; Trap (Perform action)
    
    cmp.b   #1,selectedIndex
    IF <EQ> THEN
        move.l  d1, (sp)+
        MOVE.L  #WHITE,     D1          ; Set Background color
        MOVE.B  #80,        D0          ; Task for Background Color
        TRAP    #15                     ; Trap (Perform action)
        
        move.l #87, d0
        move.l -(sp), d1
        add.l #10, d1
        add.l #10, d2
        sub.l #10, d3
        sub.l #10, d4

        trap #15
    ENDI

    ; DRAW HARD BOX
    ; Set Pixel Colors
    MOVE.L  #RED,     D1          ; Set Background color
    MOVE.B  #80,        D0          ; Task for Background Color
    TRAP    #15                     ; Trap (Perform action)
    MOVE.L  #440, D1 ; X
    MOVE.L  #150, D2 ; Y
    MOVE.L D1, D3
    MOVE.L D2, D4
    ADD.L #BOX_SIZE, D3 ; Width
    ADD.L #BOX_SIZE, D4 ; Height
    MOVE.B  #87,        D0          ; Draw box
    TRAP    #15                     ; Trap (Perform action)
    
        
    cmp.b   #2,selectedIndex
    IF <EQ> THEN
        move.l  d1, (sp)+
        MOVE.L  #WHITE,     D1          ; Set Background color
        MOVE.B  #80,        D0          ; Task for Background Color
        TRAP    #15                     ; Trap (Perform action)
        
        move.l #87, d0
        move.l -(sp), d1
        add.l #10, d1
        add.l #10, d2
        sub.l #10, d3
        sub.l #10, d4

        trap #15
    ENDI

    ; Message
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0D09,     D1          
    TRAP    #15                     ; Trap (Perform action)
    LEA     EASY_MSG1,  A1   ; Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)

    ; Message
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$090D,     D1          
    TRAP    #15                     ; Trap (Perform action)
    LEA     EASY_MSG2,  A1   ; Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)
    
    ; Message
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$090E,     D1          
    TRAP    #15                     ; Trap (Perform action)
    LEA     EASY_MSG3,  A1   ; Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)
    
    ; Message
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$090F,     D1          
    TRAP    #15                     ; Trap (Perform action)
    LEA     EASY_MSG4,  A1   ; Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)
    
    ; Message
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$2409,     D1          
    TRAP    #15                     ; Trap (Perform action)
    LEA     MEDIUM_MSG1,  A1   ; Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)
    
    ; Message
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$220D,     D1          
    TRAP    #15                     ; Trap (Perform action)
    LEA     MEDIUM_MSG2,  A1   ; Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)
    
    ; Message
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$210E,     D1          
    TRAP    #15                     ; Trap (Perform action)
    LEA     MEDIUM_MSG3,  A1   ; Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)
    
    ; Message
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$210F,     D1          
    TRAP    #15                     ; Trap (Perform action)
    LEA     MEDIUM_MSG4,  A1   ; Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)
    
    ; Message
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$3B09,     D1          
    TRAP    #15                     ; Trap (Perform action)
    LEA     HARD_MSG1,  A1   ; Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)
    
    ; Message
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$3B0D,     D1          
    TRAP    #15                     ; Trap (Perform action)
    LEA     HARD_MSG2,  A1   ; Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)
    
    ; Message
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$3A0E,     D1          
    TRAP    #15                     ; Trap (Perform action)
    LEA     HARD_MSG3,  A1   ; Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)
    
    ; Message
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$3A0F,     D1          
    TRAP    #15                     ; Trap (Perform action)
    LEA     HARD_MSG4,  A1   ; Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)

    ; Message
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$171E,     D1          
    TRAP    #15                     ; Trap (Perform action)
    LEA     ENTER_DIFFICULTY_MSG,  A1   ; Message
    MOVE    #13,        D0          ; No Line feed
    TRAP    #15                     ; Trap (Perform action)

    
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$341E,     D1          
    TRAP    #15                     ; Trap (Perform action)
    ; READ INPUT
    bsr     testInput

    CLR.L   D1                      ; Clear contents of D1 (XOR is faster)
    MOVE.B  #TC_REDRAW,        D0
    TRAP    #15
    BRA DRAW_DIFFSELECT

CLEAR_SCREEN:
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
	MOVE.W  #$FF00,     D1          ; Fill Screen Clear
	TRAP	#15                     ; Trap (Perform action)
	RTS

checkDifSelected:
    CMP.b #0, selectedIndex
    IF <EQ> THEN
        MOVE.B  #5,antsRemaining
        MOVE.l  #1,EASY_SLOW
        MOVE.B  #1,DIFFICULTY
        move.b  #5, maxAntHp
        BRA mapInit
    ENDI
    CMP.b #1, selectedIndex
    IF <EQ> THEN
        MOVE.B  #5,antsRemaining
        MOVE.l  #0,EASY_SLOW
        MOVE.B  #2,DIFFICULTY
        move.b  #3, maxAntHp
        BRA mapInit
    ENDI
    CMP.b #2, selectedIndex
    IF <EQ> THEN
        MOVE.l  #0,EASY_SLOW
        MOVE.B  #1,antsRemaining
        MOVE.B  #5,DIFFICULTY
        move.b  #3, maxAntHp
        BRA mapInit
    ENDI
    RTS


BOX_SIZE           EQU  150 ; Box size constant
CHOOSE_LEVEL_MSG DC.B 'CHOOSE A DIFFICULTY:', 0 
EASY_MSG1 DC.B '1-EASY', 0 
EASY_MSG2 DC.B 'Less, slower,', 0 
EASY_MSG3 DC.B 'enemies. More ', 0 
EASY_MSG4 DC.B 'lives per ant', 0 
MEDIUM_MSG1 DC.B '2-MEDIUM', 0 
MEDIUM_MSG2 DC.B 'Medium speed', 0 
MEDIUM_MSG3 DC.B 'Normal enemies', 0
MEDIUM_MSG4 DC.B 'Standard lives', 0 
HARD_MSG1 DC.B '3-HARDCORE', 0 
HARD_MSG2 DC.B 'You are the ', 0 
HARD_MSG3 DC.B 'Kindom`s last ', 0 
HARD_MSG4 DC.B 'hope. 1 Life', 0 
ENTER_DIFFICULTY_MSG DC.B '-Press `Enter` to choose difficulty-', 0

selectedIndex     dc.b    1
EASY_SLOW         DC.L    0
EASY_EXTRAHP      DC.B    0
HARD_INCREASE     EQU     1
EASY_DECREASE     EQU     1
DIFFICULTY        DC.b    0
easyDiff              EQU     1
normalDiff              EQU     2
hardDiff              EQU     5