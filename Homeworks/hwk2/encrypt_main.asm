.data
# Checked
ciphertext: .ascii "drfXArg153cyIJvv2dkivJvSpka5BXf4MyeauUCg5cfQjiY6bs6BKEqE1cXtvHZEn0MO"
plaintext: .ascii "Never trust a computer you can't throw out a window. -Steve Wozniak\0"
keyphrase: .ascii "I'll have you know that I stubbed my toe last week and only cried for 20 minutes.\0"
corpus: .ascii "When in the Course of human events, it becomes necessary for one people to dissolve the political bands which have connected them with another, and to assume among the powers of the earth, the separate and equal station to which the Laws of Nature and of Nature's God entitle them, a decent respect to the opinions of mankind requires that they should declare the causes which impel them to the separation.\0"

# Checked
plaintext1: .ascii "The trouble with having an open mind, of course, is that people will insist on coming along and trying to put things in it. -Terry Pratchett\0"
keyphrase1: .ascii "What's the difference between ignorance and apathy? I don't know and I don't care.\0"
corpus1: .ascii "Call me Ishmael. Some years ago - never mind how long precisely - having little or no money in my purse, and nothing particular to interest me on shore, I thought I would sail about a little and see the watery part of the world. It is a way I have of driving off the spleen and regulating the circulation.\0"

# Checked!!!!
plaintext2: .ascii "If debugging is the process of removing software bugs, then programming must be the process of putting them in. -Edsger Dijkstra\0"
keyphrase2: .ascii "What is the sum of 12 and 37? The answer, CLEARLY, is 49!\0"
corpus2: .ascii "It was the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the epoch of belief, it was the epoch of incredulity, it was the season of Light, it was the season of Darkness, it was the spring of hope, it was the winter of despair, we had everything before us, we had nothing before us, we were all going direct to Heaven, we were all going direct the other way - in short, the period was so far like the present period, that some of its noisiest authorities insisted on its being received, for good or for evil, in the superlative degree of comparison only.\0"

# CHECKEDD!!!
plaintext3: .ascii "Never trust a computer you can't throw out a window. -Steve Wozniak\0"
keyphrase3: .ascii "I'll have you know that I stubbed my toe last week and only cried for 20 minutes.\0"
corpus3: .ascii "When in the Course of human events, it becomes necessary for one people to dissolve the political bands which have connected them with another, and to assume among the powers of the earth, the separate and equal station to which the Laws of Nature and of Nature's God entitle them, a decent respect to the opinions of mankind requires that they should declare the causes which impel them to the separation.\0"

# Encrypted: tKCIP 2fDbqV 6foJ Vyu ORoK 4R pPT HmbV VO 6Dve, D bN0 t W6DMGHm EK I8 n8eV 464 MQN9HwV
# Decrypted: anime thighs when she open up her legs so wide, i got a twinkle in my eyes uwu noozles
# Encrypt Converted: 67
# Encrypt Copied: 19
plaintext4: .asciiz "Anime Thighs When She Open Up Her Legs So Wide, I Got A Twinkle In My Eyes Uwu Noozles"
keyphrase4: .asciiz "thick thighs saves lives uwu. Please don't murduwu me"
corpus4: .asciiz "8 And return to thee with all their heart, and all their soul, in the land of their enemies, to which they have been led captives: and pray to thee towards the way of their land, which thou gavest to their fathers, and of the city which thou hast chosen, and of the temple which I have built to thy name: 49 Then hear thou in heaven, in the firmament of thy throne, their prayers, and their supplications, and do judgment for them:"

.text
.globl main
main:
	li $s0, 699
	li $s1, 700
	li $s2, 701
	li $s3, 702
	li $s4, 703
	li $s5, 704
	li $s6, 705
	li $s7, 706
	
 	la $a0, ciphertext
	la $a1, plaintext4
	la $a2, keyphrase4
	la $a3, corpus4
	jal encrypt
		
	# You must write your own code here to check the correctness of the function implementation.
	move $t0, $v0
	move $t1, $v1
	
	move $a0, $t0
	li $v0, 1
	syscall
	
	li $a0, '\n'
	li $v0, 11
	syscall
	
	move $a0, $t1
	li $v0, 1
	syscall
	
	li $a0, '\n'
	li $v0, 11
	syscall
	
	la $a0, ciphertext
	li $v0, 4
	syscall
	
	
	
	li $v0, 10
	syscall
	
.include "hwk2.asm"
