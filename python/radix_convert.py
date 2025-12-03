def toBaltern(dividend: int) -> list[str]:
    digits = []
    if dividend == 0:
        digits.append('0')
    
    while dividend != 0:
        remainder = dividend % 3
        if remainder == 0:
            digits.append('0')
        elif remainder == 1:
            digits.append('+')
            dividend -= 1
        else:  # remainder == 2
            digits.append('-')
            dividend += 1
        dividend //= 3

    return ''.join(digits[::-1])  # Most significant digit first

def toDec(balTern: list[str]) -> int:
    """
    Converts a list of balanced ternary symbols (MSB first) into
    a decimal integer 
    """
    decNum = 0
    maxIndex = len(balTern) - 1
    num = None
    for i in range(0, len(balTern)):
        match balTern[i]:
            case '-':
                num = -1
            case '0':
                num = 0
            case '+':
                num = 1
            case _:
                raise ValueError
        decNum += num * 3**(maxIndex-i)
    return decNum

def showBalTern(start:int, stop: int):
    """
    Prints a sequence of balanced ternary numbers from \n
    decimal integer start to decimal integer stop.
    """
    for i in range(start, stop + 1):
        balTernNum = toBaltern(i)
        print(balTernNum)

        newDec = toDec(balTernNum)
        if newDec != i:
            print(f'Error with Decimal {i}')
    print('DONE')

def addBalTern(num1: list[str], num2: list[str]):
    return toDec(num1) + toDec(num2)

def subBalTern(num1: list[str], num2: list[str]):
    return toDec(num1) - toDec(num2)



if __name__ == "__main__":
    num1 = ['0', '-', '+', '-', '-', '0']
    num2 = ['+', '+', '-', '0', '0', '0']
    print(toBaltern(addBalTern(num1, num2)))
    #print(toBaltern(subBalTern(num1, num2)))

