% Function: Computation_time
% Get computation time
% Input: Magnitude and phase of fundamental component, Magnitude and time constant of DDC
% Output: The computation time

function compu_time = Computation_time(fundamental_mag,fundamental_pha,...
                    DDC_mag,DDC_time_con)

num_alg_select = evalin('base','num_alg_select');
name_alg_select = evalin('base','name_alg_select');
sampling_number = evalin('base','sampling_number');

tag=1; % basic signal
answer{1} = fundamental_mag;
answer{2} = fundamental_pha;
answer{3} = DDC_mag;
answer{4} = DDC_time_con;

% Check whether the user input meets the requirements
is_unqualified  = check_input(answer);
if is_unqualified ==1
    return
else
    phasor_mag=answer{1};
    phasor_phase=answer{2};
    DDC_mag=answer{3};
    DDC_time_con=answer{4};
    % Import the time constant and magnitude into the workspace
    assignin("base","phasor_mag",phasor_mag);
    assignin("base","phasor_phase",phasor_phase);
    assignin("base","DDC_mag",DDC_mag);
    assignin("base","DDC_time_con",DDC_time_con);

    % Generate progress bar
    Progress_bar=waitbar(0.1,'calculating...'); % progress bar
    
    % generate test signal
    test_signal=generate_signal_dynamic(tag);

    % gain computation time,calculate 10 times and take the average
    Var=cell(num_alg_select,2);
    compu_time=cell(num_alg_select,1);
    for num=1:num_alg_select
        tic;
        for count=1:10
            [Var{num,1},Var{num,2}]=eval([name_alg_select{num},'(test_signal,tag);']);
        end
        compu_time{num}=toc*1e6/10/12/sampling_number;
    end
    close(Progress_bar);
end

end
