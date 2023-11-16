.data
greeting_message:    .asciiz "Welcome to the MIPS Calculator\n"
select_option_message:    .asciiz "\nSelect an option:\n[1] isPrime?    [2] Factorial?    [3] Exit?\n"
dash:    .asciiz "-------\n"
is_prime_message:    .asciiz "isPrime\n"
enter_integer_message:    .asciiz "Please enter an integer:\n"
factorial_message:    .asciiz "Factorial\n"

.text
.globl main

main:
    # Greet user
    li $v0, 4       # syscall: print_str
    la $a0, greeting_message  # load address of prompt string
    syscall

loop:
    jal get_option
    j loop

get_option:

    # Display select option message
    li $v0, 4       # syscall: print_str
    la $a0, select_option_message  # load address of prompt string
    syscall


    # Exit program
    li $v0, 10      # syscall: exit
    syscall



    # # Prompt for user input
    # li $v0, 4       # syscall: print_str
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
    # li $v0, 4       # syscall: print_str

    # la $a0, not_prime_message
    # syscall

    # Graceful exit
    j end_program

# prime_result:
#     li $v0, 4       # syscall: print_str
#     la $a0, is_prime_message
#     syscall

end_program:
    # Exit program
    li $v0, 10      # syscall: exit
    syscall

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
