% Function: System_frequency
% System frequency sensitivity test
% Input: Magnitude and phase of fundamental component, Magnitude and time constant of DDC
% Input: system frequency
% Output: The measured phasor, measuring error, TVE

function [Phasor,Max_error,Max_TVE] = System_frequency(fundamental_mag,fundamental_pha,...
                    DDC_mag,DDC_time_con,f0)

global flag2 plot_flag;                     
                
fs = evalin('base','fs');
num_alg_select = evalin('base','num_alg_select');
name_alg_select = evalin('base','name_alg_select');
color_set = evalin('base','color_set');

% execute the algorithm and draw the image
Phasor=cell(num_alg_select,2); % num_alg_selec*2 The first column is the estimated amplitude and the second column is the estimated phase angle
sampling_number_beyond=cell(num_alg_select,1); % The algorithm uses additional sampling points on the basis of one periodic sampling points
sampling_number = ceil(fs/f0);

tag=2;
answer{1} = fundamental_mag;
answer{2} = fundamental_pha;
answer{3} = DDC_mag;
answer{4} = DDC_time_con;
answer{5} = f0;

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

    f0=answer{5};
    % Determine whether the system frequency is reasonable
    if f0>=45 && f0<=55
        assignin("base","f0",f0);
        test_signal=generate_signal_sensitivity(tag);
        
        [Phasor, sampling_number_beyond] = execute_algorithm_f0(test_signal,name_alg_select,num_alg_select,tag);
        
        % get the maximum error
        Max_error=cell(num_alg_select,2);
        Max_TVE=cell(num_alg_select,1);
        for num=1:num_alg_select
            [Max_error{num,1},Max_error{num,2},Max_TVE{num,1}]=obtain_max_error(Phasor{num,1},...
                Phasor{num,2},sampling_number_beyond{num,1},tag);
        end
        
        if (plot_flag)
            figure(flag2+14)% draw the amplitude image
            clf;
            set(gcf,'outerposition',[1 1 1680 980]);
            set(gcf,'color','w');
            set(gca, 'LineWidth',1.5);
            hold on
            for num=1:num_alg_select
                
                plot(Phasor{num,1}(sampling_number-sampling_number_beyond{num,1}+1:6*sampling_number-...
                    sampling_number_beyond{num,1}),'color',color_set{num},'LineWidth',4)
            end
            hold off
            set(gca,'looseinset',[0 0 0.03 0]);
            set(gca,'xlim',[0,5*sampling_number],'xtick',(0:sampling_number:5*sampling_number),'FontName','Times');
            set(gca,'XTicklabel',(0:20:100));
            % set(gca,'ylim',[0,1.6],'FontName','Times');
            % set(gca,'ytick',(0:0.4:1.6))
            xlabel('(a) Time (ms)');
            ylabel('Magnitude (p.u.)');
            set(gca,'FontName','Times','FontSize',40,'FontWeight','bold');
            write_figure_title();
            box on;
            grid on;
            
            figure(flag2+15)% draw the phase image
            clf;
            set(gcf,'outerposition',[1 1 1680 980]);
            set(gcf,'color','w');
            set(gca, 'LineWidth',1.5);
            hold on
            for num=1:num_alg_select
                
                plot(Phasor{num,2}(sampling_number-sampling_number_beyond{num,1}+1:6*sampling_number-...
                    sampling_number_beyond{num,1}),'color',color_set{num},'LineWidth',4)
            end
            hold off
            set(gca,'looseinset',[0 0 0.03 0]);
            set(gca,'xlim',[0,5*sampling_number],'xtick',(0:sampling_number:5*sampling_number),'FontName','Times');
            set(gca,'XTicklabel',(0:20:100));
            % set(gca,'ylim',[0,1.6],'FontName','Times');
            % set(gca,'ytick',(0:0.4:1.6))
            xlabel('(a) Time (ms)');
            ylabel('Phase(rad)');
            set(gca,'FontName','Times','FontSize',30,'FontWeight','bold');
            legend(name_alg_select,'FontSize',30,'Location','southEast','FontName','Times')
            write_figure_title();
            box on;
            grid on;
        end
        
    else
        dlg=errordlg('The frequency should be in the 45-55 Hz range','Error');
        dlg.Visible="off";   % hide the dialog
        resize_dlg(dlg,24);
    end
    
    % reset the system frequency
    f0 = 50;
    assignin("base","f0",f0);
end

end
