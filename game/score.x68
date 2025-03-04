score dc.l 0

; scores
scorePerfectDef equ 250
scoreHillDef equ 75
scoreKill equ 5
scoreLife equ 30 ; ant left alive
scoreWin equ 100
scoreAchievement equ 50

; final score values
finalPerfectDef ds.l 01
finalKill ds.l 01
finalLife ds.l 01
finalWin ds.L 01
finalHillDef    dc.l 0

; values
totalKills dc.l 0
isWin dc.l 0
perfectDefenceAmount dc.l 0

tallyScore:
    move.l #0, score ; init to zero, just in case

    ; got win
    clr.l d2
    move.b isWin, d2
    mulu #scoreWin, d2
    clr.L   d3
    move.b DIFFICULTY, d3
    mulu d3, d2
    add.l d2, score
    move.l d2, finalWin

    ; lives remaining
    clr.l d2
    move.b antsRemaining, d2
    mulu #scoreLife, d2
    cmp.b #5, DIFFICULTY
    IF <EQ> THEN
        clr.l d2
        move.b antsRemaining, d2 
        mulu.w #1000, d2
    ENDI
    add.l d2, score
    move.l d2, finalLife

    ; enemies killed
    clr.l d2
    move.l totalKills, d2
    mulu #scoreKill, d2
    clr.L   d3
    move.b DIFFICULTY, d3
    mulu d3, d2
    add.l d2, score
    move.l d2, finalKill
    
    ; hills defended
    clr.l d2
    move.b totalHillsDefended, d2
    mulu #scoreHillDef, d2
    clr.L   d3
    move.b DIFFICULTY, d3
    mulu d3, d2
    add.l d2, score
    move.l d2, finalHillDef

    ; perfect hill defence
    clr.l d2
    move.l perfectDefenceAmount, d2
    mulu #scorePerfectDef, d2
    clr.L   d3
    move.b DIFFICULTY, d3
    mulu d3, d2
    add.l d2, score
    move.l d2, finalPerfectDef

    ;move.l  #110000,score
    bsr     writeScore


scoreScreen:
    ; moved to score screen, setup
    move.w #3, lvlType

    jsr stop_song
    ;jsr MENU_SONG_LOAD
    ;jsr PLAY_SONG

    ; temp remove double buffer
    jsr disableDoubleBuffer

    ;------------PRINT STUFF
    ; TITLE
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0D01,     D1        
    TRAP    #15                     ; Trap (Perform action)
    lea finalScoreMsg, a1
    jsr print

    jsr scoreScreenInbetween

    ; WIN
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0903,     D1        
    TRAP    #15                     ; Trap (Perform action)
    lea scoreWinMsg, a1
    move.l finalWin, d1
    jsr printWithNum

    jsr scoreScreenInbetween

    ; KILLS
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0904,     D1        
    TRAP    #15                     ; Trap (Perform action)
    lea scoreLifeMsg, a1
    move.l finalLife, d1
    jsr printWithNum

    jsr scoreScreenInbetween

    ; ANTS REMAINING
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0905,     D1        
    TRAP    #15                     ; Trap (Perform action)
    lea scoreKillMsg, a1
    move.l finalKill, d1
    jsr printWithNum

    jsr scoreScreenInbetween

    ; HILLS DEF
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0906,     D1        
    TRAP    #15                     ; Trap (Perform action)
    lea scoreHillDefMsg, a1
    move.l finalHillDef, d1
    jsr printWithNum

    jsr scoreScreenInbetween

    ; PERFECT DEF
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0907,     D1        
    TRAP    #15                     ; Trap (Perform action)
    lea scorePerfectDefMsg, a1
    move.l finalPerfectDef, d1
    jsr printWithNum

    jsr scoreScreenInbetween

     ; Total score
    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$0909,     D1        
    TRAP    #15                     ; Trap (Perform action)
    lea totalScoreMsg, a1
    move.l score, d1
    jsr printWithNum

    jsr scoreScreenInbetween

    MOVE.B  #TC_CURSR_P,D0          ; Set Cursor Position
    MOVE.W  #$020d,     D1        
    TRAP    #15                     ; Trap (Perform action)
    lea scoreContinueMsg, a1
    jsr print

    bsr crlf
    jsr scoreScreenInbetween

    ; MUST PRESS ENTER TO CONTINUE
    bra getEnter
    rts

scoreScreenInbetween:
    jsr PLAY_HIT
    move.l #scoreLineDelay, d3
    jsr newDelay
    rts

writeScore:
     ; close
    move.b  #50, d0
    trap       #15
    
    ;open 
    move.b  #51,d0
    lea     txt,a1
    trap    #15
    move.l    d1,fileId
    
    ; read 
    move.l  fileId,d1
    move.b  #53,d0
    lea     highscoreFile,a1
    move.b  #4,d2
    trap    #15
    
    
    ; position file
    move.l  fileId,d1
    move.b  #55, d0
    move.l  #0, d2
    trap    #15

    ; write 
    ; compare
    move.l  highscore,d1
    move.l  score,d2
    cmp.l   d2,d1
    bgt     skipWrite
    move.l  score,(a1)
    move.b  #54,d0
    move.l  fileId,d1
    move.l  #4,d2
    trap    #15

skipWrite:
    ; close
    move.b  #56, d0
    trap       #15
    
     ; close
    move.b  #50, d0
    trap       #15
    rts

getEnter:

    move.l currentKey, lastKey

    ; set d1 to enter
    move.l #enterKey, d1

    ; put "get input" code into d0
    move.l #tcinp, d0
    trap #15
    
    ; test if no input
    cmpi.l #0, d1
    if <eq> then
        bra noEnter
    endi

    ; from here, enter is currently pressed

    move.l #enterKey, currentKey

    cmpi.l #enterKey, lastKey
    beq getEnter

    ; from here, enter is JUST pressed

    ; go home
    jsr clearscreen
    bra nextInit

noEnter:
    move.l #0, currentKey
    bra getEnter

finalScoreMsg dc.b '- FINAL SCORE -',0
    
scoreKillMsg dc.b 'Enemies Vanquished: ',0
scoreLifeMsg dc.b 'Ants Remaining: ',0
scoreWinMsg  dc.b 'Kingdom Defended: ',0
scoreHillDefMsg dc.b 'Hills Defended: ',0
scorePerfectDefMsg dc.b 'Perfect Hill Defence: ',0
totalScoreMsg       dc.b 'Total Score: ',0

scoreContinueMSg dc.b 'Press "ENTER/(A)" to return to title ',0


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
