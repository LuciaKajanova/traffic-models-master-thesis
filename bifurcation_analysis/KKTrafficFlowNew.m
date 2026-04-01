function out = KKTrafficFlowNew
out{1} = @init;
out{2} = @fun_eval;
out{3} = [];
out{4} = [];
out{5} = [];
out{6} = [];
out{7} = [];
out{8} = [];
out{9} = [];

% --------------------------------------------------------------------------
function dydt = fun_eval(t,kmrgd,par_cc,par_q_star,par_vf,par_rho_m,par_eta_0,par_theta_0,par_tau)
rho=par_q_star/(par_cc+kmrgd(1));
Ve=par_vf*(1/(1+exp((rho/par_rho_m-0.25)/0.06))-3.72e-6);
dydt=[kmrgd(2);
kmrgd(2)*(par_q_star/par_eta_0)*(1-(par_theta_0/(par_cc+kmrgd(1))^2))-(par_q_star/par_eta_0)*((Ve-kmrgd(1))/(par_tau*(par_cc+kmrgd(1))));];

% --------------------------------------------------------------------------
function [tspan,y0,options] = init
handles = feval(KKTrafficFlowNew);
y0=[0,0];
options = odeset('Jacobian',[],'JacobianP',[],'Hessians',[],'HessiansP',[]);
tspan = [0 10];

% --------------------------------------------------------------------------
function jac = jacobian(t,kmrgd,par_cc,par_q_star,par_vf,par_rho_m,par_eta_0,par_theta_0,par_tau)
% --------------------------------------------------------------------------
function jacp = jacobianp(t,kmrgd,par_cc,par_q_star,par_vf,par_rho_m,par_eta_0,par_theta_0,par_tau)
% --------------------------------------------------------------------------
function hess = hessians(t,kmrgd,par_cc,par_q_star,par_vf,par_rho_m,par_eta_0,par_theta_0,par_tau)
% --------------------------------------------------------------------------
function hessp = hessiansp(t,kmrgd,par_cc,par_q_star,par_vf,par_rho_m,par_eta_0,par_theta_0,par_tau)
%---------------------------------------------------------------------------
function tens3  = der3(t,kmrgd,par_cc,par_q_star,par_vf,par_rho_m,par_eta_0,par_theta_0,par_tau)
%---------------------------------------------------------------------------
function tens4  = der4(t,kmrgd,par_cc,par_q_star,par_vf,par_rho_m,par_eta_0,par_theta_0,par_tau)
%---------------------------------------------------------------------------
function tens5  = der5(t,kmrgd,par_cc,par_q_star,par_vf,par_rho_m,par_eta_0,par_theta_0,par_tau)
