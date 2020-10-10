.data

str20: .ascii "I\0" # Givese 25
str21: .asciiz "When in the Course of human events, it becomes necessary for one people to dissolve the political bands which have connected them with another, and to assume among the powers of the earth, the separate and equal station to which the Laws of Nature and of Nature's God entitle them, a decent respect to the opinions of mankind requires that they should declare the causes which impel them to the separation."
str22: .ascii "Stony Brook University\0"
.text
.globl main
main:
	la $a0, str22
	jal to_lowercase

	# You must write your own code here to check the correctness of the function implementation.
	# $v0 have our return value move it to $a0 first then print
	move $a0, $v0
	li $v0, 1
	syscall

	li $v0, 10
	syscall
	
.include "hwk2.asm"	
