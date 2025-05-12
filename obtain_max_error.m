% Function: obtain_max_error
% Check the selected algorithm and quantity
% Input: the magnitude and phase of phasor, sampling number beyond one cycle
% Output: maximum magnitude error, maximum  phase error

function [max_mag, max_phase, max_TVE] = obtain_max_error(Signal_mag, Signal_phase, delay,tag)

global fs f0 fundamental_mag fundamental_pha frequency_modulation;

sampling_number = ceil(fs / f0);

if tag==7
    n_afterfault=10*sampling_number : 103*sampling_number+40-1;
    Ts=1/fs;
    k_modulation=0.1; %  amplitude modulation factor
    %fundamental_mag = evalin('base','fundamental_mag');
    %fundamental_pha = evalin('base','fundamental_pha');
    %frequrncy_modulation=evalin('base','frequency_modulation');

    omiga_modulation=2*pi*frequency_modulation; % modulation angular frequency
    mag_fundamental_dynamic=fundamental_mag*(1+k_modulation*cos(omiga_modulation.*n_afterfault*Ts));
    delta_omiga=-(k_modulation*omiga_modulation*sin(omiga_modulation*(n_afterfault)*Ts));
    %-k_modulation*frequrncy_modulation*sin(frequrncy_modulation*n_afterfault*Ts)
    phase_fundamental_dynamic=delta_omiga*Ts+k_modulation*cos(omiga_modulation*(n_afterfault)*Ts-pi)+fundamental_pha;
    
    Phasor_truth=mag_fundamental_dynamic.*exp(1i*phase_fundamental_dynamic);
    Phasor_truth_real = real(Phasor_truth);
    Phasor_truth_imag = imag(Phasor_truth);
    Phasor_estimation = Signal_mag .* exp(1j*Signal_phase);

    % amplitude error
    max_mag = max( abs( Signal_mag(10*sampling_number+delay : end) - mag_fundamental_dynamic(delay+40 : end) ) );
    if max_mag < 1e-4
        max_mag = 0;
    end
    % phase error
    max_phase = max( abs( Signal_phase(10*sampling_number+delay : end) - phase_fundamental_dynamic(delay+40 : end) ) );
    if max_phase < 1e-4
        max_phase = 0;
    end
    % TVE
    TVE = sqrt(((real(Phasor_estimation(10*sampling_number+delay : end))-Phasor_truth_real(40+delay : end)).^2 ...
        +(imag(Phasor_estimation(10*sampling_number+delay : end))-Phasor_truth_imag(40+delay : end)).^2)...
        ./(Phasor_truth_real(40+delay : end).^2+Phasor_truth_imag(40+delay : end).^2));
    max_TVE = max(TVE)*100;
    if max_TVE < 1e-4
        max_TVE = 0;
    end

else

    max_mag = max( abs( Signal_mag(4*sampling_number+delay : end) - fundamental_mag ) );
    if max_mag < 1e-4
        max_mag = 0;
    end

    max_phase = max( abs( Signal_phase(4*sampling_number+delay : end) - fundamental_pha ) );
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

end

