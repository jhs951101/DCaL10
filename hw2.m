clear all; close all;

Rb = 1;     fs = 16*Rb;
Tb = 1/Rb;  ts = 1/fs;
Nbit = fs/Rb;
% -------------------------------------------------------------------------
bitlen = 10^4;
bit = randi([0,1], 1, bitlen);
bit(bit==0) = -1;
% bit = rand(1, bitlen);
% bit = 2*round(bit)-1;

bt = bit'*ones(1, Nbit);
bt = bt';   bt = bt(:)';
x = bt;
% -------------------------------------------------------------------------
Ttime = 0:ts:bitlen*Tb-ts;
AXIS_TIME = [0, 10*Tb, -2, 2];
% -------------------------------------------------------------------------
roll_off = [0, 0.5, 1];
[ht1, time1] = Function_Gen_Raised_Cosine_Filter_Time_Domain(Rb, fs, roll_off(1));
[ht2, time2] = Function_Gen_Raised_Cosine_Filter_Time_Domain(Rb, fs, roll_off(2));
[ht3, time3] = Function_Gen_Raised_Cosine_Filter_Time_Domain(Rb, fs, roll_off(3));
% -------------------------------------------------------------------------
xt1 = conv(x, ht1, 'same').*ts;
xt2 = conv(x, ht2, 'same').*ts;
xt3 = conv(x, ht3, 'same').*ts;
% -------------------------------------------------------------------------
noise_power = 0;
f_cutoff = 1*Rb;        % Bandwidth of Channel (1~7)

y = Function_Channel_Filter(x, 1, noise_power, f_cutoff, fs);

yt1 = Function_Channel_Filter(xt1, 1, noise_power, f_cutoff, fs);
yt2 = Function_Channel_Filter(xt2, 1, noise_power, f_cutoff, fs);
yt3 = Function_Channel_Filter(xt3, 1, noise_power, f_cutoff, fs);
% -------------------------------------------------------------------------
figure
subplot(211), stairs(Ttime, x); grid on; axis(AXIS_TIME);
xlabel('time [sec]'); title('Polar NRZ input bit stream');
subplot(212), plot(Ttime, y); grid on; axis(AXIS_TIME);
xlabel('time [sec]'); title('Channel Output of x(t)');

figure
subplot(211), plot(Ttime, xt1); grid on; axis(AXIS_TIME);
xlabel('time [sec]'); title(['Raised Cosine Filtering, roll-off = ', num2str(roll_off(1))]);
subplot(212), plot(Ttime, yt1); grid on; axis(AXIS_TIME);
xlabel('time [sec]'); title(['Channel Output of RC filtering, roll-off = ',num2str(roll_off(1)),', cut-off frequency = ',num2str(f_cutoff)]);

figure
subplot(211), plot(Ttime, xt2); grid on; axis(AXIS_TIME);
xlabel('time [sec]'); title(['Raised Cosine Filtering, roll-off = ', num2str(roll_off(2))]);
subplot(212), plot(Ttime, yt2); grid on; axis(AXIS_TIME);
xlabel('time [sec]'); title(['Channel Output of RC filtering, roll-off = ',num2str(roll_off(2)),', cut-off frequency = ',num2str(f_cutoff)]);

figure
subplot(211), plot(Ttime, xt2); grid on; axis(AXIS_TIME);
xlabel('time [sec]'); title(['Raised Cosine Filtering, roll-off = ', num2str(roll_off(3))]);
subplot(212), plot(Ttime, yt2); grid on; axis(AXIS_TIME);
xlabel('time [sec]'); title(['Channel Output of RC filtering, roll-off = ',num2str(roll_off(3)),', cut-off frequency = ',num2str(f_cutoff)]);

% -------------------------------------------------------------------------
M = 10^13;
[Sx, freq] = Function_PSD_dB(x, fs, M);
[Sx1, freq1] = Function_PSD_dB(xt1, fs, M);
[Sx2, freq2] = Function_PSD_dB(xt2, fs, M);
[Sx3, freq3] = Function_PSD_dB(xt3, fs, M);
% -------------------------------------------------------------------------
AXIS_FREQ = [0, 5*Rb, -80, 0];

str1 = ['roll-off=',num2str(roll_off(1))];
str2 = ['roll-off=',num2str(roll_off(2))];
str3 = ['roll-off=',num2str(roll_off(3))];

figure
plot(freq, Sx, 'k'); hold on;
plot(freq1, Sx1, 'b'); hold on;
plot(freq2, Sx2, 'm'); hold on;
plot(freq3, Sx3, 'r'); hold on;
grid on; axis(AXIS_FREQ);
xlabel('Normalized frequency'); ylabel('Power Spectral Density [dB]');
title('Raised Cosine Pulse Shaping Before Channel');
legend('input bit stream',str1,str2,str3);

% -------------------------------------------------------------------------
[Sy, freq_y] = Function_PSD_dB(y, fs, M);
[Sy1, freq_y1] = Function_PSD_dB(yt1, fs, M);
[Sy2, freq_y2] = Function_PSD_dB(yt2, fs, M);
[Sy3, freq_y3] = Function_PSD_dB(yt3, fs, M);
% -------------------------------------------------------------------------
figure
plot(freq_y, Sy, 'k'); hold on;
plot(freq_y1, Sy1, 'b'); hold on;
plot(freq_y2, Sy2, 'm'); hold on;
plot(freq_y3, Sy3, 'r'); hold on;
grid on; axis(AXIS_FREQ);
xlabel('Normalized frequency'); ylabel('Power Spectral Density [dB]');
title('Raised Cosine Pulse Shaping After Channel');
legend('input bit stream',str1,str2,str3);