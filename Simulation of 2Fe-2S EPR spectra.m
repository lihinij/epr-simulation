%% Load EPR data
[file, folder] = uigetfile('*.DTA', 'Select EPR data file');
if isequal(file, 0)
    return
end
[B, spc] = eprload(fullfile(folder, file));

%% Experiment parameters
Exp = struct();
Exp.mwFreq      = 9.732714;            % GHz
Exp.Range       = [268 428];   % mT
Exp.nPoints     = 3200;
Exp.ModAmp      = 0.2;               % mT modulation amplitude
Exp.Temperature = 15;               % K
Exp.Harmonic    = 1;                 % first derivative CW

%% Spin system: reduced [2Fe–2S] (S = 1/2)
Sys = struct();
Sys.S       = 1/2;
Sys.g       = [2.02 1.95];      % initial guess for rhombic g-tensor
Sys.lwpp    = 0.2;                   % mT linewidth
Sys.HStrain = [50 80];            % MHz, inhomogeneous broadening

% Optional 57Fe hyperfine (uncomment if enriched and visible)
%%Sys.Nucs   = '57Fe,57Fe,57Fe,57Fe';
%%Sys.A      = [40 50; 50 460]; % MHz
%%Sys.AFrame = [0 0; 0 0];

%% Vary parameters during fit
Vary = struct();
Vary.g       = [1 0.06];
Vary.lwpp    = 0.5;
Vary.HStrain = [30 30];
% Vary.A      = [10 10; 10 10];
% Vary.AFrame = [0 0; 0 0];

%% Run esfit
% Pass {Sys,Exp} for initial parameters, {Vary} for variation limits
esfit(spc, @pepper, {Sys, Exp}, {Vary});

%%
% Make sure both are column vectors
Bcol   = B(:);
fitcol = fit1.fit(:);

% Path to Desktop (change 'YourUsername' to your Windows username)
desktopPath = 'C:\Users\lihin\OneDrive\Desktop\EPR CRYO\';

% Save simulated fit
data_fit = [Bcol fitcol];
save(fullfile(desktopPath,'fitSpec_ascii.txt'),'data_fit','-ascii');
save(fullfile(desktopPath,'fitSpec.mat'),'B','fit1');




%%