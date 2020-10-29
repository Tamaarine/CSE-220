.data
customer: .word 69

.text
lw $a0, customer
li $v0, 1
syscall

addi $a0, $a0, -1
li $v0, 1
syscall



li $v0, 10
syscall