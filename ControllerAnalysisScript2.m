close all; clc;

% Load Controller Parameters
load('controller_params')

%% Time and Frequency Response

% Plant Transfer Fxn
plant_sys = ss(A, B, C, D, Ts);

fig = figure;
step(feedback(plant_sys, 1), 10)
grid
title('Time Response for Step Input (Plant without Controller)')
saveas(gcf,'ResponsePlots\TimeResponse_Plant.png'); 

fig = figure;
bodeplot(feedback(plant_sys, 1))
grid
title('Bode Plot for the system without controller')
saveas(gcf,'ResponsePlots\BodePlot_Plant.png'); 

%% Close Loop Transfer Fxn (Plant, Observer and P Controller)

A_est = A - M*C*A;
B_est = B - M*C*B;

A_p = [A, zeros(size(A));
    M*C*A, A_est - B_est*Kx];
B_p = [B; M*C*B];
C_p = [zeros(size(Kx)) Kx];
D_p = 0;

p_contr_sys = ss(A_p, B_p, C_p, D_p, Ts);

fig = figure;
step(feedback(p_contr_sys, 1), 10)
grid
title('Time Response for P controller without normalization')
saveas(gcf,'ResponsePlots\TimeResponse_P_Controller.png'); 

fig = figure;
bode(feedback(p_contr_sys, 1))
grid
title('Bode Plot for P controller without normalization')
saveas(gcf,'ResponsePlots\BodePlot_P_Controller.png'); 

%% Close Loop Transfer Fxn (Plant, Observer and P Controller with Norm)

A_pnorm = [A, -B*Kx;
    M*C*A, A_est - B_est*Kx - M*C*B*Kx];
B_pnorm = [B; B_est+M*C*B];
C_pnorm = [C, zeros(size(C))];
D_pnorm = 0;

pnorm_contr_sys = ss(A_pnorm, B_pnorm, C_pnorm, D_pnorm, Ts);

fig = figure;
step(Nbar*feedback(p_contr_sys, 1), 10)
grid
title('Time Response for P controller with normalization')
saveas(gcf,'ResponsePlots\TimeResponse_P_Controller_Norm.png'); 

fig = figure;
bode(Nbar*feedback(p_contr_sys, 1))
grid
title('Bode Plot for P controller with normalization')
saveas(gcf,'ResponsePlots\BodePlot_P_Controller_Norm.png'); 

%% Close Loop Transfer Fxn (Plant, Observer and PI Controller)

A_pi = [A, zeros(size(A)), zeros(n_states, 1);
    M*C*A-B_est*Ki_int*C, A_est - B_est*Kx_int, B_est*Ki_int;
    zeros(1, 2*n_states), 1];
B_pi = [B; M*C*B; 0];
C_pi = [Ki_int*C, Kx_int, -Ki_int];
D_pi = 0;

pi_contr_sys = ss(A_pi, B_pi, C_pi, D_pi, Ts);

fig = figure;
step(feedback(pi_contr_sys, 1), 10)
grid
title('Time Response for Step Input (Plant with PI Controller)')
saveas(gcf,'ResponsePlots\TimeResponse_PI_Controller.png'); 


fig = figure;
bode(feedback(pi_contr_sys, 1))
grid
title('Bode Plot for PI controller')
saveas(gcf,'ResponsePlots\BodePlot_PI_Controller.png'); 
