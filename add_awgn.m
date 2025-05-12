function noisy_signal = add_awgn(signal, snr)
    % add_awgn: 向信号添加高斯白噪声
    % 输入:
    %   signal: 原始信号（向量）
    %   snr: 信噪比（以dB为单位）
    % 输出:
    %   noisy_signal: 添加噪声后的信号

    % 1. 计算输入信号的功率
    signal_power = mean(signal.^2);

    % 2. 根据SNR计算噪声功率
    snr_linear = 10^(snr / 10); % 将SNR从dB转换为线性值
    noise_power = signal_power / snr_linear;

    % 3. 生成高斯白噪声
    noise = sqrt(noise_power) * randn(size(signal));

    % 4. 将噪声添加到原始信号
    noisy_signal = signal + noise;
end
