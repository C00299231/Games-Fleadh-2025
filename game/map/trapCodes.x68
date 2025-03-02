; traps
tccrs  EQU 11       ; Trap code cursor position
tcdbl  EQU 92       ; Double Buffer Screen Trap Code
tcinp equ 19        ; get input trap code
tcScreen EQU 33    ; Screen size information trap code
tcScreenSize EQU 00    ; Places 0 in D1.L to retrieve Screen width and height in D1.L
                    ; First 16 bit Word is screen Width and Second 16 bits is screen Height
tcFont equ 21       ; change font style/colour
tcPenClr equ 80     ; change pen colour
tcPenFil equ 81     ; change pen fill
tcRect equ 87       ; draw rectangle
tcLine equ 84       ; draw line

tcFullScreen equ 33 ; toggle full screen


*-----------------------------------------------------------
* Section       : Trap Codes BATTLE
* Description   : Trap Codes used throughout StarterKit
*-----------------------------------------------------------
* Trap CODES
TC_SCREEN   EQU         33          ; Screen size information trap code
TC_S_SIZE   EQU         00          ; Places 0 in D1.L to retrieve Screen width and height in D1.L
                                    ; First 16 bit Word is screen Width and Second 16 bits is screen Height
TC_KEYCODE  EQU         19          ; Check for pressed keys
TC_DBL_BUF  EQU         92          ; Double Buffer Screen Trap Code
TC_CURSR_P  EQU         11          ; Trap code cursor position

TC_REDRAW   EQU         94          ; Redraw Screen
TC_EXIT     EQU         09          ; Exit Trapcode