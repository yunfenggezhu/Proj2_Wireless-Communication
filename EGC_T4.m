% this function is for SIMO system under EGC (2 reseive and 4 receive)
function [BER] = EGC(SNR, N, sigma_h, receive)
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
theta = angle(H); % angle
re = cos(-theta);
im = sin(-theta);
beta =(re + 1i*im)./norm(H); %generate coefficent for different channel

%---------------generate output signal Y(k) = HX + N-----------------
%---------------GENERATE NOISE N FIRST---------------------
for k = 1:length(SNR)   % generate noise variance
    sigma(k) = 10.^(-SNR(k)/20);
    n(k,:) = sqrt(sigma(k)^2/2).*(randn(1,N) + 1i.*randn(1,N)); % noise
    for number = 1:N
       Y(k, number) = 0;
       for c = 1:receive  %since we have several different channels
           channel(c) = X(number) * H(receive, number) * beta(receive, number) + n(k, number) * beta(receive, number);
           Y(k, number) = channel(c) + Y(k, number); % received signals
       end 
    end
    % before decoding, we need to eliminate the effect of rayleigh fading
%     Y_r(k,:) = Y(k,:) ./mean(H);
    for m = 1:N
        if real(Y(k, m)) > 0
            R(k, m) = 1;
        elseif real(Y(k, m)) < 0
            R(k, m) = -1;
        end % if
    end % for
    %decoding
    difference(k,:) = R(k) - X;
    error(k) = length(find(difference(k))); % erros
end
BER = error / N; % ber
 
end % function