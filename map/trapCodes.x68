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