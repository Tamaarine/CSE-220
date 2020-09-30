.data

str20: .ascii "I\0" # Givese 25
	
.text
.globl main
main:
	la $a0, str20
	jal to_lowercase

	# You must write your own code here to check the correctness of the function implementation.
	# $v0 have our return value move it to $a0 first then print
	move $a0, $v0
	li $v0, 1
	syscall

	li $v0, 10
	syscall
	
.include "hwk2.asm"	
