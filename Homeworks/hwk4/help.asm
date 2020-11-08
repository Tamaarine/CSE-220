#$a0 - the starting address of a valid Hashtable Struct
#$a1 - a 13-character, null-terminated string that represents a valid ISBN
hash_book:
 addi $sp, $sp, -12
 sw $s0, 0($sp)
 sw $s1, 4($sp)
 sw $ra, 8($sp) 
 
 move $s0, $a0  #stores the address of the valid Hashtable
 move $s1, $a1  #stores the address of a valid ISBN 
 
 li $t0, 0      #the sum of the ASCII characters found in the ISBN
 sum_string: 
  lbu $t1, 0($s1)       #loads the currecnt character in the string into $t1
  beq $t1, $0, done_sum    #if we are the null terminator of the string, then we are the end of the string
  add $t0, $t0, $t1     #add the ASCII character to $t0
  addi $s1, $s1, 1      #load the next character
  j sum_string          #keep on looping 
 done_sum:
 li $v0, 1
 move $a0 $t0
 syscall
 
 li $a0, ' '
 li $v0, 11
 syscall
 
 
  lw $t1, 0($s0)         #gets the capacity of the hash table
  div $t0, $t1           #divide the ASCII sum by the capacity
  mfhi $v0               #store the remainder
  #restore the $s and $ra
  lw $s0, 0($sp)      #restore $s0 
  lw $s1, 4($sp)      #restore $s1
  lw $ra, 8($sp)      #restore $ra 
  addi $sp, $sp, 12   #restore the stack 
  jr $ra    #jump back to the caller