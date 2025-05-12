% Function: generate_signal_sensitivity
% Generates various test signals for sensitivity test
% Input: the interference flag
% Output: the test signal

function [Signal] = generate_signal_sensitivity(tag)

global f0 fs ;

sampling_number = fs / f0;
Ts = 1 / fs;

n_beforefault = 1 : 3*sampling_number-1;
n_afterfault = 3*sampling_number : 15*sampling_number-1;

% generate test signal
Signal_beforfault=0.1 * cos(2*pi*f0*n_beforefault*Ts - pi/2);

% The corresponding signal is generated according to the tag
switch tag

    case 1   % DDC time constant sensitivity test
    
        % Import DDC time constant from the basic workspace
        fundamental_mag = evalin('base','fundamental_mag');
        fundamental_pha = evalin('base','fundamental_pha');
        DDC_mag = evalin('base','DDC_mag');
        DDC_time_con = evalin('base','DDC_time_con');
        % converts the time constant to a sampling point representation
        % 100 ms convert to 5*sampling_number
        time_con_tans = 5*sampling_number / 100 * DDC_time_con;
        Signal_afterfault = fundamental_mag*cos(2*pi*f0*n_afterfault*Ts + fundamental_pha)...
            + DDC_mag*exp(-(n_afterfault-3*sampling_number) / time_con_tans);
        Signal = [Signal_beforfault, Signal_afterfault];
        return;

    case 2   % frequency deviation  
         
        sampling_number = 64;
        Ts = 1/(sampling_number * 50);
        n_beforefault = 1 : 3*sampling_number-1;
        n_afterfault = 3*sampling_number : 15*sampling_number-1;
        % generate test signal
        Signal_beforfault=0.1 * cos(2*pi*f0*n_beforefault*Ts - pi/2);
        
        fundamental_mag = evalin('base','fundamental_mag');
        fundamental_pha = evalin('base','fundamental_pha');
        DDC_mag = evalin('base','DDC_mag');
        DDC_time_con = evalin('base','DDC_time_con');
        % converts the time constant to a sampling point representation
        % 100 ms convert to 5*sampling_number
        time_con_tans = 5*sampling_number / 100 * DDC_time_con;
        Signal_afterfault = fundamental_mag * cos(2*pi*f0*n_afterfault*Ts + fundamental_pha)...
              + DDC_mag * exp(-(n_afterfault-3*sampling_number) / time_con_tans);
        Signal = [Signal_beforfault, Signal_afterfault];
        return;


    case 3   % sampling frequrency sensitivity test
     
        fundamental_mag = evalin('base','fundamental_mag');
        fundamental_pha = evalin('base','fundamental_pha');
        DDC_mag = evalin('base','DDC_mag');
        DDC_time_con = evalin('base','DDC_time_con');
        % converts the time constant to a sampling point representation
        % 100 ms convert to 5*sampling_number
        time_con_tans = 5*sampling_number / 100 * DDC_time_con;
        Signal_afterfault = fundamental_mag*cos(2*pi*f0*n_afterfault*Ts + fundamental_pha)...
            + DDC_mag * exp(-(n_afterfault-3*sampling_number) / time_con_tans);
        Signal = [Signal_beforfault, Signal_afterfault];
        return;


    otherwise
        return;

end

