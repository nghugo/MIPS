.data
greeting_message:    .asciiz "Welcome to the MIPS Calculator\n"
select_option_message:    .asciiz "\nSelect an option:\n[1] isPrime?    [2] Factorial?    [3] Exit?\n"
is_prime_message:    .asciiz "-------\nisPrime\n-------\n"
enter_integer_message:    .asciiz "Please enter an integer:\n"
factorial_message:    .asciiz "-------\nFactorial\n-------\n"

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


    li $t0, 1
    blt $s0, $t0, option_executed_or_invalid_input  # if $s0 ie option < 1, jump after all options (invalid input)
    li $t0, 3
    bgt $s0, $t0, option_executed_or_invalid_input  # if $s0 ie option > 3, jump after all options (invalid input)
    li $t0, 2
    bge $s0, $t0, option_2_or_3  # if $s0 ie option >= 2, jump to option_2_or_3
    # fill in: option 1 proc
    # testing START ---
    li $v0, 1       # syscall: print integer
    la $a0, 1111
    syscall
    # testing END   ---

    j option_executed_or_invalid_input
option_2_or_3:
    li $t0, 3
    beq $s0, $t0, option_3  # if $s0 ie option == 3, jump to option_3
    # fill in: option 2 proc
    # testing START ---
    li $v0, 1       # syscall: print integer
    la $a0, 2222
    syscall
    # testing END   ---
    j option_executed_or_invalid_input
option_3:
    # fill in: option 3 proc
    # testing START ---
    li $v0, 1       # syscall: print integer
    la $a0, 3333
    syscall
    j end_program
    # testing END   ---
    j option_executed_or_invalid_input
option_executed_or_invalid_input:

    # TODO: call the 3 procedures based on the 3 different values of $s0

    lw      $ra,        4($sp)      # Restore return address.
    lw      $s0,        0($sp)      # Restore $s0.
    addi    $sp,        $sp,    8   # Restore stack pointer position.
    jr $ra # Return from program

    # TODO: Move the exit program code below to the 3rd procedure ie exit
    # Graceful exit
    

# TODO: is_prime procedure
# TODO: get_remainder procedure
# TODO: factorial procedure
# TODO: mult procedure


end_program:
    # Exit program
    li $v0, 10      # syscall: exit
    syscall

    # # Prompt for user input
    # li $v0, 4       # syscall: print string
    # la $a0, prompt  # load address of prompt string
    # syscall

    # # Read integer from user
    # li $v0, 5       # syscall: read_int
    # syscall
    # move $s0, $v0   # store user input in $s0

    # # Call isprime function
    # move $a0, $s0   # pass user input as argument
    # jal isprime

    # # Display the result
    # beq $v0, 1, prime_result
    # li $v0, 4       # syscall: print string

    # la $a0, not_prime_message
    # syscall

    

# prime_result:
#     li $v0, 4       # syscall: print string
#     la $a0, is_prime_message
#     syscall



# isprime:
#     # Input: $a0 (number to check)
#     # Output: $v0 (1 if prime, 0 if not prime)

#     # Handle base cases (0 and 1 are not prime)
#     beq $a0, 0, not_prime
#     beq $a0, 1, not_prime

#     # Check divisibility from 2 to n-1
#     li $t0, 2       # start divisor at 2
#     isprime_loop:
#         bge $t0, $a0, prime_done  # check if divisor exceeds n

#         # Check for divisibility
#         move $a1, $a0
#         move $a0, $t0
#         jal divide    # divide $a1 by $a0, store quotient in $a1, remainder in $a2
#         beqz $a2, not_prime

#         # Increment divisor and loop
#         addi $t0, $t0, 1
#         j isprime_loop

#     prime_done:
#         # Number is prime
#         li $v0, 1
#         j isprime_end

#     not_prime:
#         # Number is not prime
#         li $v0, 0

#     isprime_end:
#         jr $ra          # return

# divide:
#     # Input: $a0 (numerator), $a1 (denominator)
#     # Output: $a1 (quotient), $a2 (remainder)

#     li $a2, 0      # initialize remainder to 0
#     divide_loop:
#         sub $a0, $a0, $a1  # subtract denominator from numerator
#         bgez $a0, divide_loop  # repeat until numerator is non-negative
#         addi $a2, $a0, $a1  # add denominator back to correct overshoot
#         j $ra
