.data
ciphertext_alphabet: .ascii "drfXArg153cyIJvv2dkivJvSpka5BXf4MyeauUCg5cfQjiY6bs6BKEqE1cXtvHZ"
keyphrase: .ascii "Stony? ?Brook? ?UniversityStony? ?Brook? ?UniversityStony? ?Brook? ?UniversityStony? ?Brook? ?UniversityMonday,? ?September? ?21st,? ?2020? ?4:39? ?PM? ?EDTMonday,? ?September? ?21st,? ?2020? ?4:39? ?PM? ?EDT"

.text
.globl main
main:
	la $a0, ciphertext_alphabet
	la $a1, keyphrase
	jal generate_ciphertext_alphabet
	
	# You must write your own code here to check the correctness of the function implementation.

	li $v0, 10
	syscall
	
.include "hwk2.asm"
