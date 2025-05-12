function write_figure_title( )

global  flag1 flag2;

if flag1 ==1
    
    if flag2 == 1
        title('Basic signal test','FontName','Times','FontSize',35,'FontWeight','bold');
    elseif flag2 == 2
        title('Multiple DDCs test','FontName','Times','FontSize',35,'FontWeight','bold');
    elseif flag2 == 3
        title('Noise test','FontName','Times','FontSize',35,'FontWeight','bold');
    elseif flag2 == 4
        title('Harmonic test','FontName','Times','FontSize',35,'FontWeight','bold');
    elseif flag2 == 5
        title('Inter-harmonic test','FontName','Times','FontSize',35,'FontWeight','bold');
    elseif flag2 == 6
        title('Signal aliasing test','FontName','Times','FontSize',35,'FontWeight','bold');
    elseif flag2 == 7
        title('Power oscillation test','FontName','Times','FontSize',35,'FontWeight','bold');
    end
    
elseif flag1 ==2
    
    if flag2 == 1
        title('DDC time constant sensitivity test','FontName','Times','FontSize',35,'FontWeight','bold');
    elseif flag2 == 2
        title('System frequency sensitivity test','FontName','Times','FontSize',35,'FontWeight','bold');
    elseif flag2 == 3
        title('Sampling frequency sensitivity test','FontName','Times','FontSize',35,'FontWeight','bold');
    elseif flag2 == 4
        title('Noise SNR sensitivity test','FontName','Times','FontSize',35,'FontWeight','bold');
    end
    
end
    
end

