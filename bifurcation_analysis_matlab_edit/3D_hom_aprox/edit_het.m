% Load original figure (invisible)
f = openfig('2D_aprox_het.fig','invisible');

ax = findobj(f,'Type','axes');
ax = ax(1);   % main axis

lines = findobj(ax,'Type','line');
texts = findobj(ax,'Type','text');

% Create clean figure
f2 = figure;
ax2 = axes(f2);
hold(ax2,'on')

copyobj(lines, ax2)
copyobj(texts, ax2)

% Axis limits
xlim(ax2,[-210 50])
ylim(ax2,[-5 110])

% Axis labels
xlabel(ax2,'$y$','Interpreter','latex','FontSize',14)
ylabel(ax2,'$v$','Interpreter','latex','FontSize',14)


% Unify appearance
set(ax2,'FontSize',12,'LineWidth',0.8)
box(ax2,'on')

% Close original figure
close(f)

% Adjustment was done by hand in matlab plot and then exported to the
% final figure

%% Export final figure

%exportgraphics(gcf,'two_parametric_diagram_final.pdf','ContentType','vector')
