% Function: Sampling_frequency
% Sampling frequency sensitivity test
% Input: Magnitude and phase of fundamental component, Magnitude and time constant of DDC
% Output: TVE, sampling frequency

function [Max_TVE, input_parameter] = Sampling_frequency(fundamental_mag,fundamental_pha,...
    DDC_mag,DDC_time_con,fs_sensitivity)

global flag2 f0 fs plot_flag;

num_alg_select = evalin('base','num_alg_select');
name_alg_select = evalin('base','name_alg_select');
color_set = evalin('base','color_set');

tag = 3; % basic signal
answer{1} = fundamental_mag;
answer{2} = fundamental_pha;
answer{3} = DDC_mag;
answer{4} = DDC_time_con;
answer{5} =fs_sensitivity;

input_parameter = answer{5};

% Check whether the user input meets the requirements
is_unqualified  = check_input(answer);
if is_unqualified ==1
    return
else
    % Import the time constant and magnitude into the workspace
    assignin("base","fundamental_mag",fundamental_mag);
    assignin("base","fundamental_pha",fundamental_pha);
    assignin("base","DDC_mag",DDC_mag);
    assignin("base","DDC_time_con",DDC_time_con);
    
    if isempty(answer{5})==1  % Determines whether the cell array is empty
        dlg=errordlg('Please enter the sampling frequency','Error');
        Resize(app,dlg,20);
    elseif answer{5}>400
        fs_sensitivity=answer{5};
        
        num_test=length(fs_sensitivity);
        Var_error=cell(num_alg_select,2); % store the maximum error of magnitude and phase
        Max_TVE = cell(num_alg_select,1); % store the TVE of magnitude and phase
        
        for number=1:num_test
            assignin("base","fs",fs_sensitivity(number));
            
            % generate test signal
            test_signal=generate_signal_sensitivity(tag);
            delay=cell(num_alg_select,1);
            
            for num=1:num_alg_select
                [mag,pha,delay]=eval([name_alg_select{num},'(test_signal,tag);']);
                [Var_error{num,1}(number),Var_error{num,2}(number),Max_TVE{num,1}(number)]=...
                    obtain_max_error_fs(mag,pha,delay);
            end
        end
        if (plot_flag)
            figure(flag2+15) % draw the error graph
            set(gcf,'outerposition',[1 1 2036/2 900]);
            set(gcf,'color','w');
            set(gca, 'LineWidth',2);
            hold on;
            for num=1:num_alg_select
                plot(Max_TVE{num,1},color_set{num},'LineWidth',4)
            end
            hold off;
            set(gca,'looseinset',[0 0 0.08 0]);
            set(gca,'xlim',[1 length(fs_sensitivity)],'xtick',1:length(fs_sensitivity));
            set(gca,'XTicklabel',fs_sensitivity);
            % set(gca,'ylim',[-0.05,30]);
            % set(gca,'ytick',(0:5:30))
            % set(gca,'YTicklabel',[0:5:30]);
            xlabel('Sampling frequency (ms)');
            ylabel('TVE (%)');
            set(gca,'FontName','Times','FontSize',30,'FontWeight','bold');
            legend(name_alg_select,'FontSize',30,'Location','southEast','FontName','Times')
            write_figure_title();
            grid on;
            box on;
        end
        
    else
        dlg=errordlg('The sampling frequency must be greater than 400','Error');
        dlg.Visible="off";   % hide the dialog
        resize_dlg(dlg,24);
    end
    
    sampling_number = evalin('base','sampling_number');
    f0 = evalin('base','f0');
    fs = f0 * sampling_number;
    assignin("base","fs",fs);
    
end
end

