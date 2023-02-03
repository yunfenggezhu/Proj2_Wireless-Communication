clc;
clear;
%this code is for MIMO system beamforming
N = 100;
Mt = 4;
Mr = 4;
receive = [2 4];
sigma_h = sqrt(.5);
SNR = [-4:2:14];
monte = 1e4;

for run = 1:monte
    BER_MIMO(run,:) = MIMO_Beamforming(N, SNR, Mt, Mr, sigma_h);
    BER_NoDiversity(run,:) = no_diversity(SNR, N, sigma_h);
    BER_SC_2(run,:) = selection_combining(SNR, N, sigma_h, receive(1));
    BER_SC_4(run,:) = selection_combining(SNR, N, sigma_h, receive(2));
    BER_MRC_2(run,:) = MRC(SNR, N, sigma_h, receive(1));
    BER_MRC_4(run,:) = MRC(SNR, N, sigma_h, receive(2));
    BER_EGC_2(run,:) = EGC(SNR, N, sigma_h, receive(1));
    BER_EGC_4(run,:) = EGC(SNR, N, sigma_h, receive(2));
end

BER_MIMO_average = sum(BER_MIMO)./ monte;
BER_NoDiversity_Average = sum(BER_NoDiversity) / monte;
BER_SC_2_Average = sum(BER_SC_2) / monte;
BER_SC_4_Average = sum(BER_SC_4) / monte;
BER_MRC_2_Average = sum(BER_MRC_2) / monte;
BER_MRC_4_Average = sum(BER_MRC_4) / monte;
BER_EGC_2_Average = sum(BER_EGC_2) / monte;
BER_EGC_4_Average = sum(BER_EGC_4) / monte;

mimo = semilogy(SNR, BER_MIMO_average);
hold on;
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

title('Performance Comparison between MIMO and SIMO system');
legend([mimo, no, sc2, sc4, mrc2, mrc4, egc2, egc4], 'MIMO', 'No Diversity', 'SC-2Rx', 'SC-4Rx', 'MRC-2Rx', 'MRC-4Rx', 'EGC-2Rx', 'EGC-4Rx', 'Location', 'southeast');
xlabel('SNR(dB)');
ylabel('Error Bit Probability');
grid on;
