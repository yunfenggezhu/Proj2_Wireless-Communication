%this code for MIMO system under mulplexing gain
clc;
clear;
%-------------------parameters setting------------------------
N = 100;
Mt = 4;
Mr = 4;
sigma_h = sqrt(.5); % raileigh fading
SNR = [-4:2:14]; % SNR range
monte = 1e4;

for run = 1:monte
   [BER_MIMO_Multi(run,:),Rate_MIMO_Multi(run,:), Capacity_MIMO_Multi(run,:)] = MIMO_Mitiplex(SNR, N, Mt, Mr, sigma_h);
end % run
% take avg value over monte carlo runs
BER_MIMO_Multi_average = sum(BER_MIMO_Multi)./ monte;
Rate_MIMO_Multi_average = sum(Rate_MIMO_Multi)./monte;
Capacity_MIMO_Multi_average = sum(Capacity_MIMO_Multi)./monte;

figure;
semilogy(SNR, BER_MIMO_Multi_average);
title('Performance for MIMO Multiplexing of BER over SNR(dB)');
xlabel('SNR(dB)');
ylabel('Error Bit Probability');
grid on;
figure;
plot(SNR, Rate_MIMO_Multi_average);
title('Sum-Rate for MIMO Multiplexing of MIMO channels over SNR(dB)');
xlabel('SNR(dB)');
ylabel('MIMO channels');
grid on;
figure;
plot(SNR, Capacity_MIMO_Multi_average);
title('Capacity for MIMO Multiplexing of MIMO channels over SNR(dB)');
xlabel('SNR(dB)');
ylabel('Capacity');
grid on;