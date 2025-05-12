% Function: execute_algorithm_main
% The purpose of this function is to execute the selected algorithms
% Input: app, test signal, the selected algorithms, the number of selected algorithms
% Output: the phasor, sampling number beyond one cycle

function [Phasor,sampling_number_beyond] = execute_algorithm_main(test_signal, name_alg_selec,tag)

global f0 fs color_set plot_flag flag2 name_alg_select;

num_alg_selec = length(name_alg_selec);

% execute the algorithm and draw the image
Phasor=cell(num_alg_selec,2); % num_alg_selec*2 The first column is the estimated amplitude and the second column is the estimated phase angle
sampling_number_beyond=cell(num_alg_selec,1); % The algorithm uses additional sampling points on the basis of one periodic sampling points
sampling_number = fs/f0;

for num=1:num_alg_selec
    [Phasor{num,1},Phasor{num,2},sampling_number_beyond{num,1}]=eval([name_alg_selec{num},'(test_signal,tag);']);
end

if (plot_flag)
    % draw the amplitude image
    figure(2*flag2-1);
    clf;
    set(gcf,'outerposition',[1 1 1680 980]);
    set(gcf,'color','w');
    set(gca, 'LineWidth',1.5);
    hold on

    if tag==7   % power oscillation

        for num=1:num_alg_selec
            plot(Phasor{num,1}(sampling_number-sampling_number_beyond{num,1}+1:102*sampling_number-...
                sampling_number_beyond{num,1}),'color',color_set{num},'LineWidth',2);
        end
        hold off
        set(gca,'looseinset',[0 0 0.03 0]);
        set(gca,'xlim',[0,100*sampling_number],'xtick',(0:20*sampling_number:100*sampling_number),'FontName','Times');
        set(gca,'XTicklabel',(0:400:2000));

    else

        for num=1:num_alg_selec
            plot(Phasor{num,1}(sampling_number-sampling_number_beyond{num,1}+1:6*sampling_number-...
                sampling_number_beyond{num,1}),'color',color_set{num},'LineWidth',4);
        end
        hold off
        set(gca,'looseinset',[0 0 0.03 0]);
        set(gca,'xlim',[0,5*sampling_number],'xtick',(0:sampling_number:5*sampling_number),'FontName','Times');
        set(gca,'XTicklabel',(0:20:100));
        write_figure_title();
        % set(gca,'ylim',[0,1.6],'FontName','Times');
        % set(gca,'ytick',(0:0.4:1.6))

    end

    xlabel('(a) Time (ms)');
    ylabel('Magnitude (p.u.)');
    set(gca,'FontName','Times','FontSize',30,'FontWeight','bold');
    legend(name_alg_select,'FontSize',30,'Location','southEast','FontName','Times')
    write_figure_title();
    box on;
    grid on;


    % draw the phase image
    figure(2*flag2)
    clf;
    set(gcf,'outerposition',[1 1 1680 980]);
    set(gcf,'color','w');
    set(gca, 'LineWidth',1.5);
    hold on

    if tag == 7   % power oscillation

        for num=1:num_alg_selec
            plot(Phasor{num,2}(sampling_number-sampling_number_beyond{num,1}+1:102*sampling_number-...
                sampling_number_beyond{num,1}),'color',color_set{num},'LineWidth',2);
        end
        hold off
        set(gca,'looseinset',[0 0 0.03 0]);
        set(gca,'xlim',[0,100*sampling_number],'xtick',(0:20*sampling_number:100*sampling_number),'FontName','Times');
        set(gca,'XTicklabel',(0:400:2000));

    else

        for num=1:num_alg_selec
            plot(Phasor{num,2}(sampling_number-sampling_number_beyond{num,1}+1:6*sampling_number...
                -sampling_number_beyond{num,1}),'color',color_set{num},'LineWidth',4);
        end
        
        hold off
        set(gca,'looseinset',[0 0 0.03 0]);
        set(gca,'xlim',[0,5*sampling_number],'xtick',(0:sampling_number:5*sampling_number),'FontName','Times');
        set(gca,'XTicklabel',(0:20:100),'FontName','Times');
        % set(gca,'ylim',[-2.0 -0.4],'ytick',(-2.0:0.4:-0.4));
    end
    
    xlabel('(b) Time (ms)');
    ylabel('Phase (rad)');
    set(gca,'FontName','Times','FontSize',30,'FontWeight','bold');
    legend(name_alg_select,'FontSize',30,'Location','southEast','FontName','Times')
    write_figure_title();
    box on;
    grid on;

end

end



