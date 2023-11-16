.data
greeting_message:    .asciiz "Welcome to the MIPS Calculator\n"
select_option_message:    .asciiz "\nSelect an option:\n[1] isPrime?    [2] Factorial    [3] Exit\n"
is_prime_message:    .asciiz "-------\nisPrime\n-------\n"
enter_integer_message:    .asciiz "Please enter an integer:\n"
factorial_message:    .asciiz "-------\nFactorial\n-------\n"
exit_message:    .asciiz "Exit.\n"

.text
.globl main

main:
    # Greet user
    li $v0, 4       # syscall: print string
    la $a0, greeting_message  # load address of prompt string
    syscall


loop:
    jal get_option
    j loop


get_option:

    addi $sp, $sp, -8  # Move the stack pointer.
    sw  $ra,    4($sp)  # Store return address (we are about to call nested procedures).
    sw  $s0,    0($sp)  # Store $s0 as we want to use it, but we are also obligated to restore it.

    # Display select option message
    li $v0, 4       # syscall: print string
    la $a0, select_option_message  # load address of prompt string
    syscall

    # Receive option from user input (expect integer 1/ 2/ 3)
    li $v0, 5       # syscall: read integer
    syscall

    # Set the option to $s0, which persists across procedural calls
    add $s0, $v0, $zero


    # Value of option from user input is not yet determined
    li $t0, 1
    blt $s0, $t0, option_executed_or_invalid_input  # if $s0 ie option < 1, jump after all options (invalid input)
    li $t0, 3
    bgt $s0, $t0, option_executed_or_invalid_input  # if $s0 ie option > 3, jump after all options (invalid input)
    
    # Invalid values of option from user input have been filtered out at this point
    li $t0, 2
    bge $s0, $t0, option_2_or_3  # if $s0 ie option >= 2, jump to option_2_or_3
    jal is_prime  # Value of option from user input is found to be 1, so execute is_prime
    j option_executed_or_invalid_input
option_2_or_3:
    li $t0, 3
    beq $s0, $t0, option_3  # if $s0 ie option == 3, jump to option_3
    jal factorial  # Value of option from user input is found to be 2, so execute factorial
    j option_executed_or_invalid_input
option_3:
    j exit  # Value of option from user input is found to be 3, so execute exit
option_executed_or_invalid_input:
    lw      $ra,        4($sp)      # Restore return address.
    lw      $s0,        0($sp)      # Restore $s0.
    addi    $sp,        $sp,    8   # Restore stack pointer position.
    jr $ra # Return from program    


is_prime:
    # if call procedure, make sure to store $ra in stack
    # TODO: is_prime procedure
    # TODO: get_remainder procedure
    # testing START ---
    li $v0, 1       # syscall: print integer
    la $a0, 1111
    syscall
    jr $ra
    # testing END   ---

factorial:
    # if call procedure, make sure to store $ra in stack
    # TODO: factorial procedure
    # TODO: mult procedure
    # testing START ---
    li $v0, 1       # syscall: print integer
    la $a0, 2222
    syscall
    jr $ra
    # testing END   ---


exit:
    # Display select option message
    li $v0, 4       # syscall: print string
    la $a0, exit_message  # load address of prompt string
    syscall
    li $v0, 10      # syscall: exit
    syscall
