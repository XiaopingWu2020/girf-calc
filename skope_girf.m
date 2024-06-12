% This is a script for calculating gradient impulse response funcions (GIRF) 
% given input gradients and corresponding skope field measurements.
%
% created by Xiaoping Wu, 12/29/2022

clearvars;

addpath(fullfile('.','src'));
addpath(fullfile('.','skope_matlabAqSysDataImport','bin'));
addpath(genpath(fullfile('.','pulseq')));

%% Example data from a prototype insert-gradient system
fieldDataFolder = fullfile('.','skopeData');
%% pulseq method
seqfile= 'girf_calib.seq'; % trap grad type
myseq= mr.Sequence();
myseq.read(seqfile);

scanId= 23;
fn = 'GIRFs_demo';

scan = AqSysData(fieldDataFolder,scanId);

[Hw, freqs]= calcGIRFs(myseq,scan);
save(fn, 'Hw', 'freqs');

%% plot GIRFs
girfs= load('GIRFs_demo.mat');
myaxis= {[-3 3 0 0.01],[-3 3 0 1.2],[-3 3 0 0.01],[-3 3 0 0.1],[-3 3 0 0.5]};
plotGIRFs(girfs,myaxis);


