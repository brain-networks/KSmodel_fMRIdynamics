clearvars
close all

% load empirical Kij, D, nFCavg
load sch200_SC
load sch200_FC

% Yeo 7 canonical systems
load yeo7indices

load mycmap

[xxy,yyy] = grid_communities(yeo7lbls);

N = 200;

lcol = [0.2 0.2 0.2];

% display SC matrix and D and FC matrix (both empirical)
figure('position',[100 100 900 300])
subplot('position',[0.025 0.15 0.25 0.7])
imagesc(log10(Kij(yeo7indsr,yeo7indsr)),[-3 0])
hold on
plot(xxy,yyy,'color',lcol,'linewidth',1);
set(gca,'Colormap',flipud(gray.^1.5),'XTick',[],'YTick',[])
xlabel('Nodes','FontSize',14)
axis square
cb = colorbar; set(cb,'Ticks',[-3 -2 -1 0],'FontSize',12,'Position',[0.275 0.200 0.015 0.600])
title('SC Weights','FontSize',16)
subplot('position',[0.35 0.15 0.25 0.7])
imagesc(D(yeo7indsr,yeo7indsr),[0 max(D(:))])
hold on
plot(xxy,yyy,'color',lcol,'linewidth',1);
set(gca,'Colormap',flipud(gray),'XTick',[],'YTick',[])
xlabel('Nodes','FontSize',14)
axis square
cb = colorbar; set(cb,'Ticks',[0 50 100 150],'FontSize',12,'Position',[0.6 0.200 0.015 0.600])
title('SC Lengths','FontSize',16)
subplot('position',[0.675 0.15 0.25 0.7])
imagesc(nFCavg(yeo7indsr,yeo7indsr),[-0.75 0.75])
hold on
plot(xxy,yyy,'color',lcol,'linewidth',1);
set(gca,'Colormap',flipud(mycmap),'XTick',[],'YTick',[])
xlabel('Nodes','FontSize',14)
axis square
cb = colorbar; set(cb,'Ticks',[-0.75 0 0.75],'FontSize',12,'Position',[0.925 0.200 0.015 0.600])
title('FC','FontSize',16)