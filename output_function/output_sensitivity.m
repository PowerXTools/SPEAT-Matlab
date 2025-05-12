function output_sensitivity(Max_TVE, input_parameter, flag2)

global folder_path name_alg_select; 
filename = obtain_output_filename( );
folder_path_output = fullfile(folder_path, fullfile('output_test_result',filename));

num_alg_select = length(name_alg_select);

% Open output file
test_result = fopen(folder_path_output,'w');
% Output header
title_width=strcat('%-',num2str(num_alg_select*10-4),'s');
fprintf(test_result, title_width, ' ');
fprintf(test_result,'Test Results\n\n');

%% output result
title_width_measurement=strcat('%-',num2str(num_alg_select*10-4),'s');
fprintf(test_result, title_width_measurement, ' ');

fprintf(test_result, '%-20s\n', 'TVE(%)');
switch flag2
    case 1
        fprintf(test_result,'%-20s', 'Time constant(ms)');
    case 3
        fprintf(test_result,'%-20s', 'Sample frequency(Hz)');
    case 4
        fprintf(test_result,'%-20s', 'SNR(dB)');
end

% Output names of algorithms
for i = 1:num_alg_select
    fprintf(test_result, '%-2s', ' ');
    fprintf(test_result, '%-16s', name_alg_select{i});
end
fprintf(test_result, '\n');

for num=1:length(input_parameter)
    % Output variation parameter
    fprintf(test_result, '%-10f', input_parameter(num));

    % Output data by row
    for j = 1:num_alg_select
        if isnan(Max_TVE{j})
            fprintf(test_result, '%-20s', '');
        else
            fprintf(test_result, '%-8s', '');
            fprintf(test_result, '%-12f', Max_TVE{j}(num));
        end
    end
    fprintf(test_result, '\n');
end

% closed file
fclose(test_result);

end

