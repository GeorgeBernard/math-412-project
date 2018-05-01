%% Calculate Betti progression for random graphs
clear; format short; close all;
import edu.stanford.math.plex4.*;

%% Script constants
drop_thresholds=[0.001, 0.002, 0.005, 0.01, 0.02, 0.05 0.1, 0.2, 0.5, 1, 2];

num_in = 784;
num_W1 = 300;
num_W2 = 10;

num_vertices = num_in + num_W1 + num_W2 + 2;

%% Make random network
mu  = 0;
sig = 1;

W1 = normrnd(mu, sig, [num_in, num_W1]);
b1 = normrnd(mu, sig, [num_W1]);
W2 = normrnd(mu, sig, [num_W1, num_W2]);
b2 = normrnd(mu, sig, [num_W2]);

%% Make adjacency matrices
adjacencies = cell(length(drop_thresholds));

for drop_ind = 1:length(drop_thresholds)
    drop = drop_thresholds(drop_ind);
    adjacency = zeros(num_vertices, num_vertices);

    % Check first weight matrix
    for i = 1:size(W1, 1);
        for j = 1:size(W1, 2);
            adj_j = num_in + j;
            
            if (W1(i, j) >= drop)
                adjacency(i, adj_j) = 1;
                adjacency(adj_j, i) = 1;
            end
        end
    end
    
    % Check second weight matrix
    for i = 1:size(W2, 1);
        for j = 1:size(W2, 2);
            adj_i = num_in + i;
            adj_j = num_in + num_W1 + j;
            
            if (W2(i, j) >= drop)
                adjacency(adj_i, adj_j) = 1;
                adjacency(adj_j, adj_i) = 1;
            end
        end
    end
    
    % Check bias 1 node
    for i = 1:size(b1)
        adj_i = num_in+i;
        
        if (b1(i) >= drop)
            adjacency(1095, adj_i) = 1;
            adjacency(adj_i, 1095) = 1;
        end
    end
    
    % Check bias 2 node
    for i = 1:size(b2)
        adj_i = num_in + num_W1;
        
        if (b1(i) >= drop)
            adjacency(1096, adj_i) = 1;
            adjacency(adj_i, 1096) = 1;
        end
    end

    adjacencies{drop_ind} = adjacency;
end

%% Calculate betti numbers

% Prepare output
betti_0 = zeros(length(drop_thresholds), 1);
betti_1 = zeros(length(drop_thresholds), 1);

for drop_ind = 1:length(drop_thresholds)
    % Convert adjacency matrix to stream
    adjacency = adjacencies{drop_ind};
    stream = examples.SimplexStreamExamples.createGraphComplex(adjacency);
    
    % Calculate Betti Numbers
    persistence = api.Plex4.getModularSimplicialAlgorithm(2, 2);
    intervals = persistence.computeIntervals(stream);
    infinite_barcodes = intervals.getInfiniteIntervals();
    betti_numbers_array = infinite_barcodes.getBettiSequence();
    
    if(length(betti_numbers_array) == 1)
        betti_0(drop_ind) = betti_numbers_array(1);
        betti_1(drop_ind) = 0;
    end
    if (length(betti_numbers_array) == 2)
        betti_0(drop_ind) = betti_numbers_array(1);
        betti_1(drop_ind) = betti_numbers_array(2);
    end
end

%% Plot progression

figure(1);
subplot(1, 2, 1);
bar(log10(drop_thresholds), betti_0);
title('B_0 vs. log drop threshold')
xlabel('log_{10}(threshold)');
ylabel('B_0');
grid on;

subplot(1, 2, 2);
bar(log10(drop_thresholds), betti_1);
title('B_1 vs. log drop threshold')
xlabel('log_{10}(threshold)');
ylabel('B_1');
grid on;

print('random-graph-bettis', '-dpng')
