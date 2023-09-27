function kp = compute_potentiometer_constant(args)
%COMPUTE_KP Summary of this function goes here
%   Detailed explanation goes here

arguments
    args.plot_collected_data
    args.plot_selected_data
end

fig_num = 0;

% Load Parameters
load("1_potentiometer_constant.mat", 'tensao_pot')

% Read parameters from Struct
time_array = tensao_pot.time;
signal_mat = tensao_pot.signals.values;
Vs = signal_mat(1:end, 2); % Get the potentiometer values

% Plot the data gathered from lab
if args.plot_collected_data
    fig_num = fig_num + 1; % Setting figure number for plot
    
    % Plotting
    figure(fig_num)
    plot(time_array, Vs)

    % Plot readability
    title('Plot of Collected Data (for Potentiometer Constant calculation)')
    xlabel('Time [secs]')
    ylabel('Tensions [V]')
    xlim([0, 20])
end

angles = [0, -45, 45, 22.5, -22.5]';
angles_e = [Vs(1001), Vs(4001), Vs(8001), Vs(13001), Vs(18001)]';

% Fitting data using Linear Polynomial fitting
P = polyfit(angles_e, angles, 1);                          % Linear Fit

% Plot the selected data points
if args.plot_selected_data
    fig_num = fig_num + 1;

    figure(fig_num)
    scatter(angles, angles_e)
    hold on

    angles_fit = polyval(P, angles_e);
    plot(angles_fit, angles_e,'-r')

    title('Plot of Tensions against angles (Potentiometer Constant)')
    xlabel('Angles [deg]')
    ylabel('Tensions [V]')
    xticks(linspace(-45, 45, 5))
    xlim([-45, 45])

    hold off
    grid
end

% Getting the Kp
kp = P(1); % Kp is the value of the slope of the polynomial fit.

end

