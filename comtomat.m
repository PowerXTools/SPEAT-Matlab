% Function: comtomat
% The purpose of this function is to transform the COMTRADE-formated signal
% to mat-formated
% COMTRADE-formate signal test
% Input: folder
% Output: the test signal

function test_signal = comtomat(folder)
global fs;
%fs = evalin('base','fs');

pmu_num=1;    % Number of PMUs, corresponding to the following file names
PMUDataCell={'Wave1.cfg'};   % Data source: cfg file output by PSCAD recorder

currentFolder = fullfile(folder,'\COMTRADE_signal');
filefolder=char(strcat(currentFolder,'\Run_00001'));   % PSCAD46 Data storage location after simulation
% filefolder=char(strcat(currentFolder,'\data'));   % Data transfer location
% 
% copyfile(sourcefolder,filefolder,'f');   % Copy the file and copy the psacd recording file to the data folder 

for i=1:pmu_num
    
    data_single = ReadComtrade(filefolder,char(PMUDataCell(i)));   % reroute
    
    [M,~] = size(data_single.ProcessedData);
    Tm = zeros(M,1); 
    for j=1:M
        Tm(j) =j*1 / fs;
    end
    Data=[Tm,data_single.ProcessedData]';
    test_signal = Data(4,:);
end

rmpath('COMTRADE_signal')
rmdir('COMTRADE_signal', 's');

end
