% this function is for SIMO system under SC (2 reseive and 4 receive)
function [BER] = selection_combining(SNR, N, sigma_h, receive)
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
H = sigma_h.*(randn(receive,N) + 1i.*randn(receive,N)); % H forms complex Gaussian distribution
for s = 1:N
   norm_H(s) = norm(H(:,s));
end

%---------------generate output signal Y(k) = HX + N-----------------
%---------------GENERATE NOISE N FIRST---------------------
for k = 1:length(SNR)   % generate noise variance
    sigma(k) = 10.^(-SNR(k)/20);
    n(k,:) = sqrt(sigma(k)^2/2).*(randn(1,N) + 1i.*randn(1,N)); % noise
    for number = 1:N
        for c = 1:receive  %since we have several different channels
            Y(k, number, c) = X(number) * H(receive, number);
        end % c
        Y_r(k, number) = max(Y(k, number)) + n(k, number);  %pick the biggest one since it's SC
        Y_r(k, number) = Y_r(k, number) ./ norm_H(number);  %eliminate the effect of fading channel
        %decoding
        if real(Y_r(k, number)) > 0
            R(k, number) = 1;
        elseif real(Y_r(k, number)) < 0
            R(k, number) = -1;
        end % if
    end % number
    difference(k,:) = R(k) - X;
    error(k) = length(find(difference(k))); % errors
end % k
BER = error / N; % ber
 
end % k