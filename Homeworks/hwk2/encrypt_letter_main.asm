.data
plaintext_letter: .byte 'n'
letter_index: .word 15
plaintext_alphabet: .asciiz "abccccccccdddddefghiiiiiijjjjjjjjjklmmnopqrstuvwwwwwwwxyyyyzzz"
ciphertext_alphabet: .asciiz "StonyBrkUivesNwYadfAmcbghjlpquxzCDEFGHIJKLMOPQRTVWXZ0123456789"
# dfAmcbgh
.text
.globl main
main:
 	lbu $a0, plaintext_letter
	lw $a1, letter_index
	la $a2, plaintext_alphabet
	la $a3, ciphertext_alphabet
	jal encrypt_letter
	
	# You must write your own code here to check the correctness of the function implementation.
	# $v0 have our letter we are suppose to replace
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
	
.include "hwk2.asm"
