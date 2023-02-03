clc;
clear;
% This is for ploting the rayleigh fading channel
fc = 2e9; % frequence
N = 8;
duration = 2; % delay
v = [3 30 100]; % speed
for i = 1:3
    Small_Rayleigh(v(i), fc, N, duration);
    title('The channel amplitude |Z(t)| [dB] vs. time t');
    xlabel('time(s)');
    ylabel('|Z(t)| [dB]');
    grid on;
end % i