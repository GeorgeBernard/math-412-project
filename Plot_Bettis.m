%% Plot the betti numbers found for the transformed graph

clear; format short;

%% Load the data

load('bettis');

%% Script Constants
drop_thresholds=[0.001, 0.002, 0.01, 0.02, 0.1, 0.2, 1, 2];
num_epochs=10;

%% Plot the bettis
for drop_ind = 1:length(drop_thresholds)
    drop = drop_thresholds(drop_ind);
    
    betti_0_prog = betti_0(drop_ind, :);
    betti_1_prog = betti_1(drop_ind, :);
    
    epochs = 0:(num_epochs-1);
    
    figure(drop_ind);
    subplot(1, 2, 1);
    plot(epochs, betti_0_prog, 'x--');
    title_0 = sprintf('B_0 vs. Epoch, Thresh-%s', num2str(drop));
    title(title_0)
    xlabel('Training Epoch')
    ylabel('B_0')
    grid on;
    
    subplot(1, 2, 2);
    plot(epochs, betti_1_prog, 'x--');
    title_1 = sprintf('B_1 vs. Epoch, Thresh-%s', num2str(drop));
    title(title_1)
    xlabel('Training Epoch')
    ylabel('B_1')
    grid on;
    
    filename = sprintf('betti-progression-thresh-%s-plot', num2str(drop));
    print(filename, '-dpng')
    
end