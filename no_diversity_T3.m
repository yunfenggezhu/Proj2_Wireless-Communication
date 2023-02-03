%this function is for simulating SIMO under no diversity, which is SISO
function [BER] = no_diversity(SNR, N, sigma_h)

%---------------generate input signal X(k)---------------------------
Z = rand(1,N);
for k = 1:N
   if Z(k) > .5
       X(k) = 1;
   elseif Z(k) < .5
       X(k) = -1;
   end % if
end % k

%---------------generate rayleigh fading channel H-------------------
H = sigma_h.*(randn(1,N) + 1i.*randn(1,N)); % H forms complex Gaussian distribution

%---------------generate output signal Y(k) = HX + N-----------------
%---------------GENERATE NOISE N FIRST---------------------
for k = 1:length(SNR)   % generate noise variance
    sigma(k) = 10.^(-SNR(k)/20);
    n(k,:) = sqrt(sigma(k)^2/2).*(randn(1,N) + 1i.*randn(1,N)); % noise
    for l = 1:N
        Y(k, l) = X(l).* H(l) + n(k,l); % since the channel is not changing, only noise changes for different SNR
        Y_r(k, l) = Y(k, l) ./ abs(H(l)); % should eliminate the effect of fading channel
        % decoding
        if real(Y_r(k, l)) > 0
            R(k, l) = 1;
        elseif real(Y_r(k, l)) < 0
            R(k, l) = -1;
        end % if
    end % l
    difference(k,:) = R(k) - X;
    error(k) = length(find(difference(k))); % erros
end % k
BER = error / N; % ber

end % function