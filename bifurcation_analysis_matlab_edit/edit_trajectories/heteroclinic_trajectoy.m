clear
clc

% load data (assumes variable x is stored in the file)
load('aprox_hetero.mat')

% period of the cycle
T = x(end-1);

% time step
dt = T/400;

% extract the part corresponding to the cycle points
x_cycle = x(1:802,end);

% split into variables v and y
v = x_cycle(1:2:end);
y = x_cycle(2:2:end);

% time vector
z = (0:length(v)-1) * dt;

% plot v over time
figure
plot(z, v, 'LineWidth', 0.8, 'Color', 'b')
xlabel('$z$', 'Interpreter', 'latex')
ylabel('$v$', 'Interpreter', 'latex')
xlim([0 9500])
% ylim([-5 120])