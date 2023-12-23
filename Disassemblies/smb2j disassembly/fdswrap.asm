;This file takes the assembled binaries of the program files and puts
;them into an FDS file along with the character files that are needed.
;In order for this to work, the program files need to already be assembled
;and the character files from the disk or disk image are also needed.

DiskInfoBlock     = 1
FileAmountBlock   = 2
FileHeaderBlock   = 3
FileDataBlock     = 4
PRG = 0
CHR = 1
VRAM = 2

 base 0

;FWNES header
 .db "FDS",$1a,1,0,0,0,0,0,0,0,0,0,0,0

 .db DiskInfoBlock
 .db "*NINTENDO-HVC*"
 .db $01,"SMB ",0,0,0,0,0,$0f
 .db $ff,$ff,$ff,$ff,$ff
 .db $61,$07,$23
 .db $49,$61,$00,$00,$02,$00,$1b,$00,$97,$00
 .db $61,$07,$23
 .db $ff,$ff,$ff,$ff,$ff,$00,$00,$00,$00

 .db FileAmountBlock
 .db 8

 .db FileHeaderBlock
 .db $00,$00
 .db "KYODAKU-"
 .dw $2800
 .dw KyodakuEnd-KyodakuStart
 .db VRAM

 .db FileDataBlock
KyodakuStart
 .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$17,$12,$17,$1d,$0e
 .db $17,$0d,$18,$24,$28,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24
 .db $24,$24,$24,$24,$24,$24,$24,$0f,$0a,$16,$12,$15,$22,$24,$0c,$18
 .db $16,$19,$1e,$1d,$0e,$1b,$24,$1d,$16,$24,$24,$24,$24,$24,$24,$24
 .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24
 .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24
 .db $24,$24,$1d,$11,$12,$1c,$24,$19,$1b,$18,$0d,$1e,$0c,$1d,$24,$12
 .db $1c,$24,$16,$0a,$17,$1e,$0f,$0a,$0c,$1d,$1e,$1b,$0e,$0d,$24,$24
 .db $24,$24,$0a,$17,$0d,$24,$1c,$18,$15,$0d,$24,$0b,$22,$24,$17,$12
 .db $17,$1d,$0e,$17,$0d,$18,$24,$0c,$18,$27,$15,$1d,$0d,$26,$24,$24
 .db $24,$24,$18,$1b,$24,$0b,$22,$24,$18,$1d,$11,$0e,$1b,$24,$0c,$18
 .db $16,$19,$0a,$17,$22,$24,$1e,$17,$0d,$0e,$1b,$24,$24,$24,$24,$24
 .db $24,$24,$15,$12,$0c,$0e,$17,$1c,$0e,$24,$18,$0f,$24,$17,$12,$17
 .db $1d,$0e,$17,$0d,$18,$24,$0c,$18,$27,$15,$1d,$0d,$26,$26,$24,$24
KyodakuEnd

 .db FileHeaderBlock
 .db $01,$01
 .db "SM2CHAR1"
 .dw $0000
 .dw Char1End-Char1Start
 .db CHR

 .db FileDataBlock
Char1Start
 .incbin "SM2CHAR1.bin"
Char1End

 .db FileHeaderBlock
 .db $02,$10
 .db "SM2CHAR2"
 .dw $0760
 .dw Char2End-Char2Start
 .db CHR

 .db FileDataBlock
Char2Start
 .incbin "SM2CHAR2.bin"
Char2End

 .db FileHeaderBlock
 .db $03,$05
 .db "SM2MAIN "
 .dw $6000
 .dw MainEnd-MainStart
 .db PRG

 .db FileDataBlock
MainStart
 .incbin "sm2main.bin"
MainEnd

 .db FileHeaderBlock
 .db $04,$20
 .db "SM2DATA2"
 .dw $c470
 .dw Data2End-Data2Start
 .db PRG

 .db FileDataBlock
Data2Start
 .incbin "sm2data2.bin"
Data2End

 .db FileHeaderBlock
 .db $05,$30
 .db "SM2DATA3"
 .dw $c5d0
 .dw Data3End-Data3Start
 .db PRG

 .db FileDataBlock
Data3Start
 .incbin "sm2data3.bin"
Data3End

 .db FileHeaderBlock
 .db $06,$40
 .db "SM2DATA4"
 .dw $c2b4
 .dw Data4End-Data4Start
 .db PRG

 .db FileDataBlock
Data4Start
 .incbin "sm2data4.bin"
Data4End

 .db FileHeaderBlock
 .db $07,$0f
 .db "SM2SAVE "
 .dw $d29f
 .dw 1
 .db PRG

 .db FileDataBlock
 .db 0

 .pad $ffec,0