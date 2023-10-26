%zero_pot;

% Model Identification
A = [3.9879, -5.8186, 3.2254, 0.3447, -1.0312, 0.2918;
    1, 0, 0, 0, 0, 0;
    0, 1, 0, 0, 0, 0;
    0, 0, 1, 0, 0, 0;
    0, 0, 0, 1, 0, 0;
    0, 0, 0, 0, 1, 0];

B = [1, 0, 0, 0, 0, 0]';

C = 1e-3 * [-0.6242, 0.7542, -0.0716, 0, 0, 0];

D = 0;

Kp = 37.39;
Ke = -7.77;

x_init = zeros(6, 1);

% Control Law
Q = C' * C;
R = 1000;

if (rank(ctrb(A, B)) == 6) && (rank(obsv(A, C)) == 6)
    K = dlqr(A, B, Q, R);
end

% Kalman Gain
G = eye(6);
Qw = 1000 * eye(6);
Rv = 1;

M = dlqe(A, G, C, Qw, Rv);

% Computing N

N = inv( [A-eye(6, 6), B; C, 0] ) * [zeros(6, 1); 1];
Nx = N(1:6, :);
Nu = N(7, 1);

Nbar = Nu + K*Nx;