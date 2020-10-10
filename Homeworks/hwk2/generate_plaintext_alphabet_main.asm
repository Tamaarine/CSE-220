.data
plaintext_alphabet: .ascii "eauUCg5cfQjiY6bs6BKEqE1cXtvHZEn0MOHKZ9uaz5XPGBRIOYQM41FHQAxGc2Wasda\0"

# Answer: abcdeeeeeeeeefgggggggghhhhhijjjjjjklllllllmnoooopqrstttuuvwxyz, checked
sorted_alphabet: .ascii "egljhotupvfsxawqkrmzdyncib\0"

# Answer: aaaaaaaaabbbbbbbbcccccccddddddeeeeeffffggghhijklmnopqrstuvwxyz, checked
sorted_alphabet1: .asciiz "abcdefghijklmnopqrstuvwxyz\0"

# Answer: abbcdeeeeeeeeefghijklmnnnnnnnoooooopqqqrrrrstuvvvvvwxyzzzzzzzz, checked
sorted_alphabet2: .asciiz "eznovrqbdatjghlwmskyipcxfu"

# Answer: abcdefgghhhhhhhijjjjjjjjjklmmmmmmmmnoooooopqqqqrstuvwxxxxxyzzz, checked
sorted_alphabet3: .asciiz "jmhoxqzgityudwsecvfalnkrbp"

# Answer abcddddddefffffffffgghijjjjjjjklmnooooooooppppqrstuvwwwxxxxxyz, checked
sorted_alphabet4: .asciiz "fojdxpwgzaskclmqhvinuteybr"

# Answer aaaaaabcdeffffggggggghhhhhhhhijkkklmnnopqqqqqrssssssssstuvwxyz, checked
sorted_alphabet5: .asciiz "shgaqfknjplzoiwtvmcyeudrbx"

# Answer abbbcddefggggghijkkkkllllllllmnopqqqqqqqrsssssstuvwwwwwwwwwxyz, checked
sorted_alphabet6: .asciiz "wlqsgkbdcuexianzoptjhfrymv"

# Answer abcdefghijklmnopqrsstttuuuuvvvvvwwwwwwxxxxxxxyyyyyyyyzzzzzzzzz, checked
sorted_alphabet7: .asciiz "zyxwvutsrqponmlkjihgfedcba"

# Answer aaaaabcdeeeeeeeeefghhhhhhhiijklmnnnnoooooopqrsssttttttttuvwxyz, checked
sorted_alphabet8: .asciiz "ethoansircdlmpuwfvbgqykjxz"

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
	
	la $a0, plaintext_alphabet
	la $a1, sorted_alphabet2
	jal generate_plaintext_alphabet
	
	# You must write your own code here to check the correctness of the function implementation.
	la $a0, plaintext_alphabet
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
	
.include "hwk2.asm"
