.data
sorted_alphabet: .ascii "drfXArg153cyIJvv2dkivJvSpka"
counts: .word 28 13 24 2 28 19 12 2 0 10 23 14 3 28 1 2 21 4 4 25 29 0 9 29 13 18

.text
.globl main
main:
	la $a0, sorted_alphabet
	la $a1, counts
	jal sort_alphabet_by_count
	
	# You must write your own code here to check the correctness of the function implementation.

	li $v0, 10
	syscall
	
.include "hwk2.asm"
