.data
hi: .word 7684917

.text
# We load positive 8 into our register $t1
li $t1, -1

# Then we use NOT bitwise operator on the register $t1 to try to get the complement
not $t2 $t1
