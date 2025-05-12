% Function: execute_algorithm_main
% The purpose of this function is to execute the selected algorithms
% Input: app, test signal, the selected algorithms, the number of selected algorithms
% Output: the phasor, sampling number beyond one cycle


function [Phasor,sampling_number_beyond] = execute_algorithm_f0(test_signal,Alg_select,num_alg_select,tag)

% execute the algorithm and draw the image
Phasor=cell(num_alg_select,2); % num_alg_selec*2 The first column is the estimated amplitude and the second column is the estimated phase angle
sampling_number_beyond=cell(num_alg_select,1); % The algorithm uses additional sampling points on the basis of one periodic sampling points

for num=1:num_alg_select

    [Phasor{num,1},Phasor{num,2},sampling_number_beyond{num,1}]=eval([Alg_select{num},'(test_signal,tag);']);
    
end

