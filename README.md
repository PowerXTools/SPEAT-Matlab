# Comprehensive Evaluation Toolbox of Synchronous Phasor Estimation Algorithm for Anti-Decaying DC Component

## Authors

Zhang Hengxu, zhanghx@sdu.edu.cn
Qu Yifan, qyifansdu@163.com
School of Electrical Engineering, Shandong University, Jinan, 250061, Shandong Prov. China

## Project Background

The presence of a decaying DC component (DDC) in signals can significantly impact the accuracy of phasor estimation algorithms. Although numerous anti-DDC phasor estimation algorithms have been developed, there is still a lack of efficient software for testing these algorithms. With the large-scale integration of renewable energy sources and the connection of flexible loads, electrical signals are exhibiting increasingly complex spectral characteristics, high noise levels, and dynamic behaviors. Existing evaluation methods are no longer sufficient to address the signal morphology of emerging power systems. To enhance the efficiency of algorithm testing, a comprehensive platform called SPEAT has been established for testing anti-DDC phasor estimation algorithms.

## Main Functions

- SPEAT is an open-source comprehensive testing software for anti-DDC phasor estimation algorithms, designed for evaluating the performance of such algorithms.
- Currently, SPEAT offers six comparative algorithms, including DFT,ADFT[^1],TDFT[^2],DDFT[^3],DLSE[^4],Prony[^5]与IDFT[^6]along with algorithm import interfaces.
- SPEAT supports resistance against interference, sensitivity, and dynamic performance testing and can add additional testing as per specific requirements.

  1. Interference Resistance Performance Testing：
     - [x] Basic signal testing
     - [x] Multiple DDCs resistance testing
     - [x] Noise resistance testing
     - [x] Harmonics resistance testing
     - [x] Inter-harmonics resistance testing
     - [x] Signal alising resistance testing
  2. Sensitivity Testing：
     - [x] Test for sensitivity of time constant
     - [x] Test for sensitivity of frequency offset
     - [x] Test for sensitivity of sampling frequency
     - [x] Test for sensitivity of SNR
  3. Dynamic Performance Testing
     - [x] Rise time
     - [x] Settling time
     - [x] Computation time
  4. Algorithm Comprehensive Evaluation

     - [x] Super efficiency data envelopment analysis
  5. Simulation and measured signal Testing
- SPEAT is capable of significantly enhancing algorithm testing efficiency and serves as a dependable research and educational tool. We encourage your participation in further advancing and refining the testing platform.

## Installation and Usage Instructions

Copy and run.

Use two flags(flag1 and flag2) to select test contingency:

1. ① to import and select an algorithm for the calculation area, users can import and choose the algorithms to be tested (see Algorithm Code Writing Guidelines for algorithm code writing considerations).
2. ② to select the testing phase and input parameters, users should enter appropriate parameters in the respective testing items.
3. ③ is the test result display area, which shows the algorithm's magnitude, phase estimation results, and the maximum error after algorithm stabilization.

**Note：** 

- To ensure that the estimated results are easily distinguishable, the number of tested algorithms should not exceed six.
- The magnitude of the fundamental component before and after the fault is 0.1 per unit. The phase of the fundamental component before the fault is &pi;/2 rad。
- The phase of the fundamental component after the fault is between -&pi; and 0。
- In harmonics resistance testing, according to the IEEE-519 standard[^7],three harmonic components are randomly selected in each of the harmonic intervals such as 2-10, 11-16, and so on. The test signal amplitudes are set based on the maximum harmonic current distortion limit, and the phases are randomly chosen.
- In Inter-harmonics resistance testing, 10 sets of frequency components are randomly generated within the user-input frequency range. Their amplitudes are randomly selected within the 0-0.2 p.u. range, and their phases are also randomly chosen.

## Algorithm Code Writing Guidelines

- The algorithm is only compatible with being written in the form of MATLAB functions, and it requires that the file names must match the function names.
- The function needs to have three inputs, which are the test signal, system rated frequency, and sampling frequency.
- The function should have three outputs, which are the estimated magnitude,the estimated phase, and the number of samples beyond one cycle required for the algorithm.
- The number of samples beyond one cycle required for the algorithm (referred to as 'delay' in the sample code) should be manually set based on the algorithm's principles.

To assist in writing the algorithm, here is an example code for the DFT.

```MATLAB
% Function: DFT
% Input: test signal
% Output: the estimated magnitude, the estimated phase angle, sampling number beyond one cycle

function [Mag_signal_DFT,Phase_signal_DFT,sampling_number_beyond] = DFT(Signal)

f0 = evalin('base','f0');
fs = evalin('base','fs');

 sampling_number = ceil(fs / f0);   % obtain the sampling number in one cycle

 signal_length = ceil(12*sampling_number);   % length of test signal
 Signal_DFT = zeros(1,signal_length);   % preset phasor length to improve computing efficiency
 Mag_signal_DFT = zeros(1,signal_length);   % Preset magnitude length
 Phase_signal_DFT = zeros(1,signal_length);   % Preset phase angle length

 m = 0:sampling_number-1;
 Rotated_factor = exp(-1i*2*pi*m/sampling_number);
 
 % body of DFT 
 for window = 1:signal_length
    % calculate phasors and their magnitudes and phase angles
    Signal_DFT(window) = sum(Signal(window+m).*Rotated_factor) * 2 / sampling_number;
    Mag_signal_DFT(window) = abs(Signal_DFT(window));
    Phase_signal_DFT(window) = rem(angle(Signal_DFT(window))-2*pi*(window+sampling_number)...
                       *(f0/50) / sampling_number , pi);
 end

 sampling_number_beyond=0;   % sampling number beyond one cycle

end
```

## The Architecture of SPEAT (Matlab Version)

SPEAT V1.0 is completely developed in the MATLAB environment, mainly including three parts: the GUI visualization operation interface, the SPEAT kernel, and the Runtime execution environment. SPEAT V1.0 is completely developed in the MATLAB environment, mainly including three parts: the GUI visualization operation interface, the SPEAT kernel, and the Runtime execution environment. The algorithm selection module provides various classic algorithms and algorithm import interfaces, while the test selection module offers various types of numerical signal tests, simulation, and real-measurement signal tests for selection, with parameters input in dialog box format. The test selection module is linked to the SPEAT kernel, driving the execution of test algorithms through numerical signal or format-converted simulation and real-measurement signals, with execution results displayed on the visualization interface after data processing. After numerical signal testing is completed, users can quantify the performance of algorithms using the Supper Efficiency Data Envelopment Analysis (SE-EDA) efficiency data envelope analysis tool.



## The references for the above algorithms

[^1]: M. R. Dadash Zadeh and Z. Zhang, “A new DFT-based current phasor estimation for numerical protective relaying,” IEEE Trans. Power Del., vol. 28, no. 4, pp. 2172–2179, Oct. 2013, doi: 10.1109/TPWRD.2013.2266513.

[^2]: S. Afrandideh, M. R. Arabshahi, and S. M. Fazeli, “Two modi-fied DFT‐based algorithms for fundamental phasor estimation,” IET Gener. Transm. Distrib., vol. 16, no. 16, pp. 3218–3229, Aug. 2022, doi: 10.1049/gtd2.12516.

[^3]: H. Yu, Z. Jin, H. Zhang, and V. Terzija, “A phasor estimation al-gorithm robust to decaying DC component,” IEEE Trans. Power Del., vol. 37, no. 2, pp. 860–870, Apr. 2022, doi: 10.1109/TPWRD.2021.3073135.

[^4]: J. K. Hwang and C. S. Lee, “Fault current phasor estimation be-low one cycle using Fourier analysis of decaying DC compo-nent,” IEEE Trans. Power Del., vol. 37, no. 5, pp. 3657–3668, Oct. 2022, doi: 10.1109/TPWRD.2021.3134086.

[^5]: Q. Zhang, X.Y. Bian, X,Y. Xu, R.M. Huang, H.E. Li, “Research on factors influencing subsynchronous oscillation damping characteristics based on SVD-Prony and principal component regression,” J. Electr. Eng. Technol., vol. 37 no. 17, pp. 4364–4376, Sep. 2022, doi: 10.19595/j.cnki.1000-6753.tces.211085.

[^6]: B. Jafarpisheh, S. M. Madani, and S. Jafarpisheh, “Improved DFT-based phasor estimation algorithm using down-sampling,” IEEE Trans. Power Del., vol. 33, no. 6, pp. 3242–3245, Dec. 2018, doi: 10.1109/TPWRD.2018.2831005.

[^7]: IEEE Standard for Harmonic Control in Electric Power Systems, IEEE Standard 519, 2022.