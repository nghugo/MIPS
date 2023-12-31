# .data
greeting_message = "\nWelcome to the MIPS Calculator"
select_option_message = "\nSelect an option:\n[1] isPrime?    [2] Factorial    [3] Exit"
is_prime_message = "-------\nisPrime\n-------\nPlease enter an integer:"
factorial_message = "-------\nFactorial\n-------\nPlease enter an integer:"

not_terminated = True  # do not need in mips, as you can command a global exit

# .main
def main():
    print(greeting_message)
    while not_terminated:
        get_option()
    print("Exit.")
        
def get_option():
    global not_terminated  # represents register address
    print(select_option_message)
    option = input()
    if option == "1":
        is_prime()
    if option == "2":
        factorial()
    if option == "3":
        not_terminated = False

def is_prime():
    print(is_prime_message)
    val = int(input())  # need to use $s0 to persist val after get_remainder procs
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

def get_remainder(dividend, divisor):
    while dividend >= 0:  # == case important
        dividend -= divisor
    dividend += divisor  # correct for overshoot
    return dividend

def factorial():
    print(factorial_message)
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
        


