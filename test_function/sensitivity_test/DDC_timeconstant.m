% Function: DDC_timeconstant
% DDC time constant sensitivity test
% Input: Magnitude and phase of fundamental component, Magnitude and time constant of DDC
% Output: TVE, time constant of DDC

function [Max_TVE, input_parameter] = DDC_timeconstant(fundamental_mag,fundamental_pha,...
                    DDC_mag,DDC_time_con)

global  flag2 plot_flag;                

num_alg_select = evalin('base','num_alg_select');
name_alg_select = evalin('base','name_alg_select');
color_set = evalin('base','color_set');

tag=1; % basic signal 
answer{1} = fundamental_mag;
answer{2} = fundamental_pha;
answer{3} = DDC_mag;
answer{4} = DDC_time_con;

input_parameter = answer{4};

% Check whether the user input meets the requirements
is_unqualified  = check_input_ts(answer);
if is_unqualified ==1
    return
else

    % Import the time constant and magnitude into the workspace
    assignin("base","fundamental_mag",fundamental_mag);
    assignin("base","fundamental_pha",fundamental_pha);
    assignin("base","DDC_mag",DDC_mag);

    if DDC_time_con>0

        num_test=length(DDC_time_con);
        Var_error=cell(num_alg_select,2); % store the maximum error of magnitude and phase
        Max_TVE = cell(num_alg_select,1); % store the TVE of magnitude and phase

        for number=1:num_test
            assignin("base","DDC_time_con", DDC_time_con(number));
            % generate test signal
            test_signal=generate_signal_sensitivity(tag); % generate test signal
            % generate maximum error
            for num=1:num_alg_select
                [mag,pha,delay]=eval([name_alg_select{num},'(test_signal,tag);']);
                [Var_error{num,1}(number),Var_error{num,2}(number),Max_TVE{num,1}(number),]=...
                    obtain_max_error(mag,pha,delay,tag);
            end
        end
        
        if (plot_flag)
            figure(flag2+14) % draw the error graph
            set(gcf,'outerposition',[1 1 2036/2 900]);
            set(gcf,'color','w');
            set(gca, 'LineWidth',2);
            hold on;
            for num=1:num_alg_select
                plot(Max_TVE{num,1},color_set{num},'LineWidth',4)
            end
            hold off;
            set(gca,'looseinset',[0 0 0.08 0]);
            set(gca,'xlim',[1 length(DDC_time_con)],'xtick',1:length(DDC_time_con));
            set(gca,'XTicklabel',DDC_time_con);
            % set(gca,'ylim',[-0.05,30]);
            % set(gca,'ytick',(0:5:30))
            % set(gca,'YTicklabel',[0:5:30]);
            xlabel('Time constant (ms)');
            ylabel('TVE (%)');
            set(gca,'FontName','Times','FontSize',30,'FontWeight','bold');
            legend(name_alg_select,'FontSize',30,'Location','southEast','FontName','Times')
            write_figure_title();
            grid on;
            box on;
        end
        
        return;
    else
        error('The time constant must be greater than zero');
    end
end

end

