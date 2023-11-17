.data
greeting_message:    .asciiz "Welcome to the MIPS Calculator\n"
select_option_message:    .asciiz "\nSelect an option:\n[1] isPrime?    [2] Factorial    [3] Exit\n"
is_prime_message:    .asciiz "-------\nisPrime\n-------\nPlease enter an integer:\n"
is_prime_true_message:    .asciiz " is a prime number\n"
is_prime_false_message:    .asciiz " is NOT a prime number\n"
factorial_message:    .asciiz "-------\nFactorial\n-------\nPlease enter an integer:\n"
exit_message:    .asciiz "Exit.\n"

.text
.globl main

main:
    # Greet user
    li $v0, 4       # syscall: print string
    la $a0, greeting_message  # load address of prompt string
    syscall
main_loop:
    jal get_option
    j main_loop



get_option:

    addi $sp, $sp, -8  # Move the stack pointer.
    sw  $ra,    4($sp)  # Store return address (we are about to call nested procedures).
    sw  $s0,    0($sp)  # Store $s0 as we want to use it, but we are also obligated to restore it.

    # Display select_option_message
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

    addi $sp, $sp, -12  # Move the stack pointer.
    sw  $ra,    8($sp)  # Store return address (we are about to call nested procedures).
    sw  $s0,    4($sp)  # Store $s0 as we want to use it, but we are also obligated to restore it.
    sw  $s1,    0($sp)  # Store $s1 as we want to use it, but we are also obligated to restore it.

    # Display is_prime_message (isPrime?)
    li $v0, 4       # syscall: print string
    la $a0, is_prime_message  # load address of prompt string
    syscall

    # Receive integer from user input
    li $v0, 5       # syscall: read integer
    syscall
    add $s0, $v0, $zero  # store user's input integer (dividend) in $s0, which persists across procedural calls

    li $t0, 1  # just set a threshold for comparison
    ble $s0, $t0, is_prime_false  # if $s0 ie integer <= 1, jump to is_prime_false   
    li $s1, 2  # divisor starts at 2 and is gradually increased to the value of the dividend

is_prime_loop:
    beq $s0, $s1, is_prime_true  # if the divisor $s1 reaches the dividend $s0 without ever getting remainder 0, then exit to is_prime_true
    add $a0, $s0, $zero  # dividend
    add $a1, $s1, $zero  # divisor
    jal get_remainder  # get_remainder takes $a0 as the dividend, $a1 as the divisor, and returns remainder in $v0
    beq $v0, $zero, is_prime_false  # exit to is_prime_false if remainder is 0 (indicates dividend is not prime)
    addi $s1, $s1, 1  # increment divisor by 1
    j is_prime_loop

is_prime_true:   
    # Display user's input integer of interest (stored in $s0)
    li $v0, 1       # syscall: print integer
    add $a0, $s0, $zero
    syscall

    # Display is_prime_true_message
    li $v0, 4       # syscall: print string
    la $a0, is_prime_true_message  # load address of prompt string
    syscall
    j is_prime_done

is_prime_false:
    # Display user's input integer of interest (stored in $s0)
    li $v0, 1       # syscall: print integer
    add $a0, $s0, $zero
    syscall

    # Display is_prime_false_message
    li $v0, 4       # syscall: print string
    la $a0, is_prime_false_message  # load address of prompt string
    syscall

is_prime_done:
    lw      $ra,        8($sp)      # Restore return address.
    lw      $s0,        4($sp)      # Restore $s0.
    lw      $s1,        0($sp)      # Restore $s1.
    addi    $sp,        $sp,    12   # Restore stack pointer position.
    jr $ra



get_remainder:
    # take args from $a0 (dividend) and $a1 (divisor)
    # store remainder in $v0
    li $t0, 0
    blt $a0, $t0, get_remainder_done  # if $a0 (dividend) < 0, jump to get_remainder
    sub $a0, $a0, $a1
    j get_remainder  # loop until exit
get_remainder_done:
    add $v0, $a0, $a1  # correct for overshoot, store result in $v0
    jr $ra


factorial:
    # Display factorial_message (Factorial)
    li $v0, 4       # syscall: print string
    la $a0, factorial_message  # load address of prompt string
    syscall

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
    # Display select_option_message
    li $v0, 4       # syscall: print string
    la $a0, exit_message  # load address of prompt string
    syscall
    li $v0, 10      # syscall: exit
    syscall
