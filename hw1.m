clear all; close all;

Rb = 1;         fs = 100*Rb;
Tb = 1/Rb;      ts = 1/fs;
df = 0.1;
Nbit = fs/Rb;
% -------------------------------------------------------------------------
ptime = -(Tb/2):ts:(Tb/2)-ts;

pulse_rect = ones(1, Nbit);
pulse_tri = (-2/Tb).*abs(ptime)+1;
pulse_cos = cos((pi*ptime)/(Tb));

BT = 1.0; Bo = BT/Tb;
Qalpha = 2*pi*Bo./(sqrt(log(2)));
pulse_gau = (1/(Tb)).*(Q_funct(Qalpha.*(ptime-Tb/4))-Q_funct(Qalpha.*(ptime+Tb/4)));
% -------------------------------------------------------------------------
Ttime = -Tb:ts:Tb-ts;

pulse_rect = [zeros(1,Nbit/2), pulse_rect, zeros(1,Nbit/2)];
pulse_tri = [zeros(1,Nbit/2), pulse_tri, zeros(1,Nbit/2)];
pulse_cos = [zeros(1,Nbit/2), pulse_cos, zeros(1,Nbit/2)];
pulse_gau = [zeros(1,Nbit/2), pulse_gau, zeros(1,Nbit/2)];

AXIS_TIME = [-2*Tb, 2*Tb, 0, 1.5*Tb];
figure
stairs(Ttime, pulse_rect, 'k'); hold on;
plot(Ttime, pulse_tri, 'b'); hold on;
plot(Ttime, pulse_cos, 'g'); hold on;
plot(Ttime, pulse_gau, 'r'); hold on;
grid on; axis(AXIS_TIME);
xlabel('time [sec]'); title('pulse shapes in Time-domain');
legend('rect','tri','cos','gaussian');

% -------------------------------------------------------------------------
[Srect, xrect1, df1] = fft_mod(pulse_rect, ts, df);
[Stri, xtri1, df2] = fft_mod(pulse_tri, ts, df);
[Scos, xcos1, df3] = fft_mod(pulse_cos, ts, df);
[Sgau, xgau1, df4] = fft_mod(pulse_gau, ts, df);

Srect = Srect./fs;  Srect = fftshift(abs(Srect)); Srect = Srect./max(Srect);
Stri = Stri./fs;    Stri = fftshift(abs(Stri)); Stri = Stri./max(Stri);
Scos = Scos./fs;    Scos = fftshift(abs(Scos)); Scos = Scos./max(Scos);
Sgau = Sgau./fs;    Sgau = fftshift(abs(Sgau)); Sgau = Sgau./max(Sgau);

freq1 = (0:df1:(length(xrect1)-1)*df1) - fs/2;
freq2 = (0:df2:(length(xtri1)-1)*df2) - fs/2;
freq3 = (0:df3:(length(xcos1)-1)*df3) - fs/2;
freq4 = (0:df4:(length(xgau1)-1)*df4) - fs/2;
% -------------------------------------------------------------------------
figure
plot(freq1, 20*log10(Srect), 'k'); hold on;
plot(freq2, 20*log10(Stri), 'b'); hold on;
plot(freq3, 20*log10(Scos), 'g'); hold on;
plot(freq4, 20*log10(Sgau), 'r'); hold on;
grid on; axis([-10*Tb, 10*Tb, -150 20]);
xlabel('frequency [Hz]'); title('pulse shapes in Frequency-domain');
legend('rect','tri','cos','gaussian');
% -------------------------------------------------------------------------
