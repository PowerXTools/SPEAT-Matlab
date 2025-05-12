function output_benefit(Comprehensive_benefit)

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

% Output names of algorithms
for i = 1:num_alg_select
    fprintf(test_result, '%-8s', ' ');
    fprintf(test_result, '%-12s', name_alg_select{i});
end
fprintf(test_result, '\n\n');

%% output result
% output comprehensive benifits
title_width_measurement=strcat('%-',num2str(num_alg_select*10-12),'s');
fprintf(test_result, title_width_measurement, ' ');
fprintf(test_result,'Comprehensive benefit\n');
fprintf(test_result, '\n');

% Output data by row
    for j = 1:num_alg_select
            if isnan(Comprehensive_benefit(j))
                fprintf(test_result, '%-20s', '');
            else
                fprintf(test_result, '%-7s', '');
                fprintf(test_result, '%-12f', Comprehensive_benefit(j));
            end
    end
    fprintf(test_result, '\n');

% closed file
fclose(test_result);

end

