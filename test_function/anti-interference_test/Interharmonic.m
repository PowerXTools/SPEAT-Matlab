% Function: Interharmonic
% Inter-harmonic interference test
% Input: Magnitude and phase of fundamental component, Magnitude and time constant of DDC
% Input: Upper and lower limits of interharmonic frequencies
% Output: The measured phasor, measuring error, TVE

function [Phasor,Max_error,Max_TVE] = Interharmonic(fundamental_mag,fundamental_pha,...
                    DDC_mag,DDC_time_con,min_fre,max_fre)

num_alg_select = evalin('base','num_alg_select');
name_alg_select = evalin('base','name_alg_select');

tag=5; % anti-interharmonics test,marked 5
answer{1} = fundamental_mag;
answer{2} = fundamental_pha;
answer{3} = DDC_mag;
answer{4} = DDC_time_con;
answer{5} = min_fre;
answer{6} = max_fre;

% Check whether the user input meets the requirements
if isempty(answer) || isempty(answer{1}) || isempty(answer{2}) || isempty(answer{3})...
        || isempty(answer{4}) || isempty(answer{5}) || isempty(answer{6})
    error('Missing input');
end

% Determine whether the input amplitude and time constant are reasonable
if fundamental_mag<=0
    error("The magnitude of fundamental frequency cannot be less than zero");
end
if fundamental_pha > 0 || fundamental_pha < -3.14
    error("The phase of fundamental component must be between -3.14 and 0");
end
if DDC_mag<=0
    error("The initial magnitude of the DDC cannot be less than zero");

end
if DDC_time_con<=0
    error("The time constant must be greater than zero");

end
% Import the time constant and magnitude into the workspace
assignin("base","fundamental_mag",fundamental_mag);
assignin("base","fundamental_pha",fundamental_pha);
assignin("base","DDC_mag",DDC_mag);
assignin("base","DDC_time_con",DDC_time_con);

% Determine whether the maximum and minimum frequencies meet the requirements
if min_fre<0 || min_fre>=max_fre
    error("Please enter the correct range of interharmonic");
else
    % Import the intermediate harmonic range into the workspace
    assignin("base","min_fre", min_fre);
    assignin("base","max_fre", max_fre);
    
    % generate test signal
    test_signal=generate_signal_interference(tag);
    % execute the algorithms
    [Phasor, delay] = execute_algorithm_main(test_signal,name_alg_select,tag);
    % get the maximum error
    [Max_error,Max_TVE]=compute_max_error(name_alg_select,Phasor,delay,tag);

end

end

