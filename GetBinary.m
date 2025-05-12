function binary_matrix = GetBinary(decimal_vector, num_bits)
    % 将十进制数字转换为二进制矩阵
    binary_matrix = zeros(length(decimal_vector), num_bits);
    for i = 1:num_bits
        binary_matrix(:, i) = bitget(decimal_vector, i);
    end
end