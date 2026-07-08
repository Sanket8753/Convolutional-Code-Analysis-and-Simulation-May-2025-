function msg = generate_random_message(length_bits)
    msg = rand(1, length_bits) > 0.5;
end
