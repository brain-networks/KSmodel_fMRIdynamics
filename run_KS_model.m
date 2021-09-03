clearvars
close all

rng('shuffle')

% Empirical SC (consensus)
% Kij: Connection weights; D: Connection lengths (mm)
load sch200_SC.mat

% Initialize Parameters
N = size(Kij,1);                            % number of nodes
frequency_mean = 40;                        % mean intrinsic frequency (Hz)
f_std = 0.1;                                % standard decviation of intrinsic frequency

% Time Parameters
runlength = 792+20;                         % runlength (20 = length of HRF in sec, equals transient later discarded)
transient = 20;                             % transient
dt = 0.001;                                 % integration step
tspan = [dt:dt:runlength];                  % solve diff equations at these time points
tspan_transient = [dt:dt:transient];        % solve diff equations at these time points (transient)
step = 720;                                 % TR in msec, used for downsampling Ybold
lts = 1100;                                 % length of run in number of TRs

% Delay/Frustration Matrix
vel = 12;                                   % conduction velocity in mm/ms
D2 = D.*(1/vel);                            % delay in milliseconds
Aij = D2./((1/dt)/frequency_mean).*(2*pi);  % phase frustration

% BOLD HRF (from BD toolbox)
load BOLDHRF
hrf = BOLDHRF(1:20000);                     % define length of hrf (20 sec)
lhrf = length(hrf);

% Max integration timestep
odeoptions = odeset('MaxStep',dt);

% Number of bins 'nbins' for entropy
nbins = 128;

% Scaled coupling parameter
kvals = 280;

% initial condition (phase) and intrinsic phases
ths_ic = (2*pi).*rand(N,1);
omegas = (2*pi).*(frequency_mean+f_std.*randn(N,1));

tic

% Setup and Solve ODE - Note: KS_fcn is adapted from Kuramoto-Sakaguchi in the bdtoolbox
[~,ths] = ode45(@KS_fcn,tspan_transient,ths_ic,odeoptions,Kij,kvals,Aij,N,omegas);
ths = ths';
ths = mod(ths,2*pi);
ths_ics = ths(:,end);                            % final state of transient is IC for the following simulation
[~,ths] = ode45(@KS_fcn,tspan,ths_ics,odeoptions,Kij,kvals,Aij,N,omegas);
ths = ths';
ths = mod(ths,2*pi);
ths_fs = ths(:,end);                            % final state of 'ths' may be used to continue sim

% Convert to BOLD (convolution method), lowpass filter, and downsample
Ybold_ds = zeros(N,lts);
for n=1:N
    Yboldtemp = conv(sin(ths(n,:)),hrf,'valid'); % 'valid'
    Yboldtemp = lowpass(Yboldtemp,0.25,1000,'Steepness',0.95); % lowpass, 0.25 Hz
    for t=1:lts
        Ybold_ds(n,t) = mean(Yboldtemp((t-1)*step+1:t*step));
    end
end
ths = ths(:,lhrf+1:end);  % discard first 'lhrf' to align with 'valid'

% Order parameter
Rtemp = mean(exp(1i.*ths));
R = abs(Rtemp);                 % OP magnitude
Rp = unwrap(angle(Rtemp));      % OP phase

% Regress global mean from downsampled Ybold
Yboldglob = mean(Ybold_ds);
Ybold_reg = zeros(lts,N);
for n=1:N
    [~,~,Ybold_reg(:,n)] = regress(Ybold_ds(n,:)',[ones(1,lts)', Yboldglob']);
end

% FC
FC = corr(Ybold_reg);

% Display status
disp(['done: ',num2str(kvals)]);

toc

% Conserve storage space
R = single(R);
Rp = single(Rp);

save KS_out Kij D Aij N frequency_mean f_std runlength transient dt vel hrf kvals step lts nbins ...
    R Rp FC Ybold_reg ths_ic ths_ics ths_fs omegas
