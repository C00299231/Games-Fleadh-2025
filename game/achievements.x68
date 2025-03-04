; this file contains achievement data

achievementMsg dc.b 'ACHIEVEMENT GET!',0

baseAchievementDecay equ 200
achievementDecay dc.w 200

;------------------------------------------ACHIEVEMENTS

ach10killsTrue dc.b 0
ach10killsMsg dc.b '10 vanquishes!',0

ach30killsTrue dc.b 0
ach30killsMsg dc.b '30 vanquishes!',0

achJumpTrue dc.b 0
achJumpMsg dc.b 'Went for a hop!',0

achPerfectDefTrue dc.b 0
achPerfectDefMsg dc.b 'Perfect defence!',0

achAppleTrue dc.b 0
achAppleMsg dc.b 'Ate an apple!',0

achTest dc.b 0
achTestMsg dc.b 'Test achievement!',0

;--------------------------------------DRAW

currentAchievement ds.w 01 ; when an achievement is gotten, place relevant text in here

getAchievement:
    move a2, currentAchievement
    move.w #0, achievementDecay

    ; here, play achievement sound
    jsr STOP_sting
    jsr ACHIEVE_STING_LOAD
    jsr play_sting

    rts

drawAchievement:

    ; check if achievement should be drawn at all
    cmp.w #baseAchievementDecay, achievementDecay
    if <eq> then
        rts
    endi

    ; set colours
    move.l #color5, D1
    eor.l d2, d2 ; clear d2
    jsr setFontColour
    jsr setPenColour

    move.l #deepgreen, D1
    jsr setFillColour

    ; draw rect (might make rect move?)
    move.l #15, D1
    move.l #30, D2
    move.l #205, d3
    move.l #120, d4

    cmpi #40, achievementDecay
    if <lt> then
        sub #200, d1
        sub #200, d3
        add achievementDecay, d1
        add achievementDecay, d3
        add achievementDecay, d1
        add achievementDecay, d3
        add achievementDecay, d1
        add achievementDecay, d3
        add achievementDecay, d1
        add achievementDecay, d3
        add achievementDecay, d1
        add achievementDecay, d3
    endi

    jsr drawUiRect

    cmpi #40, achievementDecay
    if <lt> then
        bra decayAchievement
    endi

    

    ;------------------------------DRAW TEXT
    move.l #$0303, D1
    jsr setCursor
    lea achievementMsg, A1
    jsr print

    move.l #$0305, D1
    jsr setCursor
    move currentAchievement, A1
    jsr print

    move.l #$0306, d1
    jsr setCursor
    clr.l d1
    move.w achievementDecay, d1
    jsr printNum

    ; decrement achievement
    bra decayAchievement

decayAchievement:
    add #1, achievementDecay
    rts

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
