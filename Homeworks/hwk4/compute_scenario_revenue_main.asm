# Test case #4
.data
num_sales: .word 13
scenario: .word 6989
.align 2
sales_list:
# BookSale struct start
.align 2
.ascii "3318220944005\0"
.byte 0 0
.word 68169
.word 1310
.word 429
# BookSale struct start
.align 2
.ascii "1790274371133\0"
.byte 0 0
.word 12055
.word 1911
.word 67
# BookSale struct start
.align 2
.ascii "2323508691228\0"
.byte 0 0
.word 25027
.word 1950
.word 382
# BookSale struct start
.align 2
.ascii "6580406620516\0"
.byte 0 0
.word 14457
.word 1160
.word 390
# BookSale struct start
.align 2
.ascii "1220293838689\0"
.byte 0 0
.word 26212
.word 1181
.word 79
# BookSale struct start
.align 2
.ascii "8838065641525\0"
.byte 0 0
.word 38406
.word 1406
.word 239
# BookSale struct start
.align 2
.ascii "4140073652158\0"
.byte 0 0
.word 91560
.word 1707
.word 231
# BookSale struct start
.align 2
.ascii "0358003692171\0"
.byte 0 0
.word 97221
.word 1131
.word 492
# BookSale struct start
.align 2
.ascii "8102823570747\0"
.byte 0 0
.word 64311
.word 1671
.word 147
# BookSale struct start
.align 2
.ascii "2694841805861\0"
.byte 0 0
.word 81769
.word 1342
.word 380
# BookSale struct start
.align 2
.ascii "8985832671846\0"
.byte 0 0
.word 33475
.word 1157
.word 455
# BookSale struct start
.align 2
.ascii "9649316844603\0"
.byte 0 0
.word 74921
.word 1199
.word 446
# BookSale struct start
.align 2
.ascii "2768474273172\0"
.byte 0 0
.word 48218
.word 1291
.word 474



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
lw $a2, scenario
jal compute_scenario_revenue

# Write code to check the correctness of your code!
move $a0, $v0
li $v0, 1
syscall


li $v0, 10
syscall

.include "hwk4.asm"
