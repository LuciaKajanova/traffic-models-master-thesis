function [rho_1, v_1] = EE_KK_sim (rho_0, v_0, dt, dx, tau, eta, theta, V, rho_right, v_right)

% Minimal values of density and velocity
rho_min = 1*ones(size(rho_0));
v_min = 0.5*ones(size(v_0)); 

% Boundary conditions
v_plus   = [v_0(2:end); v_right];
v_minus = [v_0(1); v_0(1:end-1)]; % hom. Neumann

%rho_plus = [rho_0(2:end); rho_right];
rho_minus = [rho_0(1); rho_0(1:end-1)]; % hom. Neumann

% Calculation

rho_1 = rho_0 -(dt/dx)*v_0.*(rho_0 - rho_minus)-(dt/dx)*rho_0.*(v_plus - v_0);
v_1 = v_0 + (dt/tau)*(V(rho_0)-v_0) - v_0.*((v_0 - v_minus)*dt)/dx - ((dt./max(rho_0, rho_min))).*((theta/dx)*(rho_0-rho_minus)-(eta/dx^2)*(v_plus-2*v_0+v_minus));

v_1 = max(v_min,v_1);
rho_1 = max(rho_min,rho_1);

% Boundary condition
%rho_1(end) = rho_right;
v_1(end)   = v_right;
end
