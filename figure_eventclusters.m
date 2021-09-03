clearvars
close all

load k280_eventclusters.mat
load ciuindices

[xx,yy] = grid_communities(ciulbls);

load mycmap
load mywrmap

N = 200;
lc = [0.2 0.2 0.2];
lcol = [0.2 0.2 0.2];

% display the CC(R) matrix marking the 4 largest clusters
figure('position',[100 100 600 600])
subplot('position',[0.1 0.15 0.7 0.7])
plim = max([min(CC(:)), max(CC(:))]);
imagesc(CC(bb,bb),[-plim plim])
hold on
for cb=1:4
    ll = line([clusbounds(cb)+0.5 clusbounds(cb)+0.5],[0 length(bb)+1]); set(ll,'Color',lc,'LineWidth',1.2);
    ll = line([0 length(bb)+1],[clusbounds(cb)+0.5 clusbounds(cb)+0.5]); set(ll,'Color',lc,'LineWidth',1.2);
end
axis square; 
cb = colorbar; set(cb,'Ticks',[-0.5:0.25:0.5],'FontSize',12,'Position',[0.83 0.2 0.0275 0.6])
set(gca,'FontSize',12,'XTick',[20:20:160],'YTick',[]);
title('Event Clusters','FontSize',16)
xlabel('events','FontSize',14); %ylabel('events','FontSize',14)
colormap(jet)
   
% display the patterns
figure('position',[50 50 900 700])
plim = 2;
subplot('position',[0 0.2 0.25 0.25])
imagesc(etspat(ciuindsr,ciuindsr,1),[-plim plim])
hold on
plot(xx,yy,'color',lcol,'linewidth',1);
axis square
set(gca,'XTick',[],'YTick',[]);
xlabel('Nodes','FontSize',14);
title('Cluster 1','FontSize',16);
subplot('position',[0.25 0.2 0.25 0.25])
imagesc(etspat(ciuindsr,ciuindsr,2),[-plim plim])
hold on
plot(xx,yy,'color',lcol,'linewidth',1);
axis square
set(gca,'XTick',[],'YTick',[]);
xlabel('Nodes','FontSize',14);
title('Cluster 2','FontSize',16);
subplot('position',[0.5 0.2 0.25 0.25])
imagesc(etspat(ciuindsr,ciuindsr,3),[-plim plim])
hold on
plot(xx,yy,'color',lcol,'linewidth',1);
axis square
set(gca,'XTick',[],'YTick',[]);
xlabel('Nodes','FontSize',14);
title('Cluster 3','FontSize',16);
subplot('position',[0.75 0.2 0.25 0.25])
imagesc(etspat(ciuindsr,ciuindsr,4),[-plim plim])
hold on
plot(xx,yy,'color',lcol,'linewidth',1);
axis square
set(gca,'XTick',[],'YTick',[]);
xlabel('Nodes','FontSize',14);
title('Cluster 4','FontSize',16);
colormap(flipud(mycmap))



