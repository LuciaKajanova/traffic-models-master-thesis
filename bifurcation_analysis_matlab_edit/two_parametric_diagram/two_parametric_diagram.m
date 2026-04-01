% Load original figure (invisible)
f = openfig('two_parametric_diagram.fig','invisible');

ax = findobj(f,'Type','axes');
ax = ax(1);   % main axis

lines = findobj(ax,'Type','line');
texts = findobj(ax,'Type','text');

% Create clean figure
f2 = figure;
ax2 = axes(f2);
hold(ax2,'on')

% Slice c
plot([900 5500],[5,5], 'k--') % c = 5
plot([900 5500],[20,20], 'k--') % c = 20
plot([900 5500],[26.94,26.94], 'k--') % c = 26
plot([900 5500],[40,40], 'k--') % c = 40

copyobj(lines, ax2)
copyobj(texts, ax2)

% Axis limits zoom
%xlim(ax2,[2415 2465])
%ylim(ax2,[18 20.5])

% Axis limits
xlim(ax2,[900 5500])
ylim(ax2,[-60 100])

% Axis labels
xlabel(ax2,'$q^{*}$','Interpreter','latex','FontSize',14)
ylabel(ax2,'$c$','Interpreter','latex','FontSize',14)

% Slice c - label
xl = xlim(ax2);
xr = xl(2)+20;

text(xr,5,'$c=5$','Interpreter','latex','HorizontalAlignment','left')
text(xr,20,'$c=20$','Interpreter','latex','HorizontalAlignment','left')
text(xr,26,'$c=26.94$','Interpreter','latex','HorizontalAlignment','left')
text(xr,40,'$c=40$','Interpreter','latex','HorizontalAlignment','left')

% Unify appearance
set(ax2,'FontSize',12,'LineWidth',0.8)
box(ax2,'on')

% Close original figure
close(f)

% Adjustment was done by hand in matlab plot and then exported to the
% final figure

%% Export final figure

%exportgraphics(gcf,'two_parametric_diagram_final.pdf','ContentType','vector')
