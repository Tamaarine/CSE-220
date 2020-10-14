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

.align 2
state: .byte 0x99 0x99 0x99 0x99 0x99
.asciiz "XArg153cyIJvv2dkivJvSpka5BXf4MyeauUCg5cfQjiY6bs6BKEqE1cXtvHZ"

.text
.globl main
main:

la $a0, state
la $a1, filename7
jal load_game

# You must write your own code here to check the correctness of the function implementation.
# We just have to print the returned value here
move $t0, $v0
move $t1, $v1

li $v0, 1
move $a0, $t0
syscall

li $v0, 11
li $a0, '\n'
syscall

li $v0, 1
move $a0, $t1
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
