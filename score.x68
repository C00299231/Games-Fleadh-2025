score dc.l 0

; scores
scorePerfectDef equ 100
scoreKill equ 5
scoreLife equ 30 ; ant left alive
scoreWin equ 100

; final score values
finalPerfectDef ds.l 01
finalKill ds.l 01
finalLife ds.l 01
finalWin ds.L 01

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
    add.l d2, score
    move.l d2, finalWin

    ; lives remaining
    clr.l d2
    move.b antsRemaining, d2
    mulu #scoreLife, d2
    add.l d2, score
    move.l d2, finalLife

    ; enemies killed
    clr.l d2
    move.b totalKills, d2
    mulu #scoreKill, d2
    add.l d2, score
    move.l d2, finalKill

    ; perfect hill defence
    clr.l d2
    move.b #scorePerfectDef, d2
    mulu perfectDefenceAmount, d2
    add.l d2, score
    move.l d2, finalPerfectDef


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
    lea finalScoreMsg, a1
    jsr print

    jsr scoreScreenInbetween

    ; WIN
    lea scoreWinMsg, a1
    move.l finalKill, d1
    jsr printWithNum

    jsr scoreScreenInbetween

    ; KILLS
    lea scoreKillMsg, a1
    move.l finalKill, d1
    jsr printWithNum

    jsr scoreScreenInbetween

    ; ANTS REMAINING
    lea scoreLifeMsg, a1
    move.l finalKill, d1
    jsr printWithNum

    jsr scoreScreenInbetween

    ; PERFECT DEF
    lea scorePerfectDefMsg, a1
    move.l finalKill, d1
    jsr printWithNum

    jsr scoreScreenInbetween

    lea scoreContinueMsg, a1
    jsr print

    jsr scoreScreenInbetween

    ; MUST PRESS ENTER TO CONTINUE
    bra getEnter
    rts

scoreScreenInbetween:
    jsr PLAY_HIT
    move.l scoreLineDelay, d3
    jsr newDelay
    rts

getEnter:

    ; set d1 to $0000 0000
    move.l #0, d1

    ; put "get input" code into d0
    move.b #tcinp, d0
    trap #15
    move.b d1, currentkey
    trap #15
    
    ; AT THIS POINT, CURRENT KEY CONTAINS THE CURRENT KEY PRESSED
    ; AND D1 CONTAINS WHETHER OR NOT IT IS STILL PRESSED
    
    ; test if no input
    cmpi.b #0, d1
    beq getEnter

    cmp.b #enterKey, currentKey
    bne getEnter

    ; go home
    bra nextInit

finalScoreMsg dc.b '- FINAL SCORE -',0
    
scoreKillMsg dc.b 'Enemies Vanquished: ',0
scoreLifeMsg dc.b 'Ants Remaining: ',0
scoreWinMsg  dc.b 'Kingdom Defended: ',0
scorePerfectDefMsg dc.b 'Perfect Hill Defence: ',0

scoreContinueMSg dc.b 'Press "ENTER" to return to title...',0

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
