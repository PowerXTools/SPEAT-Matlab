% Function: Signal_aliasing
% Signal aliasing test
% Input: Magnitude and phase of fundamental component, Magnitude and time constant of DDC
% Input: magnitude , phase and frequency of aliasing signal
% Output: The measured phasor, measuring error, TVE
% Sampling frequrency is 3200 Hz,signals above 1600Hz will cause signal aliasing.

function [Phasor,Max_error,Max_TVE] = Signal_aliasing(fundamental_mag,fundamental_pha,...
                    DDC_mag,DDC_time_con,aliasing_mag,aliasing_phase,aliasing_fre)

num_alg_select = evalin('base','num_alg_select');
name_alg_select = evalin('base','name_alg_select');

tag=6;
answer{1} = fundamental_mag;
answer{2} = fundamental_pha;
answer{3} = DDC_mag;
answer{4} = DDC_time_con;

% Check whether the user input meets the requirements
is_unqualified  = check_input(answer);
if is_unqualified ==1
    return
else

    assignin("base","fundamental_mag",fundamental_mag);
    assignin("base","fundamental_pha",fundamental_pha);
    assignin("base","DDC_mag",DDC_mag);
    assignin("base","DDC_time_con",DDC_time_con);

    % Determine whether the input magnitude and frequency are reasonable
    if aliasing_mag<=0
        error("The initial magnitude must be greater than zero");
    end
    if aliasing_fre<=1600
        error("Only signals above 1600Hz will cause signal aliasing");
    end
    assignin("base","aliasing_mag",aliasing_mag);
    assignin("base","aliasing_phase",aliasing_phase);
    assignin("base","aliasing_fre",aliasing_fre);

    test_signal=generate_signal_interference(tag);
    
    [Phasor, delay] = execute_algorithm_main(test_signal,name_alg_select,tag);

    % get the maximum error
    [Max_error,Max_TVE]=compute_max_error(name_alg_select,Phasor,delay,tag);


end

