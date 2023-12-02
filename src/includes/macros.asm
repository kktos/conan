
.macro ifx ...parms
	.if .len(parms)!=2
		.error "Macro ifx : needs 2 params"
	.end

	.if .type(parms[0])!="string"
		.error "Macro ifx : the first parm <",parms[0],"> needs to be a string"
	.end

	expr= .split(parms[0])
	goto= parms[1]
	parmIdx= 0

	.if .len(expr)=3
		ldx %(expr[parmIdx])
		parmIdx= parmIdx + 1
	.end

	op= expr[parmIdx]
	value= expr[parmIdx+1]

	isValidOp= 0

	cpx %(value)

	.if op="<" {
		isValidOp= 1
		bcc goto
	}

	.if op="<="
		isValidOp= 1
		bcc goto
		beq goto
	.end

	.if op=">"
		isValidOp= 1
		beq :+
		bcs goto
		:
	.end

	.if op=">="
		isValidOp= 1
		bcs goto
		:
	.end

	.if !isValidOp
		.error "Macro ifx : Invalid Operation ",op
	.end

.end

.macro assertDefinedLabels neededLabels, errmsg
	.if .type(neededLabels) != "array"
		.error "checkIfDefined needs an array of strings as label names"
	.end

	missingLabels = .array()
	.for label of neededLabels
		.if .undef(label)
			t= .push(missingLabels, label)
		.end
	.end

	.if .len(missingLabels) != 0
		.error errmsg, " ", missingLabels
	.end
.end
