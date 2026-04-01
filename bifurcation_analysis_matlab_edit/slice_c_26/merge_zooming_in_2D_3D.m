clear
close all
clc

%% === OPEN FIGURES ===
f2D = openfig('2D_c_26.fig','invisible');
f3D = openfig('3D_zooming_in_c_26.fig','invisible');

%% === CREATE NEW FIGURE ===
figure('Color','w','Position',[100 100 1200 500])

%% =================== 2D SUBPLOT ======================
ax1 = subplot(1,2,1);
hold(ax1,'on')

ax_old_2D = findobj(f2D,'type','axes');
objs2D = allchild(ax_old_2D);
copyobj(objs2D, ax1)

xlabel(ax1,'$q^{*}$','Interpreter','latex','FontSize',14)
ylabel(ax1,'$v$','Interpreter','latex','FontSize',14)

% ? ZOOM REGION (upraviù podæa potreby)
xlim(ax1,[2580 2640])
ylim(ax1,[-5 120])

title(ax1,'2D diagram (zoom)','FontWeight','bold')
set(ax1,'FontSize',11,'LineWidth',0.8)
box(ax1,'on')

%% =================== 3D SUBPLOT ======================
ax2 = subplot(1,2,2);
hold(ax2,'on')

ax_old_3D = findobj(f3D,'type','axes');
objs3D = allchild(ax_old_3D);
copyobj(objs3D, ax2)

xlabel(ax2,'$y$','Interpreter','latex','FontSize',14)
ylabel(ax2,'$q^{*}$','Interpreter','latex','FontSize',14)
zlabel(ax2,'$v$','Interpreter','latex','FontSize',14)

% ? ZOOM REGION
xlim(ax2,[-200 50])
ylim(ax2,[2580 2640])
zlim(ax2,[-5 120])

title(ax2,'3D diagram (zoom)','FontWeight','bold')
set(ax2,'FontSize',11,'LineWidth',0.8)
box(ax2,'on')
view(ax2,3)

%% === CLEAN UP ===
close(f2D)
close(f3D)

%% === EXPORT ===
%exportgraphics(gcf,'combined_zoom.pdf','ContentType','vector')