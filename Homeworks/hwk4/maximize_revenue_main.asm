# Test case #4
.data
num_sales: .word 13
.align 2
sales_list:
# BookSale struct start
.align 2
.ascii "0969867337768\0"
.byte 0 0
.word 91339
.word 1799
.word 274
# BookSale struct start
.align 2
.ascii "7167926219358\0"
.byte 0 0
.word 87431
.word 1648
.word 149
# BookSale struct start
.align 2
.ascii "5856271181125\0"
.byte 0 0
.word 38069
.word 1171
.word 135
# BookSale struct start
.align 2
.ascii "1739956344089\0"
.byte 0 0
.word 24120
.word 1716
.word 401
# BookSale struct start
.align 2
.ascii "2423634816035\0"
.byte 0 0
.word 44091
.word 1735
.word 429
# BookSale struct start
.align 2
.ascii "7323738407143\0"
.byte 0 0
.word 33518
.word 1687
.word 357
# BookSale struct start
.align 2
.ascii "0790885414601\0"
.byte 0 0
.word 49219
.word 1389
.word 468
# BookSale struct start
.align 2
.ascii "2095877382616\0"
.byte 0 0
.word 89257
.word 1679
.word 325
# BookSale struct start
.align 2
.ascii "7788346465697\0"
.byte 0 0
.word 76118
.word 1374
.word 364
# BookSale struct start
.align 2
.ascii "7903951955477\0"
.byte 0 0
.word 45362
.word 1032
.word 44
# BookSale struct start
.align 2
.ascii "2668430009430\0"
.byte 0 0
.word 26427
.word 1969
.word 245
# BookSale struct start
.align 2
.ascii "5802412331328\0"
.byte 0 0
.word 94001
.word 1133
.word 62
# BookSale struct start
.align 2
.ascii "0689148237261\0"
.byte 0 0
.word 28651
.word 1412
.word 265



.text
.globl main
main:
li $s0, 699
li $s1, 699
li $s2, 699
li $s3, 699
li $s4, 699
li $s5, 699
li $s6, 699
li $s7, 699


la $a0, sales_list
lw $a1, num_sales
jal maximize_revenue

# Write code to check the correctness of your code!
move $a0, $v0
li $v0, 1
syscall

li $v0, 10
syscall

.include "hwk4.asm"
