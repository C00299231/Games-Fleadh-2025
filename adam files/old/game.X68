    ORG    $1000
START:

;TODO
	; make is_action_just_pressed()

; traps
TC_CURSR_P  EQU 11 ; Trap code cursor position
TC_DBL_BUF  EQU 92 ; Double Buffer Screen Trap Code

;PAUSE_LOC EQU $3000

TC_USR_INP  equ 19

;------------BUTTONS
; misc
escape equ $1b
spacebar equ $20

; arrows
left equ $25
up equ $26
right equ $27
down equ $28

; wasd
w equ $57
a equ $41
s equ $53
d equ $44

;-------------MAIN ROUTINES

;func _ready() -> void:
INIT:
	move.b #00, d6 ; pause register
	
	; Enable the screen back buffer(see easy 68k help)
	;MOVE.B  #TC_DBL_BUF,D0          ; 92 Enables Double Buffer
    ;MOVE.B  #17,        D1          ; Combine Tasks
	;TRAP	#15                     ; Trap (Perform action)


;func _process(delta: float) -> void:
LOOP:
	;bsr clearscreen
	bsr getInput
	
	move.l d6, d1
	move #16, d2
	move #15, d0
	trap #15
	bsr crlf
	
	cmp.b #$ff, d6
	beq pause
	
	; process goes here
	
	bra draw
	bra loop

;------------SUBROUTINES

clearscreen:
	; Clear the screen
    MOVE.B	#TC_CURSR_P,D0          ; Set Cursor Position
	MOVE.W	#$FF00,     D1          ; Clear contents
	TRAP    #15
	rts

draw:
	
	bra loop                  ; Trap (Perform action)

checkJustPaused:
	move.b currentkey, d1
	cmp.b lastkey, d1
	bne togglepause
	rts

togglePause:
	not.b d6
	rts

pause:
	; Enable back buffer
    MOVE.B  #94,        D0
    TRAP    #15
	;move.b #tc_cursr_p, d0
	;move.w #$0902, d1
	;trap #15
	
	lea pauseMsg, a1
	move #13, d0
	;trap #15
	
	bra draw

;-------INPUTS

getinput:
    ; Process Input
    move.b currentkey, lastkey  ; get previous key
    
    CLR.L   D1                      ; Clear Data Register
    MOVE.B  #tc_usr_inp, D0         ; Listen for Keys
    TRAP    #15                     ; Trap (Perform action)
    MOVE.l  D1, D2          		; Move last key D1 to D2
    CMP.B   #00, D2          		; Key is pressed
    BEQ     inputprocess            ; Process Key
    TRAP    #15                     ; Trap for Last Key
    ; Check if key still pressed
    CMP.B   #$FF,       D1          ; Is it still pressed
    BEQ     inputprocess            ; Process Last Key
    RTS                             ; Return to subroutine

inputProcess:
	MOVE.b  D2, currentkey ; Put Current Key in Memory
	
	; options input
	cmp.b #spacebar, currentkey
	beq checkJustPaused
	
	cmp.b #escape, currentkey
	beq endGame
	
	; movement input
    cmp.l #a, currentkey
    beq moveL
    cmp.l #d, currentkey
    beq moveR
    cmp.l #w, currentkey
    beq moveU
    cmp.l #s, currentkey
    beq moveD    
    RTS  
	
;MOVEMENT: process value in d3, then accept d3 value outside subroutine
;works for any position placed in d3
MOVEU:
    sub.b #1, d3
    ;bsr showpos
    rts
MOVED:
    add.b #1, d3
    ;bsr showpos
    rts
MOVEL:
    sub #$100, d3
    ;bsr showpos
    rts
MOVER:
    add #$100, d3
    ;bsr showpos
    rts

showTest:
	move #13, d0
	lea testmsg, a1
	trap #15
	rts

showInput:
	move #3, d0
	trap #15
	bsr crlf
	rts

; INSTANT NEW LINE
crlf:
    move #6, d0
    move #13, d1
    trap #15
    move #10, d1
    trap #15
    rts


ENDGAME:
	move #14, d0
	lea doneMsg, a1
	trap #15
	
FINISH:
	

    SIMHALT

currentKey ds.l 01
lastKey ds.l 01

playerPos dc.w 300,300

pauseMsg dc.b 'PAUSED',0
testMsg dc.b 'test!',0
doneMsg dc.b 'done!',0

    END    START


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
