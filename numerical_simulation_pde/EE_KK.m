function [rho_1, v_1] = EE_KK (rho_0, v_0, dt, dx, rho_max, v_max, tau, eta, theta, rho_init)

% Minimal values of density and velocity
rho_min = 1*ones(size(rho_0));
v_min = 0.5*ones(size(v_0)); 

% Fundamental diagram
V = @(rho)  v_max*(1./(1 + exp((rho/rho_max - 0.25)/0.06))- 3.72e-6);  

% Periodic boundary conditions
%rho_plus = [rho_0(2:end);rho_0(1)];
rho_minus = [rho_0(end); rho_0(1:end-1)];

v_plus = [v_0(2:end);v_0(1)];
v_minus = [v_0(end);v_0(1:(end-1))];

% Condition

rho_krit = 27.9; % computed in KK_FD script

dv = (rho_init >= rho_krit).*(v_plus - v_0) + (rho_init < rho_krit).*(v_0 - v_minus);

% Calculation

rho_1 = rho_0 -(dt/dx)*v_0.*(rho_0 - rho_minus)-(dt/dx)*rho_0.*(v_plus - v_0);
v_1 = v_0 + (dt/tau)*(V(rho_0)-v_0) - v_0.*(dv*dt)/dx - ((dt./max(rho_0, rho_min))).*((theta/dx)*(rho_0-rho_minus)-(eta/dx^2)*(v_plus-2*v_0+v_minus));

v_1 = max(v_min,v_1);
rho_1 = max(rho_min,rho_1);
end
