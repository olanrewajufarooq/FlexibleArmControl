function kb = compute_strain_constant(args)
%COMPUTE_STRING_CONSTANT Summary of this function goes here
%   Detailed explanation goes here
arguments
    args.plot_collected_data
    args.plot_selected_data
end


%% Load Parameters
load("1_strain_constant.mat", 'tensao_pot')

% Read parameters from Struct
time_array = tensao_pot.time;
signal_mat = tensao_pot.signals.values;
Vs = signal_mat(1:end, 3); % Get the strain gauge values

%% Plot the data gathered from lab
if args.plot_collected_data
    
    % Plotting
    figure()
    plot(time_array, Vs)

    % Plot readability
    title('Plot of Collected Data (for Deflection Constant calculation)')
    xlabel('Time [secs]')
    ylabel('Tensions [V]')
    xlim([0, 30])
end

%% Obtaining deflection angles
Ds = linspace(1.75, -2.25, 15)'; % Estimating the deflection lengths
L = 16; % Length of the bar 
thetas_rads = Ds / L; % Deflection in Radiants
thetas = 180/pi * thetas_rads; % Deflection in degrees

thetas_e = [Vs(691), Vs(2500), Vs(4500), Vs(5800), Vs(7300),... 
    Vs(8700), Vs(10100), Vs(11500), Vs(13200), Vs(15100),...
    Vs(18800), Vs(23000), Vs(25200), Vs(26600), Vs(29400)]'; % Tensions estimated

% Fitting data using Linear Polynomial fitting
P = polyfit(thetas_e, thetas, 1);                          % Linear Fit

%% Plot the selected data points
if args.plot_selected_data

    figure()
    scatter(thetas, thetas_e)
    hold on

    thetas_fit = polyval(P, thetas_e);
    plot(thetas_fit, thetas_e,'-r')

    title('Plot of Tensions against angles (Deflection Constant)')
    xlabel('Angles [deg]')
    ylabel('Tensions [V]')
    %xticks(linspace(-45, 45, 5))
    %xlim([-45, 45])

    hold off
    grid
end

%% Getting the Kb constant
kb = P(1); % Kb is the value of the slope of the polynomial fit.

end