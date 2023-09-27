t = ScopeData.time;
sigs = ScopeData.signals.values;

utrend = sigs(:,1);

thetae = sigs(:,2);
alpha = sigs(:,3);

Kp = 36.790;
Ke = -1.301;
ytrend = thetae*Kp + alpha*Ke;

af = 0.8;
Afilt = [1, -af];
Bfilt = (1-af)*[1, -1];

yf = filter(Bfilt,Afilt,ytrend);

u = dtrend(utrend);

% view_io_structwtime;

z = [yf, u];
na = 4; nc = na;
nb = 2;
nk = 1;
nn = [na, nb, nc, nk];
th = armax(z, nn);

[den1, num1] = polydata(th);

yfsim = filter(num1, den1, u);

figure(1)
plot(t, yf, '-r', t, yfsim, '--g')
% range = 1000:4000
% plot(t(range), yf(range), '--r', t(range), yfsim(range), '-g')

error = sqrt( mean((yfsim - yf).^2) )

[num, den] = eqtflength(num1, conv(den1, [1, -1]))
[A, B, C, D] = tf2ss(num, den);