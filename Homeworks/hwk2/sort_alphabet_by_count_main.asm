.data
sorted_alphabet: .ascii "drfXArg153cyIJvv\0dkivJvSpkaasdfadsGGgasda"
counts: .word 28 13 24 2 28 19 12 2 0 10 23 14 3 28 1 2 21 4 4 25 29 0 9 29 13 18
counts1: .word 12 32 22 89 89 84 72 81 34 12 21 3 8 12 33 22 11 84 31 23 43 9 0 23 12 43
counts2: .word 21 17 20 25 21 19 28 26 15 16 21 13 11 16 1 27 24 20 5 23 26 2 29 15 21 8
counts3: .word 23 26 29 1 20 9 15 30 24 20 23 7 17 15 5 4 17 14 12 24 14 1 0 4 14 6
counts4: .word 19 3 7 12 26 5 2 17 12 0 0 9 7 9 13 3 1 9 10 17 6 6 4 0 2 0
counts5: .word 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26
counts6: .word 29 9 10 24 64 13 12 7 30 2 3 19 9 32 30 10 1 28 25 35 14 2 7 3 14 0
counts7: .word 26 2 13 11 50 6 2 27 17 0 1 10 9 24 27 9 2 14 22 37 9 3 7 0 2 0
.text
.globl main
main:
	li $s0, 69
	li $s1, 69
	li $s2, 69
	li $s3, 69
	li $s4, 69
	li $s5, 69
	li $s6, 69
	li $s7, 69
	
	la $a0, sorted_alphabet
	la $a1, counts3
	jal sort_alphabet_by_count
	
	# You must write your own code here to check the correctness of the function implementation.
	la $a0, sorted_alphabet
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
	
.include "hwk2.asm"
