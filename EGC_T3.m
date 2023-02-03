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

for s = 1:receive
   for t = 1:N
      theta(s, t) = atan(imag(H(s, t))./real(H(s, t)));  % angle
      beta(s, t) = cos(theta(s, t)) - 1i*sin(theta(s, t));
      norm_H(t) = norm(H(:,t));
   end % t
end % s

%---------------generate output signal Y(k) = HX + N-----------------
%---------------GENERATE NOISE N FIRST---------------------
for k = 1:length(SNR)   % generate noise variance
    sigma(k) = 10.^(-SNR(k)/20);
    n(k,:) = sqrt(sigma(k)^2/2).*(randn(1,N) + 1i.*randn(1,N)); % noise
    for number = 1:N
       for c = 1:receive  %since we have several different channels
          Y_channel(c, number) = X(number)*beta(c, number)*H(c, number) + n(k, number)*beta(c, number); % channels
          Y_receive = sum(Y_channel);
       end %c
       Y(k, number) = Y_receive(number)./norm_H(number);
       if real(Y(k, number)) > 0
            R(k, number) = 1;
       elseif real(Y(k, number)) < 0
            R(k, number) = -1;
       end % if
    end % number
 
    %decoding
    difference(k,:) = R(k) - X; % errors
    error(k) = length(find(difference(k))); % error nums
end % k
BER = error / N; % Ber

end % function