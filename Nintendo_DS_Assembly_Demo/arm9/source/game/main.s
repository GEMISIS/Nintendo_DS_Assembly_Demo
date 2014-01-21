.global main
main:
	ldr		r4, =0x04000000	@ The background mode address is at bit offset 0 at address
							@ 0x04000000, and we set the mode for the first 32 bits.

	ldr		r5, =0x10000	@ The value for the background register. Initializes
							@ everything to 0 except for the Display Mode (bits 16-17), which
							@ it sets to 2.

	str		r5, [r4, #0]	@ Load the value 0x10000 into the memory location 0x04000000
							@ at bit offset 0.

	add		r4, #0x1000		@ Add on 4 KB of space to the original background address.
	str		r5, [r4, #0]	@ Load the value 0x10000 into the memory location 0x04010000
							@ at bit offset 0.

	ldr		r0, =0x0		@ Select the screen to use via register 0 (0 for the bottom
							@ screen, 1 for the top screen).
	ldr		r1, =0xff		@ The red component of the color.
	ldr		r2, =0x00		@ The blue component of the color.
	ldr		r3, =0x00		@ The green component of the color.

	add		lr, pc, #0		@ Set the line return register to the program counter register
							@ value for returning to this spot.
	b		setBgColor		@ Branch to the setBgColor subroutine.

	ldr		r0, =0x1		@ Select the screen to use via register 0 (0 for the bottom
							@ screen, 1 for the top screen).
	ldr		r1, =0x00		@ The red component of the color.
	ldr		r2, =0x00		@ The blue component of the color.
	ldr		r3, =0xff		@ The green component of the color.

	add		lr, pc, #0		@ Set the line return register to the program counter register
							@ value for returning to this spot.
	b		setBgColor		@ Branch to the setBgColor subroutine.

loop:
	mov	r0, #1
	mov	r1, #1
	mov	r2, #0
	nop
	b		loop

