% Function: DLS

% Input: test signal, test function flag

% Output: the estimated amplitude, the estimated phase, sampling number beyond one cycle

% J. K. Hwang, C. S. Lee. Fault current phasor estimation below one cycle using Fourier analysis
% of decaying DC component[J]. IEEE Transactions on Power Delivery, 2022, 37(5):3657–3668.

function [Mag_signal_DLS, Phase_signal_DLS, sampling_number_beyond] = DLS(Signal,tag)

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

Signal_DLS = zeros(1,signal_length);   % preset phasor length to improve computing efficiency
Mag_signal_DLS = zeros(1,signal_length);   % preset magnitude length
Phase_signal_DLS = zeros(1,signal_length);   % preset phase angle length
V0 = zeros(1,signal_length);
V1 = zeros(1,signal_length);
V2 = zeros(1,signal_length);

delta_theta = 2*pi/sampling_number; 
Rotated_factor_reverse = exp(1i*2*pi/sampling_number);   % reverse rotation factor
data_length = sampling_number-2;   % number of sampling points used
M = 0:data_length;

max_har_order = evalin('base','max_har_order'); % maximum harmonic order
max_har_order = floor(max_har_order);
% max_har_order = 16;

% body of DLS
for window = 1:signal_length

    % traverse the coefficient matrix
    Q = [];   % matrix size (data_length+1) * (2*max_har_order)
    for m = 1:data_length+1 
        for n = 1:max_har_order
            Q(m, 2*n-1:2*n) = [cos((m-1)*n*delta_theta) -sin((m-1)*n*delta_theta)];
        end
    end

    % corresponding equation (24) in the reference
    V0(1:2*max_har_order, window) = (inv(Q'*Q)*Q') * Signal(window+M)';
    V1(1:2*max_har_order, window) = (inv(Q'*Q)*Q') * Signal(window+M+1)';
    V2(1:2*max_har_order, window) = (inv(Q'*Q)*Q') * Signal(window+M+2)';

    % corresponding equation (27) in the reference
    % guarantee algorithm stability
    lamda_nume = V2(1,window) + 1i*V2(2,window) - (V1(1,window)+1i*V1(2,window)) * Rotated_factor_reverse;
    lamda_demo = V1(1,window) + 1i*V1(2,window) - (V0(1,window)+1i*V0(2,window)) * Rotated_factor_reverse;
    lamda = real(lamda_nume) / (real(lamda_demo)+1e-10);
    if lamda>1e5
        lamda=0;
    end

    % corresponding equation (28) in the reference
    Y=lamda_demo / (lamda - Rotated_factor_reverse + 1e-10);

    % calculate phasors and their magnitudes and phase angles
    % corresponding equation (29) in the reference
    Signal_DLS(window) = V0(1,window)+1i*V0(2,window) - Y;
    Mag_signal_DLS(window) = abs(Signal_DLS(window));
    Phase_signal_DLS(window) = rem(angle(Signal_DLS(window)) - 2*pi*(window+sampling_number)...
                    *(f0/50) / sampling_number, pi);

end   % end of  for window=1:signal_length

sampling_number_beyond = data_length-sampling_number+2;

end

