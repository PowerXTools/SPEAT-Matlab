function output_filename = obtain_output_filename( )

global  flag1 flag2;

if flag1 ==1
    
    if flag2 == 1
        output_filename = 'output_basic_signal_test.txt';
    elseif flag2 == 2
        output_filename = 'output_multiple_DDCs_test.txt';
    elseif flag2 == 3
        output_filename = 'output_noise_test_test.txt';
    elseif flag2 == 4
        output_filename = 'output_harmonic_test.txt';
    elseif flag2 == 5
        output_filename = 'output_interharmonic_test.txt';
    elseif flag2 == 6
        output_filename = 'output_signal_aliasing_test.txt';
    elseif flag2 == 7
        output_filename = 'output_power_oscillation_test.txt';
    end
    
elseif flag1 ==2
    
    if flag2 == 1
        output_filename = 'output_time_constant_sensitivity _test.txt';
    elseif flag2 == 2
        output_filename = 'output_system_frequency_sensitivity_test.txt';
    elseif flag2 == 3
        output_filename = 'output_sampling_frequency_sensitivity _test.txt';
    elseif flag2 == 4
        output_filename = 'output_SNR_sensitivity _test.txt';
    end
    
elseif flag1 ==3
    
    if flag2 == 1
        output_filename = 'output_rise_time _test.txt';
    elseif flag2 == 2
        output_filename = 'output_response_time_test.txt';
    elseif flag2 == 3
        output_filename = 'output_computation_time _test.txt';
    end
    
elseif flag1 ==4
    
    if flag2 == 1
        output_filename = 'comprehensive_quantitative_evaluation.txt';
    end
    
elseif flag1 ==5
    
    if flag2 == 1
        output_filename = 'COMTRADE_signal_test.txt';
    end
    
end

end

