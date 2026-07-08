# Convolutional Code Performance Analysis using Viterbi Decoding
A MATLAB-based simulation environment that analyzes the performance of Convolutional Codes under varying signal conditions. The project models a complete digital communication system over an Additive White Gaussian Noise (AWGN) channel using Binary Phase Shift Keying (BPSK) modulation.

## Overview

This project implements a hardware-accurate convolutional encoder alongside both **Hard-Decision** and **Soft-Decision Viterbi Decoders** to compare performance metrics. The simulation tests three distinct configurations to analyze the effect of varying rates ($r$) and constraint lengths ($K$):
1. **Rate 1/2, K = 3** with generator matrix `[1 0 1; 1 1 1]`
2. **Rate 1/3, K = 4** with generator matrix `[1 0 1 1; 1 1 0 1; 1 1 1 1]`
3. **Rate 1/3, K = 6** with generator matrix `[1 0 0 1 1 1; 1 0 1 0 1 1; 1 1 1 1 0 1]`

## Features
- **Custom Trellis Construction:** Automatically builds state transitions and outputs dynamically based on the input generator matrix.
- **Hard Decision Decoder:** Evaluates path costs using Hamming distance on demodulated bits.
- **Soft Decision Decoder:** Evaluates unquantized Euclidean distance directly from received channel values, improving decoding gains.
- **Monte Carlo Simulation:** Tests 10,000 trials per SNR point across an SNR range of 0 to 10 dB to map highly accurate Bit Error Rate (BER) curves.

## File Structure
- `main_simulation.m`: The primary script that coordinates parameter definitions, loops across SNR vectors, handles plotting, and executes tests across all three configurations.
- `encode_msg.m`: Simulates the shift-register state machine of a convolutional encoder.
- `viterbi_hard.m`: Implements the forward trellis traversal and backtracking using Hamming metrics.
- `viterbi_soft.m`: Implements the forward trellis traversal and backtracking using Euclidean distance metrics.
- `add_awgn_noise.m`, `map_bits_to_symbols.m`, `threshold_decoder.m`, `generate_random_message.m`: System-level utility scripts facilitating signal processing and channel modeling.

## How to Run
1. Open MATLAB.
2. Set your current directory to this project folder containing all the `.m` files.
3. Run the main script via the command window or editor:
   ```matlab
   main_simulation
