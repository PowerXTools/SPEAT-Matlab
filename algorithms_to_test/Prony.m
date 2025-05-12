% Function: Prony
%   Input: test signal
%   Output: the estimated magnitude, the estimated phase angle, sampling number beyond one cycle
% Ref: 
% ZHANG Qian, BIAN Xiaoyan, XU Xinyu, et al. Analysis of Influencing Factors on Damping Characteristics
% of Subsynchronous Oscillation Based on Singular Value Decomposition Prony and Principal Component Re-gression[J].
% Transactions of China Electrotechnical Society, 2022, 17(37):4364–4376.

function [Mag_signal_Prony, Phase_signal_Prony, sampling_number_beyond] = Prony(Signal,tag)

global f0 fs;

sampling_number = ceil(fs / f0);   % obtain the sampling number in one cycle
if tag==7   % length of test signal
    signal_length = ceil(103 * sampling_number);
else
    signal_length = ceil(12 * sampling_number);
end
Ts = 1 / fs;   % sampling period

Mag_signal_Prony = zeros(1, signal_length);   % preset magnitude length
Phase_signal_Prony = zeros(1, signal_length);   % preset phase angle length

data_length = sampling_number;   % Number of sampling points used

% body of SVD-Prony
for window = 1:signal_length

    Signal_one_window = Signal(window:window + data_length-1);

    Hankel_row = floor(data_length/2);
    Hankel_column = data_length - Hankel_row+1;
    Hankel = zeros(Hankel_row, Hankel_column);   % preset Hankel matrix
    yita = zeros(1, sampling_number);   % preset singular value growth rate
    
    %Signal_rec = zeros(1, data_length);

    % Noise suppression
    % constructing Hankel matrix
    % corresponding equation (1) in the reference
    for num=1:Hankel_row
        Hankel(num,:)=Signal_one_window(num:num + Hankel_column - 1);% Matrix Hankel
    end

    % corresponding equations (2) and (3) in the reference
    % The number of effective singular values is selected using the singular value growth rate
    [U1, S1, V1] = svd(Hankel);
    sigma1=diag(S1);
    % compute singular value growth rates and find the maximum
    for count = 1:(rank(S1))
        if count == length(sigma1)
            break
        end
        yita(count) = abs((sigma1(count+1) - sigma1(count)) / sigma1(count));
    end
    [~, max_yita_order] = max(yita);    % Obtain the sequence number of the maximum singular value growth rate

    % signal reconstruction
    % Update matrix Hankel matrix
    for i = max_yita_order+1 : length(sigma1)
        S1(i,i) = 0;
    end
    Hankel_new = U1*S1*V1';
    Signal_rec = Hankel_new(1,:);
    Signal_rec = [Signal_rec Hankel_new(2:Hankel_row, Hankel_column)'];

    % Determine the model order
    R = [];
    order_pre = Hankel_row;
    for i = 0:order_pre
        temp_list = [];
        for j = 0:order_pre
            temp_sum = 0;
            for n = order_pre:data_length-1
                temp_sum = temp_sum + Signal_rec(n-j+1) * Signal_rec(n-i+1);
            end
            temp_list = [temp_list, temp_sum];
        end
        R = [R; temp_list];
    end

    % SVD
    [~,S,~] = svd(R);
    sigma = diag(S);
    for count = 1:data_length/4
        if sigma(count) < 1e-5
            break
        end
    end
    order = count-1; % order of determination


    % Prony solution

    number = 2 * order;
    Signal_use = Signal_rec(1:2 * fix(Hankel_row))';
    Coeff_mat = zeros(Hankel_row, number);   % coefficient matrix
    for k = 1:number
        Coeff_mat(:,k) = Signal_use(k:Hankel_row-1+k);
    end
    Cons_mat = zeros(number, 1);   %constant matrix
    for k = 1:Hankel_row
        Cons_mat(k,:) = -Signal_use(number+k);
    end
    alfa_back = Coeff_mat \ Cons_mat;
    alfa_back = [alfa_back; 1];
    alfa = alfa_back(number+1:-1:1);

    Z = roots(alfa);
    freq = abs(log(Z)) / (2*pi*Ts);   % calculated frequrncy
    dec_factor = log(abs(Z)) / (2*pi*Ts);   % calculated decaying factor

    % build a Vandermond matrix, computational phasor
    Van = [];
    for k = 0:(2*Hankel_row-1)
        Van(k+1, :) = conj(Z') .^ k;
    end
    Signal_Prony = 2 * (Van \ Signal_use);

    [Frequency_symmetry, num_before_sort] = sort(freq); % frequency from small to sort
    num = 0;

    for k = 1:number-1
        if Frequency_symmetry(k) ~= Frequency_symmetry(k+1)  % remove conjugate terms
            continue;
        end
        num = num+1;
        val_ord = num_before_sort(k);     % extract a valid element ordinal number

        freq1(num) = freq(val_ord);
        dec_factor1(num) = dec_factor(val_ord);
        Mag1(num) = abs(Signal_Prony(val_ord));
        Phase1(num) = angle(Signal_Prony(val_ord));
    end

    % calculate magnitudes and phase angles
    Mag_signal_Prony(window) = Mag1(1);
    Phase_signal_Prony(window) = rem(Phase1(1)-2*pi*(window)...
        * (f0/50) / sampling_number, pi);
end

sampling_number_beyond = 0;   % sampling number beyond one cycle

end

