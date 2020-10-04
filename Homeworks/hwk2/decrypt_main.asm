.data
# Checked
plaintext: .ascii "2WPlU0f6FQqkvvJz4eUDyKXvbmLf1Oxa5wozIGU06dOsF9WOUoIEljICyWDcaiDmbqZw"
ciphertext: .ascii "Dk5wQ 1Q4RW h yLCO4XnQ 8H4 yaE'3 VpQH6 L4V a 6qGoJ6. -R3n5t 6J9GqIA\0"
keyphrase: .ascii "I'll have you know that I stubbed my toe last week and only cried for 20 minutes.\0"
corpus: .ascii "When in the Course of human events, it becomes necessary for one people to dissolve the political bands which have connected them with another, and to assume among the powers of the earth, the separate and equal station to which the Laws of Nature and of Nature's God entitle them, a decent respect to the opinions of mankind requires that they should declare the causes which impel them to the separation.\0"

# Checked 
ciphertext1: .ascii "Xjc 1UN4dDn 6xXj jW5vJk WJ ORcK GmKf, PI iO4TVn, mV 0jW3 RwQREy 6mDE xKVlV1 NJ iMGqLk aDPJk aJf 2U8uHk 2Q R40 2jlJkV xK lZ. -3rUT8 RThYijc23\0"
keyphrase1: .ascii "What's the difference between ignorance and apathy? I don't know and I don't care.\0"
corpus1: .ascii "Call me Ishmael. Some years ago - never mind how long precisely - having little or no money in my purse, and nothing particular to interest me on shore, I thought I would sail about a little and see the watery part of the world. It is a way I have of driving off the spleen and regulating the circulation.\0"

# Checked
ciphertext2: .ascii "L7 e1iXTTAkT 9K MCu zFxsnGH x7 F2jxZEkT Gy7P0hDo iXTI, VCfk zFqTDhjj4kT jXKP in Mwm zFqsdKG q7 zXNOEkT VCnj Rk. -2eGTuD eAbcKSDt\0"
keyphrase2: .ascii "What is the sum of 12 and 37? The answer, CLEARLY, is 49!\0"
corpus2: .ascii "It was the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the epoch of belief, it was the epoch of incredulity, it was the season of Light, it was the season of Darkness, it was the spring of hope, it was the winter of despair, we had everything before us, we had nothing before us, we were all going direct to Heaven, we were all going direct the other way - in short, the period was so far like the present period, that some of its noisiest authorities insisted on its being received, for good or for evil, in the superlative degree of comparison only.\0"

# Encrypted: tKCIP 2fDbqV 6foJ Vyu ORoK 4R pPT HmbV VO 6Dve, D bN0 t W6DMGHm EK I8 n8eV 464 MQN9HwV
# Decrypted: anime thighs when she open up her legs so wide, i got a twinkle in my eyes uwu noozles
# Decrypt Converted: 19
# Decrypt Copied: 67
ciphertext3: .asciiz "tKCIP 2fDbqV 6foJ Vyu ORoK 4R pPT HmbV VO 6Dve, D bN0 t W6DMGHm EK I8 n8eV 464 MQN9HwV"
plaintext3: .asciiz "Anime Thighs When She Open Up Her Legs So Wide, I Got A Twinkle In My Eyes Uwu Noozles"
keyphrase3: .asciiz "thick thighs saves lives uwu. Please don't murduwu me"
corpus3: .asciiz "8 And return to thee with all their heart, and all their soul, in the land of their enemies, to which they have been led captives: and pray to thee towards the way of their land, which thou gavest to their fathers, and of the city which thou hast chosen, and of the temple which I have built to thy name: 49 Then hear thou in heaven, in the firmament of thy throne, their prayers, and their supplications, and do judgment for them:"

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
	
 	la $a0, plaintext
	la $a1, ciphertext3
	la $a2, keyphrase3
	la $a3, corpus3
	jal decrypt
	
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
	
	la $a0, plaintext
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
	
.include "hwk2.asm"
