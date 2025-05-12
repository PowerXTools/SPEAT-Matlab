clc;
clear;

global f0 fs sampling_number color_set  name_alg_select max_har_order plot_flag;
global fundamental_mag fundamental_pha DDC_mag DDC_time_con DDC_mag_pri;
global DDC_time_con_pri DDC_mag_sub DDC_time_con_sub snr aliasing_mag aliasing_phase aliasing_fre; 
global frequency_modulation depth_modulation folder_path flag1 flag2;

f0 = 50; % system frequency f0
fs = 64*f0; %sampling frequency
sampling_number = fs/f0; % sampling number in a period
color_set = {'r','b','g','m','k','y'}; %
name_alg_select = { 'IDFT', 'DFT', 'ADFT'};  % selected algorithms to be tested
max_har_order = 16;  % DLS considers the maximum number of harmonics

plot_flag = 1; %control plot or not

%% initialize
% Add current path and subpath to the matlab searching path
folder_path = pwd;
addpath(fullfile(folder_path));
addpath(fullfile(folder_path,'algorithms_to_test'));
addpath(fullfile(folder_path,'test_function\anti-interference_test'));
addpath(fullfile(folder_path,'test_function\sensitivity_test'));
addpath(fullfile(folder_path,'test_function\dynamic_perfornace_test'));
addpath(fullfile(folder_path,'test_function\comprehensive_quantitative_evaluation'));
addpath(fullfile(folder_path,'test_function\COMTRADE-format_signal_test'));
addpath(fullfile(folder_path,'output_function'));
addpath(fullfile(folder_path,'test_function'));


num_alg_select = length(name_alg_select);

% Check whether the algorithm entered by the user exists
for num=1:num_alg_select
    alg_folder = fullfile(folder_path,'algorithms_to_test');
    exists = check_algorithm_select(name_alg_select{num},alg_folder);
    if  ~exists  % If not exist, the user is prompted
        error(strcat(name_alg_select{num},"does not exist in ", alg_folder));
    end
end

%% testing flag setting; changing the flags to swith the testing contingency.
test_flag = [1 1; 1 2; 1 3;1 4;1 5;1 6;1 7; 2 1; 2 2; 2 3;2 4;3 1;3 2;3 3; 4 1; 5 1];
[total_test, col]  = size(test_flag);

program_execution_time = tic;
disp('Start Testing...');
for i=1:total_test
    flag1 = test_flag(i,1);
    flag2 = test_flag(i,2); 
    fprintf("Testing [%d %d]", flag1, flag2);
%     figure_num = i; %Plot the curves on different graph Windows
%% test contingence #1: anti_interference test
if (flag1 == 1)
    fundamental_mag = 1.0; % magnitude of fundamental component
    fundamental_pha = -1.5; % phase of fundamental component
    DDC_mag = 1; % magnitude of DDC
    DDC_time_con = 100; % time constant of DDC

    if (flag2 == 1) % basic signal test
        [Phasor,Max_error,Max_TVE] = Basic_Signal(fundamental_mag, fundamental_pha, DDC_mag, DDC_time_con);
    elseif (flag2 == 2)
        DDC_mag_pri = 1;  % magnitude of primary DDC
        DDC_time_con_pri = 100; % time constant of primary DDC
        DDC_mag_sub = 0.3; % magnitude of subordinate DDC
        DDC_time_con_sub = 300; % time constant of subordinate DDC

        [Phasor,Max_error,Max_TVE] = Multiple_DDCs(fundamental_mag,fundamental_pha,DDC_mag_pri,...
            DDC_time_con_pri,DDC_mag_sub,DDC_time_con_sub);
    elseif (flag2 == 3)  % noise test
        snr = 40; % SNR of noise

        [Phasor,Max_error,Max_TVE] = Noise(fundamental_mag,fundamental_pha,DDC_mag,DDC_time_con,snr);
    elseif (flag2 == 4)  % harmonic test
        [Phasor,Max_error,Max_TVE] = Harmonic(fundamental_mag,fundamental_pha,DDC_mag,DDC_time_con);
    elseif (flag2 == 5)  % inter-harmonic test
        min_fre = 100; % minimum frequency
        max_fre = 2000; % maximum frequency

        [Phasor,Max_error,Max_TVE] = Interharmonic(fundamental_mag,fundamental_pha,DDC_mag,DDC_time_con,min_fre,max_fre);
    elseif (flag2 == 6)  % signal aliasing test
        aliasing_mag = 0.1; % magnitude of aliasing signal
        aliasing_phase = -1; % phase of  aliasing signal
        aliasing_fre = 1975; % frequency of  aliasing signal

        [Phasor,Max_error,Max_TVE] = Signal_aliasing(fundamental_mag,fundamental_pha,...
            DDC_mag,DDC_time_con,aliasing_mag,aliasing_phase,aliasing_fre);
    elseif (flag2 == 7)  % power oscillation test
        frequency_modulation = 0.5; % modulation frequency
        depth_modulation = 0.1; % modulation depth

        [Phasor,Max_error,Max_TVE] = Power_oscillation(fundamental_mag,fundamental_pha,...
            DDC_mag,DDC_time_con,frequency_modulation,depth_modulation);
    end

    %output data to file
    output_interference(Phasor,Max_error,Max_TVE);
end

% sensitivity test
if(flag1 == 2)
    fundamental_mag = 1.0;
    fundamental_pha = -1.5;
    DDC_mag = 1;

    % sensitivity test
    if (flag2 == 1) % DDC time constant
        DDC_time_con = [5 25 50 100 150 200];

        [Max_TVE, input_parameter] = DDC_timeconstant(fundamental_mag,fundamental_pha, DDC_mag,DDC_time_con);

        output_sensitivity(Max_TVE, input_parameter, flag2);

    elseif (flag2 == 2) % power system frequency
        DDC_time_con = 100;
        f0 = 50.5; %  the system frequency

        [Phasor,Max_error,Max_TVE] = System_frequency(fundamental_mag,fundamental_pha, DDC_mag,DDC_time_con,f0);

        output_f0(Phasor,Max_error,Max_TVE);
    elseif (flag2 == 3) % sampling frequency
        DDC_time_con = 100;
        fs_sensitivity = [800 1600 3200 6400 12800]; % sampling frequency

        [Max_TVE, input_parameter] = Sampling_frequency(fundamental_mag,fundamental_pha,...
            DDC_mag,DDC_time_con,fs_sensitivity);

        output_sensitivity(Max_TVE, input_parameter, flag2);
    elseif (flag2 == 4) % noise SNR
        DDC_time_con = 100;
        min_SNR = 20; % minimum SNR
        max_SNR = 50; % maximum SNR

        [Max_TVE, input_parameter] = Noise_SNR(fundamental_mag,fundamental_pha,...
            DDC_mag,DDC_time_con,min_SNR,max_SNR);

        output_sensitivity(Max_TVE, input_parameter, flag2);
    end
end

% dynamic performance test
if(flag1 == 3)
    fundamental_mag = 1.0;
    fundamental_pha = -1.5;
    DDC_mag = 1;
    DDC_time_con = 100;

    if (flag2 == 1) % rise time
        time = Rise_time(fundamental_mag,fundamental_pha, DDC_mag,DDC_time_con);
    elseif (flag2 == 2) % response time
        time = Response_time(fundamental_mag,fundamental_pha, DDC_mag,DDC_time_con);
    elseif (flag2 == 3) % computation time
        time = Computation_time(fundamental_mag,fundamental_pha, DDC_mag,DDC_time_con);
    end

    output_time(time,flag2);
end

% comprehensive quantitative evaluation
if (flag1 == 4)
    if (flag2 == 1)
    % input index
    % colum: the length of data window, rise time, response time, computation time
    % the last row is weight
    Inputindex_cell = [
        {'0.2' }    {'1.33'}    {'0.37'}    {'1.98'};
        {'1.09'}    {'2.1' }    {'0.55'}    {'1.09'};
        {'0.37'}    {'4'   }    {'1.09'}    {'3.5' };
        {'0.1' }    {'0.1' }    {'0.1' }    {'0.1' };
        ] ;
    % outout index
    % column: error of basic signal、multipleDDCs、noise、harmonic、inter-harmonic、signal aliasing、
    % power oscillation、time constant、system frequency、sampling frequency
    % the last row is weight
    Outputindex_cell = [
        {'0.37'}    {'1.09'}    {'3.5'}    {'2.1' }    {'0.2' }    {'0.55'}    {'2.1' }    {'1.54'}    {'1.98'}    {'1.33'};
        {'3.65'}    {'1.33'}    {'0.2'}    {'0.37'}    {'1.09'}    {'1.98'}    {'4'   }    {'0.37'}    {'0.2' }    {'0.55'};
        {'0.2' }    {'0.55'}    {'2.1'}    {'3.5' }    {'1.33'}    {'0.2' }    {'2.54'}    {'4'   }    {'3.5' }    {'4'   };
        {'0.1' }    {'0.1' }    {'0.1'}    {'0.1' }    {'0.1' }    {'0.1' }    {'0.1' }    {'0.1' }    {'0.1' }    {'0.1' };
        ];

    Comprehensive_benefit = Calculate_comprehensive_benefit(Inputindex_cell,Outputindex_cell);

    output_benefit(Comprehensive_benefit);
    end
end

% COMTRADE-format signal test
if (flag1 == 5)
    if (flag2 == 1)
    % file path of COMTRADE-format signal
    filepath='demo\PSCAD_signal\Rank_00001';

    filepath = fullfile(folder_path,filepath);
    Phasor = COMTRADE_signal(filepath);

    output_COMTRADE(Phasor);
    end
end

end
elapsedTime = toc(program_execution_time); % 结束计时并返回耗时
disp(['program execution time: ', num2str(elapsedTime), ' s']);
disp('Testing Finished.');