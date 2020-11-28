.data
hi: .word 66053
hello_world: .asciiz "Hello world how are you?"
this: .asciiz "Guys this is very cool!"

.text
la $a0, hello_world
jal print_string

la $a0, this
jal print_string

# Exit the program
li $v0, 10
syscall


print_string:
    # This function takes in an address of a string and prints it along with \n
    
    # $a0 -> The address of the string to print
    
    # Since the address is already in $a0 we can just print it by calling syscall 4
    li $v0, 4
    syscall
    
    # Then we have to print a \n char
    li $a0, '\n'
    li $v0, 11
    syscall
    
    # Then we can just return to the caller as we are done with the function
    jr $ra


