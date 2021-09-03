clearvars
close all

% load empirical Kij, empirical FC, CC (co-classification) and simulated FC (mean of 12
% runs at k=280)
load sch200_SC
load sch200_FC
load sch200_CC
load sch200_simFC

% indices for 0 SC consensus modules
load ciuindices
% Yeo7 canonical systems
load yeo7indices

load mycmap

[xxy,yyy] = grid_communities(yeo7lbls);
[xxc,yyc] = grid_communities(ciulbls);

N = 200;

% indices: inds1 = all edges (2H); inds2 = intrahemispheric edges (1H);
% inds3 = SC-connected edges (2H); inds4 = intrahemispheric SC-connected
% edges (1H)
inds1 = find(triu(ones(N),1));
mask = [ones(100) zeros(100); zeros(100) ones(100)]; mask = triu(mask,1);
inds2 = find(mask);
inds3 = find(triu(Kij,1)>0);
inds4 = find(mask.*triu(Kij,1)>0);

lcol = [0.2 0.2 0.2];

% display SCciu, FC simulated (at k=280)
figure('position',[100 100 900 300])
subplot('position',[0.025 0.15 0.25 0.7])
imagesc(A(ciuindsr,ciuindsr),[-0.75 0.75])
hold on
plot(xxc,yyc,'color',lcol,'linewidth',1);
set(gca,'Colormap',flipud(mycmap),'XTick',[],'YTick',[])
xlabel('Nodes','FontSize',14)
axis square
cb = colorbar; set(cb,'Ticks',[-0.75 0 0.75],'FontSize',12,'Position',[0.275 0.200 0.015 0.600])
title('SC Co-Classification','FontSize',16)
subplot('position',[0.35 0.15 0.25 0.7])
imagesc(avgFC280sim(ciuindsr,ciuindsr),[-0.75 0.75])
hold on
plot(xxc,yyc,'color',lcol,'linewidth',1);
set(gca,'Colormap',flipud(mycmap),'XTick',[],'YTick',[])
xlabel('Nodes','FontSize',14)
axis square
cb = colorbar; set(cb,'Ticks',[-0.75 0 0.75],'FontSize',12,'Position',[0.6 0.200 0.015 0.600])
title('Simulated FC','FontSize',16)
subplot('position',[0.675 0.2 0.225 0.65])
% scatter plot
cr = [1 0.5 0.2];
cb = [0.2 0.6 0.7];
sc = scatter(nFCavg(inds1),avgFC280sim(inds1),'r.'); 
set(sc,'MarkerEdgeAlpha',0.25,'MarkerFaceAlpha',0.25,'MarkerFaceColor',cr,'MarkerEdgeColor',cr);
hold on
sc = scatter(nFCavg(inds2),avgFC280sim(inds2),'b.'); 
set(sc,'MarkerEdgeAlpha',0.25,'MarkerFaceAlpha',0.25,'MarkerFaceColor',cb,'MarkerEdgeColor',cb);
axis([-0.6 1 -0.6 1])
set(gca,'FontSize',12,'YAxisLocation','right')
box on
%axis square
xlabel('empirical FC','FontSize',14); ylabel('simulated FC','FontSize',14)
title('Emp/Sim FC','FontSize',16)
legend('2H','1H','Location','Northwest')

% compute summary SCFC correlations
avgFC280simz = fcn_fisher(avgFC280sim);
nFCavgz = fcn_fisher(nFCavg);
cc1avg = corr(avgFC280simz(inds1),nFCavgz(inds1),'type','p');
cc2avg = corr(avgFC280simz(inds2),nFCavgz(inds2),'type','p');
cc3avg = corr(avgFC280simz(inds3),Kij(inds3),'type','s');
cc4avg = corr(avgFC280simz(inds4),Kij(inds4),'type','s');
cc5avg = corr(avgFC280simz(inds1),A(inds1),'type','p');
cc6avg = corr(avgFC280simz(inds2),A(inds2),'type','p');

% display summary SCFC correlations
disp(['simulated FC - empirical FC (2H): R = ',num2str(cc1avg)])
disp(['simulated FC - empirical FC (1H): R = ',num2str(cc2avg)])
disp(['simulated FC - SC (2H): rho = ',num2str(cc3avg)])
disp(['simulated FC - SC (1H): rho = ',num2str(cc4avg)])
disp(['simulated FC - CC (2H): R = ',num2str(cc5avg)])
disp(['simulated FC - CC (1H): R = ',num2str(cc6avg)])



