% Function: Calculate_comprehensive_benefit
% Calculate comprehensive benefit of algorithms
% Input: Input index matrix, output index matrix
% Output: Comprehensive benefits

function Comprehensive_benefit = Calculate_comprehensive_benefit(Inputindex_cell,Outputindex_cell)

num_alg_select = evalin('base','num_alg_select');
name_alg_select = evalin('base','name_alg_select');

% index conversion
[Inputindex_wight,Outputindex_wight] = convert_index(Inputindex_cell,Outputindex_cell,...
    name_alg_select,num_alg_select);  
% Use SE_EDA to calculate Comprehensive benefits
Comprehensive_benefit = SE_EDA(Inputindex_wight,Outputindex_wight);

end

