% Function: compute_write_max_error
% Calculate the maximum error and write it into the table
% Input: app, the number of selected algorithm, the selected algorithm,
% phasor, sampling number beyond one cycle
% Output: no output


function [Max_error,Max_TVE]=compute_max_error(Alg_selec, Phasor, sampling_number_beyond,tag)

num_alg_selec = length(Alg_selec);

% receives the number of sampling points in one cycle from the workspace
%sampling_number = evalin('base','sampling_number');
%max_error_table1.Data=[];
Max_error=cell(num_alg_selec,2);
Max_TVE=cell(num_alg_selec,1);

for num=1:num_alg_selec

    [Max_error{num,1},Max_error{num,2},Max_TVE{num,1}]=obtain_max_error(Phasor{num,1},...
        Phasor{num,2},sampling_number_beyond{num,1},tag);
    
end

end

