.data
hello_world: .asciiz "Go fuck yourself bitttttch"

.text
main:
    # Loading the String for syscall
    li $v0, 4
    la $a0, hello_world
    syscall

    li $v0, 10
    syscall
