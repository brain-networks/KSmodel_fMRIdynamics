clearvars
close all

%% This script will allow reproducing main findings reported in Pope et al (2021).
% Users will want to enter their own desired simulation and analysis parameters

%% Run a single KS model simulation and save output
run_KS_model

%% Compute ets and rss
ts = zscore(Ybold_reg);
ets = fcn_edgets(ts);
rss = sum(ets.^2,2).^0.5;

%% Detect 'events' in the RSS time series
% parameters for detecting 'events' using the circshift null
R = 1000;
offsets = [-lts:1:lts];
pthr = 0.001;
zext = 4.5;

% compute 'event' time points (validpk_ts), amplitudes (validpk_amp) and counts
% (validnumpk)
[~,~,~,~,~,~,validpk_ts,validpk_amp,validnumpk] = detect_RSSevents(ts,R,offsets,pthr,zext);

%% Display ets matrix, rss time course and event timings
load mycmap
figure('position',[100 100 1000 400])
subplot('position',[0.1 0.45 0.5 0.45])
imagesc(ets',[-3 3])
set(gca,'XTick',[],'YTick',[],'FontSize',10); ylabel('Edges','FontSize',12);
colormap(flipud(mycmap))
title('Edge Time Series and RSS','FontSize',14)
subplot('position',[0.1 0.15 0.5 0.25])
pp = plot(rss,'k');
hold on
pp = plot(validpk_ts,validpk_amp,'k.');
pp = plot(validpk_ts,validpk_amp+30,'kv');
set(gca,'XTick',[1 200 400 600 800 1000],'YTick',[0 100 200 300],'FontSize',10)
xlabel('Time','FontSize',12); ylabel('RSS','FontSize',12);
axis([1 1100 0 360])

%% Extract high/low-RSS FC components and display
inds1 = find(triu(ones(N),1));
FCfull = FC;
[rssordered,rssindices] = sort(rss,'descend');
FChi_ets = mean(ets(rssindices(1:110),:));  % top 10% RSS frames
temp = zeros(N); temp(inds1) = FChi_ets; FChi = temp+temp';
FClo_ets = mean(ets(rssindices(end-110+1:end),:));  % bottom 10% RSS frames
temp = zeros(N); temp(inds1) = FClo_ets; FClo = temp+temp';

load ciuindices
load mycmap
plim = 0.75;
lcol = [0.2 0.2 0.2];
[xxc,yyc] = grid_communities(ciulbls);

figure('position',[100 100 350 800])
subplot('position',[0.05 0.7 0.8 0.25])
imagesc(FCfull(ciuindsr,ciuindsr),[-plim plim])
set(gca,'XTick',[],'YTick',[])
hold on
plot(xxc,yyc,'color',lcol,'linewidth',1);
axis square
subplot('position',[0.05 0.4 0.8 0.25])
imagesc(FChi(ciuindsr,ciuindsr),[-plim plim])
set(gca,'XTick',[],'YTick',[])
hold on
plot(xxc,yyc,'color',lcol,'linewidth',1);
axis square
subplot('position',[0.05 0.1 0.8 0.25])
imagesc(FClo(ciuindsr,ciuindsr),[-plim plim])
hold on
plot(xxc,yyc,'color',lcol,'linewidth',1);
set(gca,'XTick',[],'YTick',[])
axis square
colormap(flipud(mycmap))
cb = colorbar; set(cb,'Position',[0.8 0.35 0.05 0.35],'Ticks',[-0.75 0 0.75],'FontSize',12);

%% Compute similarity between ets frames and display
figure('position',[100 100 350 600])
cc = corr(ets');
subplot('position',[0.05 0.55 0.8 0.35])
imagesc(cc,[0 0.1])
hold on
axis square
set(gca,'XTick',[],'YTick',[])
xlabel('Frames (Time)','FontSize',14);
subplot('position',[0.05 0.1 0.8 0.35])
imagesc(cc(rssindices,rssindices),[0 0.1])
axis square
set(gca,'XTick',[],'YTick',[])
xlabel('Frames (RSS)','FontSize',14);
cb = colorbar; set(cb,'Position',[0.8 0.325 0.05 0.35],'Ticks',[0 0.05 0.1],'FontSize',12);
