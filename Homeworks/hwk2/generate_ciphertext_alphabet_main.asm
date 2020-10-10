.data
ciphertext_alphabet: .ascii "drfXArg153cyIJvv2dkivJvSpka5BXf4MyeauUCg5cfQjiY6bs6BKEqE1cXtvHZ"
# Over 100,000 instruction for this one
keyphrase: .ascii "Stony? ?Brook? ?UniversityStony? ?Brook? ?UniversityStony? ?Brook? ?UniversityStony? ?Brook? ?UniversityMonday,? ?September? ?21st,? ?2020? ?4:39? ?PM? ?EDTMonday,? ?September? ?21st,? ?2020? ?4:39? ?PM? ?EDT"

# Tested
# Answer: "suPeRcalIfrAgiLtCxdoObhjkmnpqvwyzBDEFGHJKMNQSTUVWXYZ0123456789"
keyphrase1: .asciiz "suPeRcalIfrAgiListICexPiaLIdoCIOus"

# Tested
# Answer is "pleaskim12349bcdfghjnoqrtuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ05678"
keyphrase2: .asciiz "pleasekillme12349"

# Tested
# Answer: "aecqlthv69zy1fb4x32s87gpumjdn0oirw5kABCDEFGHIJKLMNOPQRSTUVWXYZ"
keyphrase3: .asciiz "aecqlthv69zy1fb4x32s87gpumjdn0oirw5k"

# Tested
# Answer :"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
keyphrase4: .asciiz "a"

# Tested
# Answer: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
keyphrase5: .asciiz "aa"

# Tested
# Answer: "bcadefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
keyphrase6: .asciiz "bbc"

# Tested
# Answer: "zabcdefghijklmnopqrstuvwxyABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
keyphrase7: .asciiz "z"

# Tested
# Answer: "faze7pbu6hq2l1j4isnv9ck8wo0yx5dtgm3rABCDEFGHIJKLMNOPQRSTUVWXYZ"
keyphrase8: .ascii "faze7pbu6hq2l1j4isnv9ck8wo0yx5dtgm3r\0"

# Tested
# Answer: "abcABC0123defghijklmnopqrstuvwxyzDEFGHIJKLMNOPQRSTUVWXYZ456789"
keyphrase9: .asciiz "abcABC0123"

# Tested
# Answer: "012345678abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ9"
keyphrase10: .asciiz "012345678"

# Tested
# Answer: "012345678abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ9
keyphrase11: .asciiz "0-1:2[3]4[[[5;;;6'7@#$%^&*(8"

# Tested
# Answer: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
keyphrase12: .asciiz "0  1    2    3       4    5   6  7  8 9"

# Tested
# Answer: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
keyphrase13: .asciiz ""

# Tested
# Answer: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
keyphrase14: .asciiz "   - - - -          "

# Tested "StonyBrkUivesabcdfghjlmpquwxzACDEFGHIJKLMNOPQRTVWXYZ0123456789"
keyphrase15: .asciiz "Stony? ?Brook? ?University" # return 13

# Tested "MondaySeptmbr21s0439PEDTcfghijklquvwxzABCFGHIJKLNOQRUVWXYZ5678"
keyphrase16: .asciiz "Monday, September 21st, 2020 4:39 PM EDT"

# Tested "suPeRcalIfrAgiLtCxdoObhjkmnpqvwyzBDEFGHJKMNQSTUVWXYZ0123456789"
keyphrase17: .asciiz "suPeRcalIfrAgiListICexPiaLIdoCIOus"

keyphrase18: .asciiz "adfsdifgrqerjUBRFBOhiyhdouwjqoemvxmcjvbzx,DSNFOSDNF[][][\[QWE[]QWE]QQWEHIHS"

# Answer Ilhaveyouknwtsbdmcrif20gjpqxzABCDEFGHJKLMNOPQRSTUVWXYZ13456789
keyphrase19: .asciiz "I'll have you know that I stubbed my toe last week and only cried for 20 minutes."

.text
.globl main
main:
	# Say we used $s0 here
	li $s0, 69
	li $s1, 69
	li $s2, 69
	li $s3, 69
	li $s4, 69
	li $s5, 69
	li $s6, 69
	li $s7, 69
	la $a0, ciphertext_alphabet
	la $a1, keyphrase17
	
	jal generate_ciphertext_alphabet
	
	# You must write your own code here to check the correctness of the function implementation.
	# Because the value is returned in $v0, we move it to $a0 to see if it is correct
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
	
.include "hwk2.asm"
