% Function: Multiple_DDCs
% Base signal containing multiple DDCs test
% Input: Magnitude and phase of fundamental component, Magnitude and time constant of DDC
% Input: Magnitude and time constant of subordinate DDC
% Output: The measured phasor, measuring error, TVE

function [Phasor,Max_error,Max_TVE] = Multiple_DDCs(fundamental_mag,fundamental_pha,DDC_mag_pri,...
                    DDC_time_con_pri,DDC_mag_sub,DDC_time_con_sub)

num_alg_select = evalin('base','num_alg_select');
name_alg_select = evalin('base','name_alg_select');

tag=2; % anti-multiple DDCs test,marked 2
answer{1} = fundamental_mag;
answer{2} = fundamental_pha;
answer{3} = DDC_mag_pri;
answer{4} = DDC_time_con_pri;

% Check whether the user input meets the requirements
is_unqualified  = check_input(answer);
if is_unqualified ==1
    return
else

    assignin("base","fundamental_mag",fundamental_mag);
    assignin("base","fundamental_pha",fundamental_pha);
    assignin("base","DDC_mag_pri",DDC_mag_pri);
    assignin("base","DDC_time_con_pri",DDC_time_con_pri);

%     DDC_mag_sub = answer{5};
%     DDC_time_con_sub = answer{6};
    % Determine whether the input amplitude and time constant are reasonable
    if DDC_mag_sub<0
        disp("The initial magnitude of subordinate DDC cannot be less than zero");
        return;
    end
    if DDC_time_con_sub<=0
        disp("The time constant of subordinate DDC must be greater than zero");
        return;
    end
    % Import the time constant and magnitude into the workspace
    assignin("base","DDC_mag_sub",DDC_mag_sub);
    assignin("base","DDC_time_con_sub",DDC_time_con_sub);

    % generate test signal
    test_signal=generate_signal_interference(tag);
    % execute the algorithms
    [Phasor, delay] = execute_algorithm_main(test_signal,name_alg_select,tag);
    % get the maximum error
    [Max_error,Max_TVE]=compute_max_error(name_alg_select,Phasor,delay,tag);

end

end

