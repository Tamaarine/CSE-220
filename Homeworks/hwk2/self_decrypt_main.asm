# HOW TO CHECK
# I listed the output of what I got above each plaintext, keyphrase, and corpus above each set
# Please compare and share if you got anything same or different.


# Please make sure you don't have any extraneous output such like the length of the String 
# printed in index_of. I only test encrypt and decrypt because it combines all of the functions


# All your functions should have no I/O output! Please make sure you double check that. The only output
# You should see are only the ones I have put in self_encrypt_main and self_decrypt_main


# 8/10 of the functions have a return value. Only sort_alphabet_by_count and generate_plaintext_alphabet
# doesn't have any return type


# I suggest if you have python you can just use python to check if the Strings are equivalent :)

##########################################################################
.data
# Don't change plaintext
plaintext: .ascii "2WPlU0f6FQqkvvJz4eUDyKXvbmLf1Oxa5wozIGU06dOsF9WOUoIEljICyWDcaiDmbqZw"

# 90
# 23
# i want to die please kill me. computer science is fun but along with other courses it becomes really stressful :(
ciphertext1: .ascii "u 6sF1 3K pvb QDjkTx CwDD Er. yMEQ4ZrS TyvgIyr wT m4F e4W aDNGn 6uYq P2qrS yP4SUlT z0 egyOExV SftDD8 V2SfTUm4D :(\0"
keyphrase1: .ascii "this is a keyphrase hehe xd :)\0"
corpus1: .ascii "Diffusion, on the other hand, is the spread of culture between groups through contact of some kind (Merriam-Webster.com 2013). So, when looking at the adoption/diffusion of anime, I am studying how it has been picked up and spread into the United States. In terms of culture, this means that I am studying how culture has been picked up by a new group of people and how that culture spread to that area in the first place. \0"

# 73
# 16
# all quizzes and tests, including the final examination will be given as a take home tests
ciphertext2: .asciiz "oFF O4B99dU sH1 0nRXV, CHeF41AHz Zqn QBHoF b7wGCHuYCKH 6xFF vb zx5cH wU o YlEp gIGy WmVZU"
keyphrase2: .asciiz "ou also will have 1- 2 days to complete the tests- as described in the  Quizzes and Tests Schedule posted below. This schedule is desig"
corpus2: .asciiz "Miusov, as a man man of breeding and deilcacy, could not but feel some inwrd qualms, when he reached the Father Superior's with Ivan: he felt ashamed of havin lost his temper. He felt that he ought to have disdaimed that despicable wretch, Fyodor Pavlovitch, too much to have been upset by him in Father Zossima's cell, and so to have forgotten himself."

# 93
# 19
# thesis: andrew hackers argument fails due to his ineffective usage of logos and unsuccessful attempts at ethos.
ciphertext3: .asciiz "U5hTpR: vAaLo4 yifqwK'S dKt2zhA1 ucsxR a2b XD 5sQ pAkuuwfVp3r 2Tvto Du xBtDT EAa 2AT2ffrQRu2x d1UkzIYR nU kXyCS."
keyphrase3: .asciiz "Evidence: Of all who embark on higher education, only 58% end up with bachelor’s degrees."
corpus3: .asciiz "Andrew Hacker points out that the graduates who received a bachelor degree in Mathematics are rare. However, this does not prove the point that math courses causes impedance in obtaining a degree. The one percent of degrees in mathematics does not incorporate other field of studies that also employs algebra or math courses in general."

# 170
# 32
# to investigate how each reason contributes to the disappearance of native americans we must take a look and analyze the cruel manner of european settlers during the early period of european colonialism.
ciphertext4: .asciiz "VJ fH5uSVfmw0n UI6 gkiU QypRIH iIGYQdo43nT ZI 2Uh tfSwOOsaQeCiN IW Fp1l5j wBnQdieES 6n B4TY 0rxD k AIJx kCt eHpA89u 0Ug iQ4uz BaGHnQ JW g4QMOurG SsZ0AuQT t4QbGm XUg hpQz8 OgQdMt LW g4QIOupG iMzJHfKAdSB."
keyphrase4: .asciiz "Kare wa pekori to ojigi shite watashi ni kitta Doku he yuku no? Nani wo suru no? Watashi nani mo ienakute naita no Utsumuita kono odeko tonton"
corpus4: .asciiz "The Cherokee Removal illustrate the persuasiveness of this myth because of belligerent act of Euro-American settlers against the native people that includes violence, enslavement, the development of Civilization program in hoping to achieve the conversion of the native savages to have European like farming lifestyle, and the overall oppression from neighboring states all attribute in taking away the identity of Native Americans."

# 83
# 31
# anime thighs when she open up so wide, i got a twinkle in my eye asian _____ is so tight, i just really wanna pipe
ciphertext5: .asciiz "TEkBf 1bjRbU 6dDH Ubv KNDE 4N UK 6xwl, q RKY T 26gFzAS xF B8 J8l TUqmG _____ gU UK YgRd2, x y4U2 QSuAA8 6THIm NxNM"
keyphrase5: .asciiz "The music that we love music that we want feat Minto, DJ-S3RL"
corpus5: .asciiz "The myth of the Vanishing Indian influenced the United States into developing the Civilization program. After the United States won their independence from Britain, the Native Americans fell under the rule of the U.S. and were treated like defeated enemies because they sided with Britain during the revolution."

# 15
# 8
# cse, cse, cse, ams, wst
ciphertext6: .asciiz "olI, hlI, mlI, jPl, 0lp"
keyphrase6: .asciiz "justiceforanimethighs ANIME THIGHS GOT TAKEN OFF OF SPOTIFY. LETS BLOW THIS HASHTAG UP ON INSTAGRAM AND TWITTER. I HATE THAT WE HAVE TO TAKE THE ATTENTION OFF THE NEW SONG BUT WE NEED TO GET THIS FIGURED OUT!"
corpus6: .asciiz "owo,uwu,vwv,qwq,ewe,rwr,pwp,zwz,xwx,cwc,wvw,bwb"

# 85
# 30
# molly is a friend of mine she's so pure. she is devine. just don't let her get too cut when she's cut she is no fun
ciphertext7: .asciiz "sJrr8 fW i bThFzC Pb slyI XdL'V XP R4UF. Xd0 kW CN5kBM. p4W3 CKt'Z rLZ dIU cLZ 3GJ D4Z 6dNt XdF'V D4Y VdI lX uG b4z"
keyphrase7: .asciiz "HAHAHAHA imagine ADC IN 2020? LMFAOOOOOOO"
corpus7: .asciiz "The course is an introduction to the abstract notions encountered in machine computation. Topics include finite automata, regular expressions, and formal languages, with emphasis on regular and context-free grammars. Questions relating to what can and cannot be done by machines are covered by considering various models of computation, including Turing machines, recursive functions, and universal machines."

# 6
# 1
# help me
ciphertext8: .asciiz "QFVZ WF"
keyphrase8: .asciiz ""
corpus8: .asciiz ""

# 10
# 0
# zzzzzzebra
ciphertext9: .asciiz "999999Fq1a"
keyphrase9: .asciiz "abcdef"
corpus9: .asciiz "aaaaaaaaabbbbbbcccccddddeeeefghijk"

# 10
# 10
# q r-s=t:u;v[w]x(y)z*
ciphertext10: .asciiz "0 1-2=3:4;5[6]7(8)9*"
keyphrase10: .asciiz "abcdef"
corpus10: .asciiz "aaaaaaaaabbbbbbcccccddddeeeefghijk"


.text
.globl main
main:
	# If you have time make sure these registers are the same values after
	# you assemble and run. They should be preserved across your decrypt function call
	li $s0, 699
	li $s1, 700
	li $s2, 701
	li $s3, 702
	li $s4, 703
	li $s5, 704
	li $s6, 705
	li $s7, 706
	
	# Again don't change plaintext
 	la $a0, plaintext
 	
 	# Change these argument's number
	la $a1, ciphertext3
	la $a2, keyphrase3
	la $a3, corpus3
	jal decrypt
	
	# These are for the output
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






