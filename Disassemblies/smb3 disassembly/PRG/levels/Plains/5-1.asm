; Original address was $B44B
; 5-1
    .word W501_BonusL   ; Alternate level layout
    .word W501_BonusO   ; Alternate object layout
    .byte LEVEL1_SIZE_09 | LEVEL1_YSTART_180
    .byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
    .byte LEVEL3_TILESET_01 | LEVEL3_VSCROLL_FREE | LEVEL3_PIPENOTEXIT
    .byte 1 & %00011111 | LEVEL4_INITACT_NOTHING
    .byte LEVEL5_BGM_OVERWORLD | LEVEL5_TIME_300

    .byte $00, $00, $03, $1A, $00, $C0, $19, $59, $1A, $81, $41, $16, $02, $00, $59, $08
    .byte $B0, $00, $39, $09, $13, $38, $0C, $10, $09, $07, $E2, $12, $0A, $E2, $44, $0C
    .byte $B0, $01, $25, $0C, $C2, $38, $0D, $11, $57, $0E, $05, $10, $04, $07, $14, $08
    .byte $07, $19, $12, $93, $56, $12, $B0, $0F, $55, $14, $B0, $02, $54, $16, $B5, $00
    .byte $11, $14, $E2, $52, $1A, $B0, $04, $11, $1B, $92, $50, $1E, $B2, $00, $0A, $1C
    .byte $E2, $50, $1F, $B0, $03, $39, $14, $40, $35, $1A, $40, $39, $19, $40, $03, $12
    .byte $07, $07, $1A, $07, $0D, $16, $07, $30, $20, $10, $55, $22, $B1, $00, $51, $23
    .byte $B3, $00, $55, $23, $B0, $07, $33, $20, $01, $51, $28, $B3, $00, $51, $29, $B0
    .byte $03, $4F, $2C, $B0, $03, $50, $2C, $B0, $00, $4E, $2E, $B0, $03, $09, $28, $E2
    .byte $04, $2D, $E2, $02, $26, $07, $05, $28, $07, $07, $21, $E3, $0B, $24, $07, $34
    .byte $27, $40, $2A, $2C, $03, $26, $30, $82, $24, $34, $82, $4D, $30, $B0, $03, $4C
    .byte $32, $B0, $03, $0B, $32, $91, $4B, $34, $B0, $03, $09, $36, $91, $4A, $36, $B0
    .byte $03, $49, $38, $B0, $03, $48, $3A, $B0, $02, $47, $3C, $B0, $01, $46, $3D, $B0
    .byte $00, $27, $3E, $12, $10, $3B, $E2, $59, $35, $B1, $14, $16, $36, $01, $37, $3A
    .byte $91, $18, $3C, $91, $02, $34, $07, $12, $39, $07, $14, $3F, $07, $27, $3E, $0D
    .byte $35, $40, $40, $36, $40, $40, $36, $42, $16, $36, $41, $0B, $36, $43, $0B, $36
    .byte $45, $0B, $36, $47, $0B, $18, $40, $97, $12, $43, $E2, $47, $41, $B0, $01, $49
    .byte $41, $B0, $05, $46, $43, $B2, $00, $49, $47, $B2, $00, $4B, $48, $B0, $07, $48
    .byte $43, $B0, $00, $0A, $49, $94, $03, $45, $E2, $26, $49, $25, $4A, $4F, $B0, $07
    .byte $28, $44, $40, $26, $4C, $02, $03, $4F, $07, $46, $53, $B0, $01, $05, $56, $E2
    .byte $4B, $56, $B2, $00, $2D, $57, $10, $2E, $57, $10, $2F, $57, $10, $30, $57, $10
    .byte $31, $57, $10, $4D, $58, $B4, $00, $51, $59, $B0, $01, $52, $5A, $B3, $00, $55
    .byte $5B, $B0, $01, $56, $5C, $B3, $00, $1A, $5C, $C0, $33, $10, $59, $91, $14, $5B
    .byte $91, $19, $5E, $96, $29, $54, $41, $08, $5A, $07, $0D, $5D, $E3, $11, $60, $E2
    .byte $36, $62, $82, $12, $66, $02, $36, $6C, $82, $19, $6D, $92, $0F, $68, $07, $13
    .byte $65, $07, $13, $70, $E2, $37, $71, $10, $38, $71, $10, $39, $71, $10, $17, $72
    .byte $01, $40, $7B, $09, $0F, $79, $07, $11, $74, $07, $4B, $3E, $53, $4C, $3D, $55
    .byte $4D, $3D, $51, $4F, $3F, $52, $50, $3F, $52, $52, $3D, $51, $53, $3D, $55, $54
    .byte $3E, $53, $4D, $41, $51, $4E, $41, $51, $51, $41, $51, $52, $41, $51, $4E, $4D
    .byte $53, $4F, $4C, $55, $50, $4C, $51, $52, $4E, $52, $53, $4E, $52, $55, $4C, $51
    .byte $56, $4C, $55, $57, $4D, $53, $50, $50, $51, $51, $50, $51, $54, $50, $51, $55
    .byte $50, $51, $E0, $21, $20, $E3, $52, $E1, $FF