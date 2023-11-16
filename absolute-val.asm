# Calculating absolute difference (Version 1)
.data # Enter following into data segment.
vals: .word 180, 100 # Two words of data (8 bytes).
.space 4 # One word of space for result (4 bytes).
.text
.globl main
main:
la $10, vals # Load address of vals into $10.
lw $4, 0($10) # Load A from memory into $4.
lw $5, 4($10) # Load B from memory into $5.
sub $12, $4, $5 # $12 = $4 - $5.
bgez $12, pos # If positive then jump to 'pos' label.
sub $12, $5, $4 # $12 = $5 - $4 (other way round)
pos: sw $12, 8($10) # Store result into memory.
li $v0, 10 # Exit program using system call 10.
syscall # syscall 10 (exit)