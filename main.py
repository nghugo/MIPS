
# .data
greeting_message = "Welcome to the MIPS Calculator"
prompt_select_option_message = "Select an option:"
prompt_options_message = "[1] isPrime?    [2] Factorial?    [3] Exit?"
dash = "-------"
newline = ""  #  \n
is_prime_message = "isPrime"
enter_integer_message = "Please enter an integer:"
factorial_message = "Factorial"

notTerminated = True

# .main
def main():
    print(greeting_message)
    while notTerminated:
        getOption()
    print("Exit.")
        
def getOption():
    global notTerminated  # represents register address
    print(newline)
    print(prompt_select_option_message)
    print(prompt_options_message)
    option = input()
    if option == "1":
        isPrime()
    if option == "2":
        factorial()
    if option == "3":
        notTerminated = False

def isPrime():
    print(dash)
    print(is_prime_message)
    print(dash)
    print(enter_integer_message)
    val = int(input())
    if val <= 1:
        print(f"{val} is NOT a prime number")
        return
    for i in range(2, val):  # 2, ..., val - 1 , change to while loop
        if val % i == 0:  # replace with a function
            print(f"{val} is NOT a prime number")
            return
    print(f"{val} is a prime number")

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
        


