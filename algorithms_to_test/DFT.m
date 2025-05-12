% Function: DFT

% Input: test signal

% Output: the estimated magnitude, the estimated phase angle, sampling number beyond one cycle

function [Mag_signal_DFT,Phase_signal_DFT,sampling_number_beyond] = DFT(Signal,tag)

f0 = evalin('base','f0');
fs = evalin('base','fs');

 sampling_number = ceil(fs / f0);   % obtain the sampling number in one cycle

 if tag==7   % length of test signal
    signal_length = ceil(103 * sampling_number);
else
    signal_length = ceil(12 * sampling_number);
end
 Signal_DFT = zeros(1,signal_length);   % preset phasor length to improve computing efficiency
 Mag_signal_DFT = zeros(1,signal_length);   % Preset magnitude length
 Phase_signal_DFT = zeros(1,signal_length);   % Preset phase angle length

 m = 0:sampling_number-1;
 Rotated_factor = exp(-1i*2*pi*m/sampling_number);
 
 % body of DFT 
 for window = 1:signal_length

    % calculate phasors and their magnitudes and phase angles
    Signal_DFT(window) = sum(Signal(window+m).*Rotated_factor) * 2 / sampling_number;
    Mag_signal_DFT(window) = abs(Signal_DFT(window));
    Phase_signal_DFT(window) = rem(angle(Signal_DFT(window))-2*pi*(window+sampling_number)...
                       *(f0/50) / sampling_number , pi);

 end

 sampling_number_beyond=0;   % sampling number beyond one cycle

end

