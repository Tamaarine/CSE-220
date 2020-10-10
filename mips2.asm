.data
hello: .asciiz "Hello World"

.text
main:
	jal functionA
	
	li $v0, 10
	syscall

functionA:
	# Going to call function B
	jal functionB

	jr $ra
functionB:
	
	# Does something and return
	jr $ra
