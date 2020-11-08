.data
start_date: .asciiz "2020-11-07"
end_date: .asciiz "3156-11-03"

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

la $a0, start_date
la $a1, end_date
jal datestring_to_num_days

# Write code to check the correctness of your code!
move $a0, $v0
li $v0, 1
syscall

li $v0, 10
syscall

.include "hwk4.asm"

