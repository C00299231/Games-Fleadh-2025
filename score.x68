score dc.l 0

; scores
scorePerfectDef equ 100
scoreKill equ 5
scoreLife equ 30 ; ant left alive
scoreWin equ 100

; values
totalKills dc.l 0
isWin dc.l 0

tallyScore:
    move.l #0, score ; init to zero, just in case

    ; got win
    clr.l d2
    move.b isWin, d2
    mulu #scoreWin, d2
    add.l d2, score

    ; lives remaining
    clr.l d2
    move.b antsRemaining, d2
    mulu #scoreLife, d2
    add.l d2, score

    ; enemies killed
    clr.l d2
    move.b totalKills, d2
    mulu #scoreKill, d2
    add.l d2, score

    ; perfect hill defence


    
scoreKillMsg dc.b 'Enemies Vanquished: ',0
scoreLifeMsg dc.b 'Ants Remaining: ',0
scoreWinMsg  dc.b 'Kingdom Defended: ',0
scorePerfectDefMsg dc.b 'Perfect Hill Defence: ',0



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
