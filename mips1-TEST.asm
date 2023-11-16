# Calculator Version 0.0
# This adds together three 32-bit words
# and puts the result back into memory.
.data
vals: .word 4, 5, 8, 0
.text
.globl main
main:
la $4, vals # Load $4 with the address of label 'vals'.
add $8, $0, $0 # Set sum to zero
lw $9, 0($4) # Get first number from memory
add $8, $8, $9 # Add to sum
lw $9, 4($4) # Get second number from memory
add $8, $8, $9 # Add to sum
lw $9, 8($4) # Get third number from memory
add $8, $8, $9 # Add to sum
sw $8, 12($4) # Save the result to memory.
li $v0 10 # System call code for exit = 10
syscall # syscall 10 (exit)