# Column contains a straight with no additional cards below
.data
.align 2
col_num: .word 4
##### Board #####
.data
.align 2
board:
.word card_list378165 card_list379418 card_list441201 card_list227116 card_list359697 card_list201820 card_list400949 card_list882509 card_list524786 
# column #6
.align 2
card_list400949:
.word 0  # list's size
.word 0  # address of list's head (null)
# column #7
.align 2
card_list882509:
.word 0  # list's size
.word 0  # address of list's head (null)
# column #2
.align 2
card_list441201:
.word 0  # list's size
.word 0  # address of list's head (null)
# column #8
.align 2
card_list524786:
.word 0  # list's size
.word 0  # address of list's head (null)
# column #0
.align 2
card_list378165:
.word 0  # list's size
.word 0  # address of list's head (null)
# column #3
.align 2
card_list227116:
.word 0  # list's size
.word 0  # address of list's head (null)
# column #1
.align 2
card_list379418:
.word 0  # list's size
.word 0  # address of list's head (null)
# column #5
.align 2
card_list201820:
.word 0  # list's size
.word 0  # address of list's head (null)
# column #4
.align 2
card_list359697:
.word 10  # list's size
.word node278376 # address of list's head
node183374:
.word 7689014
.word node897929
node586186:
.word 7689012
.word node394689
node72519:
.word 7689009
.word node966455
node278376:
.word 7689017
.word node869645
node897929:
.word 7689013
.word node586186
node966455:
.word 7689008
.word 0
node394689:
.word 7689011
.word node386419
node386419:
.word 7689010
.word node72519
node869645:
.word 7689016
.word node969333
node969333:
.word 7689015
.word node183374


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

la $a0, board
lw $a1, col_num
jal clear_full_straight

# Write code to check the correctness of your code!
move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, board
jal print_board

li $v0, 10
syscall

.include "hwk5.asm"
