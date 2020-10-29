.data
isbn: .asciiz "9780451230242"
title: .asciiz "The Pacific omgkillmyself"
author: .asciiz "Hugh Amberosajoker lisab"
books:
.align 2
.word 7 4 68
# Book struct start
.align 2
.ascii "9780461230234\0"
.ascii "Financial Peace Revisite\0"
.ascii "Dave Ramsey\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
.word 222
# empty or deleted entry starts here
.align 2
.ascii "9780451220234\0"
.ascii "Financial Peace Revisite\0"
.ascii "Dave Ramsey\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
.word 222# empty or deleted entry starts here
.align 2
# empty
.byte -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 
# Book struct start
.align 2
.ascii "9780461230234\0"
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
.byte 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
# Book struct start
.align 2
.ascii "9780451230234\0"
.ascii "Joey Pigza Swallowed the\0"
.ascii "Jack Gantos\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
.word 333



.text
.globl main
main:
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

# Printing space
li $a0, '\n'
li $v0, 11
syscall

# Printing the number of books looked to insert
move $a0, $t1
li $v0, 1
syscall

li $v0, 10
syscall

.include "hwk4.asm"

