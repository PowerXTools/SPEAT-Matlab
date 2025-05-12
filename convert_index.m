% Function: convert_index
% The purpose of this function is to convert output indicators into positive indicators, taking into account weights
% Input: tabular data for input and output indexes,name of algorithm
% selected, number of algorithm selected
% Output: Converted input/output indexes


function [Inputindex_wight,Outputindex_wight] = convert_index(Inputindex_cell,Outputindex_cell,name_alg_selec,num_alg_selec)

% convert to the numeric type
for row = 1:num_alg_selec+1
    for column = 1:4
        Inputindex(row,column) = str2double(Inputindex_cell(row,column));
    end
end
Wight_input = Inputindex(num_alg_selec+1,:);

for row = 1:num_alg_selec+1
    for column = 1:10
        Outputindex(row,column) = str2double(Outputindex_cell(row,column));
    end
end
Wight_output = Outputindex(num_alg_selec+1,:);

% weighting
for column = 1:4
    for row = 1:num_alg_selec
        Inputindex_wight(row,column) = Wight_input(column)*Inputindex(row,column);
    end
end

% the output indicator is converted to a positive indicator,
% weighting
for column = 1:10
    max_outputindex = max(Outputindex(1:end-1,column));
    min_outputindex = min(Outputindex(1:end-1,column));
    ave_outputindex = mean(Outputindex(1:end-1,column));
    for row = 1:num_alg_selec
        Outputindex_wight(row,column) = Wight_output(column)*ave_outputindex...
            *(1-(Outputindex(row,column)-min_outputindex)/(max_outputindex-min_outputindex+1e-10));
    end
end

end

