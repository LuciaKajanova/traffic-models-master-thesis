%% Initial condition

%% Parameters

rho_max =  140;
v_max = 120;
tau = 1/120;   
eta = 600; 
theta = 3600;
rho_init = 30;
Delta_rho_0 = 1;

L = 10; % Length of the road
T = 3; % Simulation time

n_x = 1000; % discretization (500)
n_t = 3000000; % time discretization (1000000)

%% Initial condition
x = linspace(0,L,n_x+1).';

rho_0 = rho_init + Delta_rho_0 .* ...
    (sech((160/L) .* (x - 5*L/16)).^2 ...
    - 1/4 * sech((40/L) .* (x - 11*L/32)).^2);

%% Figure

figure
plot(x, rho_0, 'LineWidth', 1)
xlabel('x','Interpreter', 'latex')
ylabel('$\rho$', 'Interpreter', 'latex')
grid on

% Improve figure size (in cm)
set(gcf, 'Units', 'centimeters')
set(gcf, 'Position', [1 1 12 8])

%% export 
exportgraphics(gcf, 'initial_condition.pdf', 'ContentType', 'vector')