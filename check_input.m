% Function: check_input
% check whether the input is empty and meets requirements
% Input: app, the input
% Output: a sign of compliance


function is_unqualified = check_input(answer)

is_unqualified = 0;

% Check whether the input has been made
if isempty(answer) 
    is_unqualified = 1;
    disp('Missing input in Func check_input.');
    return;
end

% Check whether the input is empty
[num_answer,~] = size(answer);   % Gets the number of inputs
for i = 1:num_answer
    if isempty(answer{i})
        is_unqualified = 1;
    disp('Missing input in Func check_input.');
        return;
    end
end

% Check whether the input parameters of power frequency and DDC are within the specified range
if answer{1}<=0
    is_unqualified = 1;
    disp("The magnitude of fundamental frequency cannot be less than zero");
    return;
end
if answer{2} > 0 || answer{2} < -3.14
    is_unqualified = 1;
    disp("The phase of fundamental component must be between -3.14 and 0");
    return;
end
if answer{3}<=0
    is_unqualified = 1;
    disp("The initial magnitude of the DDC cannot be less than zero");
    return;
end
if answer{4}<=0
    is_unqualified = 1;
   disp("The time constant must be greater than zero");
    return;
end

end