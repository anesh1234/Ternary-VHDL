import random

def generate_constrained_sequence(character_set, length):
    """
    Generates a random sequence from a character set with no more than two 
    equal characters appearing after one another.

    Args:
        character_set (str or list): The characters to choose from.
        length (int): The desired length of the sequence.

    Returns:
        str: The generated sequence.
    """
    if not character_set:
        return ""

    sequence = []
    for _ in range(length):
        while True:
            # Randomly choose a character
            next_char = random.choice(character_set) #
            
            # Check the last two characters if they exist
            if len(sequence) >= 2:
                if next_char == sequence[-1] and next_char == sequence[-2]:
                    # Violation found, try another character
                    continue
            
            # If no violation (or length < 2), add the character and break the while loop
            sequence.append(next_char)
            break
            
    return "".join(sequence)

# --- Example Usage ---

# Example 1: Using lowercase letters
char_set_letters = '-0+'
sequence_length = 3000
result_letters = generate_constrained_sequence(char_set_letters, sequence_length)
print(f"Random sequence of letters (length {sequence_length}): {result_letters}")
