    # Calculating absolute difference
.data   
vals:   .word   1800, 100, 0
.text   
        .globl  main
main:       jal     my_program      # Run my program.
    lw      $a0,        8($t1)      # Store return value, ie 8($t1), of my_program into $a0 for printing later
    li      $2,         1           # Print value using system call 1
    syscall                         # syscall 1 (print)
    li      $2,         10          # Exit program using system call 10.
    syscall                         # syscall 10 (exit)
my_program:
    addi    $sp,        $sp,    -8  # Move the stack pointer.
    sw      $ra,        4($sp)      # Store return address.
    la      $t1,        vals        # Load address of data into $t1.
    lw      $a0,        0($t1)      # Load A from memory into $a0.
    lw      $a1,        4($t1)      # Load B from memory into $a1.
    jal     abs_proc                # Jump and link to 'abs' procedure.
    sw      $v0,        8($t1)      # Write result and return.
    lw      $ra,        4($sp)      # Restore return address.
    addi    $sp,        $sp,    8   # Restore stack pointer position.
    jr      $ra                     # Return from program.
    # PROCEDURE abs(a, b) to calculate the
    # absolute difference of two words.
abs_proc:
    sub     $v0,        $a0,    $a1 # result = a - b
    bgez    $v0,        return      # If +ve jump next instruction.
    sub     $v0,        $a1,    $a0 # result = b - a
return: 
    jr      $ra                     # Return from procedure.
