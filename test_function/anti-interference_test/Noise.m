% Function: Basic_Signal
% Basic signal test
% Input: Magnitude and phase of fundamental component, Magnitude and time constant of DDC
% Input: the signal-to-noise ratio of noise
% Output: The measured phasor, measuring error, TVE

function [Phasor,Max_error,Max_TVE] = Noise(in_fundamental_mag,in_fundamental_pha,...
    in_DDC_mag,in_DDC_time_con,in_snr)

global num_alg_select name_alg_select;
global fundamental_mag fundamental_pha DDC_mag DDC_time_con snr;

tag=3; % anti-noise test,marked 3
answer{1} = in_fundamental_mag;
answer{2} = in_fundamental_pha;
answer{3} = in_DDC_mag;
answer{4} = in_DDC_time_con;

% Check whether the user input meets the requirements
is_unqualified  = check_input(answer);
if is_unqualified ==1
    return
else

    fundamental_mag = in_fundamental_mag;
    fundamental_pha = in_fundamental_pha;
    DDC_mag =in_DDC_mag;
    DDC_time_con = in_DDC_time_con;

    % snr=answer{5};
    % If an incorrect SNR is entered, a message is displayed
    if snr<=0
        error("The SNR must be greater than zero");
    end
    snr = in_snr;

    % generate test signal
    test_signal=generate_signal_interference(tag);

    % execute the algorithms
    [Phasor, delay] = execute_algorithm_main(test_signal,name_alg_select,tag);

    % get the maximum error   %参数传递有问题吧
    [Max_error,Max_TVE]=compute_max_error(name_alg_select,Phasor,delay,tag);


end

