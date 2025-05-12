% Function: ADFT

% Input: test signal, test function flag

% Output: the estimated magnitude, the estimated phase angle, sampling number beyond one cycle

% M. R. Dadash Zadeh, Z. Zhang. A new DFT-based current phasor esti-mation for numerical protective relaying[J].
% IEEE Transactions on Power Delivery, 2013,28(4):2172–2179.

function [Mag_Signal_ADFT, Phase_signal_ADFT, sampling_number_beyond] = ADFT(Signal,tag)

f0 = evalin('base','f0');
fs = evalin('base','fs');

sampling_number = ceil(fs / f0);   % obtain the sampling number in one cycle
Ts = 1/fs;   % sampling period

if tag==7   % length of test signal
    % for a power oscillation test, the signal length is 103 cycles
    signal_length = ceil(103 * sampling_number);
else
    % for other tests, the signal length is 12 cycles
    signal_length = ceil(12 * sampling_number);
end

X_ADFT = zeros(1,signal_length);   % preset the phasor length
Mag_Signal_ADFT = zeros(1,signal_length);   % preset magnitude length
Phase_signal_ADFT = zeros(1,signal_length);   % preset phase angle length

m = 0:sampling_number-1;

% body of ADFT
for window = 1:signal_length

    % corresponding equation (2) in the reference
    % computes the real and imaginary parts of the DFT
    I_Im = sum(Signal(window+m) .* sin(2*pi*m/sampling_number)) * 2/sampling_number;
    I_Re = sum(Signal(window+m) .* cos(2*pi*m/sampling_number)) * 2/sampling_number;
    
    % corresponding equations (6) to (9) in the reference
    I_dc1 = sum(Signal(window+m)) / sampling_number;
    I_dc2 = sum(Signal(window+m+1)) / sampling_number;
    time_con = Ts / (log(I_dc1/I_dc2)+1e-10);    % calculate the time constant of the DDC
    % calculate the real and imaginary part errors introduced by DDC
    I_comp_Im = 2*I_dc2 / (1+time_con^2*(2*pi*50)^2);
    I_comp_Re = time_con*2*pi*50*I_comp_Im;

    % calculate phasors and their magnitudes and phase angles
    X_ADFT(window)=I_Re-1i*I_Im+(-I_comp_Im+1i*I_comp_Re);
    Mag_Signal_ADFT(window)=abs(X_ADFT(window));
    Phase_signal_ADFT(window)=rem(angle(X_ADFT(window))-2*pi*(window+sampling_number)*(f0/50)/sampling_number,pi);

end  % end of  for window=1:signal_length

sampling_number_beyond=1;  % sampling number beyond one cycle

end

