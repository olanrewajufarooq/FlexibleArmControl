close all; clc;

% Load Controller Parameters
load('controller_params')
see_plots = true;

% options = stepDataOptions('InputOffset', -1, 'Amplitude', 60);
options = stepDataOptions('Amplitude', 60);

%% Time and Frequency Response

% Plant Transfer Fxn
plant_sys = ss(A, B, C, D, Ts);

fig = figure;
step(plant_sys, 10, options)
grid
title('Time Response for Step Input (Plant without Controller)')
savefig('ResponsePlots\TimeResponse_Plant.fig')
set(fig, 'visible', see_plots);

fig = figure;
bodeplot(plant_sys)
grid
title('Bode Plot for the system without controller')
savefig('ResponsePlots\BodePlot_Plant.fig')
set(fig, 'visible', see_plots);

%% Close Loop Transfer Fxn (Plant, Observer and P Controller)

A_p = [A, -B*Kx;
    M*C*A, A - B*Kx - M*C*A];
B_p = zeros(2*n_states, n_contrs);
C_p = [C, zeros(size(C))];
D_p = 0;

p_contr_sys = ss(A_p, B_p, C_p, D_p, Ts);

fig = figure;
step(p_contr_sys, 10)
grid
title('Time Response for Step Input (Plant with P Controller)')
savefig('ResponsePlots\TimeResponse_P_Controller.fig')
set(fig, 'visible', see_plots);

fig = figure;
bode(p_contr_sys)
grid
title('Bode Plot for P controller without normalization')
savefig('ResponsePlots\BodePlot_P_Controller.fig')
set(fig, 'visible', see_plots);

%% Close Loop Transfer Fxn (Plant, Observer and P Controller with Norm)

A_pnorm = [A, -B*Kx;
    M*C*A, A - B*Kx - M*C*A];
B_pnorm = [B*Nbar; B*Nbar];
C_pnorm = [C, zeros(size(C))];
D_pnorm = 0;

pnorm_contr_sys = ss(A_pnorm, B_pnorm, C_pnorm, D_pnorm, Ts);

fig = figure;
step(pnorm_contr_sys, 10, options)
grid
title('Time Response for Step Input (Plant with P Controller with Normalization)')
savefig('ResponsePlots\TimeResponse_P_Controller_Norm.fig')
set(fig, 'visible', see_plots);

fig = figure;
bode(pnorm_contr_sys)
grid
title('Bode Plot for P controller with normalization')
savefig('ResponsePlots\BodePlot_P_Controller_Norm.fig')
set(fig, 'visible', see_plots);

%% Close Loop Transfer Fxn (Plant, Observer and PI Controller)

A_pi = [A - B*Ki_int*C, -B*Kx_int;
    M*C*A - B*Ki_int*C, A - B*Kx_int - M*C*A];
B_pi = [B*Ki_int; B*Ki_int];
C_pi = [C, zeros(size(C))];
D_pi = 0;

pi_contr_sys = ss(A_pi, B_pi, C_pi, D_pi, Ts);

fig = figure;
step(feedback(pi_contr_sys, 1), 10, options)
grid
title('Time Response for Step Input (Plant with PI Controller)')
savefig('ResponsePlots\TimeResponse_PI_Controller.fig')
set(fig, 'visible', see_plots);

fig = figure;
bode(pi_contr_sys)
grid
title('Bode Plot for PI controller')
savefig('ResponsePlots\BodePlot_PI_Controller.fig')
set(fig, 'visible', see_plots);

%% Checking for Separation Principle
