.data
hello: .asciiz "Hello World"

.text
li $s0, 10 # Store immediate 10 into register $s0
li $s0, 20 # Replace 10 in $s0 with 20

move $s3, $s0 # Copy $s0's content into $s3

# Terminate program
li $v0, 10
syscall

