%clear
clc;
clear;

T_max = 5 / 100;

% Create start signals
Fs = 10e7;
global t_start;
global freq;
t_start = 0 : 1/Fs : T_max - 1/Fs;
freq = Fs;

f_150_start = sin(2 * pi * 150 * t_start);
f_3300_start = sin(2 * pi * 3300 * t_start);
f_11000_start = sin(2 * pi * 11000 * t_start);
f_150_and_3300_start = sin(2 * pi * 150 * t_start) + sin(2 * pi * 3300 * t_start);
f_150_and_3300_and_11000_start = sin(2 * pi * 150 * t_start) + sin(2 * pi * 3300 * t_start) + sin(2 * pi * 11000 * t_start);
f_150_and_4900_and_11000_start = sin(2 * pi * 150 * t_start) + sin(2 * pi * 4900 * t_start) + sin(2 * pi * 11000 * t_start);

% Create 44100 signals
Fs = 44100;
t_44100 = 0 : 1/Fs : T_max - 1/Fs;

f_150_44100 = sin(2 * pi * 150 * t_44100);
f_3300_44100 = sin(2 * pi * 3300 * t_44100);
f_11000_44100 = sin(2 * pi * 11000 * t_44100);
f_150_and_3300_44100 = sin(2 * pi * 150 * t_44100) + sin(2 * pi * 3300 * t_44100);
f_150_and_3300_and_11000_44100 = sin(2 * pi * 150 * t_44100) + sin(2 * pi * 3300 * t_44100) + sin(2 * pi * 11000 * t_44100);
f_150_and_4900_and_11000_44100 = sin(2 * pi * 150 * t_44100) + sin(2 * pi * 4900 * t_44100) + sin(2 * pi * 11000 * t_44100);

% Create 48000 signals
Fs = 48000;
t_48000 = 0 : 1/Fs : T_max - 1/Fs;

f_150_48000 = sin(2 * pi * 150 * t_48000);
f_3300_48000 = sin(2 * pi * 3300 * t_48000);
f_11000_48000 = sin(2 * pi * 11000 * t_48000);
f_150_and_3300_48000 = sin(2 * pi * 150 * t_48000) + sin(2 * pi * 3300 * t_48000);
f_150_and_3300_and_11000_48000 = sin(2 * pi * 150 * t_48000) + sin(2 * pi * 3300 * t_48000) + sin(2 * pi * 11000 * t_48000);
f_150_and_4900_and_11000_48000 = sin(2 * pi * 150 * t_48000) + sin(2 * pi * 4900 * t_48000) + sin(2 * pi * 11000 * t_48000);

% Create 96000 signals
Fs = 96000;
t_96000 = 0 : 1/Fs : T_max - 1/Fs;

f_150_96000 = sin(2 * pi * 150 * t_96000);
f_3300_96000 = sin(2 * pi * 3300 * t_96000);
f_11000_96000 = sin(2 * pi * 11000 * t_96000);
f_150_and_3300_96000 = sin(2 * pi * 150 * t_96000) + sin(2 * pi * 3300 * t_96000);
f_150_and_3300_and_11000_96000 = sin(2 * pi * 150 * t_96000) + sin(2 * pi * 3300 * t_96000) + sin(2 * pi * 11000 * t_96000);
f_150_and_4900_and_11000_96000 = sin(2 * pi * 150 * t_96000) + sin(2 * pi * 4900 * t_96000) + sin(2 * pi * 11000 * t_96000);

% Create 192000 signals
Fs = 192000;
t_192000 = 0 : 1/Fs : T_max - 1/Fs;

f_150_192000 = sin(2 * pi * 150 * t_192000);
f_3300_192000 = sin(2 * pi * 3300 * t_192000);
f_11000_192000 = sin(2 * pi * 11000 * t_192000);
f_150_and_3300_192000 = sin(2 * pi * 150 * t_192000) + sin(2 * pi * 3300 * t_192000);
f_150_and_3300_and_11000_192000 = sin(2 * pi * 150 * t_192000) + sin(2 * pi * 3300 * t_192000) + sin(2 * pi * 11000 * t_192000);
f_150_and_4900_and_11000_192000 = sin(2 * pi * 150 * t_192000) + sin(2 * pi * 4900 * t_192000) + sin(2 * pi * 11000 * t_192000);f_150_and_4900_and_11000_192000 = sin(2 * pi * 150 * t_192000) + sin(2 * pi * 4900 * t_192000) + sin(2 * pi * 11000 * t_192000);



%sample 44100 and r = 10

f_150_44100_10 = sample(f_150_44100, 10, t_44100, f_150_start, "150 Hz", 150);
f_3300_44100_10 = sample(f_3300_44100, 10, t_44100, f_3300_start, "3300 Hz", 3300);
f_11000_44100_10 = sample(f_11000_44100, 10, t_44100, f_11000_start, "11000 Hz", 11000);
f_150_and_3300_44100_10 = sample(f_150_and_3300_44100, 10, t_44100, f_150_and_3300_start, "150 + 3300 Hz", 150);
f_150_and_3300_and_11000_44100_10 = sample(f_150_and_3300_and_11000_44100, 10, t_44100, f_150_and_3300_and_11000_start, "150 + 3300 + 11000 Hz", 150);
f_150_and_4900_and_11000_44100_10 = sample(f_150_and_4900_and_11000_44100, 10, t_44100, f_150_and_4900_and_11000_start, "150 + 4900 + 11000 Hz", 150);



%sample 48000 and r = 10

f_150_48000_10 = sample(f_150_48000, 10, t_48000, f_150_start, "150 Hz", 150);
f_3300_48000_10 = sample(f_3300_48000, 10, t_48000, f_3300_start, "3300 Hz", 3300);
f_11000_48000_10 = sample(f_11000_48000, 10, t_48000, f_11000_start, "11000 Hz", 11000);
f_150_and_3300_48000_10 = sample(f_150_and_3300_48000, 10, t_48000, f_150_and_3300_start, "150 + 3300 Hz", 150);
f_150_and_3300_and_11000_48000_10 = sample(f_150_and_3300_and_11000_48000, 10, t_48000, f_150_and_3300_and_11000_start, "150 + 3300 + 11000 Hz", 150);
f_150_and_4900_and_11000_48000_10 = sample(f_150_and_4900_and_11000_48000, 10, t_48000, f_150_and_4900_and_11000_start, "150 + 4900 + 11000 Hz", 150);



%sample 96000 and r = 10

f_150_96000_10 = sample(f_150_96000, 10, t_96000, f_150_start, "150 Hz", 150);
f_3300_96000_10 = sample(f_3300_96000, 10, t_96000, f_3300_start, "3300 Hz", 3300);
f_11000_96000_10 = sample(f_11000_96000, 10, t_96000, f_11000_start, "11000 Hz", 11000);
f_150_and_3300_96000_10 = sample(f_150_and_3300_96000, 10, t_96000, f_150_and_3300_start, "150 + 3300 Hz", 150);
f_150_and_3300_and_11000_96000_10 = sample(f_150_and_3300_and_11000_96000, 10, t_96000, f_150_and_3300_and_11000_start, "150 + 3300 + 11000 Hz", 150);
f_150_and_4900_and_11000_96000_10 = sample(f_150_and_4900_and_11000_96000, 10, t_96000, f_150_and_4900_and_11000_start, "150 + 4900 + 11000 Hz", 150);



%sample 192000 and r = 10

f_150_192000_10 = sample(f_150_192000, 10, t_192000, f_150_start, "150 Hz", 150);
f_3300_192000_10 = sample(f_3300_192000, 10, t_192000, f_3300_start, "3300 Hz", 3300);
f_11000_192000_10 = sample(f_11000_192000, 10, t_192000, f_11000_start, "11000 Hz", 11000);
f_150_and_3300_192000_10 = sample(f_150_and_3300_192000, 10, t_192000, f_150_and_3300_start, "150 + 3300 Hz", 150);
f_150_and_3300_and_11000_192000_10 = sample(f_150_and_3300_and_11000_192000, 10, t_192000, f_150_and_3300_and_11000_start, "150 + 3300 + 11000 Hz", 150);
f_150_and_4900_and_11000_192000_10 = sample(f_150_and_4900_and_11000_192000, 10, t_192000, f_150_and_4900_and_11000_start, "150 + 4900 + 11000 Hz", 150);


%sample 44100 and r = 16

f_150_44100_16 = sample(f_150_44100, 16, t_44100, f_150_start, "150 Hz", 150);
f_3300_44100_16 = sample(f_3300_44100, 16, t_44100, f_3300_start, "3300 Hz", 3300);
f_11000_44100_16 = sample(f_11000_44100, 16, t_44100, f_11000_start, "11000 Hz", 11000);
f_150_and_3300_44100_16 = sample(f_150_and_3300_44100, 16, t_44100, f_150_and_3300_start, "150 + 3300 Hz", 150);
f_150_and_3300_and_11000_44100_16 = sample(f_150_and_3300_and_11000_44100, 16, t_44100, f_150_and_3300_and_11000_start, "150 + 3300 + 11000 Hz", 150);
f_150_and_4900_and_11000_44100_16 = sample(f_150_and_4900_and_11000_44100, 16, t_44100, f_150_and_4900_and_11000_start, "150 + 4900 + 11000 Hz", 150);



%sample 48000 and r = 16

f_150_48000_16 = sample(f_150_48000, 16, t_48000, f_150_start, "150 Hz", 150);
f_3300_48000_16 = sample(f_3300_48000, 16, t_48000, f_3300_start, "3300 Hz", 3300);
f_11000_48000_16 = sample(f_11000_48000, 16, t_48000, f_11000_start, "11000 Hz", 11000);
f_150_and_3300_48000_16 = sample(f_150_and_3300_48000, 16, t_48000, f_150_and_3300_start, "150 + 3300 Hz", 150);
f_150_and_3300_and_11000_48000_16 = sample(f_150_and_3300_and_11000_48000, 16, t_48000, f_150_and_3300_and_11000_start, "150 + 3300 + 11000 Hz", 150);
f_150_and_4900_and_11000_48000_16 = sample(f_150_and_4900_and_11000_48000, 16, t_48000, f_150_and_4900_and_11000_start, "150 + 4900 + 11000 Hz", 150);



%sample 96000 and r = 16

f_150_96000_16 = sample(f_150_96000, 16, t_96000, f_150_start, "150 Hz", 150);
f_3300_96000_16 = sample(f_3300_96000, 16, t_96000, f_3300_start, "3300 Hz", 3300);
f_11000_96000_16 = sample(f_11000_96000, 16, t_96000, f_11000_start, "11000 Hz", 11000);
f_150_and_3300_96000_16 = sample(f_150_and_3300_96000, 16, t_96000, f_150_and_3300_start, "150 + 3300 Hz", 150);
f_150_and_3300_and_11000_96000_16 = sample(f_150_and_3300_and_11000_96000, 16, t_96000, f_150_and_3300_and_11000_start, "150 + 3300 + 11000 Hz", 150);
f_150_and_4900_and_11000_96000_16 = sample(f_150_and_4900_and_11000_96000, 16, t_96000, f_150_and_4900_and_11000_start, "150 + 4900 + 11000 Hz", 150);



%sample 192000 and r = 16

f_150_192000_16 = sample(f_150_192000, 16, t_192000, f_150_start, "150 Hz", 150);
f_3300_192000_16 = sample(f_3300_192000, 16, t_192000, f_3300_start, "3300 Hz", 3300);
f_11000_192000_16 = sample(f_11000_192000, 16, t_192000, f_11000_start, "11000 Hz", 11000);
f_150_and_3300_192000_16 = sample(f_150_and_3300_192000, 16, t_192000, f_150_and_3300_start, "150 + 3300 Hz", 150);
f_150_and_3300_and_11000_192000_16 = sample(f_150_and_3300_and_11000_192000, 16, t_192000, f_150_and_3300_and_11000_start, "150 + 3300 + 11000 Hz", 150);
f_150_and_4900_and_11000_192000_16 = sample(f_150_and_4900_and_11000_192000, 16, t_192000, f_150_and_4900_and_11000_start, "150 + 4900 + 11000 Hz", 150);




%sample 44100 and r = 24

f_150_44100_24 = sample(f_150_44100, 24, t_44100, f_150_start, "150 Hz", 150);
f_3300_44100_24 = sample(f_3300_44100, 24, t_44100, f_3300_start, "3300 Hz", 3300);
f_11000_44100_24 = sample(f_11000_44100, 24, t_44100, f_11000_start, "11000 Hz", 11000);
f_150_and_3300_44100_24 = sample(f_150_and_3300_44100, 24, t_44100, f_150_and_3300_start, "150 + 3300 Hz", 150);
f_150_and_3300_and_11000_44100_24 = sample(f_150_and_3300_and_11000_44100, 24, t_44100, f_150_and_3300_and_11000_start, "150 + 3300 + 11000 Hz", 150);
f_150_and_4900_and_11000_44100_24 = sample(f_150_and_4900_and_11000_44100, 24, t_44100, f_150_and_4900_and_11000_start, "150 + 4900 + 11000 Hz", 150);



%sample 48000 and r = 24

f_150_48000_24 = sample(f_150_48000, 24, t_48000, f_150_start, "150 Hz", 150);
f_3300_48000_24 = sample(f_3300_48000, 24, t_48000, f_3300_start, "3300 Hz", 3300);
f_11000_48000_24 = sample(f_11000_48000, 24, t_48000, f_11000_start, "11000 Hz", 11000);
f_150_and_3300_48000_24 = sample(f_150_and_3300_48000, 24, t_48000, f_150_and_3300_start, "150 + 3300 Hz", 150);
f_150_and_3300_and_11000_48000_24 = sample(f_150_and_3300_and_11000_48000, 24, t_48000, f_150_and_3300_and_11000_start, "150 + 3300 + 11000 Hz", 150);
f_150_and_4900_and_11000_48000_24 = sample(f_150_and_4900_and_11000_48000, 24, t_48000, f_150_and_4900_and_11000_start, "150 + 4900 + 11000 Hz", 150);



%sample 96000 and r = 24

f_150_96000_24 = sample(f_150_96000, 24, t_96000, f_150_start, "150 Hz", 150);
f_3300_96000_24 = sample(f_3300_96000, 24, t_96000, f_3300_start, "3300 Hz", 3300);
f_11000_96000_24 = sample(f_11000_96000, 24, t_96000, f_11000_start, "11000 Hz", 11000);
f_150_and_3300_96000_24 = sample(f_150_and_3300_96000, 24, t_96000, f_150_and_3300_start, "150 + 3300 Hz", 150);
f_150_and_3300_and_11000_96000_24 = sample(f_150_and_3300_and_11000_96000, 24, t_96000, f_150_and_3300_and_11000_start, "150 + 3300 + 11000 Hz", 150);
f_150_and_4900_and_11000_96000_24 = sample(f_150_and_4900_and_11000_96000, 24, t_96000, f_150_and_4900_and_11000_start, "150 + 4900 + 11000 Hz", 150);



%sample 192000 and r = 24

f_150_192000_24 = sample(f_150_192000, 24, t_192000, f_150_start, "150 Hz", 150);
f_3300_192000_24 = sample(f_3300_192000, 24, t_192000, f_3300_start, "3300 Hz", 3300);
f_11000_192000_24 = sample(f_11000_192000, 24, t_192000, f_11000_start, "11000 Hz", 11000);
f_150_and_3300_192000_24 = sample(f_150_and_3300_192000, 24, t_192000, f_150_and_3300_start, "150 + 3300 Hz", 150);
f_150_and_3300_and_11000_192000_24 = sample(f_150_and_3300_and_11000_192000, 24, t_192000, f_150_and_3300_and_11000_start, "150 + 3300 + 11000 Hz", 150);
f_150_and_4900_and_11000_192000_24 = sample(f_150_and_4900_and_11000_192000, 24, t_192000, f_150_and_4900_and_11000_start, "150 + 4900 + 11000 Hz", 150);



%function to sampling
function sampling = sample(x, r, t, s_0, name, f_signal)
   global t_start;
   global freq;
   disp("------------------------------------------------------------------------");
   disp("Now freq of sampling = " + num2str(length(t)*20) + " Hz, r = " + num2str(r));
   disp("Signal is " + name);

   %analog-to-digital converter

   maximum = max(x);
   x = x ./ maximum;
   maximum = max(s_0);
   signal_normal = s_0 ./ maximum;
   sq = uencode(x, r, 1, 'signed');
   sqp = int32(sq) + 2^(r-1);
   x = int2bit(sqp, r);

   %digital-to-analog converter

   do = bit2int(x, r) - 2^(r-1);
   z = udecode(int32(do), r, 1, "saturate");
   z_0 = interp1(t, z, t_start, "linear", "extrap");


   Pc = sum(abs(s_0).^2/length(s_0));
   Psh = sum(abs(z_0-signal_normal).^2/length(z_0));
   SNR = 10 * log10(Pc/Psh);
   
   disp ("SNR = " + num2str(SNR) + " dB");


   %Create a spectrum

   X = fft(s_0);
   L = length(s_0);

   P2 = abs(X)/L;
   halfL = floor(L/2) + 1;
   P1 = P2(1:halfL);
   P1(2:end-1) = 2*P1(2:end-1);
   f = freq * (0 : halfL - 1) / L;
    
   subplot (1, 2, 1);
   plot(f, P1, 'r-', 'LineWidth', 2.5, 'DisplayName', 'Original Signal');
   hold on;

   X = fft(z_0);
   L = length(z_0);

   P2 = abs(X)/L;
   halfL = floor(L/2) + 1;
   P1 = P2(1:halfL);
   P1(2:end-1) = 2*P1(2:end-1); 

   plot(f, P1, 'b-', 'LineWidth', 1.25, 'DisplayName', 'Quantized & Interpolated');
   hold off;
   title('Spectrum');
   xlabel('Frequency (Hz)');
   ylabel('Amplitude');
   grid on;
   ylim([0 2]);
   xlim([0 12000]);

   subplot (1, 2, 2);
   plot(t_start, z_0, 'b-', 'LineWidth', 2);
   hold on;
   plot(t_start, signal_normal, 'r-', 'LineWidth', 1);
   hold off;
   grid on;
   ylim([-2 2]);
   xlim([0 1/f_signal]);
   
   sampling = 0;
   
   disp (" ");
   input("Нажмите Enter");
   
end
