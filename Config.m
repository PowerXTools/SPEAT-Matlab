
% selected algorithms
name_alg_select = { 'DFT', 'DLS', 'ADFT' };
% DLS considers the maximum number of harmonics
max_har_order = 16; 

% flag1、flag2 for function selection
% The corresponding relationships to functions are listed at the end
flag1 = 1;
flag2 = 1;

%%
switch flag1
    case 1
        
        fundamental_mag = 1.0; % magnitude of fundamental component
        fundamental_pha = -1.5; % phase of fundamental component
        DDC_mag = 1; % magnitude of DDC
        DDC_time_con = 100; % time constant of DDC
        
        switch flag2
            case 2 
                DDC_mag_pri = 1;  % magnitude of primary DDC
                DDC_time_con_pri = 100; % time constant of primary DDC
                DDC_mag_sub = 0.3; % magnitude of subordinate DDC
                DDC_time_con_sub = 300; % time constant of subordinate DDC
            case 3
                snr = 30; % SNR of noise
            case 5
                min_fre = 100; % minimum frequency 
                max_fre = 2000; % maximum frequency
            case 6
                aliasing_mag = 0.1; % magnitude of aliasing signal
                aliasing_phase = -1; % phase of  aliasing signal
                aliasing_fre = 1975; % frequency of  aliasing signal
            case 7
                frequency_modulation = 0.5; % modulation frequency
                depth_modulation = 0.1; % modulation depth
        end
        
    case 2
        
        fundamental_mag = 1.0;
        fundamental_pha = -1.5;
        DDC_mag = 1;
        
        switch flag2
            case 1
                DDC_time_con = [5 25 50 100 150 200];
            case 2
                DDC_time_con = 100;
                f0 = 50.5; %  the system frequency
            case 3
                DDC_time_con = 100;
                fs_sensitivity = [800 1600 3200 6400 12800]; % sampling frequency
            case 4
                DDC_time_con = 100;
                min_SNR = 20; % minimum SNR
                max_SNR = 50; % maximum SNR
        end
        
    case 3 
        
        fundamental_mag = 1.0;
        fundamental_pha = -1.5;
        DDC_mag = 1;
        DDC_time_con = 100;
        
    case 4
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
        
    case 5
        % file path of COMTRADE-format signal
        filepath='demo\PSCAD_signal\Rank_00001';
            
end
    
%%
% flag1=1
    % flag2=1--Basic Signal
    % flag2=2--Multiple DDCs
    % flag2=3--Noise
    % flag2=4--Harmonic
    % flag2=5--Inter-harmonic
    % flag2=6--Signal aliasing
    % flag2=7--Power oscillation

% flag1=2
    % flag2=1--DDC time constant
    % flag2=2--Power system frequency
    % flag2=3--Sampling frequency
    % flag2=4--Noise SNR

% flag1=3
    % flag2=1--Rise time
    % flag2=2--Response time
    % flag2=3--Computation time

% flag1=4 
    % Comprehensive quantitative evaluation
% flag1=5
    % COMTRADE-format signal test
