.data
str: .ascii "College of Engineering and Applied Sciences\0"
str1: .asciiz "Simpuwu"
str2: .asciiz "MIPS"
str3: .asciiz ""
str4: .asciiz "Wolfie Seawolf!!! 2020??"
str5: .ascii "\0"
str6: .asciiz "I want to die"
str7: .ascii "!@#\0"
str8: .ascii "CSE 220 COVID-19 Edition\0"
str9: .ascii "BCDEFGHIJKLMNOPQRSTUVWXYZ\0"

str10: .ascii "STONY Brook University\0" # Gives 22
str11: .asciiz "\0" # Gives 0
str12: .ascii "geeksForgEeks\0" # Gives 13
str13: .asciiz "geeksForgEeks" # Gives 13
str14: .ascii "HELLO EVERY ONE\0" # Gives 15
str15: .asciiz "GEEKSfORGeEKS" # Gives 13
str16: .asciiz "!@#!@#!AS-" # Gives 10
str17: .asciiz "" # Gives 0
str18: .ascii "\0" # Gives 0
str19: .asciiz "convertOpposite" # Gives 15
str20: .asciiz "int i=0; i<LN; i++" # Gives 18
str21: .asciiz "if (str[i]>='a' && str[i]<='z')" # Gives 31
str22: .asciiz "StringBuilder str = new StringBuilder(GeEkSfOrGeEkS);// Calling the Method " # Gives 75
str23: .asciiz "               " # Gives 15
str24: .asciiz "            X                   Z                  " # Gives 51
str25: .asciiz "                               z" # Gives 32
str26: .asciiz "Z                    P" # Gives 22
str27: .asciiz "z                     P" # Gives 23
str28: .asciiz "z                  o" # Gives 20
str29: .ascii "his program can alternatively be done using C++ inbuilt functions –\0" # Gives 67
str30: .ascii "BCDEFGHIJKLMNOPQRSTUVWXYZ\0" # Givese 25


.text
.globl main
main:
	la $a0, str14
	jal strlen
	
	# You must write your own code here to check the correctness of the function implementation.
	# Since the return value is in $v0 and we need it in $a0 to print, let's move $v0 into $a0
	# And check the return value
	move $a0, $v0
	li $v0, 1
	syscall 
	
	li $v0, 10
	syscall
	
.include "hwk2.asm"
