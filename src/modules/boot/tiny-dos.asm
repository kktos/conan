
		.include	"../../includes/prodos.asm"

		.namespace	tinyDOS scope="lc_bank2"

BUFFER		.equ	$0800

namelen		.equ	$02
tmplen		.equ	$03
blockPage	.equ	$04
blockStart	.equ	$05
blockCount	.equ	$06

SmartPortEntry:
		jmp	$FFFF

LoadFile:
		jmp	LoadFileEntry
LoadFromFile:
		jmp	LoadFromFileEntry
RunFile:
		jmp	RunFileEntry

;
; x/y points to
;  .pstr path: a file name, or directory names and a file name separated by '/', "L0/BKGD"
;
LoadFileEntry:
		stz	blockStart		; read from first file block
		stz	blockCount		; read the 256 block, i.e all

		stx	tmpPtr
		sty	tmpPtr+1

internalLoadFile:
	; the path's first name, after its length byte
		lda	#$01
		sta	pathIdx

	; read
		sta	smartport::command

	; directory block $0002
		inc	a
		sta	smartport::bloklo
		stz	smartport::blokhi

dirLoop:
		jsr	initBuffer
		jsr	SmartPortEntry

		jsr	FindFile
		bcc	nextDirBlock		; C=1 if found

	; the path goes on after this name: it's a directory, search it from its key block
		lda	(tmpPtr)
		cmp	nameEnd
		bcc	isFile			; length < nameEnd: the path's last name, the file
		ldy	nameEnd
		iny				; past the '/'
		sty	pathIdx
		bra	dirLoop
isFile:
		jmp	LoadFileBlocks

nextDirBlock:
	; get next directory block
		lda	BUFFER+prodos::DirBlock.nextBlock
		sta	smartport::bloklo
		lda	BUFFER+prodos::DirBlock.nextBlock+1
		sta	smartport::blokhi

		lda	smartport::bloklo
		ora	smartport::blokhi
		bne	dirLoop

		jmp	ShowError

;
; x/y points to
;  .db block start
;  .db block count
;  .pstr filename
;
LoadFromFileEntry:
		stx	tmpPtr
		sty	tmpPtr+1

		lda	(tmpPtr)
		sta	blockStart
		inc	tmpPtr

		lda	(tmpPtr)
		sta	blockCount
		inc	tmpPtr
		bra	internalLoadFile

initBuffer:
		lda	#>BUFFER
		sta	smartport::adrhi
		stz	smartport::adrlo
		rts

;
; x/y points to
;  .pstr filename
;
RunFileEntry:
		jsr	LoadFileEntry
		jmp	(srcPtr)


FindFile:
		stz	blockPage
		ldy	#.size(prodos::DirBlock)	; first entry

NextEntry:
		lda	(smartport::adrlo),y
		beq	NotFound		; unused entry

		cmp	#prodos::ST_SUBDIR_HDR	; a volume or subdirectory header ($Fx, $Ex), not a file:
		bcs	Next			; its name can be a file's or the directory's

		jsr	MatchName
		bcc	Next			; C=0 → no match

		lda	smartport::adrhi
		sta	srcPtr+1

		tya
		clc
		adc	smartport::adrlo
		sta	srcPtr
		bcc	:+
		inc	srcPtr+1
:
        ; Starting block: a file's index block, a directory's key block
		ldy	#prodos::DirEntry.keyPtr
		lda	(srcPtr),y
		sta	smartport::bloklo
		iny
		lda	(srcPtr),y
		sta	smartport::blokhi

		sec
		rts

Next:
		tya
		clc
		adc	#.size(prodos::DirEntry)
		tay
		bcc	NextEntry

		lda	blockPage
		bne	NotFound		; we should read the next dir block - TBD

		inc	blockPage
		inc	smartport::adrhi
		bra	NextEntry

NotFound:
		clc
		rts

;
; A = the entry's storage type and name length, Y = the entry's offset
; does the entry's name match the path's name from pathIdx, up to its end or a '/' ?
; C=1 if it does, with nameEnd the path index after the name
;
MatchName:
		and	#prodos::NAMELEN_MASK
		sta	namelen

		phy
		lda	pathIdx
		sta	tmplen

NameLoop:
		lda	(tmpPtr)		; past the path's end
		cmp	tmplen
		bcc	NoMatch

		iny
		phy
		ldy	tmplen
		lda	(tmpPtr),y
		ply
		cmp	(smartport::adrlo),y
		bne	NoMatch

		inc	tmplen
		dec	namelen
		bne	NameLoop

	; the path's name must end with the entry's: at the path's end, or on a '/'
		ldy	tmplen
		sty	nameEnd
		lda	(tmpPtr)
		cmp	tmplen
		bcc	Matched			; length < nameEnd: the path's end

		lda	(tmpPtr),y
		cmp	#'/'
		bne	NoMatch

Matched:
		ply
		sec
		rts

NoMatch:
		clc
		ply
		rts

LoadFileBlocks:
        ; Load address
		ldy	#prodos::DirEntry.auxType
		lda	(srcPtr),y
		sta	tmpPtr
		iny
		lda	(srcPtr),y
		sta	tmpPtr+1

		jsr	dbgAddMemRegion

		jsr	initBuffer

	; read index block
		jsr	SmartPortEntry

		lda	tmpPtr
		sta	smartport::adrlo
		sta	srcPtr
		lda	tmpPtr+1
		sta	smartport::adrhi
		sta	srcPtr+1

	; =0 LoadFile
	; =xx LoadFromFile
		ldy	blockStart
loop:
		dec	blockCount

	; the index block: the blocks' low bytes, then their high bytes; block 0 ends the file
		lda	BUFFER+$100,y
		sta	smartport::blokhi
		lda	BUFFER,y
		sta	smartport::bloklo
		ora	smartport::blokhi
		beq	loaded

		jsr	SmartPortEntry

		lda	blockCount
		beq	loaded

		inc	smartport::adrhi
		inc	smartport::adrhi
		iny
		bne	loop
loaded:

		rts

ShowError:
		lda	sys::PAGE2OFF
		lda	sys::TEXTON

		ldy	#$00
		lda	(tmpPtr),y
		tay
		lda	#$00
		sta	ErrorMsgFile+1,y
:
		lda	(tmpPtr),y
		sta	ErrorMsgFile,y
		dey
		bne	:-
		lda	#' '			; over the length byte
		sta	ErrorMsgFile

		ldx	#0
		ldy	#5
:
		lda	ErrorMsg,x
		beq	Hang
		ora	#$80
		sta	LINE10,y
		inx
		iny
		bne	:-
Hang:
		bra	Hang

ErrorMsg:
		.text	"UNABLE TO FIND"
ErrorMsgFile:
		.pstr	"WELCOME"
		.align	16, $A0
		.db	0

; the path's index of the name searched for
pathIdx:	.db	0
; the path's index after the name found
nameEnd:	.db	0

dbgAddMemRegion:

		lda	tmpPtr
		sta	start
		lda	tmpPtr+1
		sta	start+1

		lda	blockCount		; =0 LoadFile => size = EOF
		beq	setSizeEOF

		asl
		sta	size+1
		bra	setFilename

        ; ; block size
	; ldy #prodos::DirEntry.blocksUsed
        ; lda (srcPtr),y
        ; sta size
        ; iny
        ; lda (srcPtr),y
        ; sta size+1

setSizeEOF:
        ; block size
		ldy	#prodos::DirEntry.eof
		lda	(srcPtr),y
		sta	size
		iny
		lda	(srcPtr),y
		sta	size+1

setFilename:
        ; filename
		lda	srcPtr+1
		sta	name+1
		clc
		lda	#prodos::DirEntry.name
		adc	srcPtr
		sta	name
		bcc	:+
		inc	name+1
:
	; addMemRegion(filename, addr, len, color)

		BRK
		.db	$03
start:		.dw	$0000
size:		.dw	$0000
name:		.dw	$0000
		.dw	$0000

		rts
		.align	$10
		.text	"tiny_dos"
		.end	namespace

	; .org $A00 - 5
	; .text "kktos"
