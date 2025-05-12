% Function: SE_EDA
% The purpose of this function is to calculat the efficiency value using SE-EDA
% Input: converted input and output indexes
% Output: comprehensive benefit value

function eff = SE_EDA(Inputindex_wight,Outputindex)

format long

X=Inputindex_wight;   % input index
Y=Outputindex;   % output index

% extract the dimensions of the variable
[n, m] = size(X);
s = size(Y,2);

% create a storage matrix for solving variables
eff = nan(n, 1);   % comprehensive benefits
Eflag = nan(n, 2);

% Parameter preparation and linear programming process
for j=1:n

    % objective function
    f = [zeros(1,n), 1];
    % constraint condition
    X_SE=X';
    X_SE(:,j)=0;
    Y_SE=Y';
    Y_SE(:,j)=0;
    A = [ X_SE, -X(j,:)';
        -Y_SE, zeros(s,1)];
    b = [zeros(m,1);
        -Y(j,:)'];
    Aeq = [];
    beq = [];
    lb = zeros(1, n + 1);
    ub = [];
    % linprog solution
    [z, ~, exitflag] = linprog(f, A, b, Aeq, beq, lb, ub);
    if isempty(z)
        z = nan(n + 1, 1);
    end

    % extract calculation result
    theta = z(end);
    Eflag(j, 1) = exitflag;
    eff(j) = theta;
end

end

