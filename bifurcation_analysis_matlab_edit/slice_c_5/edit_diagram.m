clear
close all
clc

%% LOAD DATA
back = load('slice_c_5_backward.mat');
forw = load('slice_c_5_forward.mat');
lc   = load('H_LC_from_Hopf.mat');

x_back = back.x;  s_back = back.s;  f_back = back.f;
x_for  = forw.x;  s_for  = forw.s;  f_for  = forw.f;
x_lc   = lc.x;    s_lc   = lc.s;

LW = 0.6;

%% FIGURE
figure
ax = axes; hold(ax,'on')

%% EQUILIBRIUM BRANCHES: stability, eigenvalues in f
% (najprv nestabilné, potom stabilné = modrá navrchu)
plot_branch_by_eigs(x_back, f_back, ax, LW, 'unstable');
plot_branch_by_eigs(x_for , f_for , ax, LW, 'unstable');
plot_branch_by_eigs(x_back, f_back, ax, LW, 'stable');
plot_branch_by_eigs(x_for , f_for , ax, LW, 'stable');

%% LC ENVELOPE with stability

q_lc   = x_lc(804,:);
v_vals = x_lc(1:2:800,:);
v_min  = min(v_vals);
v_max  = max(v_vals);

mu1 = lc.f(102,:);
mu2 = lc.f(103,:);

% remove ~1 multiplicator
tol = 1e-3;

if mean(abs(mu1 - 1)) < mean(abs(mu2 - 1))
    mu = mu2;
else
    mu = mu1;
end

isStableLC = abs(mu) < 1;

% segmentation
st = double(isStableLC);
breaks = [1, find(diff(st)~=0)+1, numel(st)+1];

for b = 1:numel(breaks)-1
    idx = breaks(b):(breaks(b+1)-1);

    if st(idx(1)) == 1
        col = 'b';   % stable LC
    else
        col = 'r';   % unstable LC
    end

    plot(ax, q_lc(idx), v_min(idx), col, 'LineWidth', LW)
    plot(ax, q_lc(idx), v_max(idx), col, 'LineWidth', LW)
end

%% BIFURCATION POINTS (EQ)
plot_bif_points_eq(x_back, s_back)
plot_bif_points_eq(x_for , s_for )

%% BIFURCATION POINTS (LC) – upper part of envelope
for k = 1:length(s_lc)
    idx   = s_lc(k).index;
    label = strtrim(s_lc(k).label);
    if strcmp(label,'00') || strcmp(label,'99'), continue; end

    q_bif = x_lc(804,idx);
    v_bif = v_max(idx);

    plot(q_bif, v_bif,'r*','MarkerSize',6)
    text(q_bif*1.002, v_bif*1.002, label,'FontSize',10,'Color','k')
end

%% AXES
xlabel('$q^{*}$','Interpreter','latex','FontSize',14)
ylabel('$v$','Interpreter','latex','FontSize',14)
set(gca,'FontSize',11,'LineWidth',0.8)
ylim([-5,120])
box on
grid off

%% Export
% exportgraphics(gcf,'one_parametric_diagram.pdf','ContentType','vector')


%% ========= FUNCTIONS =========

function plot_branch_by_eigs(x_branch, f_branch, ax, lw, which)
    % x_branch: equilibrium branch (x(1,:)=v, x(3,:)=q*)
    % f_branch: eigenvalues stored by MatCont (rows = eigenvalues)
    q = x_branch(3,:);
    v = x_branch(1,:);

    % maximum real part of eigenvalues at each point
    maxRe = max(real(f_branch), [], 1);

    % treat zero as "unstable" only technically; segmentation requires a sign
    sgn = sign(maxRe);
    sgn(sgn==0) = 1;

    % stable if maxRe < 0
    isStablePoint = (maxRe < 0);
    st = double(isStablePoint);  % 1 = stable, 0 = unstable

    % segment the branch according to stability changes
    breaks = [1, find(diff(st)~=0)+1, numel(st)+1];

    for b = 1:numel(breaks)-1
        idx = breaks(b):(breaks(b+1)-1);
        isStableSeg = (st(idx(1)) == 1);

        if strcmp(which,'stable') && isStableSeg
            plot(ax, q(idx), v(idx), 'b', 'LineWidth', lw);
        elseif strcmp(which,'unstable') && ~isStableSeg
            plot(ax, q(idx), v(idx), 'r', 'LineWidth', lw);
        end
    end
end

function plot_bif_points_eq(x_branch, s_branch)
    for k = 1:length(s_branch)
        idx   = s_branch(k).index;
        label = strtrim(s_branch(k).label);
        if strcmp(label,'00') || strcmp(label,'99'), continue; end

        q_bif = x_branch(3,idx);
        v_bif = x_branch(1,idx);

        plot(q_bif, v_bif,'r*','MarkerSize',6)
        text(q_bif*1.002, v_bif*1.002, label,'FontSize',10,'Color','k')
    end
end