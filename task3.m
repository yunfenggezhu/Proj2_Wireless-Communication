% this code is for SIMO system
clc;
clear;
%----------parameters setting---------------
N = 100;
receive = [2 4]; % receive antennas
SNR = [-4:2:14]; % SNR range
sigma_h = sqrt(.5); % fading
monte = 1e4; % monte carlo runs

for run = 1:monte
    BER_NoDiversity(run,:) = no_diversity(SNR, N, sigma_h);
    BER_SC_2(run,:) = selection_combining(SNR, N, sigma_h, receive(1));
    BER_SC_4(run,:) = selection_combining(SNR, N, sigma_h, receive(2));
    BER_MRC_2(run,:) = MRC(SNR, N, sigma_h, receive(1));
    BER_MRC_4(run,:) = MRC(SNR, N, sigma_h, receive(2));
    BER_EGC_2(run,:) = EGC(SNR, N, sigma_h, receive(1));
    BER_EGC_4(run,:) = EGC(SNR, N, sigma_h, receive(2));
end % run
% --------- take the average value for monte carlo runs -----------
BER_NoDiversity_Average = sum(BER_NoDiversity) / monte;
BER_SC_2_Average = sum(BER_SC_2) / monte;
BER_SC_4_Average = sum(BER_SC_4) / monte;
BER_MRC_2_Average = sum(BER_MRC_2) / monte;
BER_MRC_4_Average = sum(BER_MRC_4) / monte;
BER_EGC_2_Average = sum(BER_EGC_2) / monte;
BER_EGC_4_Average = sum(BER_EGC_4) / monte;

figure;
no = semilogy(SNR, BER_NoDiversity_Average, 'go-');
hold on;
sc2 = semilogy(SNR, BER_SC_2_Average, 'ro:');
hold on;
sc4 = semilogy(SNR, BER_SC_4_Average, 'co-.', 'Linewidth', 1.5);
hold on;
mrc2 = semilogy(SNR, BER_MRC_2_Average, 'm+-');
hold on;
mrc4 = semilogy(SNR, BER_MRC_4_Average, 'yh:', 'Linewidth', 2);
hold on;
egc2 = semilogy(SNR, BER_EGC_2_Average, 'ks-');
hold on;
egc4 = semilogy(SNR, BER_EGC_4_Average, 'bp-');
title('Peformance of SIMO system under different diversity');
legend([no, sc2, sc4, mrc2, mrc4, egc2, egc4], 'No Diversity', 'SC-2Rx', 'SC-4Rx', 'MRC-2Rx', 'MRC-4Rx', 'EGC-2Rx', 'EGC-4Rx', 'Location', 'southwest');
xlabel('SNR(dB)');
ylabel('Error Bit Probability');
grid on;

