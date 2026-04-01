clear
close all
clc

%% LOAD EQUILIBRIA

back = load('slice_q_star_c_20_backward.mat');
forw = load('slice_q_star_c_20_forward.mat');

x_back = back.x;  s_back = back.s;  f_back = back.f;
x_for  = forw.x;  s_for  = forw.s;  f_for  = forw.f;

%% LOAD LIMIT CYCLES (two branches)

lc1 = load('H_LC_1.mat');
lc2 = load('LPC_LC_2.mat');

LW = 0.8;

%% FIGURE

figure
ax = axes; hold(ax,'on')

%% EQUILIBRIUM BRANCHES

plot_branch_by_eigs(x_back, f_back, ax, LW, 'unstable');
plot_branch_by_eigs(x_for , f_for , ax, LW, 'unstable');
plot_branch_by_eigs(x_back, f_back, ax, LW, 'stable');
plot_branch_by_eigs(x_for , f_for , ax, LW, 'stable');

%% LIMIT CYCLES (two branches)

plot_lc_envelope(lc1, ax, LW);
plot_lc_envelope(lc2, ax, LW);

%% BIFURCATION POINTS (equilibria)

plot_bif_points_eq(x_back, s_back)
plot_bif_points_eq(x_for , s_for )

%% AXES

xlabel('$q^{*}$','Interpreter','latex','FontSize',14)
ylabel('$v$','Interpreter','latex','FontSize',14)

set(ax,'FontSize',11,'LineWidth',0.8)
box(ax,'on')
grid(ax,'off')

% Optional zoom:
% xlim([2448 2470])
% ylim([-5 120])

% exportgraphics(gcf,'2D_c20_corrected.pdf','ContentType','vector')

%% FUNCTIONS

function plot_branch_by_eigs(x_branch, f_branch, ax, lw, which)

    % extract variables (v and q*)
    q = x_branch(3,:);
    v = x_branch(1,:);

    % maximum real part of eigenvalues at each point
    maxRe = max(real(f_branch), [], 1);

    % stability condition
    isStable = (maxRe < 0);
    st = double(isStable);

    % split into segments where stability changes
    breaks = [1, find(diff(st)~=0)+1, numel(st)+1];

    for b = 1:numel(breaks)-1
        idx = breaks(b):(breaks(b+1)-1);
        stableSeg = (st(idx(1)) == 1);

        if strcmp(which,'stable') && stableSeg
            plot(ax, q(idx), v(idx), 'b', 'LineWidth', lw);
        elseif strcmp(which,'unstable') && ~stableSeg
            plot(ax, q(idx), v(idx), 'r', 'LineWidth', lw);
        end
    end
end


function plot_lc_envelope(lc, ax, lw)

    x_lc = lc.x;
    f_lc = lc.f;
    s_lc = lc.s;

    % ====== PARAMETER ROW (here q* corresponds to row 804) ======
    qRow = 804;
    q_lc = x_lc(qRow,:);

    % ====== v values along the mesh (2D system, 400 points) ======
    v_vals = x_lc(1:2:800,:);
    v_min = min(v_vals, [], 1);
    v_max = max(v_vals, [], 1);

    % ====== FLOQUET MULTIPLIERS ======
    mu1 = f_lc(end-1,:);
    mu2 = f_lc(end,:);

    % distance from 1 at each point
    d1 = abs(mu1 - 1);
    d2 = abs(mu2 - 1);

    % select the nontrivial multiplier (further from 1)
    use2 = d2 > d1;

    mu = mu1;
    mu(use2) = mu2(use2);

    % stability condition
    isStableLC = abs(mu) < 1;
    st = double(isStableLC);

    % segment according to stability changes
    breaks = [1, find(diff(st)~=0)+1, numel(st)+1];

    % plot unstable first, then stable (so stable is on top)
    for pass = 1:2

        for b = 1:numel(breaks)-1
            idx = breaks(b):(breaks(b+1)-1);
            stableSeg = (st(idx(1)) == 1);

            if pass==1 && stableSeg
                continue
            end
            if pass==2 && ~stableSeg
                continue
            end

            if stableSeg
                col = 'b';
            else
                col = 'r';
            end

            plot(ax, q_lc(idx), v_min(idx), col, 'LineWidth', lw)
            plot(ax, q_lc(idx), v_max(idx), col, 'LineWidth', lw)
        end
    end

    % LC bifurcation points (plotted on upper envelope)
    for k = 1:length(s_lc)

        idx = s_lc(k).index;
        label = strtrim(s_lc(k).label);

        if strcmp(label,'00') || strcmp(label,'99')
            continue
        end

        plot(ax, q_lc(idx), v_max(idx),'r*','MarkerSize',6)
        text(ax, q_lc(idx)*1.002, v_max(idx)*1.002,...
             label,'FontSize',10,'Color','k')
    end
end


function plot_bif_points_eq(x_branch, s_branch)

    for k = 1:length(s_branch)

        idx   = s_branch(k).index;
        label = strtrim(s_branch(k).label);

        if strcmp(label,'00') || strcmp(label,'99')
            continue
        end

        q_bif = x_branch(3,idx);
        v_bif = x_branch(1,idx);

        plot(q_bif, v_bif,'r*','MarkerSize',6)
        text(q_bif*1.002, v_bif*1.002,...
             label,'FontSize',10,'Color','k')
    end
end