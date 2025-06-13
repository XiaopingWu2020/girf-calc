% This is a script for creating GIRF based gradient prediction and for
% comparing the result against actually measured gradient.
%
% assuming skope_girf.m has been run to calculate GIRFs. 
%
% created by Xiaoping Wu, 1/11/2023
%
% this is a copy of what is under ~/Siemens105T_2/session_20230320*/

clearvars;

% if ispc
%     rootfolder='X:';
%     addpath(fullfile(rootfolder,'matlab','myMatlab','skope'));
% else % isunix
%     rootfolder='~';
% end
%% Sources
addpath(fullfile('.','src'));
addpath(fullfile('.','skope_matlabAqSysDataImport','bin'));
addpath(genpath(fullfile('.','pulseq')));
%% pulseq info
myseq= mr.Sequence();
myseq.read('xw_sp2d_moco-2mm-r3-noSync.seq')
%myseq.read('./xw_sp2d-1mm-r4.seq')
% nominal gradient
load('xw_sp2d-2mm-r3.mat'); % load in grad0
%load('./xw_sp2d-1mm-r4.mat');
% todo: retrieve gradin from .seq file. 
gradin0.shape= mr.convert(grad0.shape.','Hz/m','mT/m','gamma',grad0.gamma);
%gradin0.t_vec= (0: size(grad0.shape,2)-1).* grad0.dt;
gradin0.t_vec= (1: size(grad0.shape,2)).* grad0.dt;
gradin0.dt= grad0.dt;
%% predict gradient
%load GIRFs.mat % load in Hw and freqs
load GIRFs_demo.mat;
ot= predictOutputFromGIRFs(gradin0.shape,Hw); % this gradient seemed to be too long to predict?
fieldpred0.bfield= ot;
fieldpred0.t_vec= gradin0.t_vec;
%% gradient measurement
fieldDataFolder = fullfile('.','skopeData');
%fieldDataFolder = fullfile('.','skope');
% load in skope data
scanId = 3;
scan = AqSysData(fieldDataFolder,scanId);
kspha= scan.getData('kspha',[],[],[],1);
dt= scan.k.tDwell;
trig2adcTime= myseq.getDefinition('skope_trig2AdcTime');
tshift= round((trig2adcTime- scan.k.extTrigDelay)./dt)- 4;
% clear bfield
% for idx= 1: size(kspha,2)
%     bfield(:,idx) = deriveBfieldFromPhase(kspha(:,idx),dt,grad0.dt,tshift);
% end
bfield= deriveBfieldFromPhase(kspha,dt,grad0.dt,tshift);

nt= round(length(gradin0.t_vec)*gradin0.dt/dt);
fieldmeas.bfield= mr.convert(bfield(1:nt,:),'Hz/m','mT/m','gamma',scan.gammas.mrSystem);
fieldmeas.t_vec= (1:nt)*dt;
fieldmeas0.bfield= interp1(fieldmeas.t_vec,fieldmeas.bfield,gradin0.t_vec);
fieldmeas0.t_vec= gradin0.t_vec;
% %
% gradin.shape= interp1(gradin0.t_vec,gradin0.shape,fieldmeas.t_vec);
% gradin.t_vec= fieldmeas.t_vec;
% fieldpred.bfield= interp1(fieldpred0.t_vec,fieldpred0.bfield,fieldmeas.t_vec);
% fieldpred.t_vec= fieldmeas.t_vec;

%% plot
% plotFieldMeas(fieldmeas0.bfield,  fieldmeas0.t_vec,'spiralmeas-')
% plotFieldMeas(fieldpred0.bfield,  fieldpred0.t_vec,'spiralpred-')
bfield2compare= cat(3,fieldmeas0.bfield, fieldpred0.bfield);
plotFieldMeas2(bfield2compare,  1e3*fieldmeas0.t_vec,'spiralMeasVsPrediction', {'measured','predicted'})

%% gradient
% gradient
figure('name','gradient prediction'), 
subplot(221), plot(1e3*gradin0.t_vec, gradin0.shape(:,1))
hold on
plot(1e3*fieldmeas0.t_vec, fieldmeas0.bfield(:,2),'r')
plot(1e3*fieldpred0.t_vec, fieldpred0.bfield(:,2),'g')
hold off
title('Gx')
%xlabel('time (ms)')
ylabel('magnitude (mT/m)')
%legend('GIRF_{xx}','GIRF_{yy}','GIRF_{zz}')
legend('nominal','measured','predicted')
%axis([-3 3 8.5 10])
subplot(222), plot(1e3*gradin0.t_vec, gradin0.shape(:,2))
hold on
plot(1e3*fieldmeas0.t_vec, fieldmeas0.bfield(:,3),'r')
plot(1e3*fieldpred0.t_vec, fieldpred0.bfield(:,3),'g')
hold off
title('Gy')

dev0_gx= gradin0.shape(:,1)-fieldmeas0.bfield(:,2);
devpred0_gx= fieldpred0.bfield(:,2)- fieldmeas0.bfield(:,2);
dev0_gy= gradin0.shape(:,2)-fieldmeas0.bfield(:,3);
devpred0_gy= fieldpred0.bfield(:,3)- fieldmeas0.bfield(:,3);

rdev0_gx= dev0_gx./ fieldmeas0.bfield(:,2);
rdevpred0_gx= devpred0_gx./ fieldmeas0.bfield(:,2);
rdev0_gy= dev0_gy./ fieldmeas0.bfield(:,3);
rdevpred0_gy= devpred0_gy./ fieldmeas0.bfield(:,3);

% subplot(223), plot(1e3*gradin0.t_vec, 100*rdev0_gx)
% hold on
% plot(1e3*fieldmeas0.t_vec, 100*rdevpred0_gx,'r')
% %plot(1e3*fieldpred0.t_vec, fieldpred0.bfield(:,3),'g')
% hold off
% title('Gx relative deviation')
% xlabel('time (ms)')
% ylabel('magnitude (%)')
% legend('nominal - measured','predicted - measured')
% subplot(224), plot(1e3*gradin0.t_vec, 100*rdev0_gy)
% hold on
% plot(1e3*fieldmeas0.t_vec(1:end-1), 100*rdevpred0_gy(1:end-1),'r')
% %plot(1e3*fieldpred.t_vec, fieldpred.bfield(:,3),'g')
% hold off
% title('Gy relative deviation')
% xlabel('time (ms)')
%ylabel('magnitude (mT/m)')
%legend('GIRF_{xx}','GIRF_{yy}','GIRF_{zz}')
%axis([0 20 -1 1])

subplot(223), plot(1e3*gradin0.t_vec, dev0_gx)
hold on
plot(1e3*fieldmeas0.t_vec, devpred0_gx,'r')
%plot(1e3*fieldpred0.t_vec, fieldpred0.bfield(:,3),'g')
hold off
title('Gx deviation')
xlabel('time (ms)')
ylabel('magnitude (mT/m)')
legend('nominal - measured','predicted - measured')
subplot(224), plot(1e3*gradin0.t_vec, dev0_gy)
hold on
plot(1e3*fieldmeas0.t_vec, devpred0_gy,'r')
%plot(1e3*fieldpred.t_vec, fieldpred.bfield(:,3),'g')
hold off
title('Gy deviation')
xlabel('time (ms)')
%ylabel('magnitude (mT/m)')
%legend('GIRF_{xx}','GIRF_{yy}','GIRF_{zz}')
%axis([0 20 -1 1])
%export_fig('girf-prediction-g','-png')



