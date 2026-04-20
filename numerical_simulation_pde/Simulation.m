%% SIMULATION KK MODEL PDE SYSTEM

%% Parameters

rho_max =  140;
v_max = 120;
tau = 1/120;   
eta = 600; 
theta = 3600;
rho_init = 30;
Delta_rho_0 = 1;
rho_krit = 27.9; % computed in KK_FD script

L = 10; % Length of the road
T = 3; % Simulation time

n_x = 500; % discretization (Initially: 500)
n_t = 1000000; % time discretization (Initially: 1000000)

dt = T / n_t;
dx = L / n_x;

%% KK FD

% v-rho dependency

V = @(rho)  v_max*(1./(1 + exp((rho/rho_max - 0.25)/0.06))- 3.72e-6); 
%% Initial conditions
x = linspace(0,L,n_x+1).';

rho_0 = rho_init + Delta_rho_0 .* ...
    (sech((160/L) .* (x - 5*L/16)).^2 ...
    - 1/4 * sech((40/L) .* (x - 11*L/32)).^2);

v_0 = V(rho_0);

%% Calculation
n_save = floor(n_t / 500);

rho = zeros(n_x+1, n_save+1);
v   = zeros(n_x+1, n_save+1);

rho(:,1) = rho_0;
v(:,1)   = v_0;

t = linspace(0, T, n_t+1);

rho_1 = rho_0;
v_1 = v_0;

k = 2;

for j = 1:n_t
    rho_0 = rho_1;
    v_0   = v_1;

    [rho_1, v_1] = EE_KK(rho_0, v_0, dt, dx, rho_max, v_max, tau, eta, theta, rho_init);

    if mod(j,500) == 0
        rho(:,k) = rho_1;
        v(:,k)   = v_1;
        k = k + 1;
    end
end

%% Figure

t_100 = t(1:500:end);
%rho_100 = rho(1:10:end,1:1000:end);
%x_100 = x(1:10:end);
[X, TT] = meshgrid(x, t_100);

fig1 = figure;
set(fig1, 'Units', 'centimeters');
set(fig1, 'Position', [2 2 14 8]);

%% rho � 3D
subplot(2,2,1)
surf(X, TT, rho.', 'EdgeColor', 'none')
view(45, 30)
xlabel('x', 'Interpreter', 'latex')
ylabel('t', 'Interpreter', 'latex')
zlabel('$\rho(x,t)$', 'Interpreter', 'latex')
title('Hustota (3D)', 'Interpreter', 'none', 'FontName', 'Arial')
cb = colorbar;
ylabel(cb, 'Hustota', 'Interpreter', 'latex')

%% rho � heatmap
subplot(2,2,2)
imagesc(t_100, x, rho)
set(gca, 'YDir', 'reverse') 
xlabel('t', 'Interpreter', 'latex')
ylabel('x', 'Interpreter', 'latex')
title('Hustota (heatmapa)', 'Interpreter', 'none', 'FontName', 'Arial')
cb = colorbar;
caxis([10 100])
ylabel(cb, 'Hustota', 'Interpreter', 'latex')

%% v � 3D
subplot(2,2,3)
surf(X, TT, v.', 'EdgeColor', 'none')
view(45, 30)
xlabel('x', 'Interpreter', 'latex')
ylabel('t', 'Interpreter', 'latex')
zlabel('$v(x,t)$', 'Interpreter', 'latex')
title('R�chlos� (3D)', 'Interpreter', 'none', 'FontName', 'Arial')
cb = colorbar;
caxis([0 120])
ylabel(cb, 'R�chlos�', 'Interpreter', 'latex')

%% v � heatmap
subplot(2,2,4)
imagesc(t_100, x, v)
set(gca, 'YDir', 'reverse') 
xlabel('t', 'Interpreter', 'latex')
ylabel('x', 'Interpreter', 'latex')
title('R�chlos� (heatmapa)', 'Interpreter', 'none', 'FontName', 'Arial')
cb = colorbar;
caxis([0 120])
ylabel(cb, 'R�chlos�', 'Interpreter', 'latex')

%% Export

%exportgraphics(fig1, 'KK_simulation.pdf', ...
%    'ContentType', 'image', 'Resolution', 600)