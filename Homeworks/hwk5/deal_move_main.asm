# Deal-move for a game in-progress #2
.data
##### Deck #####
.align 2
deck:
.word 36  # list's size
.word node337532 # address of list's head
node612041:
.word 6574903
.word node626130
node626130:
.word 6574903
.word node738001
node184499:
.word 6574903
.word node216742
node497902:
.word 6574897
.word node689038
node216742:
.word 6574900
.word node277571
node20527:
.word 6574901
.word node187651
node585680:
.word 6574902
.word node380261
node380261:
.word 6574897
.word node96980
node86953:
.word 6574898
.word node719107
node250185:
.word 6574902
.word node293218
node809526:
.word 6574903
.word node161677
node96980:
.word 6574905
.word node951655
node453458:
.word 6574899
.word 0
node277571:
.word 6574902
.word node214493
node827280:
.word 6574900
.word node912257
node150302:
.word 6574900
.word node809526
node337532:
.word 6574901
.word node827280
node689038:
.word 6574896
.word node522361
node214493:
.word 6574904
.word node86953
node951655:
.word 6574904
.word node746343
node667428:
.word 6574903
.word node687494
node381083:
.word 6574902
.word node497902
node746343:
.word 6574905
.word node150302
node738001:
.word 6574898
.word node32812
node777831:
.word 6574897
.word node184499
node187651:
.word 6574901
.word node585680
node293218:
.word 6574905
.word node667428
node912257:
.word 6574904
.word node551176
node161677:
.word 6574905
.word node250185
node32812:
.word 6574902
.word node319429
node719107:
.word 6574900
.word node612041
node687494:
.word 6574900
.word node381083
node522361:
.word 6574904
.word node453458
node696958:
.word 6574899
.word node777831
node551176:
.word 6574901
.word node696958
node319429:
.word 6574901
.word node20527
##### Board #####
.data
.align 2
board:
.word card_list784451 card_list437597 card_list155026 card_list665526 card_list249264 card_list543513 card_list386938 card_list660716 card_list881884 
# column #1
.align 2
card_list437597:
.word 5  # list's size
.word node243615 # address of list's head
node243615:
.word 6574896
.word node866592
node85563:
.word 6574899
.word node306983
node866592:
.word 6574898
.word node85563
node904889:
.word 7689016
.word 0
node306983:
.word 6574898
.word node904889
# column #7
.align 2
card_list660716:
.word 5  # list's size
.word node365480 # address of list's head
node365480:
.word 6574902
.word node146897
node359076:
.word 6574902
.word node994684
node146897:
.word 6574903
.word node926182
node994684:
.word 7689011
.word 0
node926182:
.word 6574905
.word node359076
# column #0
.align 2
card_list784451:
.word 1  # list's size
.word node176195 # address of list's head
node176195:
.word 7689008
.word 0
# column #5
.align 2
card_list543513:
.word 2  # list's size
.word node281452 # address of list's head
node46017:
.word 7689009
.word 0
node281452:
.word 6574901
.word node46017
# column #4
.align 2
card_list249264:
.word 1  # list's size
.word node936490 # address of list's head
node936490:
.word 7689012
.word 0
# column #8
.align 2
card_list881884:
.word 4  # list's size
.word node991222 # address of list's head
node402013:
.word 6574905
.word node846456
node808652:
.word 7689012
.word 0
node846456:
.word 6574896
.word node808652
node991222:
.word 6574897
.word node402013
# column #3
.align 2
card_list665526:
.word 3  # list's size
.word node122098 # address of list's head
node122098:
.word 6574903
.word node688763
node943176:
.word 7689013
.word 0
node688763:
.word 6574896
.word node943176
# column #6
.align 2
card_list386938:
.word 1  # list's size
.word node876855 # address of list's head
node876855:
.word 7689011
.word 0
# column #2
.align 2
card_list155026:
.word 5  # list's size
.word node205295 # address of list's head
node885822:
.word 6574896
.word node855012
node855012:
.word 6574904
.word node993036
node993036:
.word 7689010
.word 0
node568774:
.word 6574897
.word node885822
node205295:
.word 6574898
.word node568774




.text
.globl main
main:
li $s0, 699
li $s1, 699
li $s2, 699
li $s3, 699
li $s4, 699
li $s5, 699
li $s6, 699
li $s7, 699

la $a0, board
jal print_board

li $a0, '\n'
li $v0, 11
syscall

la $a0, deck
jal print_card_in_card_list

# Size of the deck before
la $a0, deck
lw $a0, 0($a0)
li $v0, 1
syscall

la $a0, board
la $a1, deck
jal deal_move

# Write code to check the correctness of your code!
li $a0, '\n'
li $v0, 11
syscall

la $a0, board
jal print_board

li $a0, '\n'
li $v0, 11
syscall

la $a0, deck
jal print_card_in_card_list

# Size of the deck after
la $a0, deck
lw $a0, 0($a0)
li $v0, 1
syscall


li $v0, 10
syscall

.include "hwk5.asm"
