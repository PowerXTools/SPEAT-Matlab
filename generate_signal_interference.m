% Function: generate_signal_interference
% Generates various test signals for anti-interference test
% Input: the interference flag
% Output: the test signal

function [Signal] = generate_signal_interference(tag)

global f0 fs;
global  fundamental_mag fundamental_pha DDC_mag DDC_time_con;
global  DDC_mag_pri DDC_time_con_pri;
global  aliasing_mag aliasing_phase aliasing_fre frequency_modulation depth_modulation snr;
       
sampling_number = fs / f0;   % the number of sampling points of a cycle
fs=sampling_number * 50;   % sampling frequency
Ts = 1 / fs;   % sampling period

time_con = 5*sampling_number;   % time constant of DDC

% signal sampling point after fault
if tag==7 % to reflect the power oscillation, a longer signal is generated
    n_beforefault = 1 : 10*sampling_number-1;   % signal sampling point before fault
    num_period=105;
    n_afterfault = 10*sampling_number : num_period*sampling_number-1;
else
    n_beforefault = 1 : 3*sampling_number-1;   % signal sampling point before fault
    n_afterfault = 3*sampling_number : 15*sampling_number-1;
end

% generate test signal
Signal_beforefault = 0.1 * cos(2*pi*50*n_beforefault*Ts - pi/3);

% The corresponding signal is generated according to the tag
switch tag
    case 1   % 1. Single DDC test
        % obtains magnitude and time constant of primary DDC from the basic workspace
        % converts the time constant to a sampling point representation
        % 100 ms convert to 5*sampling_number
        time_con_tans = 5*sampling_number / 100 * DDC_time_con;
        Signal_afterfault = fundamental_mag*cos(2*pi*f0*n_afterfault*Ts +fundamental_pha)...
            + DDC_mag * exp(-(n_afterfault-3*sampling_number) / time_con_tans);
        Signal = [Signal_beforefault, Signal_afterfault];
        return;

    case 2   % 2. multiple DDCs test
        % obtains magnitude and time constant of primary DDC from the basic workspace
        % converts the time constant to a sampling point representation
        time_con_tans_pri = 5 * sampling_number / 100 * DDC_time_con_pri;
        % obtains magnitude and time constant of primary DDC from the basic workspace
        DDC_mag_sub = evalin('base', 'DDC_mag_sub');
        DDC_time_con_sub = evalin('base', 'DDC_time_con_sub');
        time_con_tans_sub = 5 * sampling_number / 100 * DDC_time_con_sub;   % convert time constant

        Signal_afterfault = fundamental_mag*cos(2*pi*f0*n_afterfault*Ts +fundamental_pha)...
            + DDC_mag_pri * exp(-(n_afterfault-3*sampling_number) / time_con_tans_pri)...
            + DDC_mag_sub * exp(-(n_afterfault-3*sampling_number) / time_con_tans_sub);
        Signal = [Signal_beforefault, Signal_afterfault];
        return;


    case 3   % 3. noise test
        % converts the time constant to a sampling point representation
        % 100 ms convert to 5*sampling_number
        time_con_tans = 5*sampling_number / 100 * DDC_time_con;
        Signal_afterfault = fundamental_mag*cos(2*pi*f0*n_afterfault*Ts +fundamental_pha)...
            + DDC_mag * exp(-(n_afterfault-3*sampling_number) / time_con_tans);
        %Signal_afterfault = awgn(Signal_afterfault, snr, 'measured');
        Signal_afterfault = add_awgn(Signal_afterfault, snr);
        Signal = [Signal_beforefault, Signal_afterfault];
        return;


    case 4   % 4. harmonic test
        % converts the time constant to a sampling point representation
        % 100 ms convert to 5*sampling_number
        time_con_tans = 5*sampling_number / 100 * DDC_time_con;

        % random generation of harmonic order and phase
        har_order1 = randi([2 10], 1, 3);
        har_order2 = randi([11 16], 1, 3);
        har_phase = unifrnd(0, 2*pi, 1, 6);

        Signal_afterfault = fundamental_mag*cos(2*pi*f0*n_afterfault*Ts +fundamental_pha)...
            + DDC_mag * exp(-(n_afterfault-3*sampling_number) / time_con_tans)...
            + 0.05*fundamental_mag*cos(2*pi*har_order1(1)*f0*n_afterfault*Ts+har_phase(1))...
            + 0.05*fundamental_mag*cos(2*pi*har_order1(2)*f0*n_afterfault*Ts + har_phase(2))...
            + 0.05*fundamental_mag*cos(2*pi*har_order1(3)*f0*n_afterfault*Ts + har_phase(3))...
            + 0.07/3*fundamental_mag*cos(2*pi*har_order2(1)*f0*n_afterfault*Ts + har_phase(4))...
            + 0.07/3*fundamental_mag*cos(2*pi*har_order2(2)*f0*n_afterfault*Ts + har_phase(5))...
            + 0.07/3*fundamental_mag*cos(2*pi*har_order2(3)*f0*n_afterfault*Ts + har_phase(6));
        Signal = [Signal_beforefault, Signal_afterfault];
        return;

    case 5   % 5. inter-harmonic test

        %fundamental_mag = evalin('base','fundamental_mag');
        %fundamental_pha = evalin('base','fundamental_pha');
        %DDC_mag = evalin('base','DDC_mag');
        %DDC_time_con = evalin('base','DDC_time_con');
        % converts the time constant to a sampling point representation
        % 100 ms convert to 5*sampling_number
        time_con_tans = 5*sampling_number / 100 * DDC_time_con;

        min_fre = evalin('base','min_fre');
        max_fre = evalin('base','max_fre');
        % generating random interharmonic orders
        inter_fre = randi([min_fre, max_fre], 1);
        % check and adjust the interval
        % the difference between any two orders should be greater than
        % interharmonic orders cannot be a multiple of 50
        for i = 2:10
            value = randi([min_fre, max_fre], 1);
            while any(abs(inter_fre - value) < 1) || mod(value, 50) == 0
                value = randi([min_fre, max_fre], 1);
            end
            inter_fre(i) = value;
        end
        inter_mag = unifrnd(0, 0.01, 1,10)*fundamental_mag;
        inter_phase = unifrnd(0, 2*pi, 1, 10);

        Signal_afterfault = fundamental_mag*cos(2*pi*f0*n_afterfault*Ts +fundamental_pha)...
            + DDC_mag * exp(-(n_afterfault-3*sampling_number) / time_con_tans);
        % generate fault currents containing interharmonics
        for inter_order = 1 : length(inter_fre)
            Signal_afterfault = Signal_afterfault + inter_mag(inter_order) * cos(2*pi...
                *inter_fre(inter_order) * n_afterfault*Ts + inter_phase(inter_order));
        end
        Signal = [Signal_beforefault, Signal_afterfault];
        return;


    case 6   % 6. signal aliasing

        %aliasing_fre = evalin('base','aliasing_fre');
        %fundamental_mag = evalin('base','fundamental_mag');
        %fundamental_pha = evalin('base','fundamental_pha');
        %aliasing_mag = evalin('base','aliasing_mag');
        %aliasing_phase = evalin('base','aliasing_phase');
        %aliasing_fre = evalin('base','aliasing_fre');

        Signal_afterfault = fundamental_mag*cos(2*pi*f0*n_afterfault*Ts + fundamental_pha) ...
            + 1*exp(-(n_afterfault-3*sampling_number) / time_con)...
            + aliasing_mag * cos(2*pi*aliasing_fre*n_afterfault*Ts + aliasing_phase);
        Signal = [Signal_beforefault, Signal_afterfault];
        return;

    case 7   % 7. power oscillation
        % Liu Hao, Li Jue, Bi Tianshu, etal. An Adaptive Synchrophasor
        % Measurement Method[J].
        %fundamental_mag = evalin('base','fundamental_mag');
        %fundamental_pha = evalin('base','fundamental_pha');
        %DDC_mag = evalin('base','DDC_mag');
        %DDC_time_con = evalin('base','DDC_time_con');
        %frequrncy_modulation=evalin('base','frequency_modulation');
        k_modulation =depth_modulation; %  amplitude modulation factor

        har_order = randi([2 10], 1, 1);
        inter_mag = unifrnd(0, 0.002, 1,1);
        inter_fre = randi([100, 1600], 1);
        har_phase = unifrnd(0, 2*pi, 1, 2);

        f1=f0-k_modulation*frequency_modulation*sin(2*pi*frequency_modulation*n_afterfault*Ts);
        delta_f=-k_modulation*frequency_modulation*sin(2*pi*frequency_modulation*n_afterfault*Ts);
        time_con_tans = 5*sampling_number / 100 * DDC_time_con;
        Signal_afterfault = fundamental_mag*(1+k_modulation*cos(2*pi*frequency_modulation*n_afterfault*Ts))...
            .* cos(2*pi*f0.*n_afterfault*Ts +2*pi*delta_f*Ts+ fundamental_pha + k_modulation*cos(2*pi*frequency_modulation*n_afterfault*Ts-pi))...
            + DDC_mag * exp(-(n_afterfault-10*sampling_number) / time_con_tans)...
            + 0.05 * (1+k_modulation*cos(2*pi*frequency_modulation*n_afterfault*Ts))...
            .* cos(2*pi*har_order*f1.*n_afterfault*Ts+ har_phase(1) + k_modulation*cos(2*pi*frequency_modulation*n_afterfault*Ts-pi))...
            + inter_mag * (1+k_modulation*cos(2*pi*frequency_modulation*n_afterfault*Ts))...
            .* cos(2*pi*inter_fre * n_afterfault*Ts + har_phase(2) + k_modulation*cos(2*pi*frequency_modulation*n_afterfault*Ts-pi));
        Signal = [Signal_beforefault, Signal_afterfault];
        return;

    otherwise
        return;
end

end
