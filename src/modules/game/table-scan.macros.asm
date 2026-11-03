;
; Table scans: the macros the engine's collision routines are written with.
;
; They emit exactly the instructions the routines had, so the binary doesn't
; change: they only name what each compare tests.
;
; A scan walks a level table (platforms, ladders, walls) entry by entry:
;
;		scanStart
;	loop	scanNext LAC40, notFound	; X = entry index
;		require ..., loop		; any test failing goes to the next entry
;		...				; X = the entry found
;
; An operand with an index is passed in braces: {LAC00,x}.
;

; X = $FF, index kept in globals::L0322
.macro scanStart {
		ldx #$ff
		stx globals::L0322
}

; next entry: X = index, A = its keyCol value, 0 ends the table
.macro scanNext keyCol, done {
		inc globals::L0322
		ldx globals::L0322
		lda keyCol,x
		beq done
}

; same, with the index only in X
.macro scanNextX keyCol, done {
		inx
		lda keyCol,x
		beq done
}

; A = A + m (m can be negative)
.macro addA m {
	.if m < 0 {
		sec
		sbc #-m
	} .else {
		clc
		adc #m
	}
}

; go to next unless A <op> rhs, unsigned; op: "<", ">=", "<=", "=="
.macro requireA op, rhs, next {
		cmp rhs
	.if op == "<" {
		bcs next
	} .elseif op == ">=" {
		bcc next
	} .elseif op == "<=" {
		beq :+
		bcs next
:
	} .elseif op == "==" {
		bne next
	} .else {
		.error "requireA: unknown operator ", op
	}
}

; go to next unless lhs <op> rhs (lhs is loaded in A)
; written out, not with requireA, as an operand in braces can't be passed on
.macro require lhs, op, rhs, next {
		lda lhs
		cmp rhs
	.if op == "<" {
		bcs next
	} .elseif op == ">=" {
		bcc next
	} .elseif op == "<=" {
		beq :+
		bcs next
:
	} .elseif op == "==" {
		bne next
	} .else {
		.error "require: unknown operator ", op
	}
}

; go to next unless A + lo <= v <= A + hi (A: a table value)
; tests the low bound, then the high one
.macro requireWindowA lo, hi, v, next {
		addA lo - 1
		requireA "<", v, next
		addA hi - lo + 1
		requireA ">=", v, next
}

; same, loading A with col first
.macro requireWindow col, lo, hi, v, next {
		lda col
		requireWindowA lo, hi, v, next
}

; same as requireWindow, testing the high bound first
.macro requireWindowHiFirst col, lo, hi, v, next {
		lda col
		addA hi
		requireA ">=", v, next
		addA -(hi - lo + 1)
		requireA "<", v, next
}
