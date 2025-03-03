*-----------------------------------------------------------
* Section       : Sounds
* Description   : Sound files, which are then loaded and given
* an address in memory, they take a longtime to process and play
* so keep the files small.
*-----------------------------------------------------------
GAMEOVER_INDEX   EQU             00          ; gameover sound
JMP_INDEX   EQU                  01          ; jump sound
HITHURT_INDEX  EQU               02          ; player hurt sound
POWERUP_INDEX  EQU               03          ; health up sound
HIT_INDEX  EQU                   05          ; enemy hit sound   
ROAR_INDEX  EQU                  06          ; brute enemy spawn sound
HILLHURT_INDEX  EQU              07          ; hill dmg sound
    
SONG_INDEX      equ              08          ; index for the current song
STING_INDEX     EQU              09          ; sound for end of round

loadAllSounds:
    ; Initialise Sounds
    BSR     JUMP_LOAD
    BSR     GAMEOVER_LOAD
    BSR     HITHURT_LOAD
    BSR     POWERUP_LOAD
    BSR     HIT_LOAD
    BSR     ROAR_LOAD
    BSR     HILLHURT_LOAD
    rts