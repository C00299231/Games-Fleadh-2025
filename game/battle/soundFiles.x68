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

byte_align dc.b 0

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

*-----------------------------------------------------------
* Subroutines   : Sound Load and Play
* Description   : Initialise game sounds into memory 
*-----------------------------------------------------------
GAMEOVER_LOAD:
    LEA     GAMEOVER_WAV,    A1          ; Load Wav File into A1
    MOVE    #GAMEOVER_INDEX, D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

PLAY_GAMEOVER:
    bsr STOP_SONG
    MOVE    #GAMEOVER_INDEX, D1          ; Load Sound INDEX
    MOVE    #75,        D0          ; Play Sound
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

JUMP_LOAD:
    LEA     JUMP_WAV,   A1          ; Load Wav File into A1
    MOVE    #JMP_INDEX, D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

PLAY_JUMP:
    MOVE    #JMP_INDEX, D1          ; Load Sound INDEX
    MOVE    #75,        D0          ; Play Sound
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

HITHURT_LOAD:
    LEA     HITHURT_WAV,   A1          ; Load Wav File into A1
    MOVE    #HITHURT_INDEX,D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

PLAY_HITHURT:
    MOVE    #HITHURT_INDEX,D1          ; Load Sound INDEX
    MOVE    #75,        D0          ; Play Sound
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

POWERUP_LOAD:
    LEA     POWERUP_WAV,   A1          ; Load Wav File into A1
    MOVE    #POWERUP_INDEX,D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

PLAY_POWERUP:
    MOVE    #POWERUP_INDEX,D1          ; Load Sound INDEX
    MOVE    #75,        D0          ; Play Sound
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

HIT_LOAD:
    LEA     HIT_WAV,   A1          ; Load Wav File into A1
    MOVE    #HIT_INDEX,D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

PLAY_HIT:
    MOVE    #HIT_INDEX,D1          ; Load Sound INDEX
    MOVE    #75,        D0          ; Play Sound
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

ROAR_LOAD:
    LEA     ROAR_WAV,   A1          ; Load Wav File into A1
    MOVE    #ROAR_INDEX,D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

PLAY_ROAR:
    MOVE    #ROAR_INDEX,D1          ; Load Sound INDEX
    MOVE    #75,        D0          ; Play Sound
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

HILLHURT_LOAD:
    LEA     HILLHURT_WAV,   A1          ; Load Wav File into A1
    MOVE    #HILLHURT_INDEX,D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

PLAY_HILLHURT:
    MOVE    #HILLHURT_INDEX,D1          ; Load Sound INDEX
    MOVE    #75,        D0          ; Play Sound
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

; songs
MAP_SONG_LOAD:
    LEA     MAP_SONG_WAV,   A1          ; Load Wav File into A1
    MOVE    #SONG_INDEX,D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

BATTLE_SONG_LOAD:
    LEA     BATTLE_SONG_WAV,   A1          ; Load Wav File into A1
    MOVE    #SONG_INDEX,D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

MENU_SONG_LOAD:
    LEA     MENU_SONG_WAV,   A1          ; Load Wav File into A1
    MOVE    #SONG_INDEX,D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

; stings
LOSS_STING_LOAD:
    LEA     LOSS_STING_WAV,   A1          ; Load Wav File into A1
    MOVE    #STING_INDEX,D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

WIN_STING_LOAD:
    LEA     WIN_STING_WAV,   A1          ; Load Wav File into A1
    MOVE    #STING_INDEX,D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

ACHIEVE_STING_LOAD:
    LEA     ACHIEVE_STING_WAV,   A1          ; Load Wav File into A1
    MOVE    #STING_INDEX,D1          ; Assign it INDEX
    MOVE    #74,        D0          ; Load into memory
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

; special function to play song in song index
PLAY_SONG:
    MOVE    #SONG_INDEX,D1          ; Load Sound INDEX
    move.l #1, d2
    MOVE    #77,        D0          ; Play Sound
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

; stop song playing
STOP_SONG:
    move #SONG_INDEX,d1
    move.l #2, d2
    move #77, d0
    trap #15
    rts

PLAY_Sting:
    MOVE    #Sting_INDEX,D1          ; Load Sound INDEX
    MOVE    #75,        D0          ; Play Sound
    TRAP    #15                     ; Trap (Perform action)
    RTS                             ; Return to subroutine

; stop song playing
STOP_sting:
    move #stinG_INDEX,d1
    move.l #2, d2
    move #77, d0
    trap #15
    rts
