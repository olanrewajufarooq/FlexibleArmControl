clear; close all; clc

% zero_pot;

% Load Model Identification Parameters
load('model_params', 'A', 'B', 'C', 'D', 'num', 'den', 'kb', 'kp')

[n_states, n_contrs] = size(B);
[n_outputs, ~] = size(C);

% Initializing Current Observer
x_init = zeros(n_states, 1);

Ts = 0.001;

if (rank(ctrb(A, B)) == n_states) && (rank(obsv(A, C)) == n_states)
    % Control Law
    Q = C' * C;
    R = 1000;

    Kx = dlqr(A, B, Q, R)


    % Kalman Gain
    G = eye(n_states);
    Qw = 200 * eye(6);
    Rv = 10;
    
    M = dlqe(A, G, C, Qw, Rv);
    
    % Computing N
    
    N = inv( [A-eye(n_states, n_states), B; C, 0] ) * [zeros(n_states, 1); 1];
    Nx = N(1:6, :);
    Nu = N(7, 1);
    
    Nbar = Nu + Kx*Nx;

    % Computing Parameters for the Integrator
    A_aug = [A, zeros(n_states, 1); -C, 1];
    B_aug = [B; 0];
    
    Q_integrator = 100*1e-7;
    Q_aug = [Q, zeros(n_states, 1); zeros(1, n_states), Q_integrator];

    R_aug = 10000;
    
    K_with_integrator = dlqr(A_aug, B_aug, Q_aug, R_aug)
    Kx_int = K_with_integrator(1:n_states);
    Ki_int = K_with_integrator(n_states+1);

else
    disp('Plant Not Controllable')
end