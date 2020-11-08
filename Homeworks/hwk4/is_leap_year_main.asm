.data
year: .word 3997

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

lw $a0, year
jal is_leap_year

# Write code to check the correctness of your code!


move $a0, $v0
li $v0, 1
syscall

li $v0, 10
syscall

.include "hwk4.asm"
