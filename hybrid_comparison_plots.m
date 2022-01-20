% hybrid_comparison_plots.m
% some plots to evaluate hybrid J-values against MCM and TUV.
% ripped out of calc_hybrid_tables, so might need some work on the front end.
% 20190117 GMW

% COMPARE Hybrid J-values with WITH TUV AND MCM

disp('PLOTTING J-VALUES...')

% get TUV and MCM values for comparison
Met.SZA = SZA; Met.T = T; Met.P = P;
Jmcm = MCMv331_J(Met,0);

TUVParam.alt_meas = ALT;    TUVParam.alt_gnd = 0;
TUVParam.O3col = O3col;     TUVParam.albedo = albedo;
Jtuv = MCMv331_J_TUVDirect(Met,TUVParam);
%     load JtuvTest.mat %structure Jtuv

i2plot=0;%1:70; %restrict plots if desired

JratioTUV = nan(nJ,1);
JratioMCM = JratioTUV;
for i=1:nJ
    name = Jnames{i};
    Jnow = J.(name);
    
    if any(i2plot==i)
        
        figure('name',name)
        plot(SZA,Jnow,'bo')
        xlabel('SZA')
        ylabel('J (s^-^1)')
        box on
        xlim([0 90])
        text(0.8,0.95,'BotUp','color','b')
        
        hold on
        if isfield(Jmcm,name)
            plot(SZA,Jmcm.(name),'k-','LineWidth',4)
            text(0.8,0.85,'MCM','color','k')
            JratioMCM(i) = Jnow(1)./Jmcm.(name)(1);
        end
        
        if isfield(Jtuv,name)
            plot(SZA,Jtuv.(name),'m--','LineWidth',4)
            text(0.8,0.75,'TUV','color','m')
            JratioTUV(i) = Jnow(1)./Jtuv.(name)(1); %ratio at 0 SZA
        end
        
    end %end plot if
end %end nJ for loop

% PLOT ALL J VALUE RATIOS
Jhyb=J;
figure('position',[0 0.05 0.99 0.86])
s1=subplot(211); hold on
xloc = 0;
for i=1:nJ
    xloc = xloc+1;
    
    if isfield(Jmcm,Jnames{i})
        Jrat = Jmcm.(Jnames{i})(1)./Jhyb.(Jnames{i})(1);
        plot(xloc,Jrat,'r^','linewidth',3)
        if Jrat>2
            text(xloc/36,0.94,num2str(Jrat,'%2.1f'),'color','r',...
                'horizontalalignment','center','fontsize',14,'backgroundcolor','w')
        end
    end
    
    if isfield(Jtuv,Jnames{i})
        Jrat = Jtuv.(Jnames{i})(1)./Jhyb.(Jnames{i})(1);
        plot(xloc,Jrat,'bo','linewidth',3)
        if Jrat>2
            text(xloc/36,0.94,num2str(Jrat,'%2.1f'),'color','b',...
                'horizontalalignment','center','fontsize',14,'backgroundcolor','w')
        end
    end
    
    if i==35
        s2=subplot(212); hold all
        xloc = 0;
    end
end
set([s1 s2],'yscale','linear','fontsize',16,'ytick',0:0.2:2,'ygrid','on',...
    'yticklabel',{'','0.2','','0.6','','1','','1.4','','1.8',''})
set(s1,'xlim',[0 36],'xtick',1:35,'xticklabel',Jnames(1:35))
set(s2,'xlim',[0 36],'xtick',1:35,'xticklabel',Jnames(36:end))

axes(s1);
plot([0 36],[1 1],'k-')
box on
ylabel('J Ratio')
set(s1,'position',[0.05 0.68 0.93 0.30])
ylim([0 2])
text(0.02,0.79,'MCM/HYBRID','color','r','backgroundcolor','w')
text(0.02,0.94,'TUV/HYBRID','color','b','backgroundcolor','w')

axes(s2);
plot([0 36],[1 1],'k-')
box on
ylabel('J Ratio')
set(s2,'position',[0.05 0.18 0.93 0.30])
ylim([0 2])


    