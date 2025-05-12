% Function: COMTRADE_signal
% COMTRADE-format signal test
% Input: File path of COMTRADE signal
% Output: The measured phasor

function Phasor = COMTRADE_signal(filepath)

global folder_path

% folder_path = evalin('base','folder');
num_alg_select = evalin('base','num_alg_select');
name_alg_select = evalin('base','name_alg_select');

% Check whether the file name is the same as that of the imported file
if isequal(filepath,0)
    % If not exist, prompt import failed
    dlg = errordlg('Import failed','Error');
    resize_dlg(dlg,16);
    return
else
    % If exist, copy to 'SPEAT\comtomat'
%     RCOMTRADE_file_path.Value = filepath;
    savepath = fullfile(folder_path,'\COMTRADE_signal');
    copyfile(filepath, savepath);
end

% Convert the signal to mat format
addpath(savepath);
test_signal = comtomat(folder_path);

[Phasor,~] = execute_algorithm_COMTRADE(test_signal,name_alg_select,...
    num_alg_select,1);

end
