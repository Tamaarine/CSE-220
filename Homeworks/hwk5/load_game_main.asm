# Load game02.txt
.data
filename: .asciiz "game02.txt"
# Garbage values
deck: .word 49752558 84042193
# Garbage values
.data
.align 2
board:
.word card_list601262 card_list492090 card_list806140 card_list547011 card_list216912 card_list669785 card_list848653 card_list417583 card_list677543 
# column #3
.align 2
card_list547011:
.word 319918  # list's size
.word 360147 # address of list's head
# column #7
.align 2
card_list417583:
.word 330578  # list's size
.word 13158 # address of list's head
# column #1
.align 2
card_list492090:
.word 500091  # list's size
.word 278210 # address of list's head
# column #5
.align 2
card_list669785:
.word 861167  # list's size
.word 638481 # address of list's head
# column #8
.align 2
card_list677543:
.word 936317  # list's size
.word 806648 # address of list's head
# column #4
.align 2
card_list216912:
.word 840431  # list's size
.word 506422 # address of list's head
# column #0
.align 2
card_list601262:
.word 955411  # list's size
.word 451557 # address of list's head
# column #6
.align 2
card_list848653:
.word 552679  # list's size
.word 592251 # address of list's head
# column #2
.align 2
card_list806140:
.word 878537  # list's size
.word 38529 # address of list's head
# Garbage values
moves: .ascii "GWaPsfyUlNuC3gUM9VImzORemnUwBXEsP4JIkybqUbW65ORkXmxlgiTMgrh56exd6qxiqAfNqHYJ3hQIh6vsZZO3WQtC9paf1hNg7XC1y0745w8Rl05iyaAnp6aZAiZ2flIrAkX4y0te3bhYKzrKdORITm4ttMJYQvbQjts49mBnFcBe3ZZjkQdJo51eCL9mzKT03BTI8xe813nfCc8I7tSbnRcj2PHgTd1AZU4ENyvQlPQzBQRgfcnjQZPiYTQLtxGATqsA2lIH2Q7Jf27a4LMTjHWM8QMgD6PpOZ0JEbxsZWDxPVs1IWKLPYvmkcxdLgFZxWAQl5gQNeoKyiGRTgW7F7HWo4OYHFvu8MO2AY55WPrvRElpgUT1dSHTXjx7cijZPkRRzVZlXJ4pG8PlXFGQaEjrwRGOCoeBV24EzudOB3ASfuCDahcTwxuXpSJSR6JEUX0LSvQocliPCm0R1EBO1aw8P7ir97wItRewnYdhJiHaMFGAzTFeZmlwovSAVFhzewG8ygmqfShxlmf3eB0PP6C7UB8C"



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

la $a0, filename
la $a1, board
la $a2, deck
la $a3, moves
jal load_game

addi $sp, $sp, -8
sw $s0, 0($sp)
sw $s1, 4($sp)

# Write code to check the correctness of your code!\
move $s0, $v0
move $s1, $v1

move $a0, $s0
li $v0, 1
syscall

li $a0, ' '
li $v0, 11
syscall

# Print how many moves are in the array
move $a0, $s1
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall


# Let's print the board first
la $a0, board
jal print_board

li $a0, '\n'
li $v0, 11
syscall

# Then we print the moves array
la $a0, moves
move $a1, $s1
jal print_move_list

li $a0, '\n'
li $v0, 11
syscall

# Then we also print the deck
la $a0, deck
jal print_card_in_card_list


# RESTORE THE REGISTERS WE USED
lw $s0, 0($sp)
lw $s1, 4($sp)
addi $sp, $sp, 8

li $v0, 10
syscall

.include "hwk5.asm"
