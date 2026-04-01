clear
close all
clc

%% === OPEN FIGURES (invisible) ===
f2D = openfig('2D_c_26.fig','invisible');
f3D = openfig('3D_c_26.fig','invisible');

%% === CREATE NEW FIGURE ===
figure('Color','w')

%% =================== 2D SUBPLOT ======================

ax1 = subplot(1,2,1);
hold(ax1,'on')

% find the original axes and their graphical objects
ax_old_2D = findobj(f2D,'type','axes');
objs2D = allchild(ax_old_2D);

% copy all objects (curves, points, labels)
copyobj(objs2D, ax1)

% set new axis labels
xlabel(ax1,'$q^{*}$','Interpreter','latex','FontSize',14)
ylabel(ax1,'$v$','Interpreter','latex','FontSize',14)

% adjust axis limits
xlim(ax1,[1800 3300])
ylim(ax1,[-5 120])

title(ax1,'2D diagram','FontWeight','bold')

set(ax1,'FontSize',11,'LineWidth',0.8)
box(ax1,'on')

%% =================== 3D SUBPLOT ======================

ax2 = subplot(1,2,2);
hold(ax2,'on')

% find the original axes and their graphical objects
ax_old_3D = findobj(f3D,'type','axes');
objs3D = allchild(ax_old_3D);

% copy all objects into the new axes
copyobj(objs3D, ax2)

% set new axis labels
xlabel(ax2,'$y$','Interpreter','latex','FontSize',14)
ylabel(ax2,'$q^{*}$','Interpreter','latex','FontSize',14)
zlabel(ax2,'$v$','Interpreter','latex','FontSize',14)

% adjust axis limits
xlim(ax2,[-220 50])
ylim(ax2,[1800 3300])     % q* axis (or parameter y)
zlim(ax2,[-5 120])        % v axis

title(ax2,'3D diagram','FontWeight','bold')

set(ax2,'FontSize',11,'LineWidth',0.8)
box(ax2,'on')
view(ax2,3)

%% === CLEAN UP ===
close(f2D)
close(f3D)

%% === EXPORT ===
% exportgraphics(gcf,'2D_3D_combined.pdf','ContentType','vector')