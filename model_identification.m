%% Model Identification Script
clear; clc; close all

% Compute the potentiometer and strain constants
compute_constants;
plot_plant_data = true;

filenames=dir('ModelIdentificationData\*.mat');

for file_id = 1:length(filenames)
    load(['ModelIdentificationData\' filenames(file_id).name], 'ScopeData')

    % Getting the input amplitude and frequency
    filename = split(filenames(file_id).name, '.'); filename_orig = filename{1};
    filename = split(filename_orig, '_');

    amp = split(filename{3}, 'a'); amp = amp{2};
    amp = str2num(amp)/10;

    freq = split(filename{4}, 'f'); freq = freq{2};
    freq = str2num(freq)/10;

    % Load Time and Signal Values from Scope Data
    t = ScopeData.time;
    sigs = ScopeData.signals.values;
    clear ScopeData

    % Removing the first 5 seconds from the data (using array masking)
    time_array = t(t>=5);
    signal_array = sigs(t>=5, :);
    clear t sigs

    % Signal Data
    utrend = signal_array(:, 1); % Motor Excitation Signals
    thetae = signal_array(:, 2); % Potentiometer Signals
    alphae = signal_array(:, 3); % Strain Gage Signals

    % Estimating bar tip position
    ytrend = kp*thetae + kb*alphae;

    % Plot the u, y and alpha
    if plot_plant_data
        figure(file_id)
        subplot(3,1,1)
        plot(time_array,utrend)
        xlabel('Time [secs]')
        ylabel('u [V]')
    
        subplot(3,1,2)
        plot(time_array,thetae)
        xlabel('Time [secs]')
        ylabel('y [V]')
    
        subplot(3,1,3)
        plot(time_array,alphae)
        xlabel('Time [secs]')
        ylabel('alpha [V]')

        savefig(['ModelIdentificationPlots\' filename_orig])
    end

    







end
clear filenames file_id
