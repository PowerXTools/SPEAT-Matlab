function output_time(time, flag2)

global folder_path name_alg_select; 

filename = obtain_output_filename( );
folder_path_output = fullfile(folder_path, fullfile('output_test_result',filename));

num_alg_select = length(name_alg_select);

% Open output file
test_result = fopen(folder_path_output,'w');
% Output header
title_width=strcat('%-',num2str(num_alg_select*10-6),'s');
fprintf(test_result, title_width, ' ');
fprintf(test_result,'Test Results\n\n');

% Gets the longest column of data
maxLength = max(cellfun(@length, time));

% Output names of algorithms
for i = 1:num_alg_select
    fprintf(test_result, '%-8s', ' ');
    fprintf(test_result, '%-12s', name_alg_select{i});
end
fprintf(test_result, '\n\n');

%% output result
title_width_measurement=strcat('%-',num2str(num_alg_select*10-12),'s');
fprintf(test_result, title_width_measurement, ' ');
switch flag2
    case 1
        fprintf(test_result,'Rise time(ms)\n');
    case 2
        fprintf(test_result,'Response time(ms)\n');
    case 3
        fprintf(test_result,'Computation time(ms)\n');
end
fprintf(test_result, '\n');
% Fill shorter data columns to the same length
for i = 1:length(time)
    if length(time{i}) < maxLength
        time{i}(end+1:maxLength) = NaN; % Fill with NAN
    end
end
% Output data by row
    for j = 1:num_alg_select
            if isnan(time{j})
                fprintf(test_result, '%-20s', '');
            else
                fprintf(test_result, '%-7s', '');
                fprintf(test_result, '%-12f', time{j});
            end
    end
    fprintf(test_result, '\n');

% closed file
fclose(test_result);

end

