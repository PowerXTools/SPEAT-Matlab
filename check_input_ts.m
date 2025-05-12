% Function: check_input_ts
% check whether the input is empty and meets requirements
% Input: app, the input
% Output: a sign of compliance


function is_unqualified = check_input_ts(answer)

is_unqualified = 0;

% Check whether the input has been made
if isempty(answer) 
    dlg=errordlg('Missing input','Error');
    resize_dlg(dlg,16);
    is_unqualified = 1;
    return
end

% Check whether the input is empty
[num_answer,~] = size(answer);   % Gets the number of inputs
for i = 1:num_answer
    if isempty(answer{i})
        dlg=errordlg('Missing input','Error');
        resize_dlg(dlg,16);
        is_unqualified = 1;
        return
    end
end

% Check whether the input parameters of power frequency and DDC are within the specified range
if answer{1}<=0
    dlg=errordlg("The magnitude of fundamental frequency cannot be less than zero","error");
    resize_dlg(dlg,30);
    is_unqualified = 1;
    return;
end
if answer{2} > 0 || str2double(answer{2}) < -3.14
    dlg=errordlg("The phase of fundamental component must be between -3.14 and 0","error");
    resize_dlg(dlg,34);
    is_unqualified = 1;
    return;
end
if answer{3}<=0
    dlg=errordlg("The initial magnitude of the DDC cannot be less than zero","error");
    resize_dlg(dlg,30);
    is_unqualified = 1;
    return;
end

end