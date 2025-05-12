% Function: TDFT

% Input: test signal

% Output: the estimated magnitude, the estimated phase angle, sampling number beyond one cycle

% Reference: S. Afrandideh, M. R. Arabshahi, S. M. Fazeli. Two modified DFT‐based algorithms
% for fundamental phasor estimation[J]. IET Generation, Transmission &amp; Distribution, 2022, 16(16):3218–3229.

function [Mag_signal_TDFT, Phase_signal_TDFT, sampling_number_beyond] = TDFT(Signal,tag)

f0 = evalin('base','f0');
fs = evalin('base','fs');

sampling_number = ceil(fs / f0);   % obtain the sampling number in one cycle

if tag==7   % length of test signal
    % for a power oscillation test, the signal length is 103 cycles
    signal_length = ceil(103 * sampling_number);
else
    % for other tests, the signal length is 12 cycles
    signal_length = ceil(12 * sampling_number);
end

Signal_TDFT = zeros(1, signal_length);   % preset phasor length to improve computing efficiency
Mag_signal_TDFT = zeros(1, signal_length);   % preset magnitude length
Phase_signal_TDFT = zeros(1, signal_length);   % preset phase angle length

m = 0:sampling_number-1;
Rotated_factor = exp(-1i*2*pi*m / sampling_number);

% body of TDFT
for window = 1:signal_length
    
    % compute five DFTs
    % corresponding equations (15) to (18) in the reference
    Signal_DFT0 = sum(Signal(window+4+m) .* Rotated_factor) * 2/sampling_number;
    Signal_DFT1 = sum(Signal(window+3+m) .* Rotated_factor) * 2/sampling_number;
    Signal_DFT2 = sum(Signal(window+2+m) .* Rotated_factor) * 2/sampling_number;
    Signal_DFT3 = sum(Signal(window+1+m) .* Rotated_factor) * 2/sampling_number;
    Signal_DFT4 = sum(Signal(window+m) .* Rotated_factor) * 2/sampling_number;

    % corresponding equations (19) to (22) in the reference
    Signal_DFT_y1 = Signal_DFT0 - Signal_DFT1 * exp(1i*2*pi/sampling_number);
    Signal_DFT_y2 = Signal_DFT1 - Signal_DFT2 * exp(1i*2*pi/sampling_number);
    Signal_DFT_y3 = Signal_DFT2 - Signal_DFT3 * exp(1i*2*pi/sampling_number);
    Signal_DFT_y4 = Signal_DFT3 - Signal_DFT4 * exp(1i*2*pi/sampling_number);
    
    % +1e-10 guarantee algorithm stability
    % corresponding equations (32) and (31) in the reference
    X2 = (Signal_DFT_y3^2 + Signal_DFT_y2 * Signal_DFT_y4)...
        / (Signal_DFT_y1 * (Signal_DFT_y2 - Signal_DFT_y3) + 1e-10);
    X1 = (Signal_DFT_y3 + X2*Signal_DFT_y4) / (Signal_DFT_y2 + 1e-10);
    
    % corresponding equation (33) in the reference
    Lamda_s = (X1+sqrt(X1^2-4*X2)) / 2;
    Lamda_c = (X1-sqrt(X1^2-4*X2)) / 2;

    % guarantee algorithm stability
    if abs(Lamda_s) > 1e5
        Lamda_s = 0;
    end
    if abs(Lamda_c) > 1e5
        Lamda_c = 0;
    end
    
    % corresponding equations (28) and (34) in the reference
    M_c = (Signal_DFT_y2 - Lamda_s*Signal_DFT_y1) / (Lamda_c-Lamda_s+1e-5);
    M_s = Signal_DFT_y1 - M_c;

    % corresponding equations (35) and (36) in the reference
    % +1e-5 guarantee algorithm stability
    Iddc_s = M_s / (1 - Lamda_s * exp(1i*2*pi / sampling_number) + 1e-5);
    Iddc_c = M_c / (1 - Lamda_c * exp(1i*2*pi / sampling_number) + 1e-5);

    % guarantee algorithm stability
    if abs(Iddc_s) > 1e5
        Iddc_s = 0;
    end
    if abs(Iddc_c) > 1e5
        Iddc_c = 0;
    end

    % calculate phasors and their magnitudes and phase angles
    Signal_TDFT(window) = Signal_DFT4 - Iddc_s - Iddc_c;
    Mag_signal_TDFT(window) = abs(Signal_TDFT(window));
    Phase_signal_TDFT(window) = rem(angle(Signal_TDFT(window)) - 2*pi*(window+sampling_number)...
                       *(f0/50) / sampling_number,pi);
    
end   % end of  for window=1:signal_length

sampling_number_beyond = 4;   % sampling number beyond one cycle

end
