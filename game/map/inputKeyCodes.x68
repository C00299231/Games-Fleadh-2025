; this file contains relevant input keycodes

; BUTTON MAP:
;enter: A
;wasd: ls, dpad

;z: -
;0: home
;J: lb, lt
;K: rb, rt

;1: Y
;2: X

escapekey equ $1b ; pause
spacekey equ $20
enterKey equ $0d

wkey equ $57
akey equ $41
skey equ $53
dkey equ $44

pKey equ $50

zkey equ $5a ; toggle follow cam

key0 equ $30 ; toggle fullscreen
key1 equ $31 
key2 equ $32
key3 equ $33

wasdKeys equ $57415344 ; movement keys
runActionKeys equ $41444B20 ; run actions

; input prompts
jumpKeyMsg  dc.b 'Jump:     SPACEBAR / (B)',0
atkKeyMsg1  dc.b 'Swing:    K / (RB)',0
atkKeyMsg2  dc.b 'Throw:    J / (LB)',0

pauseKeyMsg dc.b 'Pause:    Esc / (+)',0

fsKeyMsg    dc.b 'Set FS:   0 / (HOME)',0
zoomKeyMsg  dc.b 'Set Zoom: Z / (-)',0

; pause prompts
pauseResetKeyMsg dc.b 'Reset: 1 / (Y)',0
pauseQuitKeyMsg dc.b 'Quit: 2 / (X)',0