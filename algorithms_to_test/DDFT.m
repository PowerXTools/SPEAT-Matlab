% Function: DDFT

% Input: test signal, test function flag

% Output: the estimated magnitude, the estimated phase angle, sampling number beyond one cycle

% H. Yu, Z. Jin, H. Zhang, et al. A phasor estimation algorithm robust to decaying DC component[J].
% IEEE Transactions on Power Delivery, 2022, 37(2):860–870.

function [Mag_signal_DDFT, Phase_signal_DDFT, sampling_number_beyond] = DDFT(Signal,tag)

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

Signal_pre_process = zeros(1, signal_length);
Signal_DFT = zeros(1, signal_length);   % preset phasor length to improve computing efficiency
I_ddc = zeros(1, signal_length);
Signal_DDFT = zeros(1, signal_length);
Mag_signal_DDFT = zeros(1, signal_length);   % preset magnitude length
Phase_signal_DDFT = zeros(1, signal_length);    % preset phase angle length

m = 0 : sampling_number-1;
m_former = 0 : fix(sampling_number/2) - 1;
m_latter = ceil(sampling_number/2) : sampling_number-1;
Rotated_factor_former = exp(-1i*2*pi*m_former / sampling_number);

% body of DDFT
for window=1:signal_length

    % preprocessing signals to filter out even harmonic
    % corresponding equation (13) in the reference
    Signal_pre_process(window+m) = (-Signal(window+m) + Signal(window+m+ceil(sampling_number/2)))/2;
    
    % corresponding equations (4) and (5) in the reference
    Signal_former = sum(Signal_pre_process(m_former+window) .* Rotated_factor_former)...
          *2/sampling_number;
    Signal_latter = sum(Signal_pre_process(m_latter+window) .* Rotated_factor_former)...
          *2/sampling_number;
    
    Signal_DFT(window) = Signal_former-Signal_latter;
    
    % corresponding equation (16) in the reference
    Signal_former_conj = conj(Signal_former);
    Signal_latter_conj = conj(Signal_latter);
    
    % corresponding equations (8) and (9) in the reference
    div = (Signal_former_conj + Signal_latter_conj) / (Signal_former + Signal_latter+1e-10);
    E = (div-1) ./ (div .* exp(1i*2*pi/sampling_number) - exp(-1i*2*pi/sampling_number)+1e-10);
    if abs(E)>1e10   % guarantee algorithm stability
        E=0;
    end

    % corresponding equation (10) in the reference
    I_ddc(window) = (Signal_former+Signal_latter) * (1-E.^(sampling_number/2))...
          / (1+E.^(sampling_number/2));
    
    % calculate phasors and their magnitudes and phase angles
    % corresponding equation (11) in the reference
    Signal_DDFT(window) = Signal_DFT(window) - I_ddc(window);
    Mag_signal_DDFT(window) = abs(Signal_DDFT(window));
    Phase_signal_DDFT(window) = rem(angle(Signal_DDFT(window)) - 2*pi*(window+sampling_number)...
               * (f0/50) / sampling_number,pi);

end

sampling_number_beyond = fix(sampling_number/2);   % sampling number beyond one cycle

end

