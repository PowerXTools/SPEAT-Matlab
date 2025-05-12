% Function: Response_time
% Get response time
% Input: Magnitude and phase of fundamental component, Magnitude and time constant of DDC
% Output: The response time

function responsetime = Response_time(fundamental_mag,fundamental_pha,...
                    DDC_mag,DDC_time_con)

num_alg_select = evalin('base','num_alg_select');
name_alg_select = evalin('base','name_alg_select');
sampling_number = evalin('base','sampling_number');

tag=1;   % basic signal
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
    
    % generate test signal
    test_signal=generate_signal_dynamic(tag);
    
    % execute the algorithm
    Var=cell(num_alg_select,2); % num_alg_selec*2 The first column is the magnitude and the second column is the phase angle
    for num=1:num_alg_select
        [Var{num,1},Var{num,2}]=eval([name_alg_select{num},'(test_signal,tag);']);
    end

    % Determine the interval corresponding to the transient time
    low_num=zeros(num_alg_select,1);
    high_num=zeros(num_alg_select,1);
    for num=1:num_alg_select
        for number=1:length(test_signal)
            if Var{num,1}(end-sampling_number-number)>1.03*phasor_mag || Var{num,1}(end-sampling_number-number)<0.97*phasor_mag
                high_num(num)=length(Var{num,1})-sampling_number-number+1;
                break;
            end
        end
        for number=1:length(test_signal)
            if Var{num,1}(number)>0.1+1e-4 || Var{num,1}(number)<0.1-1e-4
                low_num(num)=number-1;
                break;
            end
        end
    end

    responsetime=cell(num_alg_select,1);
    for num=1:num_alg_select
        responsetime{num}=(high_num(num)-low_num(num))*20/64;
    end

end

end

