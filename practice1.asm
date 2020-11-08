.data
customer: .word 69

.text
li $t0, 13

sub $a0, $0, $t0
li $v0,1
syscall





li $v0, 10
syscall
