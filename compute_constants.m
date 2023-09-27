% SCRIPT TO COMPUTE STRAIN AND POTENTIOMETER CONSTANTS
clear; clc; close all

% Computing Potentiometer Constant
kp = compute_potentiometer_constant('plot_collected_data', false, 'plot_selected_data', false);

