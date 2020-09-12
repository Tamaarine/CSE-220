.data
hello: .ascii "Hello World!\n"
li $t0 0 # t0 is our counter right now
li $t1 10 # number of times the loop will repeat

.text
la $a0, hello # Load our string address into a0 for print
li $v0, 4 # Read our syscall
loop:
	beq $t0, $t1, exit_loop
	la $a0, hello # Load our string address into a0 for print
	li $v0, 4 # Read our syscall
	syscall # Calling the syscall
	addi $t0, $t0, 1 # Adding to the counter by 1
	b loop # Going back again

exit_loop:

