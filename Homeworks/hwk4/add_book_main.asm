# Add book to hash table with existing values; multiple "deleted" slots
.data
isbn: .asciiz "9780451230230"
title: .asciiz "The Pacific"
author: .asciiz "Hugh Ambrose"
books:
.align 2
.word 7 4 68
# Book struct start 0
.align 2
.ascii "9780345501330\0"
.ascii "Fairy Tail, Vol. 1 (Fair\0"
.ascii "Hiro Mashima, William Fl\0"
.word 7777
# empty or deleted entry starts here 1
.align 2
.byte 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
# empty or deleted entry starts here 2
.align 2
.byte -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 
# Book struct start 3
.align 2
.ascii "9780670032080\0"
.ascii "Financial Peace Revisite\0"
.ascii "Dave Ramsey\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
.word 222
# Book struct start
.align 2
.ascii "9780064408330\0"
.ascii "Joey Pigza Swallowed the\0"
.ascii "Jack Gantos\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
.word 333
# empty or deleted entry starts here
.align 2
.byte -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 
# Book struct start
.align 2
.ascii "9781416971700\0"
.ascii "Out of My Mind\0\0\0\0\0\0\0\0\0\0\0"
.ascii "Sharon M. Draper\0\0\0\0\0\0\0\0\0"
.word 0


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


la $a0, books
la $a1, isbn
la $a2, title
la $a3, author
jal add_book

# Write code to check the correctness of your code!
move $t0, $v0
move $t1, $v1

# Printing the index where the book is inserted
move $a0, $t0
li $v0, 1
syscall

# Printing new line
li $a0, ' '
li $v0, 11
syscall

# Printing the number of books looked to insert
move $a0, $t1
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

# Print the new size
la $t0, books
addi $t0, $t0, 4
lw $a0, 0($t0)
li $v0, 1
syscall


li $v0, 10
syscall

.include "hwk4.asm"

