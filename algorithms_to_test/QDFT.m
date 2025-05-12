% Function: QDFT

% Input: test signal，test function flag

% Output: the estimated magnitude, the estimated phase angle, sampling number beyond one cycle

% Qu Yifan, Jin Zongshuai, Zhang Hengxu, Shi Fang. A Robust Phasor Estimation Algorithm for
%  Anti-Decaying DC Component Based on Improved Discrete Fourier Transform[J].

function [amp_X_QDFT, phase_X_QDFT, sampling_number_beyond] = QDFT(Signal,tag)

f0 = evalin('base','f0');
fs = evalin('base','fs');

sampling_number = ceil(fs / f0);   % obtain the sampling number in one cycle
% Ts = 1/fs;   % sampling period

if tag==7   % length of test signal
    % for a power oscillation test, the signal length is 103 cycles
    signal_length = ceil(103 * sampling_number);
else
    % for other tests, the signal length is 12 cycles
    signal_length = ceil(12 * sampling_number);
end

X_QDFT=zeros(1,signal_length);    % preset the phasor length
amp_X_QDFT = zeros(1,signal_length);   % preset magnitude length
phase_X_QDFT = zeros(1,signal_length);   % preset phase angle length

q=0:sampling_number/4-1;

% body of QDFT
for window = 1:signal_length
    
    % corresponding equations (5) to (8) in the reference
    X_quarter1=2/sampling_number*sum(Signal(window+q).*exp(-1i*2*pi*q/sampling_number));
    X_quarter2=2/sampling_number*sum(Signal(window+q+sampling_number/4).*exp(-1i*2*pi*q/sampling_number));
    X_quarter3=2/sampling_number*sum(Signal(window+q+sampling_number/2).*exp(-1i*2*pi*q/sampling_number));
    X_quarter4=2/sampling_number*sum(Signal(window+q+3*sampling_number/4).*exp(-1i*2*pi*q/sampling_number));
    
    % corresponding equation (11) in the reference
    E=((X_quarter4+X_quarter2)/(X_quarter1+X_quarter3+1e-5))^(4/sampling_number);
    if abs(E)>1e5
        E=0;
    end
    % corresponding equation (15) in the reference
    X_full17=X_quarter1-1j*X_quarter2-X_quarter3+1j*X_quarter4;
    % corresponding equation (12) in the reference
    X_ddc=((X_quarter1+X_quarter3)-1j*(X_quarter4+X_quarter2))*(1-E^(sampling_number/2))/(1+E^(sampling_number/2)+1e-5);
    
    % calculate phasors and their magnitudes and phase angles
    X_QDFT(window)=X_full17-X_ddc;
    amp_X_QDFT(window)=abs(X_QDFT(window));
    phase_X_QDFT(window)=rem(angle(X_QDFT(window))-2*pi*(window+sampling_number)*(f0/50)/sampling_number,pi);

end

sampling_number_beyond = 0;  % sampling number beyond one cycle

end

