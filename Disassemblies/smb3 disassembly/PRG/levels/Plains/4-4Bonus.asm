; Original address was $BA83
; 4-4 bonus area
    .word W404L ; Alternate level layout
    .word W404O ; Alternate object layout
    .byte LEVEL1_SIZE_02 | LEVEL1_YSTART_170
    .byte LEVEL2_BGPAL_05 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
    .byte LEVEL3_TILESET_11 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
    .byte 1 & %00011111 | LEVEL4_INITACT_NOTHING
    .byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_300

    .byte $4F, $00, $8B, $05, $55, $06, $84, $09, $4F, $10, $8B, $01, $57, $11, $83, $0A
    .byte $4F, $1C, $8B, $02, $2F, $00, $4F, $30, $00, $40, $31, $00, $40, $32, $00, $40
    .byte $33, $00, $40, $34, $00, $40, $35, $00, $40, $36, $00, $40, $37, $00, $40, $38
    .byte $00, $40, $39, $00, $40, $3A, $00, $4F, $30, $05, $40, $31, $05, $40, $32, $05
    .byte $40, $33, $05, $40, $34, $05, $40, $35, $05, $40, $36, $05, $40, $37, $05, $40
    .byte $30, $0F, $40, $31, $0F, $40, $32, $0F, $40, $33, $0F, $40, $34, $0F, $40, $35
    .byte $0F, $40, $36, $0F, $40, $37, $0F, $40, $37, $07, $46, $50, $06, $58, $51, $06
    .byte $58, $52, $06, $58, $53, $06, $53, $53, $0B, $53, $54, $06, $53, $54, $0B, $53
    .byte $34, $0A, $0D, $38, $01, $A2, $2F, $10, $4F, $30, $1F, $40, $31, $1F, $40, $32
    .byte $1F, $40, $33, $1F, $40, $34, $1F, $40, $35, $1F, $40, $36, $1F, $40, $37, $1F
    .byte $40, $38, $1F, $40, $39, $1F, $40, $3A, $10, $4F, $30, $11, $40, $31, $11, $40
    .byte $32, $11, $40, $33, $11, $40, $34, $11, $40, $35, $11, $40, $36, $11, $40, $37
    .byte $11, $40, $30, $1B, $40, $31, $1B, $40, $32, $1B, $40, $33, $1B, $40, $34, $1B
    .byte $40, $35, $1B, $40, $36, $1B, $40, $37, $1B, $40, $37, $13, $46, $37, $16, $0D
    .byte $30, $12, $18, $31, $12, $18, $32, $12, $18, $33, $12, $18, $34, $12, $88, $2F
    .byte $1C, $C1, $E1, $61, $42, $FF
