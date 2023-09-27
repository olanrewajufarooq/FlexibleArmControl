% angles = [0, 45, -45, -22.5, 22.5]';
% voltage = [1.9043, 0.7324, 3.1787, 2.5781, 1.4844]';

angles = [-45, 45]';
voltage = [0.7324, 3.1787]';

kp = (angles(2) - angles(1)) / (voltage(2) - voltage(1))