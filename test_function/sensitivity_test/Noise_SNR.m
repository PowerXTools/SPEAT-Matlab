% Function: Noise_SNR
% Noise SNR sensitivity test
% Input: Magnitude and phase of fundamental component, Magnitude and time constant of DDC
% Input: minimum SNR, maximum SNR
% Output: TVE, range of SNR

function [Max_TVE, input_parameter] = Noise_SNR(fundamental_mag,fundamental_pha,...
                    DDC_mag,DDC_time_con,min_SNR,max_SNR)

global flag2 plot_flag;         
                
num_alg_select = evalin('base','num_alg_select');
name_alg_select = evalin('base','name_alg_select');
color_set = evalin('base','color_set');

tag = 3;

answer{1} = fundamental_mag;
answer{2} = fundamental_pha;
answer{3} = DDC_mag;
answer{4} = DDC_time_con;
answer{5} = min_SNR;
answer{6} = max_SNR;
input_parameter = min_SNR:max_SNR;

% Check whether the user input meets the requirements
is_unqualified  = check_input(answer);
if is_unqualified ==1
    return
else
    fundamental_mag=answer{1};
    fundamental_pha=answer{2};
    DDC_mag=answer{3};
    DDC_time_con=answer{4};
    % Import the time constant and magnitude into the workspace
    assignin("base","fundamental_mag",fundamental_mag);
    assignin("base","fundamental_pha",fundamental_pha);
    assignin("base","DDC_mag",DDC_mag);
    assignin("base","DDC_time_con",DDC_time_con);

    % Determine whether the input SNR is reasonable
    if min_SNR<0 || max_SNR<0 || min_SNR>=max_SNR
        dlg=errordlg('Please enter the correct SNR','Error');
        dlg.Visible="off";   % hide the dialog
        resize_dlg(dlg,20);
    else
        % Generate progress bar
        progress_bar = waitbar(0,'0%','Name','Calculating progress',...
            'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
        setappdata(progress_bar,'canceling',0);

        SNR=min_SNR:max_SNR;

        Var_error=cell(num_alg_select,2);
        Max_TVE=cell(num_alg_select,1);
        num_test=length(SNR);
        for number=1:num_test
            var_error=cell(num_alg_select,2);
            max_TVE=cell(num_alg_select,1);
            for num=1:num_alg_select
                Var_error{num,1}(end+1)=0;
                Var_error{num,2}(end+1)=0;
                Max_TVE{num,1}(end+1)=0;
            end
            assignin("base","snr", SNR(number));
            % Calculate 100 times and take the average
            for count=1:100
                num_progress_bar = 100*(number-1)/num_test+100*count/100/num_test;
                num_progress_bar = roundn(num_progress_bar,-1);
                bar_msg=['calculating... ',num2str(num_progress_bar),'%'];
                waitbar(num_progress_bar/100,progress_bar,bar_msg);
                if getappdata(progress_bar,'canceling')
                    delete(progress_bar);
                    return
                end
                
                test_signal=generate_signal_interference(tag); % generate test signal
                % calculate error
                for num=1:num_alg_select
                    [mag,pha,delay]=eval([name_alg_select{num},'(test_signal,tag);']);
                    [var_error{num,1}(number),var_error{num,2}(number),max_TVE{num,1}(number)]=...
                        obtain_max_error(mag,pha,delay,tag);
                end
                for num=1:num_alg_select
                    Var_error{num,1}=Var_error{num,1}+var_error{num,1}/100;
                    Var_error{num,2}=Var_error{num,2}+var_error{num,2}/100;
                    Max_TVE{num,1}=Max_TVE{num,1}+max_TVE{num,1}/100;
                end
            end
            
        end
        delete(progress_bar);
        
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
            set(gca,'xlim',[1 length(SNR)],'xtick',1:5:length(SNR));
            set(gca,'XTicklabel',(SNR(1):5:SNR(end)));
            % set(gca,'ylim',[-0.05,30]);
            % set(gca,'ytick',(0:5:30))
            % set(gca,'YTicklabel',[0:5:30]);
            xlabel('SNR (dB)');
            ylabel('TVE (%)');
            set(gca,'FontName','Times','FontSize',30,'FontWeight','bold');
            legend(name_alg_select,'FontSize',30,'Location','southEast','FontName','Times')
            write_figure_title();
            grid on;
            box on;
        end
    end
end
end
