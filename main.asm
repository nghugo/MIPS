.data
greeting_message:    .asciiz "Welcome to the MIPS Calculator\n"
select_option_message:    .asciiz "\nSelect an option:\n[1] isPrime?    [2] Factorial    [3] Exit\n"
is_prime_message:    .asciiz "-------\nisPrime\n-------\nPlease enter an integer:\n"
is_prime_true_message:    .asciiz " is a prime number\n"
is_prime_false_message:    .asciiz " is NOT a prime number\n"
factorial_message:    .asciiz "-------\nFactorial\n-------\nPlease enter an integer:\n"
factorial_of_message:    .asciiz "Factorial of "
factorial_is_message:    .asciiz " is "
newline_message:     .asciiz "\n"
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
    # $s0 -> dividend (user input value)
    # $s1 -> divisor (starts from 2 up to the dividend value)

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
    # $s0 -> factorial number (user input value, will be modified by algo)
    # $s1 -> original factorial number (user input value, unchanged copy)
    # $s2 -> res

    addi $sp, $sp, -16  # Move the stack pointer.
    sw  $ra,    12($sp)  # Store return address (we are about to call nested procedures).
    sw  $s0,    8($sp)  # Store $s0 as we want to use it, but we are also obligated to restore it.
    sw  $s1,    4($sp)  # Store $s1 as we want to use it, but we are also obligated to restore it.
    sw  $s2,    0($sp)  # Store $s2 as we want to use it, but we are also obligated to restore it.

    # Display factorial_message (Factorial)
    li $v0, 4       # syscall: print string
    la $a0, factorial_message  # load address of prompt string
    syscall

    # Receive integer from user input
    li $v0, 5       # syscall: read integer
    syscall
    add $s0, $v0, $zero  # store user's input integer (factorial number) in $s0, which persists across procedural calls
    add $s1, $v0, $zero  # store user's input integer (factorial number) in $s1, which persists across procedural calls
    li $s2, 1       # store value of 1 in $s2


# TODO: factorial procedure
factorial_loop:
    li $t0, 1       # load a threshold
    ble $s0, $t0, factorial_done  # exit loop when value reaches 1

    add $a0, $s0, $zero  # pass the factorial number to multiply
    add $a1, $s2, $zero  # pass the res to multiply
    # mult takes the inputs $a0 and $a1, then returns their product in $v0
    jal mult
    add $s2, $v0, $zero  # store the product in $s2

    addi $a0, $a0, -1  # decrement factorial number by 1


    j factorial_loop

factorial_done:
    # Print the message. Recall:
    # $s1 -> input value (user input value, unchanged copy)
    # $s2 -> res
    
    # Display factorial_of_message (Factorial of)
    li $v0, 4       # syscall: print string
    la $a0, factorial_of_message  # load address of prompt string
    syscall

    # Display the original factorial number (stored in $s1)
    li $v0, 1       # syscall: print integer
    add $a0, $s1, $zero
    syscall
    
    # Display factorial_is_message (is)
    li $v0, 4       # syscall: print string
    la $a0, factorial_is_message  # load address of prompt string
    syscall

    # Display the result (stored in $s2)
    li $v0, 1       # syscall: print integer
    add $a0, $s2, $zero
    syscall

    # Display newline_message (\n)
    li $v0, 4       # syscall: print string
    la $a0, newline_message  # load address of prompt string
    syscall

    lw      $ra,        12($sp)      # Restore return address.
    lw      $s0,        8($sp)      # Restore $s0.
    lw      $s1,        4($sp)      # Restore $s1.
    lw      $s2,        4($sp)      # Restore $s2.
    addi    $sp,        $sp,    16   # Restore stack pointer position.
    jr $ra

mult:
    # $a0 -> argument x
    # $a1 -> argument y
    # $v0 -> return x * y
    li $v0, 0
mult_loop:  # loop y times to add the value x to v0
    addi $a1, $a1, -1
    beq $a1, $zero, mult_done
    add $v0, $v0, $a0  # $v0 += $a0
    j mult_loop
mult_done:
    jr $ra


exit:
    # Display select_option_message
    li $v0, 4       # syscall: print string
    la $a0, exit_message  # load address of prompt string
    syscall
    li $v0, 10      # syscall: exit
    syscall
