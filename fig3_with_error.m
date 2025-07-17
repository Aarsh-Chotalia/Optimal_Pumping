% --- Data Arrays ---
S_array1 = [0.001, 0.005, 0.01, 0.05, 0.1, 0.5, 1, 5, 10];

% Preallocate arrays
Y_array1 = zeros(length(S_array1), 21);
Sigma_array = zeros(length(S_array1), 21);

% Load data and populate arrays
for o = 1:length(S_array1)
    load("st" + S_array1(o) + ".mat");  % Assumes variables E and delta_f_array are present
    Y_array1(o, :) = E(:)';
    Sigma_array(o,:) = err;
end

% --- Plotting ---
figure('Color', 'w', 'Position', [100, 100, 1000, 900]);

% Grid layout
rows = 3;
cols = 3;

% Consistent Y-axis limits across all plots
y_min = min(Y_array1 - Sigma_array, [], 'all'); % include error region
y_max = max(Y_array1 + Sigma_array, [], 'all');

% Subplot labels
subplot_labels = {'(a)', '(b)', '(c)', '(d)', '(e)', ...
                  '(f)', '(g)', '(h)', '(i)'};

% Loop to create subplots
for i = 1:length(S_array1)
    subplot(rows, cols, i);
    
    % Get mean and std values
    mean_E = Y_array1(i, :);
    std_E = Sigma_array(i);

    % Define upper and lower bounds for error region
    upper = mean_E + std_E;
    lower = mean_E - std_E;

    % Shade the error region
    fill([delta_f_array, fliplr(delta_f_array)], ...
         [upper, fliplr(lower)], ...
         [0.5 0.5 0.5], ...       % Gray color
         'FaceAlpha', 0.3, ...    % 50% transparency
         'EdgeColor', 'none');    % No border
    hold on;

    % Plot E vs delta_f
    plot(delta_f_array, mean_E, 'k-', 'LineWidth', 2);

    % Annotate delta_f at peak if i > 5
    if i > 5
        [~, b] = max(mean_E);

        % Draw vertical line up to peak
        line([delta_f_array(b), delta_f_array(b)], [0, mean_E(b)], ...
            'LineStyle', '--', 'Color', 'r', 'LineWidth', 1.5);

        % Annotate delta_f value at base
%         text(delta_f_array(b), 0, ...
%             sprintf('\\delta_f = %.2f', delta_f_array(b)), ...
%             'VerticalAlignment', 'top', ...
%             'HorizontalAlignment', 'left', ...
%             'FontSize', 10, ...
%             'Color', 'r', ...
%             'Interpreter', 'tex');
    end

    % Labels and title
    xlabel('$\delta_f$ (Hz)', 'Interpreter', 'latex', 'FontSize', 12);
    ylabel('$E$', 'Interpreter', 'latex', 'FontSize', 12);
    title(['Shuffling Frequency $ = $ ' num2str(1/S_array1(i)) 'Hz'], ...
        'Interpreter', 'latex', 'FontSize', 12);
    
    % Axes styling
    set(gca, ...
        'FontSize', 10, ...
        'LineWidth', 1, ...
        'TickDir', 'out', ...
        'Box', 'off', ...
        'XLim', [min(delta_f_array), max(delta_f_array)], ...
        'YLim', [y_min, y_max]);

    % Subplot label
    text(0.02, 0.95, subplot_labels{i}, ...
        'Units', 'normalized', ...
        'FontSize', 12, ...
        'FontWeight', 'bold');
    %ylim([900 1350])
end

% --- Save the figure ---
print('subplots_E_vs_df_3x3_with_error','-dpng','-r300');
% print('subplots_E_vs_df_3x3','-dpdf','-r300');
