close all; clc;

% Load Controller Parameters
load('controller_params')

%% Close Loop Poles and Zeros

% Plant Transfer Fxn
C = zeros(size(C));
plant_sys = ss(A, B, C, D, Ts);

fig = figure;
rlocus(plant_sys)
sgrid
xlim([-1 1.5])
title('Root Locus')
saveas(gcf,'ResponsePlots\RootLocus.png'); 

%% Separation Principle

