% Function: Power_oscillation
% Power oscillation test
% Input: Magnitude and phase of fundamental component, Magnitude and time constant of DDC
% Input: modulation frequency, modulation depth
% Output: The measured phasor, measuring error, TVE

function [Phasor,Max_error,Max_TVE] = Power_oscillation(fundamental_mag,fundamental_pha,...
                    DDC_mag,DDC_time_con,frequency_modulation,depth_modulation)

num_alg_select = evalin('base','num_alg_select');
name_alg_select = evalin('base','name_alg_select');

tag=7;
answer{1} = fundamental_mag;
answer{2} = fundamental_pha;
answer{3} = DDC_mag;
answer{4} = DDC_time_con;

% Check whether the user input meets the requirements
is_unqualified  = check_input( answer);
if is_unqualified ==1
    return
else

    assignin("base","fundamental_mag",fundamental_mag);
    assignin("base","fundamental_pha",fundamental_pha);
    assignin("base","DDC_mag",DDC_mag);
    assignin("base","DDC_time_con",DDC_time_con);

    % Determine whether the inputs are reasonable
    if frequency_modulation<0.1 || frequency_modulation>2
        error("The modulation frequency must be between 0.1 and 2Hz");
    end
    assignin("base","frequency_modulation",frequency_modulation);

    if depth_modulation<0 || depth_modulation>0.2
        error("The modulation depth must be between 0 and 0.2p.u.");
    end
    assignin("base","depth_modulation",depth_modulation);
    
    % generate test signal
    test_signal=generate_signal_interference(tag);
    % execute the algorithms
    [Phasor, delay] = execute_algorithm_main(test_signal,name_alg_select,tag);
    % get the maximum error 
    [Max_error,Max_TVE]=compute_max_error(name_alg_select,Phasor,delay,tag);

end

