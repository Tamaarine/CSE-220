.data
str: .asciiz "!MissMissySimpySimpyMMSi!!!!"
ch: .byte '!'
start_index: .word 28

.text
.globl main
main:
	la $a0, str
	lbu $a1, ch
	lw $a2, start_index
	jal index_of
	
	# You must write your own code here to check the correctness of the function implementation.
	# If we are here then that means $v0 contains our returned index for the char in the String
	# Let's print it to debug
	move $a0, $v0
	li $v0, 1
	syscall

	li $v0, 10
	syscall
	
.include "hwk2.asm"