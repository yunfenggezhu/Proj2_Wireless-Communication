% this function is for SIMO system under MRC (2 reseive and 4 receive)
function [BER] = MRC(SNR, N, sigma_h, receive)
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
   for t = 1:receive
      beta(t,s) = H(t,s)' ./norm_H(s); 
   end % t
end % s
%---------------generate output signal Y(k) = HX + N-----------------
%---------------GENERATE NOISE N FIRST---------------------
for k = 1:length(SNR)   % generate noise variance
    sigma(k) = 10.^(-SNR(k)/20);
    n(k,:) = sqrt(sigma(k)^2/2).*(randn(1,N) + 1i.*randn(1,N)); % noise
    for number = 1:N
       for c = 1:receive
          Y_channel(c, number) = X(number)*beta(c, number)*H(c, number) + n(k, number)*beta(c, number); % received signal
          Y_receive = sum(Y_channel);
       end % c
       Y(k, number) = Y_receive(number)./(norm_H(number)^2);
       if real(Y(k, number)) > 0
            R(k, number) = 1;
       elseif real(Y(k, number)) < 0
            R(k, number) = -1;
       end % if
    end % number
    %decoding
    difference(k,:) = R(k) - X;
    error(k) = length(find(difference(k))); % errors
end
BER = error / N; % ber
 
end % function