S_array=[0.001,0.005,0.01,0.05,0.1,0.5,1,2,5,10];
Y_array=zeros(length(S_array),21);
dY_array=zeros(length(S_array),21);
Sigma_array=zeros(length(S_array),1);

for o=1:10
    
    load("st"+S_array(o)+".mat")
    
    for j=1:11
        Y_array(o,j)=E(j);
     
    end
    Sigma_array(o)=std(E)
end

% Plot
figure('Color', 'w'); % White background
semilogx(1./S_array, Sigma_array, 'b-o', 'LineWidth', 2, 'MarkerSize', 8);
hold on

% Vertical line at 10 Hz (i.e., x = 0.1)
xline(10, '--r', '10 Hz', ...
    'FontSize', 14, ...
    'Interpreter', 'latex', ...
    'LabelOrientation', 'horizontal', ...
    'LabelVerticalAlignment', 'bottom', ...
    'LineWidth', 1.5);

% Axes Labels
xlabel('Shuffling Frequency (Hz)', 'FontSize', 18, 'Interpreter', 'latex');
ylabel('$\sigma(E)$', 'FontSize', 18, 'Interpreter', 'latex');

% Define custom xticks at multiples of 10
xticks([0.001,0.01,0.1,1, 10, 100, 1000]);

% Axes Properties
set(gca, ...
    'FontSize', 16, ...
    'LineWidth', 1.5, ...
    'TickDir', 'out', ...
    'Box', 'off', ...
    'XScale', 'log', ...
    'XMinorTick', 'off', ...
    'YGrid', 'on', ...
    'XGrid', 'on');

% Optional: tight layout
axis tight;

% Save as high-res PDF or PNG
print('sigma_vs_frequency','-dpng','-r300'); % PDF is vector quality
% Alternative: print('sigma_vs_frequency','-dpng','-r300'); for high-res PNG
