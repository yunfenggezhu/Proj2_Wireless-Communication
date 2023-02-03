%---------task 1 is for simulating rayleigh flat fading--------------
function [Ez, Z] = Small_Rayleigh(v, fc, N, duration)
%setting parameter
% v= 3;
% fc = 2e9;
% N = 10;
% duration = 2;
T = 1000;
ss = 1/T;
c = 3e8; % light speed
factor = 1000/3600; % for transfering speed from km/h to m/s
fd = fc*v.*factor/c; %doppler frequency
beta = sqrt(1/N);  % gain for every path
phi = 2 * pi.* rand(1,N);
t = 0:ss:duration;

%generate rayleigh distribution z(t)
for m = 1:N
    theta(m) = 2*pi*m/N;
    for n = 1:length(t)
        phi_n(m, n) = -2*pi*fd*t(n)*cos(theta(m)) + phi(m);  % angle
        z(m,n) = beta*exp(1j*phi_n(m,n)); % channel vector
    end % n
end % m
Ez = sum(z); % expectation
Z = 10*log10(abs(sum(z))); % transfor to dB domain
figure;
plot(t, Z);
end % function


