function decodedBits = viterbi_soft(generatorMatrix, receivedSignal)
    numGenerators = size(generatorMatrix, 1);
    memoryLength = size(generatorMatrix, 2);
    totalStates = 2^(memoryLength - 1);
    stateTransitions = zeros(totalStates, 2);
    stateOutputs = zeros(totalStates, 2);

    % Build trellis structure
    for currentState = 0:totalStates-1
        for inputBit = 0:1
            nextState = bitshift(currentState, -1);
            if inputBit == 1
                nextState = nextState + 2^(memoryLength - 2);
            end
            stateTransitions(currentState + 1, inputBit + 1) = nextState;
            currentBits = dec2bin(currentState, log2(totalStates)) - '0';
            fullState = [inputBit, currentBits];
            outputBits = [];
            for k = 1:numGenerators
                outputBits = [outputBits, mod(sum(bitand(generatorMatrix(k, :), fullState)), 2)];
            end
            bitString = strrep(num2str(outputBits), ' ', '');
            stateOutputs(currentState + 1, inputBit + 1) = bin2dec(bitString);
        end
    end

    % Forward traversal using Euclidean distance
    numColumns = length(receivedSignal) / numGenerators + 1;
    pathMetrics = repmat(500, totalStates, numColumns);
    pathMetrics(1, 1) = 0;
    bitCounter = 1;

    for col = 1:numColumns - 1
        segment = receivedSignal(bitCounter:bitCounter + numGenerators - 1);
        bitCounter = bitCounter + numGenerators;
        for state = 1:totalStates
            output0 = dec2bin(stateOutputs(state, 1), numGenerators) - '0';
            output1 = dec2bin(stateOutputs(state, 2), numGenerators) - '0';
            symbols0 = 1 - 2 * output0;
            symbols1 = 1 - 2 * output1;
            metric0 = sum((segment - symbols0).^2);
            metric1 = sum((segment - symbols1).^2);
            next0 = stateTransitions(state, 1) + 1;
            next1 = stateTransitions(state, 2) + 1;
            pathMetrics(next0, col + 1) = min(pathMetrics(next0, col + 1), pathMetrics(state, col) + metric0);
            pathMetrics(next1, col + 1) = min(pathMetrics(next1, col + 1), pathMetrics(state, col) + metric1);
        end
    end

    % Backtracking
    currentState = 0;
    decodedBits = [];
    for col = numColumns - 1:-1:1
        predecessors = [];
        for state = 1:totalStates
            for inputBit = 0:1
                if stateTransitions(state, inputBit + 1) == currentState
                    predecessors = [predecessors; state, inputBit];
                end
            end
        end
        
        previous1 = predecessors(1, :);
        previous2 = [];
        if size(predecessors, 1) > 1
            previous2 = predecessors(2, :);
        end
        
        segment = [];
        for k = numGenerators - 1:-1:0
            segment = [segment, receivedSignal(numGenerators * col - k)];
        end
        
        out0 = dec2bin(stateOutputs(previous1(1), previous1(2) + 1), numGenerators) - '0';
        symb0 = 1 - 2 * out0;
        metric0 = sum((segment - symb0).^2);
        cost0 = pathMetrics(previous1(1), col) + metric0;
        
        if ~isempty(previous2)
            out1 = dec2bin(stateOutputs(previous2(1), previous2(2) + 1), numGenerators) - '0';
            symb1 = 1 - 2 * out1;
            metric1 = sum((segment - symb1).^2);
            cost1 = pathMetrics(previous2(1), col) + metric1;
        else
            cost1 = Inf;
            metric1 = Inf;
        end
        
        costs = [cost0, cost1];
        metrics = [metric0, metric1];
        previousStates = [previous1; previous2];
        
        [minCost, idx] = min(costs);
        if sum(costs == minCost) > 1
            [~, idx] = min(metrics);
        end
        
        decodedBits = [decodedBits, previousStates(idx, 2)];
        currentState = previousStates(idx, 1) - 1;
    end
    decodedBits = flip(decodedBits);
end
