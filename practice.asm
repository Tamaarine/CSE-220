.data
hex: .asciiz "89"


.text
li $t0, 3
li $t1, 13

mult $t0, $t1
mflo $a0

mul $a0, $t0, $t1
li $v0, 1
syscall


	
		
