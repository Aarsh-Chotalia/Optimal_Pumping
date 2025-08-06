Nd = 21;  % Number of delta_f values
Nr = 100;  % Number of repetitions per delta_f
st_array = [0.001, 0.005, 0.01, 0.05, 0.1, 0.5, 1, 5, 10]; %Shuffling times
sim_count = 0;  % Initialize simulation counter
total_sims = length(st_array) * Nd * Nr;  % Total number of runs


for st = st_array  % Loop over shuffling times

clc
clearvars -except st sim_count total_sims  Nd Nr% Clear all except progress tracking
hold off
st  % Display current st
dfi = 0;
dff = 1;
h = waitbar(0, 'Simulation in progress...');  % Initialize waitbar
waitbar(sim_count / total_sims, h, ...
            sprintf('Progress: %3.1f %%', 100 * sim_count / total_sims));
delta_f_array = linspace(dfi, dff, Nd);  % delta_f values
peaks = zeros(Nd,1);
E = zeros(Nd,1);
err = zeros(Nd,1);
CF = zeros(Nd,1);
E_f = zeros(Nd, Nr);  % Energy matrix for each delta_f and run


for j = 1:Nd  % Loop over delta_f values
    delta_f = delta_f_array(j);

    for l = 1:Nr  % Loop over repetitions
        j;
        l;
        tic;

        Fs = 1000;
        Ti = 0;
        Tf = 110;

        SampleNumber = (Tf - Ti) * Fs;
        p_val = 120 + 200 * rand(SampleNumber + 1, 1);  % Random input

        Tspan = linspace(Ti, Tf, SampleNumber);  % Time span

        % Parameters
        C = 135;
        dlta = 7;
        eta = 10;

        e0 = 2.5;
        v0 = 6;
        r = 0.56;
        A = 3.25;
        B = 22;
        a = 100;
        b = 50;

        % Generate time-varying eta with noise scaled by delta_f
        etas = [eta];
        for i = 1:(Tf - Ti) / st
            etas = [etas, eta + delta_f * randn * ones(Fs * st, 1)'];
        end

        zta = 1.2;
        yi = rand(7,1);
        yi(7,1) = 0;
        k = 1E-6;
        options = odeset('RelTol', k);

        % ODE simulation
        [t, y] = ode45(@(t, y) odejr(t, y, e0, v0, r, A, B, a, b, dlta, etas, zta, C, Fs, p_val), Tspan, yi, options); %Integrate JR model

        
        discard = 10;
        OutS = y(discard * Fs + 1:end, 2) - y(discard * Fs + 1:end, 3);  % Output signal
        OutS = OutS - mean(OutS);  % Demean signal

        Nsamps = length(OutS);
        xdft1 = fft(OutS);
        xdft1 = xdft1(1:floor(Nsamps/2) + 1);
        psdx1 = (1 / (Fs * Nsamps)) * abs(xdft1).^2;
        psdx1(2:end - 1) = 2 * psdx1(2:end - 1);

        freq = 0:Fs/Nsamps:Fs/2;

        E_f(j,l) = sum(psdx1);  % Frequency-domain energy
        dt = (Tf - Ti) / length(Tspan);
        E_x = sum(OutS.^2) * dt;  % Time-domain energy (not used)
        toctime=toc;

        % --- Update progress ---
        sim_count = sim_count + 1;
        Remaining = (total_sims - sim_count) * toctime;

    hrs = floor(Remaining / 3600);
    mins = floor(mod(Remaining, 3600) / 60);
    secs = mod(Remaining, 60);

    
    timeStr = '';
    if hrs > 0
        timeStr = [timeStr, sprintf('%d hr ', hrs)];
    end
    if mins > 0 || hrs > 0  % Show minutes if hours exist
        timeStr = [timeStr, sprintf('%d min ', mins)];
    end
    timeStr = [timeStr, sprintf('%.0f sec', secs)];

    % Update waitbar with progress and estimated remaining time
    waitbar(sim_count / total_sims, h, ...
        sprintf('Progress: %3.1f %% | Time left: %s', ...
        100 * sim_count / total_sims, timeStr));
    end

    E(j) = mean(E_f(j,:));  % Mean energy
    err(j) = std(E_f(j,:)); % Std deviation

end

% Plotting
x = delta_f_array;
y = E;
y_upper = y + err;
y_lower = y - err;
hold off
fill([x fliplr(x)], [y_upper' fliplr(y_lower')], [0.9 0.9 1], 'LineStyle', 'none');
hold on;
plot(x, y, 'k*', 'LineWidth', 1.5);

title("st=" + num2str(st))
xlabel('\delta_f','FontSize',20)
ylabel('Energy','FontSize',20)

save("st" + num2str(st) + ".mat")
savefig("st" + num2str(st) + ".fig")
saveas(gcf, "st" + num2str(st) + ".png")
hold off

close(h);  % Close waitbar

end  % End of st loop
