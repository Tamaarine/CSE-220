# Attempt to move movable cards to an invalid recipient column
.data
.align 2
move: .word 197125
##### Deck #####
.align 2
deck:
.word 36  # list's size
.word node565654 # address of list's head
node12639:
.word 6574905
.word node104256
node425271:
.word 6574900
.word node119970
node104256:
.word 6574900
.word node654794
node392533:
.word 6574899
.word node645758
node389676:
.word 6574898
.word node660985
node270436:
.word 6574900
.word node842468
node810708:
.word 6574902
.word node55539
node660985:
.word 6574902
.word node84011
node709262:
.word 6574899
.word node686132
node568725:
.word 6574902
.word node542423
node146751:
.word 6574896
.word node889889
node645758:
.word 6574896
.word node930604
node877253:
.word 6574897
.word node146751
node573053:
.word 6574904
.word node709262
node462734:
.word 6574900
.word node392533
node519054:
.word 6574905
.word node569612
node491599:
.word 6574904
.word node568725
node842468:
.word 6574896
.word node810708
node885638:
.word 6574905
.word node327956
node991130:
.word 6574899
.word node389676
node327956:
.word 6574900
.word node573053
node84011:
.word 6574901
.word node270436
node119970:
.word 6574897
.word 0
node216239:
.word 6574904
.word node470166
node654794:
.word 6574901
.word node991130
node889889:
.word 6574904
.word node30258
node55539:
.word 6574905
.word node462734
node30258:
.word 6574899
.word node960696
node930604:
.word 6574901
.word node216239
node470166:
.word 6574896
.word node425271
node542423:
.word 6574903
.word node519054
node569612:
.word 6574897
.word node912265
node960696:
.word 6574903
.word node491599
node565654:
.word 6574905
.word node885638
node686132:
.word 6574904
.word node877253
node912265:
.word 6574898
.word node12639
##### Board #####
.data
.align 2
board:
.word card_list788507 card_list950569 card_list805706 card_list880612 card_list654841 card_list769376 card_list685915 card_list590677 card_list505122 
# column #5
.align 2
card_list769376:
.word 5  # list's size
.word node688577 # address of list's head
node796802:
.word 7689014
.word node255386
node688577:
.word 6574897
.word node365927
node926440:
.word 7689015
.word node796802
node255386:
.word 7689013
.word 0
node365927:
.word 6574896
.word node926440
# column #6
.align 2
card_list685915:
.word 5  # list's size
.word node586146 # address of list's head
node759406:
.word 6574896
.word node660134
node660134:
.word 6574899
.word node675400
node578498:
.word 6574902
.word node759406
node675400:
.word 7689010
.word 0
node586146:
.word 6574896
.word node578498
# column #4
.align 2
card_list654841:
.word 5  # list's size
.word node888233 # address of list's head
node204701:
.word 6574897
.word node530884
node28766:
.word 6574903
.word node204701
node244854:
.word 7689017
.word 0
node530884:
.word 6574901
.word node244854
node888233:
.word 6574899
.word node28766
# column #1
.align 2
card_list950569:
.word 5  # list's size
.word node900563 # address of list's head
node987175:
.word 6574900
.word node803929
node900563:
.word 6574902
.word node987175
node803929:
.word 6574897
.word node364590
node364590:
.word 6574898
.word node854559
node854559:
.word 7689015
.word 0
# column #7
.align 2
card_list590677:
.word 5  # list's size
.word node123449 # address of list's head
node203138:
.word 6574903
.word node575879
node575879:
.word 6574897
.word node437746
node123449:
.word 6574898
.word node254892
node254892:
.word 6574901
.word node203138
node437746:
.word 7689016
.word 0
# column #3
.align 2
card_list880612:
.word 5  # list's size
.word node889531 # address of list's head
node307169:
.word 6574903
.word node172449
node495619:
.word 6574901
.word node307169
node889531:
.word 6574902
.word node262656
node172449:
.word 7689012
.word 0
node262656:
.word 6574899
.word node495619
# column #2
.align 2
card_list805706:
.word 5  # list's size
.word node78915 # address of list's head
node238730:
.word 6574899
.word node397379
node78915:
.word 6574896
.word node238730
node676440:
.word 6574905
.word node115767
node397379:
.word 6574902
.word node676440
node115767:
.word 7689017
.word 0
# column #8
.align 2
card_list505122:
.word 4  # list's size
.word node231351 # address of list's head
node841365:
.word 7689016
.word 0
node361474:
.word 6574904
.word node498583
node231351:
.word 6574901
.word node361474
node498583:
.word 6574898
.word node841365
# column #0
.align 2
card_list788507:
.word 5  # list's size
.word node343243 # address of list's head
node801411:
.word 6574901
.word node118446
node118446:
.word 6574903
.word node414155
node4330:
.word 7689010
.word 0
node414155:
.word 6574897
.word node4330
node343243:
.word 6574900
.word node801411



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
la $a1, deck
lw $a2, move
jal check_move

# Write code to check the correctness of your code!
move $a0, $v0
li $v0, 1
syscall

li $v0, 10
syscall

.include "hwk5.asm"
