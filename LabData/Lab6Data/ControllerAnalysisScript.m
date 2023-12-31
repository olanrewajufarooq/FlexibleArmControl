close all; clc;

% Load Controller Parameters
load('controller_params')

% options = stepDataOptions('InputOffset', -1, 'Amplitude', 60);
options = stepDataOptions('Amplitude', 60);

%% Time and Frequency Response

% Plant Transfer Fxn
plant_sys = ss(A, B, C, D, Ts);

fig = figure;
pzmap(plant_sys)
grid
title('Close Loop Poles and Zeros for Plant without Controller')
savefig('ResponsePlots\ZerosPoles_Plant.fig')

fig = figure;
step(plant_sys, 10, options)
grid
title('Time Response for Step Input (Plant without Controller)')
savefig('ResponsePlots\TimeResponse_Plant.fig')

fig = figure;
dbode(A, B, C, D, Ts)
grid
title('Bode Plot for the Plant without Controller')
savefig('ResponsePlots\BodePlot_Plant.fig')

%% Close Loop Transfer Fxn (Plant, Observer and P Controller)

A_p = [A, -B*Kx;
    M*C*A, A - B*Kx - M*C*A];
B_p = [B; B];
C_p = [C, zeros(size(C))];
D_p = 0;

p_contr_sys = ss(A_p, B_p, C_p, D_p, Ts);

fig = figure;
pzmap(p_contr_sys)
grid
title('Close Loop Poles and Zeros for Plant with P Controller')
savefig('ResponsePlots\ZerosPoles_P_Controller.fig')

fig = figure;
step(p_contr_sys, 10, options)
grid
title('Time Response for Step Input (Plant with P Controller)')
savefig('ResponsePlots\TimeResponse_P_Controller.fig')

fig = figure;
dbode(A_p, B_p, C_p, D_p, Ts)
grid
title('Bode Plot for P controller without normalization')
savefig('ResponsePlots\BodePlot_P_Controller.fig')

%% Close Loop Transfer Fxn (Plant, Observer and P Controller with Norm)

A_pnorm = [A, -B*Kx;
    M*C*A, A - B*Kx - M*C*A];
B_pnorm = [B*Nbar; B*Nbar];
C_pnorm = [C, zeros(size(C))];
D_pnorm = 0;

pnorm_contr_sys = ss(A_pnorm, B_pnorm, C_pnorm, D_pnorm, Ts);

fig = figure;
pzmap(pnorm_contr_sys)
grid
title('Close Loop Poles and Zeros for Plant with Normalized P Controller')
savefig('ResponsePlots\ZerosPoles_P_Controller_Norm.fig')

fig = figure;
step(pnorm_contr_sys, 10, options)
grid
title('Time Response for Step Input (Plant with P Controller with Normalization)')
savefig('ResponsePlots\TimeResponse_P_Controller_Norm.fig')

fig = figure;
dbode(A_pnorm, B_pnorm, C_pnorm, D_pnorm, Ts)
grid
title('Bode Plot for P controller with normalization')
savefig('ResponsePlots\BodePlot_P_Controller_Norm.fig')

%% Close Loop Transfer Fxn (Plant, Observer and PI Controller)

A_pi = [A - B*Ki_int*C, -B*Kx_int;
    M*C*A - B*Ki_int*C, A - B*Kx_int - M*C*A];
B_pi = [B*Ki_int; B*Ki_int];
C_pi = [C, zeros(size(C))];
D_pi = 0;

pi_contr_sys = ss(A_pi, B_pi, C_pi, D_pi, Ts);

fig = figure;
pzmap(pi_contr_sys)
grid
title('Close Loop Poles and Zeros for Plant with PI Controller')
savefig('ResponsePlots\ZerosPoles_PI_Controller.fig')

fig = figure;
step(pi_contr_sys, 10, options)
grid
title('Time Response for Step Input (Plant with PI Controller)')
savefig('ResponsePlots\TimeResponse_PI_Controller.fig')

fig = figure;
dbode(A_pi, B_pi, C_pi, D_pi, Ts)
grid
title('Bode Plot for PI controller')
savefig('ResponsePlots\BodePlot_PI_Controller.fig')

%% Checking for Separation Principle
