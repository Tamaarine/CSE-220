.data
counts: .word -890186 -438641 -817157 612618 -145953 -440997 -774137 758469 889951 834642 -919986 -204919 124497 179267 -303331 -285295 786955 -891155 -665164 -716764 -292806 176422 -299979 471550 -485856 -656536
message: .ascii "The specialization in artificial intelligence and data science emphasizes modern approaches for building intelligent systems using machine learning.\0"
message1: .asciiz "We can only see a short distance ahead, but we can see plenty there that needs to be done. -Alan Turing"
message2: .asciiz "Two exquisite objection delighted deficient yet its contained. Cordial because are account evident its subject but eat. Can properly followed learning prepared you doubtful yet him. Over many our good lady feet ask that. Expenses own moderate day fat trifling stronger sir domestic feelings. Itself at be answer always exeter up do. Though or my plenty uneasy do. Friendship so considered remarkably be to sentiments. Offered mention greater fifteen one promise because nor. Why denoting speaking fat indulged saw dwelling raillery. "
message3: .asciiz "iusov, as a man man of breeding and deilcacy, could not but feel some inwrd qualms, when he reached the ather uperior's with van: he felt ashamed of havin lost his temper. e felt that he ought to have disdaimed that despicable wretch, yodor avlovitch"
message4: .asciiz "when in the course of human events, it becomes necessary for one people to dissolve the political bands which have connected them with another, and to assume among the powers of the earth, the separate and equal station to which the laws of nature and of nature's god entitle them, a decent respect to the opinions of mankind requires that they should declare the causes which impel them to the separation."

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
	la $a0, counts
	la $a1, message1
	jal count_lowercase_letters

	# You must write your own code here to check the correctness of the function implementation.
	# Return value is in $v0 we move to $a0
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
	
.include "hwk2.asm"
