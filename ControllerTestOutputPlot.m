clc; close all

load('ControllerOutput1.mat', 'ScopeData')

time = ScopeData.time;
values = ScopeData.signals.values;
% Plot the data
%time_range = time <= 20;
figure(1)
plot(time, values(1:end, 1), '-r', time, values(1:end, 2), '-g');  % Plot the first set of values in red
xlabel('Time [second]');
ylabel('Positions [Degrees]');
title('Data Plot');
legend('Reference', 'Output');
grid on;

figure(2)
plot(time, values(1:end, 3), '-b');  % Plot the third set of values in blue
xlabel('Time [second]');
ylabel('Control [Degrees]');
title('Data Plot');
grid on;


