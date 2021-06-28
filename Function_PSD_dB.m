function [Sx, f] = Function_PSD_dB(x, fs, M)

x = x(:);           % Column vector
N = length(x);      % Number of data points

freq_range = [0  fs/2];  % Frequency range for plotting

if (nargin == 2)
    M = N;
end

if (M <= 8192)
    M1 = log2(M);
    M2 = ceil(M1);
    fft_point = 2^M2;
else
    fft_point = 1024;
end

%------------------------------------------------------
% Determine the number of windows, normalizing factor
%------------------------------------------------------
M = min(fft_point,N);
k = fix(N/M);           % Number of windows

index = 1:M;

w = ones(fft_point,1);                   % Rectangular window in this example
scale = k*fft_point*norm(w)^2/2;   % Normalizing scale factor

Px = zeros(fft_point,1);

%--------------------------------------------------------
% Accumulate fft spectrum and get the psd estimate
%--------------------------------------------------------
for i=1:k
    xw = w.*[detrend(x(index));zeros(fft_point-M,1)];
    index = index + M;
    X = abs(fft(xw,fft_point)).^2;
    Px = Px + X;
end

P = Px([2:(fft_point/2+1)])/scale; % Select first half and eliminate DC value

N1 = fft_point/2;
df = (fs/2 )/N1;                            % Frequency resolution
f_bin1 = max(1,round(freq_range(1)/df ));   % Low frequency bin
f_bin2 = min(N1,round(freq_range(2)/df));   % High frequency bin
f = (f_bin1:f_bin2)*df;                     
P = P(f_bin1:f_bin2);
Sx = P;

Sx = 10*log10(Sx);                          % For dB Scale;