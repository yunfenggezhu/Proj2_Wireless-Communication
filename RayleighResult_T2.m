function [simu_ber] = RayleighResult(N)
SNR=-4:2:14; % SNR range
s=rand(1,N)>0.5; % random number in [0, 1]
bit=2.*s-1; % change it to binary symbols
dff=[1,length(SNR)];
for i = 1:length(SNR)
    n=1/sqrt(2).*(randn(1,N)+1i.*randn(1,N)); % noise
    h=1/sqrt(2).*(randn(1,N)+1i.*randn(1,N)); % channel vectors
    y=h.*bit+n.*10^(-SNR(i)/20); % received signal
    
    %%*************ML detector**********%
    y_r=y./h;
    %%********judge
    y_r=real(y_r)>0;%if > 0, then y = 1, if y < 0, then y = -1
    
    dff(i)=size(find([s-y_r]),2); % error nums
end % i
simu_ber=dff/N; % error bit prob

end % function