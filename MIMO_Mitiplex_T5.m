% this code is for simulating MIMO system under multiplexing. 
function [BER, Rate, Capacity] = MIMO_Mitiplex(SNR, N, Mt, Mr, sigma_h)
%--------------------------------generate X(k)-----------------------------------
Z = rand(1,N);

for k = 1:N
   if Z(k) > .5
       X(k) = 1;
   elseif Z(k) < .5
       X(k) = -1;
   end % if
end % k

cell_noise = cell(length(SNR),1);
cell_channel = cell(1,N);  %since channel is not changing for different SNR
cell_precoding = cell(1,N);   % matrix of U
cell_Sigma = cell(1,N);      %matrix of Sigma  svd of H
cell_decoding = cell(1,N);   %matrix of V^H
%----------------generate rayleigh fading channel----------------------
for snr = 1:length(SNR)
   sigma(snr) = 10.^(-SNR(snr)/20);
   cell_noise{snr,1} = sqrt(sigma(snr)^2/2)*(randn(Mr,N)+1i*randn(Mr,N)); % noise
   for k = 1:N
      cell_channel{k} = sigma_h*randn(Mt, Mr)+sigma_h*1i*randn(Mt, Mr); % channel 
      [cell_precoding{k}, cell_Sigma{k}, cell_decoding{k}]= svd(cell_channel{k}); % find the eigen values
      rk_H(k) = length(find(cell_Sigma{k}));
      gamma1 = cell_Sigma{k}(1,1)^2 / sigma(snr)^2; 
      gamma2 = cell_Sigma{k}(2,2)^2 / sigma(snr)^2; 
      gamma3 = cell_Sigma{k}(3,3)^2 / sigma(snr)^2; 
      gamma4 = cell_Sigma{k}(4,4)^2 / sigma(snr)^2; 
      gamma_i(k, :) = [gamma1 gamma2 gamma3 gamma4];
      if rk_H(k) == 4
          right(k) = 1 + 1/gamma_i(k,1) + 1/gamma_i(k,2) + 1/gamma_i(k,3) + 1/gamma_i(k,4); % correct 
          gamma_0(k) = 4 / right(k);
          if gamma_0(k) < gamma_i(k,4)
              gamma(k) = gamma_0(k); 
          elseif gamma_0(k) > gamma_i(k,4)
              right(k) = 1 + 1/gamma_i(k,1) + 1/gamma_i(k,2) + 1/gamma_i(k,3);
              gamma_0(k) = 3 / right(k);
              if gamma_0(k) < gamma_i(k,3)
                  gamma(k) = gamma_0(k);
              elseif gamma_0(k) > gamma_i(k,3)
                  right(k) = 1 + 1/gamma_i(k,1) + 1/gamma_i(k,2);
                  gamma_0(k) = 2 / right(k);
                  if gamma_0(k) < gamma_i(k,2)
                      gamma(k) = gamma_0(k);
                  elseif gamma_0(k) > gamma_i(k,2)
                      gamma(k) = gamma_i(k,1);
                  end % if
              end % if
          end % if
      elseif rk_H(k) == 3
          right(k) = 1 + 1/gamma_i(k,1) + 1/gamma_i(k,2) + 1/gamma_i(k,3);
          gamma_0(k) = 3 / right(k);
          if gamma_0(k) < gamma_i(k,3)
              gamma(k) = gamma_0(k);
          elseif gamma_0(k) > gamma_i(k,3)
              right(k) = 1 + 1/gamma_i(k,1) + 1/gamma_i(k,2);
              gamma_0(k) = 2 / gamma_i(k,2);
              if gamma_0(k) < gamma_i(k,2)
                  gamma(k) = gamma_0(k);
              elseif gamma_0(k) > gamma_i(k,2)
                  gamma(k) = gamma_i(k,1);
              end % if
          end % if  
      elseif rk_H(k) == 2
          right(k) = 1 + 1/gamma_i(k,1) + 1/gamma_i(k,2);
          gamma_0(k) = 2 / right(k);
          if gamma_0(k) < gamma_i(k,2)
              gamma(k) = gamma_0(k);
          elseif gamma_0(k) > gamma_i(k,2)
              gamma(k) = gamma_i(k,1);
          end % if
      elseif rk_H(k) == 1
          gamma(k) = gamma_i(k,1);
      end % if
      for rr = 1:rk_H(k)
         coefficent(k, rr) = 1/gamma(k) - 1/gamma_i(k, rr); 
         if coefficent(k, rr) < 0
             coefficent(k, rr) = 0;
         end % if
      end % rr
      rate(snr,k) = length(find(coefficent(k,:)));
      X_tutar = X(k)*(transpose(coefficent(k,:)));
      n = cell_noise{snr,1};
      n_bar(:, k) = n(:,k).*(transpose(coefficent(k,:)));  %n will change depend on different channel
      Y = cell_Sigma{k}*X_tutar + cell_precoding{k}'* n_bar(:,k);   %Y = Sigma*X_precode + N*shifting
      Y_r(snr, k) = sum(Y);
%       R(snr, k) = Y_r(snr, k);
      R(snr, k) = Y_r(snr, k) / norm(cell_channel{k});
      RateDiversity(snr, k) = (Mt - rate(snr,k))*(Mr - rate(snr, k));
      %Capacity part
      C(snr,k) = 0;
      for cc = 1:rate(snr,k)
         C(snr,k) = log(1+gamma_i(k,cc)/gamma(k)) + C(snr,k); % compute the capacity
      end % cc
      %decoding 
      if real(R(snr, k)) > 0
          Y_hat(snr, k) = 1;
      elseif real(R(snr, k)) < 0
          Y_hat(snr, k) = -1;
      end % if
   end % k
   diff(snr,:) = Y_hat(snr) - X;
   error(snr) = length(find(diff(snr)));
end
BER = error / N; % ber
Rate = transpose(mean(RateDiversity,2));
Capacity = transpose(mean(C,2));
end % functions