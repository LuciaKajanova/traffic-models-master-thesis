%% Travelling wave speed
% rho_init = 30, delta_rho_init = 1, other parameters like usual, T = 3

% Firstly you should run Simulation script! 
% You need to select a time range, where you can see the travelling wave

rho_selected = rho(:,(end-250):(end-100)); % Last half hour
v_selected = v(:,(end-250):(end-100));
X_selected = X((end-250):(end-100),:);
TT_selected = TT((end-250):(end-100),:);

% Another selection:

%rho_selected = rho(:,(end-100):end); % Last half hour
%v_selected = v(:,(end-100):end);
%X_selected = X((end-100):end,:);
%TT_selected = TT((end-100):end,:);

rho_treshold = ones(size(rho_selected))*(80); % find the treshold

%% 

RHO = rho_selected > rho_treshold; % Logical matrix
xx = X_selected(RHO');
% xx = xx(:);
tt = TT_selected(RHO');
% tt = tt(:);


%% Linear regression

p = polyfit(tt, xx, 1);
c = p(1);
line = @(tt) p(2)+tt.*p(1);

disp(['Wave speed c = ', num2str(abs(c))])

%% Figure

fig1 = figure;
scatter(tt,xx, '.')
hold on
plot(tt,line(tt), 'Color', 'red', 'Linewidth', 1.5)
xlabel('$t$', 'Interpreter', 'latex')
ylabel('$x$', 'Interpreter', 'latex')
title('Odhad rýchlosti postupujúcej vlny', 'Interpreter', 'latex')
%xlim([2.6 2.8])
hold off
grid on

% Figure size
set(fig1, 'Units', 'centimeters')
set(fig1, 'Position', [2 2 12 8])

% Export
%exportgraphics(fig1, 'wave_speed_fit.pdf', 'ContentType', 'vector')

%% q_star 

rho_last = rho_selected(:,end);
v_last = v_selected(:,end);

q_star = (-c)*rho_last + rho_last.*v_last;

fig2 = figure;
plot([1:length(q_star)],q_star)
xlabel('Index $z$', 'Interpreter', 'latex')
ylabel('$q*$', 'Interpreter', 'latex')
xlim([0 2000])
grid on

% Figure size
set(fig2, 'Units', 'centimeters')
set(fig2, 'Position', [2 2 12 8])

% Export
%exportgraphics(fig2, 'q_star_profile.pdf', 'ContentType', 'vector')

average_q_star = mean(q_star)
min_q_star = min(q_star)
max_q_star = max(q_star)

%figure 
%plot([1:length(q_star)],rho_last)
%xlabel('Index $z$', 'Interpreter', 'latex')
%ylabel('$\rho$', 'Interpreter', 'latex')
%title('Hustota v poslednom èasovom kroku', 'Interpreter', 'latex')
%grid on


%% Bifurcation diagram

% You would need the two_parametric_diagram from bifurcation analysis
% (Matonct).

% Open figure
%fig3 = openfig('two_parametric_diagram_final.fig');
%figure(fig3)
%hold on

%plot([min_q_star, max_q_star], [-c,-c], 'Color', 'red', 'Linewidth', 1.5)

% Figure size
%set(fig3, 'Units', 'centimeters')
%set(fig3, 'Position', [2 2 12 8])

%hold off

% Export
%exportgraphics(fig3, 'bifurcation_with_wave.pdf', 'ContentType', 'vector')

%% Zoom 

% Open figure
%fig4 = openfig('two_parametric_diagram_final.fig');
%figure(fig4)
%hold on

%plot([min_q_star, max_q_star], [-c,-c], 'Color', 'red', 'Linewidth', 1.5)
%xlim([2480 2550])
%ylim([21.6 22])

% Figure size
%set(fig4, 'Units', 'centimeters')
%set(fig4, 'Position', [2 2 12 8])

%hold off






