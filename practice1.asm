.data
 word1: .asciiz"If I shift -6 right logically once I get:\t"
word2: .asciiz"If I shift -6 right arithmatically once I get:\t"


.text



li $t0, 6

la $a0, word1
li $v0, 4
syscall

srl $a0, $t0, 1 
li $v0, 35
syscall

li $v0, 11
li $a0, '\n'
syscall

la $a0, word2
li $v0, 4
syscall

sra $a0, $t0, 1
li $v0, 35
syscall