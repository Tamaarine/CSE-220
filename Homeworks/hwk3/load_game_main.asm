.data
filename1: .asciiz "game01.txt"
filename2: .asciiz "game02.txt"
filename3: .asciiz "game03.txt"
filename4: .asciiz "game04.txt"
filename5: .asciiz "game05.txt"
filename6: .asciiz "game06.txt"
filename7: .asciiz "game07.txt"
filename8: .asciiz "game08.txt"
filename9: .asciiz "game09.txt"
filename10: .asciiz "junk.txt"
filename11: .asciiz "game1100.txt" # 0 walls
filename12: .asciiz "game1101.txt" # 21 walls 
filename13: .asciiz "game1102.txt" # 21 walls
filename14: .asciiz "game1103.txt" # 20 walls

.align 2
state: .byte 0x99 0x99 0x99 0x99 0x99
.asciiz "XArg153cyIJvv2dkivJvSpka5BXf4MyeauUCg5cfQjiY6bs6BKEqE1cXtvHZ"

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
la $a1, filename14
jal load_game

# You must write your own code here to check the correctness of the function implementation.
# We just have to print the returned value here
move $t0, $v0
move $t1, $v1

# Apple found or not
li $v0, 1
move $a0, $t0
syscall

li $v0, 11
li $a0, '\n'
syscall

# Number of walls
li $v0, 1
move $a0, $t1
syscall

li $v0, 11
li $a0, '\n'
syscall

# Print the game row
la $t0, state
addi $t0, $t0, 0
lb $a0, 0($t0)
li $v0, 1
syscall

li $v0, 11
li $a0, '\n'
syscall

# Print the game col
la $t0, state
addi $t0, $t0, 1
lb $a0, 0($t0)
li $v0, 1
syscall

li $v0, 11
li $a0, '\n'
syscall

# Print the snake row
la $t0, state
addi $t0, $t0, 2
lb $a0, 0($t0)
li $v0, 1
syscall

li $v0, 11
li $a0, '\n'
syscall

# Print the snake col
la $t0, state
addi $t0, $t0, 3
lb $a0, 0($t0)
li $v0, 1
syscall

li $v0, 11
li $a0, '\n'
syscall

# Print the snake length
la $t0, state
addi $t0, $t0, 4
lb $a0, 0($t0)
li $v0, 1
syscall

li $v0, 11
li $a0, '\n'
syscall

li $v0, 4
la $t0, state
addi $t0, $t0, 5
move $a0, $t0
syscall

li $v0, 10
syscall

.include "hwk3.asm"
