%% KK fundamental diagram

% Parameters
rho_max = 140;
v_max = 120;

% v-rho dependency
V = @(rho) v_max*(1./(1 + exp((rho/rho_max - 0.25)/0.06)) - 3.72e-6);  

rho_vals = 0:0.1:rho_max;
v_vals = V(rho_vals);

%% Figure: V(rho)

figure
plot(rho_vals, v_vals, 'LineWidth', 1)
xlabel('$\rho$', 'Interpreter', 'latex')
ylabel('$V(\rho)$', 'Interpreter', 'latex')
title('Fundamentálny diagram (KK)')
grid on

% Set figure size (for consistent export)
set(gcf, 'Units', 'centimeters')
set(gcf, 'Position', [1 1 12 8])

% Export to vector PDF
exportgraphics(gcf, 'KK_V_rho.pdf', 'ContentType', 'vector')


%% q-rho dependency

Q = rho_vals .* v_vals;
[q_krit, index] = max(Q);
rho_krit = rho_vals(index);

%% Figure: Q(rho)

figure
plot(rho_vals, Q, 'LineWidth', 1)
hold on

% Critical point visualization
plot([rho_krit, rho_krit], [0, q_krit], 'k--', 'LineWidth', 1)
plot(rho_krit, q_krit, 'ko', 'MarkerFaceColor', 'k')
plot([0, rho_krit], [q_krit, q_krit], 'k--', 'LineWidth', 1)

xlabel('$\rho$', 'Interpreter', 'latex')
ylabel('$Q(\rho)$', 'Interpreter', 'latex')
title('Fundamentálny diagram (KK)')
grid on
hold off

% Set figure size
set(gcf, 'Units', 'centimeters')
set(gcf, 'Position', [1 1 12 8])

% Export to vector PDF
exportgraphics(gcf, 'KK_Q_rho.pdf', 'ContentType', 'vector')