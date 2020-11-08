# Invalid argument
.data
.align 2
n: .word 0
.align 2
src: .ascii "ABCDEFGHIJ"
.align 2
dest: .ascii "XXXXXXX"

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

la $a0,  dest
la $a1,  src
lw $a2,  n
jal memcpy

# Write code to check the correctness of your code!
move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, dest
li $v0, 4
syscall

li $v0, 10
syscall

.include "hwk4.asm"
