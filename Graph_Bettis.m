%% Find the betti numbers of an adjacency matrix
clear; format short; close all;
import edu.stanford.math.plex4.*;

%% Program constants
num_epoch = 10;
filename_pattern = 'unweighted-bias-epoch-%d-drop-%s-%d.txt';
delimiter = ' ';
drop_thresholds=[0.001, 0.002, 0.01, 0.02, 0.1, 0.2, 1, 2];

%% Prepare output
betti_0 = zeros(length(drop_thresholds), 10);
betti_1 = zeros(length(drop_thresholds), 10);

%% Load adjacency matrix from files
for drop_ind = 1:length(drop_thresholds)
    for epoch = 0:(num_epoch-1)
        drop = drop_thresholds(drop_ind);
        
        filename = sprintf(filename_pattern, num_epoch, num2str(drop), epoch);
        adjacency = importdata(filename, delimiter);
        
        % Convert adjacency matrix to stream
        stream = api.Plex4.createExplicitSimplexStream();
        
        for v = 1:length(adjacency)
            stream.addVertex(v);
        end
        
        for i = 1:length(adjacency)
            for j = 1:length(adjacency)
                if (adjacency(i, j) ~= 0)
                    stream.addElement([i, j]);
                end
            end
        end
        
        % Calculate Betti Numbers
        persistence = api.Plex4.getModularSimplicialAlgorithm(2, 2);
        intervals = persistence.computeIntervals(stream);
        infinite_barcodes = intervals.getInfiniteIntervals();
        betti_numbers_array = infinite_barcodes.getBettiSequence();
        
        if(length(betti_numbers_array) == 1)
            betti_0(drop_ind, epoch+1) = betti_numbers_array(1);
            betti_1(drop_ind, epoch+1) = 0;
        end
        if (length(betti_numbers_array) == 2)
            betti_0(drop_ind, epoch+1) = betti_numbers_array(1);
            betti_1(drop_ind, epoch+1) = betti_numbers_array(2);
        end
        
    end
end

%% Save betti numbers

save('bettis', 'betti_0', 'betti_1');