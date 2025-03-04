; this file contains achievement data

;----------------9 ACHIEVEMENTS:
; - 10kills
; - 30kills
; - jump
; - 20jumps

; - perfectdefence
; - apple
; - acorndouble
; - airattack

; - brutekill


; reset all achievement bools when game is reset
resetAchievements:
    move.b #0, ach10killsTrue
    move.b #0, ach30killsTrue
    move.b #0, achJumpTrue
    move.b #0, ach20jumpsTrue

    move.b #0, achPerfectDefTrue
    move.b #0, achAppleTrue
    move.b #0, achAcornDoubleTrue
    move.b #0, achAirAttackTrue

    move.b #0, achBruteKillTrue
    rts

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

ach20jumpsTrue dc.b 0
ach20jumpsMsg dc.b '20 hops!'0
ach20jumpsCount dc.b 0

achPerfectDefTrue dc.b 0
achPerfectDefMsg dc.b 'Perfect defence!',0

achAppleTrue dc.b 0
achAppleMsg dc.b 'Ate an apple!',0

achAcornDoubleTrue dc.b 0
achAcornDoubleMsg dc.b 'Hit 2 ants with one acorn!',0
achAcornDoubleCount dc.b 0

achAirAttackTrue dc.b 0
achAirAttackMsg dc.b 'Hit enemy while airborne!',0

achBruteKillTrue dc.b 0
achBruteKillMsg dc.b 'Slew a mighty foe! ',0

;--------------------------------------ACHIEVEMENT SUBROUTINES

currentAchievement ds.w 01 ; when an achievement is gotten, place relevant text in here

ach10killsCheck:
    move.l totalKills, d2
    add.b ENEMIES_DEFEATED, D2
    cmpi.l #10, d2
    if <eq> then
        ; got 10 kills achievement.
        move.b #$FF, ach10killsTrue
        lea ach10killsMsg, A2
        jsr getAchievement
    endi
    rts

ach30killsCheck:
    move.l totalKills, d2
    add.b ENEMIES_DEFEATED, D2
    cmpi.l #30, d2
    if <eq> then
        ; got 30 kills achievement.
        move.b #$FF, ach10killsTrue
        lea ach30killsMsg, A2
        jsr getAchievement
    endi
    rts

achJumpCheck:
    ; got jump achievement
    move.b #$FF, achJumpTrue
    lea achJumpMsg, a2
    jsr getAchievement
    rts

ach20jumpsCheck:
    move.b ach20jumpsCount, d2
    cmpi.b #20, d2
    if <eq> then
        ; got 20 jumps achievement.
        move.b #$FF, ach20jumpsTrue
        lea ach20jumpsMsg, A2
        jsr getAchievement
    endi
    rts

achPerfectDefCheck:
    move.b #$FF, achPerfectDefTrue
    lea achPerfectDefMsg, a2
    jsr getAchievement
    rts

achAppleCheck:
    move.b #$FF, achAppleTrue
    lea achAppleMsg, a2
    jsr getAchievement
    rts

achAcornDoubleCheck:
    eor.l d2, d2
    move.b achAcornDoubleCount, d2
    cmp.b #2, d2
    if <eq> then
        move.b #$FF, achAcornDoubleTrue
        lea achAcornDoubleMsg, a2
        jsr getAchievement
    endi
    rts

achAirAttackCheck:
    move.b #$FF, achAirAttackTrue
    lea achAirAttackMsg, a2
    jsr getAchievement
    rts

achBruteKillCheck:
    move.b #$FF, achBruteKillTrue
    lea achBruteKillMsg, a2
    jsr getAchievement
    rts



;--------------------------------------DRAW



getAchievement:
    ;HOW TO USE:
    ;   LEA the relevant achievement message into A2
    ;   set the achievement bool byte to #$FF
    ;   call srt

    move a2, currentAchievement
    move.w #0, achievementDecay

    ; here, play achievement sound
    jsr STOP_sting
    jsr ACHIEVE_STING_LOAD
    jsr play_sting

    rts

; THIS SHOULD ALWAYS RUN
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
    move.l #250, d3
    move.l #120, d4

    cmpi #28, achievementDecay
    if <lt> then
        ; get movement value
        move.w achievementDecay, d5
        mulu #10, d5

        ; add to rect values
        sub #280, d1
        sub #280, d3
        add d5, d1
        add d5, d3
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

    ;move.l #$0306, d1
    ;jsr setCursor
    ;clr.l d1
    ;move.w achievementDecay, d1
    ;jsr printNum

    ; increment achievement number
    bra decayAchievement

decayAchievement:
    add #1, achievementDecay
    rts



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
