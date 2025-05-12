function output_f0(Var, Max_error, Max_TVE)

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
maxLength = max(cellfun(@length, Var));

% Output names of algorithms
for i = 1:num_alg_select
    fprintf(test_result, '%-8s', ' ');
    fprintf(test_result, '%-12s', name_alg_select{i});
end
fprintf(test_result, '\n\n');

fprintf(test_result, title_width, ' ');
fprintf(test_result,'Maximum TVE(%%)\n');
for i = 1:length(name_alg_select)
    fprintf(test_result, '%-6s', ' ');
    fprintf(test_result, '%-14f', Max_TVE{i});
end
fprintf(test_result, '\n\n');

%% output result
% output maximum errors
title_width_error=strcat('%-',num2str(num_alg_select*10-18),'s');
fprintf(test_result, title_width_error, ' ');
fprintf(test_result,'Magnitude and phase errors(p.u.)\n');
for i = 1:num_alg_select
    fprintf(test_result, '%-10s', 'magnitude');
    fprintf(test_result, '%-10s', 'phase');
end
fprintf(test_result, '\n');
for i = 1:num_alg_select
    for num=1:2
        %fprintf(test_result, '%-6s', ' ');
        fprintf(test_result, '%-10f', Max_error{i,num});
    end
end
fprintf(test_result, '\n\n');

% Output phasor measurement results
title_width_measurement=strcat('%-',num2str(num_alg_select*10-12),'s');
fprintf(test_result, title_width_measurement, ' ');
fprintf(test_result,'Measurement results(p.u.)\n');
for i = 1:num_alg_select
    fprintf(test_result, '%-10s', 'magnitude');
    fprintf(test_result, '%-10s', 'phase');
end
fprintf(test_result, '\n');
% Fill shorter data columns to the same length
for i = 1:length(Var)
    if length(Var{i}) < maxLength
        Var{i}(end+1:maxLength) = NaN;
    end
end

% Output data by row
for i = 1:maxLength
    for j = 1:num_alg_select
        for num=1:2
            if isnan(Var{j,num}(i))
                fprintf(test_result, '%-10s', '');
            else
                fprintf(test_result, '%-10f', Var{j,num}(i));
            end
        end
    end
    fprintf(test_result, '\n');
end

% closed file
fclose(test_result);

end