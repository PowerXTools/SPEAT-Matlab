% Function: Basic_Signal
% Basic signal test
% Input: Magnitude and phase of fundamental component, Magnitude and time constant of DDC
% Output: The measured phasor, measuring error, TVE

function [Phasor,Max_error,Max_TVE] = Basic_Signal(fundamental_mag,fundamental_pha,DDC_mag,DDC_time_con)

global name_alg_select;

tag=1; % basic signal test, marked 1
answer{1} = fundamental_mag;
answer{2} = fundamental_pha;
answer{3} = DDC_mag;
answer{4} = DDC_time_con;

% Check whether the user input meets the requirements
is_unqualified  = check_input(answer);

if is_unqualified ==1
    return
    
else
    % Import the time constant and magnitude into the workspace
    assignin("base","fundamental_mag",fundamental_mag);
    assignin("base","fundamental_pha",fundamental_pha);
    assignin("base","DDC_mag",DDC_mag);
    assignin("base","DDC_time_con",DDC_time_con);
    
    % generate test signal
    test_signal=generate_signal_interference(tag); % generate test signal
    % execute the algorithms
    [Phasor, delay] = execute_algorithm_main(test_signal,name_alg_select,tag);
    % get the maximum errors
    [Max_error,Max_TVE]=compute_max_error(name_alg_select,Phasor,delay,tag);

end

end

