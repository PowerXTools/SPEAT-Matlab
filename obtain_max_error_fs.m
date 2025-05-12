% Function: obtain_max_error_fs
% Obtain the maximum magnitude error and phase error in sampling frequency sensitivity
% Input: the magnitude and phase of phasor, sampling number beyond one cycle
% Output: maximum magnitude error, maximum phase error

function [max_mag, max_phase, max_TVE] = obtain_max_error_fs(Signal_mag, Signal_phase, delay)

global f0 fs fundamental_mag fundamental_pha;
sampling_number = ceil(fs / f0);

max_mag = max( abs( Signal_mag(3*sampling_number+delay : end-sampling_number) - fundamental_mag ) );
if max_mag < 1e-4
    max_mag = 0;
end

max_phase = max( abs( Signal_phase(3*sampling_number+delay : end-sampling_number) - fundamental_pha ) );
if max_phase < 1e-4
    max_phase = 0;
end

Phasor_estimation = Signal_mag .* exp(1j*Signal_phase);
Phasor_truth = fundamental_mag * exp(1j*fundamental_pha);
Phasor_truth_real = real(Phasor_truth);
Phasor_truth_imag = imag(Phasor_truth);

TVE = sqrt(((real(Phasor_estimation(4*sampling_number+delay : end))-Phasor_truth_real).^2 ...
    +(imag(Phasor_estimation(4*sampling_number+delay : end))-Phasor_truth_imag).^2)...
    /(Phasor_truth_real^2+Phasor_truth_imag^2));
max_TVE = max(TVE)*100;
if max_TVE < 1e-4
    max_TVE = 0;
end

end

