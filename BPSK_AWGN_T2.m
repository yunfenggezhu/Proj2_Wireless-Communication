%-----------this is for BPSK in AWGN channel and Rayleigh Fading----Channel
clc;
clear;
SNR = [-4:2:14]; %we set Es= 1
sigma_AWGN = 10.^(-SNR/20);
sigma_Rayleigh = sqrt(.5);
N = 100;
monte = 1e4; % how many monte carlo runs we want
Z = rand(1,N);

%---------------AWGN channel part(simulation)---------------
for r = 1:monte     %------------n turns to smooth the curve
        %--------generate noise part---it can be used in both AWGN and rayleigh fading
    for k = 1:length(SNR)
        n(r, k,:) = sqrt(sigma_AWGN(k)^2/2).*randn(1,N) + 1i.*sqrt(sigma_AWGN(k)^2/2).*randn(1,N); % noise
    end % k

    %--------GENERATE X(K) PART--it can be used in both AWGN and rayleigh
    %fading, everytimes X(k) must be different
    for sk = 1:N
       if Z(sk) > .5
           X(r, sk) = 1;
       elseif Z(sk) < .5
           X(r, sk) = -1;
       end % if
    end % sk
    for m = 1:length(SNR)      %------------m SNR situation compute BER
        error(r, m) = 0;
        for on = 1:N            %------------n symbols
            Y(r, m, on) = X(r, on) + n(r, m, on);
            if real(Y(r, m, on)) > 0 && X(r, on) == -1   % check if it is right
                error(r, m) = error(r, m) + 1;
            elseif real(Y(r, m, on)) < 0 && X(r, on) == 1
                error(r, m) = error(r, m) + 1;
            end % if
        end% on
        BER(r, m) = error(r, m) / N;    %BER for every monte run
    end % m
end % r every monte realization
Monte_BER = sum(BER) / monte; % avg ber

%-------------AWGN & Rayleigh fading  theoretical BER---------------------
for h = 1:length(SNR)
   gamma(h) = 10.^(SNR(h)/10); % SNR in linear domain
   theoretical_BER(h) = qfunc(sqrt(2*gamma(h)));   %AWGN theoretical value
   theoretical_BER_rf(h) = 1 / (4*gamma(h));       %Rayleighfading theoretical value
end % h

%this part is for rayleigh fading simulation---------------------
for ss = 1:monte
    BER_rayleigh(ss,:) = RayleighResult(N);
end % ss
Monte_BER_rf = mean(BER_rayleigh);

ta = semilogy(SNR, theoretical_BER,'r*:');
hold on;
sa = semilogy(SNR, Monte_BER, 'md--', 'LineWidth', 1.5);
hold on;
tr = semilogy(SNR, theoretical_BER_rf, 'b^-.');
hold on;
sr = semilogy(SNR, Monte_BER_rf, 'c+:', 'LineWidth', 1.5);
xlabel('SNR[dB]')
ylabel('Error Bit Probability');
title('Performance comparison between AWGN channel and Rayleigh fast fading channel.');
legend([ta, sa, tr, sr], 'AWGN theo-value', 'AWGN simu-value', 'Rayleigh Fading theo-value',...
    'Rayleigh Fading simu-value', 'Location', 'southwest');
grid on;
