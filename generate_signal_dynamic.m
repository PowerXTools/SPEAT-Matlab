% Function: generate_signal_dynamic
% Generates various test signals for dynamic performance test
% Input: the interference flag
% Output: the test signal

function [Signal] = generate_signal_dynamic(tag)

f0 = 50;
fs = 50*64;

sampling_number = fs / f0;
Ts = 1/fs;

n_beforefault = 1 : 3*sampling_number-1;
n_afterfault = 3*sampling_number : 15*sampling_number-1;

Signal_beforefault = 0.1 * cos(2*pi*50*n_beforefault*Ts - pi/3);

switch tag


    case 1   % Basic signals are used for basic indicator testing
        
        % Import the power frequency phasor amplitude, DDC amplitude 
        % and time constant from the basic workspace
        phasor_mag = evalin('base','phasor_mag');
        phasor_phase = evalin('base','phasor_phase');
        DDC_mag = evalin('base','DDC_mag');
        DDC_time_con = evalin('base','DDC_time_con');
        
        % converts the time constant to a sampling point representation
        % 100 ms convert to 5*sampling_number
        time_con_trans = 5*sampling_number / 100*DDC_time_con;
        Signal_afterfault = phasor_mag * cos(2*pi*f0*n_afterfault*Ts + phasor_phase)...
               +DDC_mag * exp(-(n_afterfault-2*sampling_number) / time_con_trans);
        Signal = [Signal_beforefault, Signal_afterfault];
        return;

    otherwise
        return;
end

