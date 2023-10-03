% SCRIPT TO COMPUTE STRAIN AND POTENTIOMETER CONSTANTS

% Computing Potentiometer Constant
kp = compute_potentiometer_constant('plot_collected_data', false, 'plot_selected_data', false);

% Computing the String Constant
kb = compute_strain_constant('plot_collected_data', false, 'plot_selected_data', false);