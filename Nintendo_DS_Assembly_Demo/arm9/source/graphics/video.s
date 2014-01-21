.align 2
.global setBgColor
setBgColor:
	cmp		r0, #1			@ Compare the screen register with the value 1.
	beq		setBgColorTop	@ If both values are equal, branch to the
							@ setBgColorTop subroutine.

	ldr		r4, =0x00		@ Create a temporary value to hold a color.
	orr		r4, r1			@ Or the temporary color value with the
							@ red component in register 1.
	orr		r4, r2, LSL #5	@ Or the temporary color value with the
							@ green component in register 2, bitshifted left by 5.
	orr		r4, r3, LSL #10	@ Or the temporary color value with the
							@ blue component in register 3, bitshifted left by 10.

	ldr		r5, =0x05000400	@ Load the bottom screen's palatte color address
							@ to register 5.
	str		r4, [r5, #0]	@ Store the temporary color value from register r4 to
							@ offset 0 at the memory address stored in register 5.
	mov		pc, lr			@ Move the program counter to the address in the
							@ line return register.
	
setBgColorTop:
	ldr		r4, =0x00		@ Create a temporary value to hold a color.
	orr		r4, r1			@ Or the temporary color value with the
							@ red component in register 1.
	orr		r4, r2, LSL #5	@ Or the temporary color value with the
							@ green component in register 2, bitshifted left by 5.
	orr		r4, r3, LSL #10	@ Or the temporary color value with the
							@ blue component in register 3, bitshifted left by 10.

	ldr		r5, =0x05000000	@ Load the top screen's palatte color address
							@ to register 5.
	str		r4, [r5, #0]	@ Store the temporary color value from register r4 to
							@ offset 0 at the memory address stored in register 5.
	mov		pc, lr			@ Move the program counter to the address in the
							@ line return register.

