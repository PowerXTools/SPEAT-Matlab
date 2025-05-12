% Function: check_algorithm_select
% Check whether the algorithm entered by the user exists
% Input: Algorithm name, the path to the current folder
% Output: A sign that indicates whether the algorithm exists

function exists = check_algorithm_select(alg_name,folder)
% CHECK_ALGORITHM_SELECT 检查指定目录中是否存在指定文件
%   输入:
%       alg_name - 算法名
%       folder   - 要搜索的目录路径
%   输出:
%       exists    - 如果文件存在则不为0，不存在则为0

% 确保文件夹路径以文件分隔符结尾
if ~strcmp(folder(end), filesep)
    folder = [folder, filesep];
end

% 构建完整的文件路径，要增加".m"
filePath = fullfile(folder, alg_name+".m");

% 检查文件是否存在
exists = exist(filePath, 'file'); % 0-不存在;1-变量存在;2-是一个文件...

end

