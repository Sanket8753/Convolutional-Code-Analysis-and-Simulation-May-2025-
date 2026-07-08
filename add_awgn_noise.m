function noisy_signal = add_awgn_noise(signal, noise_std)
    noisy_signal = signal + noise_std * randn(1, length(signal));
end
