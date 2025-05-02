clc;
clear;
%% initialize
% Gets the path to the current folder
folder_path = pwd;
assignin("base","folder",folder_path);

% Add the path to the folder where the child function resides
addpath(fullfile(folder_path,'code\generate_signal'));
addpath(fullfile(folder_path,'code\execute_algorithm'));
addpath(fullfile(folder_path,'code\compute_max_error'));
addpath(fullfile(folder_path,'code\generate_dlg'));
addpath(fullfile(folder_path,'code\check'));
addpath(fullfile(folder_path,'code\computation_comprehensive_quantitative'));
addpath(fullfile(folder_path,'code\comtomat'));
addpath(fullfile(folder_path,'code\test_function\anti-interference_test'));
addpath(fullfile(folder_path,'code\test_function\sensitivity_test'));
addpath(fullfile(folder_path,'code\test_function\dynamic_perfornace_test'));
addpath(fullfile(folder_path,'code\test_function\comprehensive_quantitative_evaluation'));
addpath(fullfile(folder_path,'code\test_function\COMTRADE-format_signal_test'));
addpath(fullfile(folder_path,'code\output'));
addpath(fullfile(folder_path,'algorithm_test'));

% Configure the system frequency f0, sampling frequency, etc., and store them in the workspace
f0 = 50;
fs = 64*f0;
sampling_number = fs/f0; % sampling number in a period
color_set = {'r','b','g','m','k',[0.85,0.33,0.10]}; % 
assignin("base","f0",f0);
assignin("base","fs",fs);
assignin("base","sampling_number",sampling_number);
assignin("base","color_set",color_set);

%% User input
run('Config');
num_alg_select = length(name_alg_select);

% Check whether the algorithm entered by the user exists
for num=1:num_alg_select
    exists = check_algorithm_select(name_alg_select{num},folder_path);
    if  ~exists  % If not exist, the user is prompted
        error(strcat(name_alg_select{num},"does not exist"));
    else
        
        if strcmp( name_alg_select{num}, 'DLS')
            % max_har_order = input("The DLS algorithm considers the maximum harmonic frequency as:");
            assignin("base","max_har_order",max_har_order);
        else
            continue;
        end
        
    end    
end

%% major function
switch (flag1)
    case 1 % anti_interference test
        switch (flag2)
            case 1 % basic signal test
                [Phasor,Max_error,Max_TVE] = Basic_Signal(fundamental_mag,fundamental_pha,...
                    DDC_mag,DDC_time_con);
            case 2 % multiple DDCs test
                [Phasor,Max_error,Max_TVE] = Multiple_DDCs(fundamental_mag,fundamental_pha,DDC_mag_pri,...
                    DDC_time_con_pri,DDC_mag_sub,DDC_time_con_sub);
            case 3 % noise test
                [Phasor,Max_error,Max_TVE] = Noise(fundamental_mag,fundamental_pha,...
                    DDC_mag,DDC_time_con,snr);
            case 4 % harmonic test
                [Phasor,Max_error,Max_TVE] = Harmonic(fundamental_mag,fundamental_pha,...
                    DDC_mag,DDC_time_con);
            case 5 % inter-harmonic test
                [Phasor,Max_error,Max_TVE] = Interharmonic(fundamental_mag,fundamental_pha,...
                    DDC_mag,DDC_time_con,min_fre,max_fre);
            case 6 % signal aliasing test
                [Phasor,Max_error,Max_TVE] = Signal_aliasing(fundamental_mag,fundamental_pha,...
                    DDC_mag,DDC_time_con,aliasing_mag,aliasing_phase,aliasing_fre);
            case 7 % power oscillation test
                [Phasor,Max_error,Max_TVE] = Power_oscillation(fundamental_mag,fundamental_pha,...
                    DDC_mag,DDC_time_con,frequency_modulation,depth_modulation);
            otherwise
                error("flag1 not more than 7");
        end

    case 2 % sensitivity test
        switch (flag2)
            case 1 % DDC time constant
                [Max_TVE, input_parameter] = DDC_timeconstant(fundamental_mag,fundamental_pha,...
                    DDC_mag,DDC_time_con);
            case 2 % power system frequency
                [Phasor,Max_error,Max_TVE] = System_frequency(fundamental_mag,fundamental_pha,...
                    DDC_mag,DDC_time_con,f0);
            case 3 % sampling frequency
                [Max_TVE, input_parameter] = Sampling_frequency(fundamental_mag,fundamental_pha,...
                    DDC_mag,DDC_time_con,fs_sensitivity);
            case 4 % noise SNR
                [Max_TVE, input_parameter] = Noise_SNR(fundamental_mag,fundamental_pha,...
                    DDC_mag,DDC_time_con,min_SNR,max_SNR);
            otherwise
                error("flag1 not more than 4");
        end

    case 3 % dynamic performance test
        switch (flag2)
            case 1 % rise time
                time = Rise_time(fundamental_mag,fundamental_pha,...
                    DDC_mag,DDC_time_con);
            case 2 % response time
                time = Response_time(fundamental_mag,fundamental_pha,...
                    DDC_mag,DDC_time_con);
            case 3 % computation time
                time = Computation_time(fundamental_mag,fundamental_pha,...
                    DDC_mag,DDC_time_con);
            otherwise
                error("flag1 not more than 3");
        end

    case 4 % comprehensive quantitative evaluation

        Comprehensive_benefit = Calculate_comprehensive_benefit(Inputindex_cell,Outputindex_cell);

    case 5 % COMTRADE-format signal test

        filepath = fullfile(folder_path,filepath);
        Phasor = COMTRADE_signal(filepath);

    otherwise
        error("flag1 not more than 5");
end

%%
% Output the result to a text file
switch (flag1)
    case 1
        output_interference(Phasor,Max_error,Max_TVE);
       
    case 2
        switch (flag2)
            case 1
                output_sensitivity(Max_TVE, input_parameter, flag2);
            case 2
                output_f0(Phasor,Max_error,Max_TVE);
            case 3
                output_sensitivity(Max_TVE, input_parameter, flag2);
            case 4
                output_sensitivity(Max_TVE, input_parameter, flag2);
        end
        
    case 3
        output_time(time,flag2);
        
    case 4
        output_benefit(Comprehensive_benefit);
        
    case 5
        output_COMTRADE(Phasor);
end
