.data
hex: .asciiz "89"


.text
li $s1, 0xFFFF # Resetting register $t5
li $t1, 1 # Load 1 into $t1 and attempt to use this as our immediate

sllv $s1, $s1, $t1
	
	
		