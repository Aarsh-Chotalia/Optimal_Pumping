% Load data
load("st1.mat");

% Extract variables
x = delta_f_array;
y = E;
y_upper = y + err;
y_lower = y - err;

% Create figure
figure('Color', 'w'); % white background

% Plot shaded error region
fill([x, fliplr(x)], [y_upper', fliplr(y_lower')], [0.8 0.85 1], ...
    'EdgeColor', 'none', 'FaceAlpha', 0.5);
hold on;

% Plot main curve
plot(x, y, 'k-', 'LineWidth', 2);

% Vertical reference line at delta_f = 0.37
xline(0.37, '--r', '', ...
    'FontSize', 14, ...
    'Interpreter', 'latex', ...
    'LabelOrientation', 'horizontal', ...
    'LabelVerticalAlignment', 'bottom', ...
    'LineWidth', 1.5);

% Labels
xlabel('$\delta_f$ (Hz)', 'Interpreter', 'latex', 'FontSize', 18);
ylabel('$E$', 'Interpreter', 'latex', 'FontSize', 18);

% Axes styling
set(gca, ...
    'FontSize', 16, ...
    'LineWidth', 1.5, ...
    'TickDir', 'out', ...
    'TickLength', [0.015 0.015], ...
    'Box', 'off', ...
    'XMinorTick', 'off', ...
    'YMinorTick', 'off', ...
    'XGrid', 'off', ...
    'YGrid', 'off');

% Keep axis range tight around data
xlim([min(x), max(x)]);
ylim([min(y_lower)-0.05*range(y_lower), max(y_upper)+0.05*range(y_upper)]);

% Save figure
print('energy_vs_deltaf_vline','-dpng','-r300');  % High-res PNG
% print('energy_vs_deltaf_vline','-dpdf','-r300');  % Vector-quality PDF
