include(`commons.m4')str_trim:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp,16]
	mov	x19, x0
; X19 _EN(`will always hold value of')_RU(`всегда будет содержать значение') "s"
	bl	strlen
; X0=str_len
	cbz	x0, .L9        ; _EN(`goto L9 (exit) if')_RU(``перейти на L9 (выход), если'') str_len==0
	sub	x1, x0, `#'1
; X1=X0-1=str_len-1
	add	x3, x19, x1
; X3=X19+X1=s+str_len-1
	ldrb	w2, [x19,x1]   ; _EN(`load byte at address')_RU(`загрузить байт по адресу') X19+X1=s+str_len-1
; W2=_EN(`loaded character')_RU(`загруженный символ')
	cbz	w2, .L9        ; _EN(``is it zero? jump to exit then'')_RU(``это ноль? тогда перейти на выход'')
	cmp	w2, 10         ; _EN(`is it')_RU(`это') '\n'?
	bne	.L15
.L12:
; _EN(``main loop body. loaded character is always 10 or 13 at this moment!'')_RU(``тело главного цикла. загруженный символ в этот момент всегда 10 или 13!'')
	sub	x2, x1, x0
; X2=X1-X0=str_len-1-str_len=-1
	add	x2, x3, x2
; X2=X3+X2=s+str_len-1+(-1)=s+str_len-2
	strb	wzr, [x2,1]    ; _EN(`store zero byte at address')_RU(`записать нулевой байт по адресу') s+str_len-2+1=s+str_len-1
	cbz	x1, .L9        ; str_len-1==0? _EN(``goto exit, if so'')_RU(``перейти на выход, если это так'')
	sub	x1, x1, `#'1     ; str_len--
	ldrb	w2, [x19,x1]   ; _EN(`load next character at address')_RU(`загрузить следующий символ по адресу') X19+X1=s+str_len-1
	cmp	w2, 10         ; _EN(`is it')_RU(`это') '\n'?
	cbz	w2, .L9        ; _EN(``jump to exit, if it's zero'')_RU(``перейти на выход, если это ноль'')
	beq	.L12           ; _EN(``jump to begin loop, if it's'')_RU(``перейти на начало цикла, если это'') '\n'
.L15:
	cmp	w2, 13         ; _EN(`is it')_RU(`это') '\r'?
	beq	.L12           ; _EN(``yes, jump to the loop body begin'')_RU(``да, перейти на начало тела цикла'')
.L9:
; _EN(`return')_RU(`возврат') "s"
	mov	x0, x19
	ldr	x19, [sp,16]
	ldp	x29, x30, [sp], 32
	ret
