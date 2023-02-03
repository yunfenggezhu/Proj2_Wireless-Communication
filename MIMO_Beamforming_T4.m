function [BER] = MIMO_Beamforming(N, SNR, Mt, Mr, sigma_h)
%--------------------------------generate X(k)-----------------------------------
Z = rand(1,N);

for k = 1:N
   if Z(k) > .5
       X(k) = 1;
   elseif Z(k) < .5
       X(k) = -1;
   end % if 
end % k

%-------------------generate rayleigh fading channel --------------------
for snr = 1:length(SNR)
   sigma(snr) = 10.^(-SNR(snr)/20);
   n(snr, :) = sqrt(sigma(snr)^2/2)*(randn(1,N)+1i*randn(1,N)); % noise
   for k = 1:N
      H = sigma_h*randn(Mt, Mr)+sigma_h*1i*randn(Mt, Mr);   %generate rayleigh fading channel
      [U, S, V]= svd(H);
      Y(snr, k) = X(k) * S(1,1) + n(snr, k); % received signals
      Y_r(snr, k) = Y(snr, k) / S(1, 1);  % eliminate the effect of rayleigh fading
      if real(Y_r(snr, k)) > 0
          R(snr, k) = 1;
      elseif real(Y_r(snr, k)) < 0
          R(snr, k) = -1;
      end % if
   end % k
   %decoding 
   diff(snr,:) = R(snr) - X;
   error(snr) = length(find(diff(snr))); % errors
end
BER = error / N;

end % function