function [X, encodedBits] = encode_msg(K, M, g)
    Mlen = length(M);
    % appending K-1 zeros
    X = [M, zeros(1, K-1)];
    numGens = size(g, 1);
    totalSteps = length(X);
    encodedBits = zeros(1, numGens * totalSteps);
    
    
    shiftReg = zeros(1, K);
    outIdx = 1;
    
    % Slide through each bit of X
    for n = 1:totalSteps
        % Shift in the new bit
        shiftReg = [X(n), shiftReg(1:end-1)];
        
        % For each generator, compute output = (g(i,:), shiftReg) mod 2
        for i = 1:numGens
            encodedBits(outIdx) = mod(sum(g(i,:) .* shiftReg), 2);
            outIdx = outIdx + 1;
        end
    end
end
