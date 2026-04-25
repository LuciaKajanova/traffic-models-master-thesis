%% SIMULATION KK MODEL PDE SYSTEM WITH NGSIM DATA

clear
clc
%% Custom Colormap

cmap_viridis_base = [
    0.267 0.004 0.329
    0.283 0.141 0.458
    0.254 0.265 0.530
    0.207 0.372 0.553
    0.164 0.471 0.558
    0.128 0.567 0.551
    0.135 0.659 0.518
    0.267 0.749 0.441
    0.478 0.821 0.318
    0.741 0.873 0.150
];

n = 256;

cmap_viridis = interp1( ...
    linspace(0,1,size(cmap_viridis_base,1)), ...
    cmap_viridis_base, ...
    linspace(0,1,n) ...
);

cmap_plazma_base = [
    0.050 0.030 0.527
    0.290 0.070 0.678
    0.507 0.070 0.600
    0.700 0.150 0.450
    0.850 0.300 0.250
    0.950 0.550 0.100
    0.980 0.800 0.200
];

n = 256;

cmap_plazma = interp1( ...
    linspace(0,1,size(cmap_plazma_base,1)), ...
    cmap_plazma_base, ...
    linspace(0,1,n) ...
);

%% Load data

ic_load = readtable('initial_condition_lane2.csv');
ic = table2array(ic_load);
x_ic     = ic(:,2)/1000;
rho0_ic  = ic(:,3);
v0_ic    = ic(:,4);

bc_load = readtable('right_boundary_lane2.csv');
bc = table2array(bc_load);

t_bc = bc(:,1)/3600; 
rho_right_data = bc(:,2); 
v_right_data = bc(:,3);


%% Parameters

rho_max = 140;

% new fitted fundamental diagram
a = 62.60;
b = 52.67;
c = 16.03;

V = @(rho) a ./ (1 + exp((rho - b)./c));

tau = 1/120;
eta = 10;
theta = 6000;

%% Domain from data

L = max(x_ic);        % 480 m
T = max(t_bc);        

n_x = 100;
n_t = 1000000;

dt = T / n_t;
dx = L / n_x;

x = linspace(0, L, n_x+1).';
t = linspace(0, T, n_t+1);

%% Initial conditions from data

rho_0 = interp1(x_ic , rho0_ic, x, 'linear', 'extrap'); % 'extrap'
v_0   = interp1(x_ic, v0_ic,   x, 'linear', 'extrap');

rho_1 = rho_0;
v_1   = v_0;

n_save = floor(n_t / 500);

rho = zeros(n_x+1, n_save+1);
v   = zeros(n_x+1, n_save+1);

rho(:,1) = rho_0;
v(:,1)   = v_0;

k = 2;

for j = 1:n_t

    rho_0 = rho_1;
    v_0   = v_1;

    % boundary data at current time
    rho_right_now = interp1(t_bc, rho_right_data, t(j), 'linear', 'extrap');
    v_right_now   = interp1(t_bc, v_right_data,   t(j), 'linear', 'extrap');

    [rho_1, v_1] = EE_KK_sim( ...
        rho_0, v_0, dt, dx, tau, eta, theta, V, ...
        rho_right_now, v_right_now);

    if mod(j,500) == 0
        rho(:,k) = rho_1;
        v(:,k)   = v_1;
        k = k + 1;
    end
end

%% Figure

t_save = t(1:500:end);
t_save = t_save(1:size(rho,2));

% Axis
t_plot = t_save * 60;       % hour -> minute
x_plot = x * 1000 + 100;    % km -> m [100,600]

[X, TT] = meshgrid(x_plot, t_plot);

fig1 = figure;
set(fig1, 'Units', 'centimeters');
set(fig1, 'Position', [2 2 14 4]);

%% rho – heatmap
subplot(1,2,2)
imagesc(t_plot, x_plot, rho)
set(gca, 'YDir', 'reverse')
xlabel('$t$ (PDT)', 'Interpreter', 'latex')
ylabel('$x$ (m)', 'Interpreter', 'latex')
title('Hustota', 'Interpreter', 'none', 'FontName', 'Arial')
colormap(gca, cmap_viridis)
cb = colorbar;
ylabel(cb, 'Hustota', 'Interpreter', 'none')
xticks([0 10 20 30])
xticklabels({'08:00','08:10','08:20','08:30'})
yticks([100 200 300 400 500 600])

%% v – heatmap
subplot(1,2,1)
imagesc(t_plot, x_plot, v)
set(gca, 'YDir', 'reverse')
xlabel('$t$ (PDT)', 'Interpreter', 'latex')
ylabel('$x$ (m)', 'Interpreter', 'latex')
title('Rýchlosť', 'Interpreter', 'none', 'FontName', 'Arial')
colormap(gca, cmap_plazma)
cb = colorbar;
ylabel(cb, 'Rýchlosť', 'Interpreter', 'none')
xticks([0 10 20 30])
xticklabels({'08:00','08:10','08:20','08:30'})
yticks([100 200 300 400 500 600])


%% Export

exportgraphics(fig1, 'NGSIM_simulation_heatmap.pdf', ...
    'ContentType', 'image', ...
    'Resolution', 600)