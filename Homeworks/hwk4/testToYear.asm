.data
year: .asciiz "2016-12-18"


.text
la $a0, year
jal date_to_days_helper

li $v0, 10
syscall


.include "hwk4.asm"
