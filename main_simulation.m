clc;
clear all;

% Simulation Parameters
snr_dB_range = 0:0.5:10;
snr_linear = 10.^(snr_dB_range / 10);
num_trials = 10000;
msg_bits = 6;
[~, num_snr_points] = size(snr_dB_range);
ber_uncoded = (1/2) * erfc(sqrt(snr_linear));
original_msg = generate_random_message(msg_bits);

% (1) Code Rate: 1/2 Constraint Length: 3
constraint_length = 3;
code_rate = 1/2;
generator_matrix = [1, 0, 1; 1, 1, 1];
[ref_msg, coded_bits] = encode_msg(constraint_length, original_msg, generator_matrix);
modulated_symbols = map_bits_to_symbols(coded_bits);
noise_std_dev = sqrt(1./ (code_rate .* snr_linear));

% Initialize BER Arrays
ber1_hard = zeros(1, num_snr_points);
ber1_soft = zeros(1, num_snr_points);

% Simulation Loop
for snr_idx = 1:num_snr_points
    sigma = noise_std_dev(1, snr_idx);
    errors_hard = 0;
    errors_soft = 0;
    for trial = 1:num_trials
        noisy_symbols = add_awgn_noise(modulated_symbols, sigma);
        hard_bits = threshold_decoder(noisy_symbols);
        decoded_hard = viterbi_hard(generator_matrix, hard_bits);
        decoded_soft = viterbi_soft(generator_matrix, noisy_symbols);
        errors_hard = errors_hard + sum(decoded_hard ~= ref_msg);
        errors_soft = errors_soft + sum(decoded_soft ~= ref_msg);
    end
    total_bits = length(ref_msg) * num_trials;
    ber1_hard(1, snr_idx) = errors_hard / total_bits;
    ber1_soft(1, snr_idx) = errors_soft / total_bits;
end

% Plot Results
figure(1);
hold on;
semilogy(snr_dB_range, ber1_hard, 'bo-', 'LineWidth', 2, 'MarkerSize', 6);
semilogy(snr_dB_range, ber1_soft, 'r*--', 'LineWidth', 2, 'MarkerSize', 6); 
hold off;
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
grid on;
legend('Hard Decision', 'Soft Decision');
title('BER vs. SNR for Convolutional Code (rate=1/2, K=3)');

% (2) Code Rate: 1/3 Constraint Length: 4
constraint_length = 4;
code_rate = 1/3;
generator_matrix = [1, 0, 1, 1; 1, 1, 0, 1; 1, 1, 1, 1];
[ref_msg, coded_bits] = encode_msg(constraint_length, original_msg, generator_matrix);
modulated_symbols = map_bits_to_symbols(coded_bits);
noise_std_dev = sqrt(1./ (code_rate .* snr_linear));

% Initialize BER Arrays
ber2_hard = zeros(1, num_snr_points);
ber2_soft = zeros(1, num_snr_points);

% Simulation Loop
for snr_idx = 1:num_snr_points
    sigma = noise_std_dev(1, snr_idx);
    errors_hard = 0;
    errors_soft = 0;
    for trial = 1:num_trials
        noisy_symbols = add_awgn_noise(modulated_symbols, sigma);
        hard_bits = threshold_decoder(noisy_symbols);
        decoded_hard = viterbi_hard(generator_matrix, hard_bits);
        decoded_soft = viterbi_soft(generator_matrix, noisy_symbols);
        errors_hard = errors_hard + sum(decoded_hard ~= ref_msg);
        errors_soft = errors_soft + sum(decoded_soft ~= ref_msg);
    end
    total_bits = length(ref_msg) * num_trials;
    ber2_hard(1, snr_idx) = errors_hard / total_bits;
    ber2_soft(1, snr_idx) = errors_soft / total_bits;
end

% Plot Results
figure(2);
semilogy(snr_dB_range, ber2_hard, 'bo-', 'LineWidth', 2, 'MarkerSize', 6); 
hold on;
semilogy(snr_dB_range, ber2_soft, 'r*--', 'LineWidth', 2, 'MarkerSize', 6); 
hold off;
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
grid on;
legend('Hard Decision', 'Soft Decision');
title('BER vs. SNR for Convolutional Code (rate=1/3, K=4)');

% (3) Code Rate: 1/3 Constraint Length: 6
constraint_length = 6;
code_rate = 1/3;
generator_matrix = [1, 0, 0, 1, 1, 1; 1, 0, 1, 0, 1, 1; 1, 1, 1, 1, 0, 1];
[ref_msg, coded_bits] = encode_msg(constraint_length, original_msg, generator_matrix);
modulated_symbols = map_bits_to_symbols(coded_bits);
noise_std_dev = sqrt(1./ (code_rate .* snr_linear));

% Initialize BER Arrays
ber3_hard = zeros(1, num_snr_points);
ber3_soft = zeros(1, num_snr_points);

% Simulation Loop
for snr_idx = 1:num_snr_points
    sigma = noise_std_dev(1, snr_idx);
    errors_hard = 0;
    errors_soft = 0;
    for trial = 1:num_trials
        noisy_symbols = add_awgn_noise(modulated_symbols, sigma);
        hard_bits = threshold_decoder(noisy_symbols);
        decoded_hard = viterbi_hard(generator_matrix, hard_bits);
        decoded_soft = viterbi_soft(generator_matrix, noisy_symbols);
        errors_hard = errors_hard + sum(decoded_hard ~= ref_msg);
        errors_soft = errors_soft + sum(decoded_soft ~= ref_msg);
    end
    total_bits = length(ref_msg) * num_trials;
    ber3_hard(1, snr_idx) = errors_hard / total_bits;
    ber3_soft(1, snr_idx) = errors_soft / total_bits;
end

% Plot Results
figure(3);
semilogy(snr_dB_range, ber3_hard, 'bo-', 'LineWidth', 2, 'MarkerSize', 6); 
hold on;
semilogy(snr_dB_range, ber3_soft, 'r*--', 'LineWidth', 2, 'MarkerSize', 6); 
hold off;
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
grid on;
legend('Hard Decision', 'Soft Decision');
title('BER vs. SNR for Convolutional Code (rate=1/3, K=6)');

% (4) Combined graph together
figure(4);
semilogy(snr_dB_range, ber1_hard, 'b-o', 'LineWidth', 2, 'MarkerSize', 6); 
hold on;
semilogy(snr_dB_range, ber1_soft, 'b--*', 'LineWidth', 2, 'MarkerSize', 6);
semilogy(snr_dB_range, ber2_hard, 'g-s', 'LineWidth', 2, 'MarkerSize', 6);
semilogy(snr_dB_range, ber2_soft, 'g--^', 'LineWidth', 2, 'MarkerSize', 6);
semilogy(snr_dB_range, ber3_hard, 'm-d', 'LineWidth', 2, 'MarkerSize', 6);
semilogy(snr_dB_range, ber3_soft, 'm--x', 'LineWidth', 2, 'MarkerSize', 6); 
hold off;
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
grid on;
legend('r=1/2 & K=3 Hard', 'r=1/2 & K=3 Soft', 'r=1/3 & K=4 Hard', 'r=1/3 & K=4 Soft', 'r=1/3 & K=6 Hard', 'r=1/3 & K=6 Soft', 'Location', 'southwest');
title('Bit Error Rate vs. SNR Practical');
