.data
head_row_delta: .byte 0
head_col_delta: .byte 1
apples: .byte 1 7 3 2 1 4 4 3
apples_length: .word 4
.align 2
state:
.byte 2  # num_rows
.byte 2  # num_cols
.byte 0  # head_row
.byte 0  # head_col
.byte 1 # length
# Game grid:
.asciiz "1a.."

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

la $a0, state
lb $a1, head_row_delta
lb $a2, head_col_delta
la $a3, apples
addi $sp, $sp, -4
lw $t0, apples_length
sw $t0, 0($sp)
li $t0, 7918273    # putting some random garbage in $t0
jal slide_body
addi $sp, $sp, 4



move $t1, $v0
li $v0, 1
move $a0, $t1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $t0, state
addi $t0, $t0, 2
lb $a0, 0($t0)
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $t0, state
addi $t0, $t0, 3
lb $a0, 0($t0)
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $t0, state
addi $t0, $t0, 5
move $a0, $t0
li $v0, 4
syscall




# You must write your own code here to check the correctness of the function implementation.

li $v0, 10
syscall

.include "hwk3.asm"
