;SMB2J DISASSEMBLY (SM2DATA2 portion)

;-------------------------------------------------------------------------------------
;DEFINES

FrameCounter          = $09
Enemy_State           = $1e
Enemy_Y_Position      = $cf
PiranhaPlantUpYPos    = $0417
PiranhaPlantDownYPos  = $0434
PiranhaPlant_Y_Speed  = $58
PiranhaPlant_MoveFlag = $a0

Player_X_Scroll       = $06ff

Player_PageLoc        = $6d
Player_X_Position     = $86

AreaObjectLength      = $0730
WindFlag              = $07f9
AreaType              = $074e

TimerControl          = $0747
EnemyFrameTimer       = $078a
WorldNumber           = $075f

Sprite_Y_Position     = $0200
Sprite_Tilenumber     = $0201
Sprite_Attributes     = $0202
Sprite_X_Position     = $0203

Alt_SprDataOffset     = $06ec

NoiseSoundQueue       = $fd

MetatileBuffer        = $06a1

; import from other files
GetPipeHeight      = $7761
FindEmptyEnemySlot = $7791
SetupPiranhaPlant  = $7772
VerticalPipeData   = $7729
RenderUnderPart    = $79c6

.base $c470

;-------------------------------------------------------------------------------------------------
;$06 - used to store vertical length of pipe
;$07 - starts with adder from area parser, used to store row offset

UpsideDownPipe_High:
       lda #$01                     ;start at second row
       pha
       bne UDP
UpsideDownPipe_Low:
       lda #$04                     ;start at fifth row
       pha
UDP:   jsr GetPipeHeight            ;get pipe height from object byte
       pla
       sta $07                      ;save buffer offset temporarily
       tya
       pha                          ;save pipe height temporarily
       ldy AreaObjectLength,x       ;if on second column of pipe, skip this
       beq NoUDP
       jsr FindEmptyEnemySlot       ;otherwise try to insert upside-down
       bcs NoUDP                    ;piranha plant, if no empty slots, skip this
       lda #$04
       jsr SetupPiranhaPlant        ;set up upside-down piranha plant
       lda $06
       asl
       asl                          ;multiply height of pipe by 16
       asl                          ;and add enemy Y position previously set up
       asl                          ;then subtract 10 pixels, save as new Y position
       clc
       adc Enemy_Y_Position,x
       sec
       sbc #$0a
       sta Enemy_Y_Position,x
       sta PiranhaPlantDownYPos,x   ;set as "down" position
       clc                          ;add 24 pixels, save as "up" position
       adc #$18                     ;note up and down here are reversed
       sta PiranhaPlantUpYPos,x     
       inc PiranhaPlant_MoveFlag,x  ;set movement flag
NoUDP: pla
       tay                          ;return tile offset
       pha
       ldx $07
       lda VerticalPipeData+2,y
       ldy $06                      ;render the pipe shaft
       dey
       jsr RenderUnderPart
       pla
       tay
       lda VerticalPipeData,y       ;and render the pipe end
       sta MetatileBuffer,x
       rts

       rts                        ;unused, nothing jumps here

MoveUpsideDownPiranhaP:
      lda Enemy_State,x           ;check enemy state
      bne ExMoveUDPP              ;if set at all, branch to leave
      lda EnemyFrameTimer,x       ;check enemy's timer here
      bne ExMoveUDPP              ;branch to end if not yet expired
      lda PiranhaPlant_MoveFlag,x ;check movement flag
      bne SetupToMovePPlant       ;if moving, skip to part ahead
      lda PiranhaPlant_Y_Speed,x  ;get vertical speed
      eor #$ff
      clc                         ;change to two's compliment
      adc #$01
      sta PiranhaPlant_Y_Speed,x  ;save as new vertical speed
      inc PiranhaPlant_MoveFlag,x ;increment to set movement flag

SetupToMovePPlant:
      lda PiranhaPlantUpYPos,x    ;get original vertical coordinate (lowest point)
      ldy PiranhaPlant_Y_Speed,x  ;get vertical speed
      bpl RiseFallPiranhaPlant    ;branch if moving downwards
      lda PiranhaPlantDownYPos,x  ;otherwise get other vertical coordinate (highest point)

RiseFallPiranhaPlant:
       sta $00                     ;save vertical coordinate here
       lda TimerControl            ;get master timer control
       bne ExMoveUDPP              ;branch to leave if set (likely not necessary)
       lda Enemy_Y_Position,x      ;get current vertical coordinate
       clc
       adc PiranhaPlant_Y_Speed,x  ;add vertical speed to move up or down
       sta Enemy_Y_Position,x      ;save as new vertical coordinate
       cmp $00                     ;compare against low or high coordinate
       bne ExMoveUDPP              ;branch to leave if not yet reached
       lda #$00
       sta PiranhaPlant_MoveFlag,x ;otherwise clear movement flag
       lda #$20
       sta EnemyFrameTimer,x       ;set timer to delay piranha plant movement
ExMoveUDPP:
       rts

;-------------------------------------------------------------------------------------

HardWorldJumpSpringHandler:
  ldy WorldNumber
  cpy #$01
  beq @Shift
  cpy #$02
  bne @Done
@Shift:
  lda #$E0
@Done:
  rts

HardWorldEnemyGfxHandler:
  ldy WorldNumber
  cpy #$01
  beq @Shift
  cpy #$02
  bne @Done
@Shift:
  lsr a
@Done:
  rts

;unused bytes
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF

E_Area06:
.byte $49,$9F,$67,$03,$79,$9D,$A0,$3A,$57,$9F,$BB,$1D,$D5,$25,$0F,$05
.byte $18,$1D,$74,$00,$84,$00,$94,$00,$C6,$29,$49,$9D,$DB,$05,$0F,$08
.byte $05,$1B,$09,$1D,$B0,$38,$80,$95,$C0,$3C,$EC,$A8,$CC,$8C,$4A,$9B
.byte $78,$2D,$90,$B5,$FF

E_Area07:
.byte $74,$80,$F0,$38,$A0,$BB,$40,$BC,$8C,$1D,$C9,$9D,$05,$9B,$1C,$0C
.byte $59,$1B,$B5,$1D,$2C,$8C,$40,$15,$7C,$1B,$DC,$1D,$6C,$8C,$BC,$0C
.byte $78,$AD,$A5,$28,$90,$B5,$FF

E_Area04:
.byte $27,$A9,$4B,$0C,$68,$29,$0F,$06,$77,$1B,$0F,$0B,$60,$15,$4B,$8C
.byte $78,$2D,$90,$B5,$FF

E_Area05:
.byte $19,$9B,$99,$1B,$2C,$8C,$59,$1B,$C5,$0F,$0E,$82,$E0,$0F,$06,$2E
.byte $65,$E7,$0F,$08,$9B,$07,$0E,$82,$E0,$39,$0E,$87,$10,$BD,$28,$59
.byte $9F,$0F,$0F,$34,$0F,$77,$10,$9E,$65,$F1,$0F,$12,$0E,$65,$E3,$78
.byte $2D,$0F,$15,$3B,$29,$57,$82,$0F,$18,$55,$1D,$78,$2D,$90,$B5,$FF

E_Area09:
.byte $EB,$8E,$0F,$03,$FB,$05,$17,$85,$DB,$8E,$0F,$07,$57,$05,$7B,$05
.byte $9B,$80,$2B,$85,$FB,$05,$0F,$0B,$1B,$05,$9B,$05,$FF

E_Area0B:
.byte $0E,$C3,$A6,$AB,$00,$BB,$8E,$6B,$82,$DE,$00,$A0,$33,$86,$43,$06
.byte $3E,$BA,$A0,$CB,$02,$0F,$07,$7E,$43,$A4,$83,$02,$0F,$0A,$3B,$02
.byte $CB,$37,$0F,$0C,$E3,$0E,$FF

E_Area1E:
.byte $E6,$A9,$57,$A8,$B5,$24,$19,$A4,$76,$28,$A2,$0F,$95,$8F,$9D,$A8
.byte $0F,$07,$09,$29,$55,$24,$8B,$17,$A9,$24,$DB,$83,$04,$A9,$24,$8F
.byte $65,$0F,$FF

E_Area1F:
.byte $0F,$02,$28,$10,$E6,$03,$D8,$90,$0F,$05,$85,$0F,$78,$83,$C8,$10
.byte $18,$83,$58,$83,$F7,$90,$0F,$0C,$43,$0F,$73,$8F,$FF

E_Area12:
.byte $0B,$80,$60,$38,$10,$B8,$C0,$3B,$DB,$8E,$40,$B8,$F0,$38,$7B,$8E
.byte $A0,$B8,$C0,$B8,$FB,$00,$A0,$B8,$30,$BB,$EE,$43,$86,$0F,$0B,$2B
.byte $0E,$67,$0E,$FF

E_Area21:
.byte $0A,$AA,$0E,$31,$88,$FF

E_Area15:
.byte $CD,$A5,$B5,$A8,$07,$A8,$76,$28,$CC,$25,$65,$A4,$A9,$24,$E5,$24
.byte $19,$A4,$64,$8F,$95,$A8,$E6,$24,$19,$A4,$D7,$29,$16,$A9,$58,$29
.byte $97,$29,$FF

E_Area16:
.byte $0F,$02,$02,$11,$0F,$07,$02,$11,$FF

E_Area18:
.byte $2B,$82,$AB,$38,$DE,$43,$E2,$1B,$B8,$EB,$3B,$DB,$80,$8B,$B8,$1B
.byte $82,$FB,$B8,$7B,$80,$FB,$3C,$5B,$BC,$7B,$B8,$1B,$8E,$CB,$0E,$1B
.byte $8E,$0F,$0D,$2B,$3B,$BB,$B8,$EB,$82,$4B,$B8,$BB,$38,$3B,$B7,$BB
.byte $02,$0F,$13,$1B,$00,$CB,$80,$6B,$BC,$FF

E_Area19:
.byte $7B,$80,$AE,$00,$80,$8B,$8E,$E8,$05,$F9,$86,$17,$86,$16,$85,$4E
.byte $39,$80,$AB,$8E,$87,$85,$C3,$05,$8B,$82,$9B,$02,$AB,$02,$BB,$86
.byte $CB,$06,$D3,$03,$3B,$8E,$6B,$0E,$A7,$8E,$FF

E_Area1A:
.byte $29,$8E,$52,$11,$83,$0E,$0F,$03,$3B,$0E,$9B,$0E,$2B,$8E,$5B,$0E
.byte $CB,$8E,$FB,$0E,$FB,$82,$9B,$82,$BB,$02,$FE,$43,$E6,$BB,$8E,$0F
.byte $0A,$AB,$0E,$CB,$0E,$F9,$0E,$88,$86,$A6,$06,$DB,$02,$B6,$8E,$FF

E_Area1B:
.byte $AB,$CE,$DE,$43,$C0,$CB,$CE,$5B,$8E,$1B,$CE,$4B,$85,$67,$45,$0F
.byte $07,$2B,$00,$7B,$85,$97,$05,$0F,$0A,$92,$02,$FF

E_Area22:
.byte $0A,$AA,$1E,$23,$AA,$FF

E_Area27:
.byte $1E,$B3,$C7,$0F,$03,$1E,$30,$E7,$0F,$05,$1E,$23,$AB,$0F,$07,$1E
.byte $2A,$8A,$2E,$23,$A2,$2E,$32,$EA,$FF

E_Area28:
.byte $3B,$87,$66,$27,$CC,$27,$EE,$31,$87,$EE,$23,$A7,$3B,$87,$DB,$07
.byte $FF

E_Area2B:
.byte $2E,$B8,$C1,$5B,$07,$AB,$07,$69,$87,$BA,$07,$FB,$87,$65,$A7,$6A
.byte $27,$A6,$A7,$AC,$27,$1B,$87,$88,$07,$2B,$83,$7B,$07,$A7,$90,$E5
.byte $83,$14,$A7,$19,$27,$77,$07,$F8,$07,$47,$8F,$B9,$07,$FF

E_Area2A:
.byte $07,$9B,$0A,$07,$B9,$1B,$66,$9B,$78,$07,$AE,$65,$E5,$FF

L_Area06:
.byte $9B,$07,$05,$32,$06,$33,$07,$34,$4E,$03,$5C,$02,$0C,$F1,$27,$00
.byte $3C,$74,$47,$0B,$FC,$00,$FE,$0B,$77,$8B,$EE,$09,$FE,$0A,$45,$B2
.byte $55,$0B,$99,$32,$B9,$0B,$FE,$02,$0E,$85,$FE,$02,$16,$8B,$2E,$0C
.byte $AE,$0A,$EE,$05,$1E,$82,$47,$0B,$07,$BD,$C4,$72,$DE,$0A,$FE,$02
.byte $03,$8B,$07,$0B,$13,$3C,$17,$3D,$E3,$02,$EE,$0A,$F3,$04,$F7,$02
.byte $FE,$0E,$FE,$8A,$38,$E4,$4A,$72,$68,$64,$37,$B0,$98,$64,$A8,$64
.byte $E8,$64,$F8,$64,$0D,$C4,$71,$64,$CD,$43,$CE,$09,$DD,$42,$DE,$0B
.byte $FE,$02,$5D,$C7,$FD

L_Area07:
.byte $9B,$87,$05,$32,$06,$33,$07,$34,$03,$E2,$0E,$06,$1E,$0C,$7E,$0A
.byte $8E,$05,$8E,$82,$8A,$8B,$8E,$0A,$EE,$02,$0A,$E0,$19,$61,$23,$04
.byte $28,$62,$2E,$0B,$7E,$0A,$81,$62,$87,$30,$8E,$04,$A7,$31,$C7,$0B
.byte $D7,$33,$FE,$03,$03,$8B,$0E,$0A,$11,$62,$1E,$04,$27,$32,$4E,$0A
.byte $51,$62,$57,$0B,$5E,$04,$67,$34,$9E,$0A,$A1,$62,$AE,$03,$B3,$0B
.byte $BE,$0B,$EE,$09,$FE,$0A,$2E,$82,$7A,$0B,$7E,$0A,$97,$31,$A6,$10
.byte $BE,$04,$DA,$0B,$EE,$0A,$F1,$62,$FE,$02,$3E,$8A,$7E,$06,$AE,$0A
.byte $CE,$06,$FE,$0A,$0D,$C4,$11,$53,$21,$52,$24,$08,$51,$52,$61,$52
.byte $CD,$43,$CE,$09,$DD,$42,$DE,$0B,$FE,$02,$5D,$C7,$FD

L_Area04:
.byte $5B,$07,$05,$32,$06,$33,$07,$34,$FE,$0A,$AE,$86,$BE,$07,$FE,$02
.byte $0D,$02,$27,$32,$46,$61,$55,$62,$5E,$0E,$1E,$82,$68,$3C,$74,$3A
.byte $7D,$4B,$5E,$8E,$7D,$4B,$7E,$82,$84,$62,$94,$61,$A4,$31,$BD,$4B
.byte $CE,$06,$FE,$02,$0D,$06,$34,$31,$3E,$0A,$64,$32,$75,$0B,$7B,$61
.byte $A4,$33,$AE,$02,$DE,$0E,$3E,$82,$64,$32,$78,$32,$B4,$36,$C8,$36
.byte $DD,$4B,$44,$B2,$58,$32,$94,$63,$A4,$3E,$BA,$30,$C9,$61,$CE,$06
.byte $DD,$4B,$CE,$86,$DD,$4B,$FE,$0A,$2E,$86,$5E,$0A,$7E,$06,$FE,$02
.byte $1E,$86,$3E,$0A,$5E,$06,$7E,$02,$9E,$06,$FE,$0A,$0D,$C4,$CD,$43
.byte $CE,$09,$DE,$0B,$DD,$42,$FE,$02,$5D,$C7,$FD

L_Area05:
.byte $5B,$03,$05,$34,$06,$35,$07,$36,$6E,$0A,$EE,$02,$FE,$05,$0D,$01
.byte $17,$0B,$97,$0B,$9E,$02,$C6,$04,$FA,$30,$FE,$0A,$4E,$82,$57,$0B
.byte $58,$62,$68,$62,$79,$61,$8A,$60,$8E,$0A,$F5,$31,$F9,$7B,$39,$F3
.byte $97,$33,$B5,$71,$39,$F3,$4D,$48,$9E,$02,$AE,$05,$CD,$4A,$ED,$4B
.byte $0E,$81,$17,$04,$39,$73,$5C,$02,$85,$65,$95,$32,$A9,$7B,$CC,$03
.byte $5E,$8F,$6D,$47,$FE,$02,$0D,$07,$39,$73,$4E,$0A,$AE,$02,$E7,$23
.byte $07,$88,$39,$73,$E6,$04,$39,$FB,$4E,$0A,$C4,$31,$EB,$61,$FE,$02
.byte $07,$B0,$1E,$0A,$4E,$06,$57,$0B,$BE,$02,$C9,$61,$DA,$60,$ED,$4B
.byte $0E,$85,$0D,$0E,$FE,$0A,$78,$E4,$8E,$06,$BF,$47,$EE,$0F,$6D,$C7
.byte $0E,$82,$39,$73,$9A,$60,$A9,$61,$AE,$06,$DE,$0A,$E7,$02,$EB,$79
.byte $F7,$02,$FE,$06,$0D,$14,$FE,$0A,$5E,$82,$78,$74,$9E,$0A,$F8,$64
.byte $FE,$0B,$9E,$84,$BE,$05,$BE,$82,$DA,$60,$E9,$61,$F8,$62,$FE,$0A
.byte $0D,$C4,$11,$64,$51,$62,$CD,$43,$CE,$09,$DD,$42,$DE,$0B,$FE,$02
.byte $5D,$C7,$FD

L_Area09:
.byte $90,$B1,$0F,$26,$29,$91,$7E,$42,$FE,$40,$28,$92,$4E,$42,$2E,$C0
.byte $57,$73,$C3,$27,$C7,$27,$D3,$05,$5C,$81,$77,$63,$88,$62,$99,$61
.byte $AA,$60,$BC,$01,$EE,$42,$4E,$C0,$69,$11,$7E,$42,$DE,$40,$F8,$62
.byte $0E,$C2,$AE,$40,$D7,$63,$E7,$63,$33,$A5,$37,$27,$82,$42,$93,$05
.byte $A3,$20,$CC,$01,$E7,$73,$0C,$81,$3E,$42,$0D,$0A,$5E,$40,$88,$72
.byte $BE,$42,$E7,$88,$FE,$40,$39,$E1,$4E,$00,$69,$60,$87,$60,$A5,$60
.byte $C3,$31,$FE,$31,$6D,$C1,$BE,$42,$EF,$20,$8D,$C7,$FD

L_Area0B:
.byte $54,$21,$0F,$26,$A7,$22,$37,$FB,$73,$05,$83,$08,$87,$02,$93,$20
.byte $C7,$73,$04,$F1,$06,$31,$39,$71,$59,$71,$E7,$73,$37,$A0,$47,$08
.byte $86,$7C,$E5,$71,$E7,$31,$33,$A4,$39,$71,$A9,$71,$D3,$23,$08,$F2
.byte $13,$06,$27,$02,$49,$71,$75,$75,$E8,$72,$67,$F3,$99,$71,$E7,$20
.byte $F4,$72,$F7,$31,$17,$A0,$33,$20,$39,$71,$73,$28,$BC,$05,$39,$F1
.byte $79,$71,$A6,$21,$C3,$21,$DC,$00,$FC,$00,$07,$A2,$13,$20,$23,$07
.byte $5F,$32,$8C,$00,$98,$7A,$C7,$63,$D9,$61,$03,$A2,$07,$22,$74,$72
.byte $77,$31,$E7,$73,$39,$F1,$58,$72,$77,$73,$D8,$72,$7F,$B1,$97,$73
.byte $B6,$64,$C5,$65,$D4,$66,$E3,$67,$F3,$67,$8D,$C1,$CF,$26,$AD,$C7
.byte $FD

L_Area1E:
.byte $50,$11,$0F,$26,$FE,$10,$8B,$93,$A9,$0C,$14,$C1,$CC,$16,$CF,$11
.byte $2F,$95,$B7,$14,$C7,$96,$D6,$44,$2B,$92,$39,$0C,$72,$41,$A7,$00
.byte $1B,$95,$97,$13,$6C,$95,$6F,$11,$A2,$40,$BF,$15,$C2,$40,$0B,$9F
.byte $53,$16,$62,$44,$72,$C2,$9B,$1D,$B7,$E0,$ED,$4A,$03,$E0,$8E,$11
.byte $9D,$41,$BE,$42,$EF,$20,$CD,$C7,$FD

L_Area1F:
.byte $50,$11,$0F,$26,$AF,$32,$D8,$62,$DE,$10,$08,$E4,$5A,$62,$6C,$4C
.byte $86,$43,$AD,$48,$3A,$E2,$53,$42,$88,$64,$9C,$36,$08,$E4,$4A,$62
.byte $5C,$4D,$3A,$E2,$9C,$32,$FC,$41,$3C,$B1,$83,$00,$AC,$42,$2A,$E2
.byte $3C,$46,$AA,$62,$BC,$4E,$C6,$43,$46,$C3,$AA,$62,$BD,$48,$0B,$96
.byte $47,$05,$C7,$12,$3C,$C2,$9C,$41,$CD,$48,$DC,$32,$4C,$C2,$BC,$32
.byte $1C,$B1,$5A,$62,$6C,$44,$76,$43,$BA,$62,$DC,$32,$5D,$CA,$73,$12
.byte $E3,$12,$8E,$91,$9D,$41,$BE,$42,$EF,$20,$CD,$C7,$FD

L_Area12:
.byte $95,$B1,$0F,$26,$0D,$02,$C8,$72,$1C,$81,$38,$72,$0D,$05,$97,$34
.byte $98,$62,$A3,$20,$B3,$07,$C3,$20,$CC,$03,$F9,$91,$2C,$81,$48,$62
.byte $0D,$09,$37,$63,$47,$03,$57,$02,$8C,$02,$C5,$79,$C7,$31,$F9,$11
.byte $39,$F1,$A9,$11,$6F,$B4,$D3,$65,$E3,$65,$7D,$C1,$BF,$26,$9D,$C7
.byte $FD

L_Area21:
.byte $00,$C1,$4C,$00,$F4,$4F,$0D,$02,$02,$42,$43,$4F,$52,$C2,$DE,$00
.byte $5A,$C2,$4D,$C7,$FD

L_Area15:
.byte $97,$11,$0F,$26,$FE,$10,$2B,$92,$57,$12,$8B,$12,$C0,$41,$F7,$13
.byte $5B,$92,$69,$0C,$BB,$12,$B2,$46,$19,$93,$71,$00,$17,$94,$7C,$14
.byte $7F,$11,$93,$41,$BF,$15,$FC,$13,$FF,$11,$2F,$95,$50,$42,$51,$12
.byte $58,$14,$A6,$12,$DB,$12,$1B,$93,$46,$43,$7B,$12,$8D,$49,$B7,$14
.byte $1B,$94,$49,$0C,$BB,$12,$FC,$13,$FF,$12,$03,$C1,$2F,$15,$43,$12
.byte $4B,$13,$77,$13,$9D,$4A,$15,$C1,$A1,$41,$C3,$12,$FE,$01,$7D,$C1
.byte $9E,$42,$CF,$20,$9D,$C7,$FD

L_Area16:
.byte $52,$21,$0F,$20,$6E,$44,$0C,$F1,$4C,$01,$AA,$35,$D9,$34,$EE,$20
.byte $08,$B3,$37,$32,$43,$08,$4E,$21,$53,$20,$7C,$01,$97,$21,$B7,$05
.byte $9C,$81,$E7,$42,$5F,$B3,$97,$63,$AC,$02,$C5,$41,$49,$E0,$58,$61
.byte $76,$64,$85,$65,$94,$66,$A4,$22,$A6,$03,$C8,$22,$DC,$02,$68,$F2
.byte $96,$42,$13,$82,$17,$02,$AF,$34,$F6,$21,$FC,$06,$26,$80,$2A,$24
.byte $36,$01,$8C,$00,$FF,$35,$4E,$A0,$55,$21,$77,$20,$87,$08,$89,$22
.byte $AE,$21,$4C,$82,$9F,$34,$EC,$01,$03,$E7,$13,$67,$8D,$4A,$AD,$41
.byte $0F,$A6,$CD,$47,$FD

L_Area18:
.byte $92,$31,$0F,$20,$6E,$40,$0D,$02,$37,$73,$EC,$00,$0C,$80,$3C,$00
.byte $6C,$00,$9C,$00,$06,$C0,$C7,$73,$06,$84,$28,$72,$96,$40,$E7,$73
.byte $26,$C0,$87,$7B,$D2,$41,$39,$F1,$C8,$F2,$97,$E3,$A3,$23,$E7,$02
.byte $E3,$08,$F3,$22,$37,$E3,$9C,$00,$BC,$00,$EC,$00,$0C,$80,$3C,$00
.byte $86,$27,$5C,$80,$7C,$00,$9C,$00,$29,$E1,$DC,$05,$F6,$41,$DC,$80
.byte $E8,$72,$0C,$81,$27,$73,$4C,$01,$66,$74,$A6,$07,$0D,$11,$3F,$35
.byte $B6,$41,$2C,$82,$36,$40,$7C,$02,$86,$40,$F9,$61,$16,$83,$39,$61
.byte $AC,$04,$C6,$41,$0C,$83,$16,$41,$88,$F2,$39,$F1,$7C,$00,$89,$61
.byte $9C,$00,$A7,$63,$BC,$00,$C5,$65,$DC,$00,$E3,$67,$F3,$67,$8D,$C1
.byte $CF,$26,$AD,$C7,$FD

L_Area19:
.byte $55,$B1,$0F,$26,$CF,$33,$07,$B2,$15,$11,$52,$42,$99,$0C,$AC,$02
.byte $D3,$24,$D6,$42,$D7,$25,$23,$85,$CF,$33,$07,$E3,$19,$61,$78,$7A
.byte $EF,$33,$2C,$81,$46,$64,$55,$65,$65,$65,$0C,$F4,$53,$05,$62,$41
.byte $63,$21,$96,$22,$9A,$41,$CC,$03,$B9,$91,$C3,$06,$E6,$02,$39,$F1
.byte $63,$26,$67,$27,$D3,$07,$FC,$01,$18,$E2,$D9,$08,$E9,$05,$0C,$86
.byte $37,$22,$93,$24,$87,$85,$AC,$02,$C2,$41,$C3,$23,$D9,$71,$FC,$01
.byte $7F,$B1,$9C,$00,$A7,$63,$B6,$64,$CC,$00,$D4,$66,$E3,$67,$F3,$67
.byte $8D,$C1,$CF,$26,$AD,$C7,$FD

L_Area1A:
.byte $50,$B1,$0F,$26,$FC,$00,$1F,$B3,$5C,$00,$65,$65,$74,$66,$83,$67
.byte $93,$67,$DC,$73,$4C,$80,$B3,$20,$C3,$09,$C9,$0C,$D3,$2F,$DC,$00
.byte $2C,$80,$4C,$00,$8C,$00,$D3,$2E,$ED,$4A,$FC,$00,$93,$85,$97,$02
.byte $EC,$01,$4C,$80,$59,$11,$D8,$11,$DA,$10,$37,$A0,$47,$08,$99,$11
.byte $E7,$21,$3A,$90,$67,$20,$76,$10,$77,$60,$87,$20,$D8,$12,$39,$F1
.byte $AC,$00,$E9,$71,$0C,$80,$2C,$00,$4C,$05,$C7,$7B,$39,$F1,$EC,$00
.byte $F9,$11,$0C,$82,$6F,$34,$F8,$11,$FA,$10,$7F,$B2,$AC,$00,$B6,$64
.byte $CC,$01,$E3,$67,$F3,$67,$8D,$C1,$CF,$26,$AD,$C7,$FD

L_Area1B:
.byte $52,$B1,$0F,$20,$6E,$45,$39,$91,$B3,$08,$C3,$21,$C8,$11,$CA,$10
.byte $49,$91,$7C,$71,$97,$00,$A7,$01,$E8,$12,$88,$91,$8A,$10,$E7,$20
.byte $F7,$08,$05,$91,$07,$30,$17,$21,$49,$11,$9C,$01,$C8,$72,$2C,$E6
.byte $2C,$76,$D3,$03,$D8,$7A,$89,$91,$D8,$72,$39,$F1,$A9,$11,$09,$F1
.byte $33,$26,$37,$27,$A3,$08,$D8,$62,$28,$91,$2A,$10,$56,$21,$70,$05
.byte $79,$0C,$8C,$00,$94,$21,$9F,$35,$2F,$B8,$3D,$C1,$7F,$26,$5D,$C7
.byte $FD

L_Area22:
.byte $06,$C1,$4C,$00,$F4,$4F,$0D,$02,$06,$20,$24,$4F,$35,$A0,$36,$20
.byte $53,$46,$D5,$20,$D6,$20,$34,$A1,$73,$49,$74,$20,$94,$20,$B4,$20
.byte $D4,$20,$F4,$20,$2E,$80,$59,$42,$4D,$C7,$FD

L_Area27:
.byte $48,$01,$0E,$01,$00,$5A,$3E,$06,$45,$46,$47,$46,$53,$44,$AE,$01
.byte $DF,$4A,$4D,$C7,$0E,$81,$00,$5A,$2E,$04,$37,$28,$3A,$48,$46,$47
.byte $C7,$08,$CE,$0F,$DF,$4A,$4D,$C7,$0E,$81,$00,$5A,$2E,$02,$36,$47
.byte $37,$52,$3A,$49,$47,$25,$A7,$52,$D7,$05,$DF,$4A,$4D,$C7,$0E,$81
.byte $00,$5A,$3E,$02,$44,$51,$53,$44,$54,$44,$55,$24,$A1,$54,$AE,$01
.byte $B4,$21,$DF,$4A,$E5,$08,$4D,$C7,$FD

L_Area28:
.byte $41,$01,$B4,$34,$C8,$52,$F2,$51,$47,$D3,$6C,$03,$65,$49,$9E,$07
.byte $BE,$01,$CC,$03,$FE,$07,$0D,$C9,$1E,$01,$6C,$01,$62,$35,$63,$53
.byte $8A,$41,$AC,$01,$B3,$53,$E9,$51,$26,$C3,$27,$33,$63,$43,$64,$33
.byte $BA,$60,$C9,$61,$CE,$0B,$D4,$31,$E5,$0A,$EE,$0F,$7D,$CA,$7D,$47
.byte $FD

L_Area2B:
.byte $41,$01,$27,$D3,$79,$51,$C4,$56,$00,$E2,$03,$53,$0C,$0F,$12,$3B
.byte $1A,$42,$43,$54,$6D,$49,$83,$53,$99,$53,$C3,$54,$DA,$52,$0C,$84
.byte $09,$53,$53,$64,$63,$31,$67,$34,$86,$41,$8C,$01,$A3,$30,$B3,$64
.byte $CC,$03,$D9,$42,$5C,$84,$A0,$62,$A8,$62,$B0,$62,$B8,$62,$C0,$62
.byte $C8,$62,$D0,$62,$D8,$62,$E0,$62,$E8,$62,$16,$C2,$58,$52,$8C,$04
.byte $A7,$55,$D0,$63,$D7,$65,$E2,$61,$E7,$65,$F2,$61,$F7,$65,$13,$B8
.byte $17,$38,$8C,$03,$1D,$C9,$50,$62,$5C,$0B,$62,$3E,$63,$52,$8A,$52
.byte $93,$54,$AA,$42,$D3,$51,$EA,$41,$03,$D3,$1C,$04,$1A,$52,$33,$55
.byte $73,$44,$77,$44,$16,$D2,$19,$31,$1A,$32,$5C,$0F,$9A,$47,$95,$64
.byte $A5,$64,$B5,$64,$C5,$64,$D5,$64,$E5,$64,$F5,$64,$05,$E4,$40,$61
.byte $42,$35,$56,$34,$5C,$09,$A2,$61,$A6,$61,$B3,$34,$B7,$34,$FC,$08
.byte $0C,$87,$28,$54,$59,$53,$9A,$30,$A9,$61,$B8,$62,$BE,$0B,$C4,$31
.byte $D5,$0A,$DE,$0F,$0D,$CA,$7D,$47,$FD

L_Area2A:
.byte $07,$0F,$0E,$02,$39,$73,$05,$8B,$2E,$0B,$B7,$0B,$64,$8B,$6E,$02
.byte $CE,$06,$DE,$0F,$E6,$0A,$7D,$C7,$FD

MRetainerCHRWorld5:
.byte $0F,$3F,$7F,$7F,$F3,$ED,$FF,$FD
.byte $0F,$3F,$78,$60,$C0,$C0,$80,$00
.byte $FF,$FB,$7C,$FF,$70,$7F,$FF,$FF
.byte $00,$00,$00,$80,$43,$40,$E0,$F8
.byte $FC,$FE,$7F,$10,$00,$00,$00,$FC
.byte $FF,$FF,$63,$0F,$3F,$7C,$78,$FC
.byte $F0,$FC,$FE,$FE,$CF,$B7,$FF,$BF
.byte $F0,$FC,$1E,$06,$03,$03,$01,$00
.byte $FF,$DF,$3E,$FF,$0E,$FE,$FF,$FF
.byte $00,$00,$00,$01,$42,$02,$07,$1F
.byte $3F,$7F,$FE,$08,$00,$00,$00,$3F
.byte $FF,$FF,$C6,$F0,$FC,$3E,$1E,$3F

MRetainerCHRWorld6:
.byte $03,$07,$1F,$7F,$7F,$FF,$FD,$FF
.byte $03,$07,$1F,$7F,$7F,$FF,$FC,$F8
.byte $71,$39,$0F,$0F,$1F,$1F,$1E,$3F
.byte $4A,$03,$01,$01,$11,$10,$18,$39
.byte $3B,$3F,$3C,$3C,$18,$00,$00,$3F
.byte $24,$03,$03,$02,$07,$07,$07,$3F
.byte $C0,$F0,$F0,$FC,$FE,$FF,$8F,$FF
.byte $C0,$F0,$F0,$FC,$9E,$17,$07,$01
.byte $8E,$9E,$F8,$F8,$FE,$FE,$3F,$F7
.byte $50,$40,$00,$00,$86,$07,$0F,$CF
.byte $F7,$F7,$02,$00,$1C,$3E,$3E,$1C
.byte $1B,$FB,$FC,$DC,$FC,$3E,$3E,$1C

MRetainerCHRWorld7:
.byte $1F,$7F,$70,$C1,$C1,$95,$A3,$CB
.byte $1F,$7F,$7F,$FE,$FE,$EA,$C4,$08
.byte $F3,$FD,$FC,$3F,$38,$1C,$1F,$17
.byte $00,$02,$03,$00,$00,$63,$70,$F8
.byte $10,$38,$7F,$7F,$3F,$7F,$78,$00
.byte $FF,$DF,$9F,$3B,$3F,$7F,$78,$F8
.byte $F0,$FC,$1C,$06,$06,$82,$82,$46
.byte $F0,$FC,$FC,$FE,$FE,$7E,$1E,$48
.byte $3E,$FE,$7E,$F8,$38,$70,$E0,$D6
.byte $00,$00,$80,$00,$00,$88,$1C,$38
.byte $1F,$3F,$FF,$FE,$F8,$FC,$3E,$00
.byte $F0,$F0,$F0,$B8,$F8,$FC,$3E,$3F

;unused byte
.byte $FF