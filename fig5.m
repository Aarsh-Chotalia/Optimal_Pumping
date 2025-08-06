% --- Data Arrays ---
S_array1 = [0.001, 0.005, 0.01, 0.05, 0.1, 0.5, 1, 5, 10];
invS_array = 1 ./ S_array1;
df_len = 21;

% Preallocation
Y_array1 = zeros(length(S_array1), df_len);

% Load and collect energy data
for o = 1:length(S_array1)
    load("st" + S_array1(o) + ".mat");
    Y_array1(o, :) = E;
end

% Sort by increasing 1/S
[invS_sorted, sortIdx] = sort(invS_array, 'ascend');
Y_sorted = Y_array1(sortIdx, :);

% Create meshgrid
[DF_grid, INV_S_grid] = meshgrid(delta_f_array, invS_sorted);

% Create figure
figure('Color', 'w', 'Position', [100 100 800 600]);

% Plot contour
contourf(DF_grid, log10(INV_S_grid), Y_sorted, 20, 'LineColor', 'none');
colormap(jet);
colorbar;
yline(log10(10), '--b', '', ...
    'FontSize', 18, ...
    'Interpreter', 'latex', ...
    'LabelOrientation', 'horizontal', ...
    'LabelVerticalAlignment', 'bottom', ...
    'LineWidth', 1.5);
% Axis labels
xlabel('$\delta_f$ (Hz)', 'Interpreter', 'latex', 'FontSize', 21);
ylabel('Shuffling Frequency (Hz)', 'Interpreter', 'latex', 'FontSize', 21);

% Set Y-axis to log scale and show only powers of 10
yticks(log10([0.001, 0.01, 0.1, 1, 10, 100, 1000]));
yticklabels({'10^{-3}', '10^{-2}', '10^{-1}', '10^0', '10^1', '10^2','10^3'});

% Title
%title('Energy $E$ vs $\delta_f$ and Shuffling Frequency','Interpreter', 'latex', 'FontSize', 16);

% Optional: save figure
print('Contour','-dpng','-r300');
