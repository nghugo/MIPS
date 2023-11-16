# .data
greeting_message = "Welcome to the MIPS Calculator"
select_option_message = "Select an option:"
options_message = "[1] isPrime?    [2] Factorial?    [3] Exit?"
dash = "-------"
newline = ""  #  \n
is_prime_message = "isPrime"
enter_integer_message = "Please enter an integer:"
factorial_message = "Factorial"

not_terminated = True  # do not need in mips, as you can command a global exit

# .main
def main():
    print(greeting_message)
    while not_terminated:
        get_option()
    print("Exit.")
        
def get_option():
    global not_terminated  # represents register address
    print(newline)
    print(select_option_message)
    print(options_message)
    option = input()
    if option == "1":
        is_prime()
    if option == "2":
        factorial()
    if option == "3":
        not_terminated = False

def is_prime():
    print(dash)
    print(is_prime_message)
    print(dash)
    print(enter_integer_message)
    val = int(input())
    if val <= 1:
        print(f"{val} is NOT a prime number")
        return
    i = 2
    while i < val: # 2, ..., val - 1
        if get_remainder(val, i) == 0:  # equivalent to if val % i == 0
            print(f"{val} is NOT a prime number")
            return
        i += 1
    print(f"{val} is a prime number")

def get_remainder(val, divisor):
    while val >= 0:  # == case important
        val -= divisor
    val += divisor  # correct for overshoot
    return val

def factorial():
    print(dash)
    print(factorial_message)
    print(dash)
    print(enter_integer_message)
    val = int(input())
    valCopy = val
    res = 1
    while val > 1:
        res = mult(res, val)
        val -= 1
    print(f"Factorial of {valCopy} is {res}")

def mult(x, y):
    res = 0
    for _ in range(y):
        res += x
    return res

if __name__ == "__main__":
    main()
        


