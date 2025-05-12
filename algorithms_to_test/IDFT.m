% Function: IDFT

% Input: test signal, test function flag

% Output: the estimated magnitude, the estimated phase angle, sampling number beyond one cycle

% B. Jafarpisheh, S. M. Madani, S. Jafarpisheh. Improved DFT-Based Phasor Estimation Algorithm Using Down-Sampling[J].
% IEEE Transactions on Power Delivery, 2018, 33(6):3242–3245.

function [Mag_signal_IDFT, Phase_signal_IDFT, sampling_number_beyond] = IDFT(Signal,tag)

f0 = evalin('base','f0');
fs = evalin('base','fs');

sampling_number = ceil(fs / f0);   % number of sampling points in one cycle

if tag==7   % length of test signal
    % for a power oscillation test, the signal length is 103 cycles
    signal_length = ceil(103 * sampling_number);
else
    % for other tests, the signal length is 12 cycles
    signal_length = ceil(12 * sampling_number);
end

Signal_IDFT = zeros(1,signal_length);   % preset phasor length to improve computing efficiency
Mag_signal_IDFT = zeros(1,signal_length);   % Preset magnitude length
Phase_signal_IDFT = zeros(1,signal_length);   % Preset phase angle length

m = 0:sampling_number-1;
Rotated_factor = exp(-1i*2*pi*m/sampling_number);

% body of IDFT
for window = 1:signal_length

    Signal_DFT = sum(Signal(window+m) .* Rotated_factor) * 2 / sampling_number;
    
    % corresponding equations (5) and (6) in the reference
    Signal_one_cycle = Signal(m+window);   % Gets the test signal for a cycle length
    Si = sum(Signal_one_cycle);
    Sy = sum(0.5*(1+(-1).^m).*Signal_one_cycle);

    % corresponding equations (7) and (9) in the reference
    % +1e-5 guarantee algorithm stability
    E = Si / (Sy+1e-5) - 1;
    Delta_I1_ddc = 2*(1-E)*Si / (sampling_number*(1-E*exp(-1i*2*pi/sampling_number))+1e-5);
    
    % calculate phasors and their magnitudes and phase angles
    Signal_IDFT(window) = Signal_DFT - Delta_I1_ddc;
    Mag_signal_IDFT(window) = abs(Signal_IDFT(window));
    Phase_signal_IDFT(window) = rem(angle(Signal_IDFT(window))-2*pi*(window+sampling_number)...
                     *(f0/50)/sampling_number,pi);

end   % end of  for window=1:signal_length

sampling_number_beyond = 0;   % sampling number beyond one cycle

end

