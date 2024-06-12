% This is an example of how to read data from the acquisition system
% and how to relate k coefficients to their basis functions (kbase).

clear all;


%% Sources
addpath './/bin'

%% Example data from a prototype insert-gradient system
dataFolder = './/exampleData';
scanId = 12;

%% read data
scan = AqSysData(dataFolder,scanId);

%read raw data of 1st dynamic
raw = scan.getData('raw', [], [], [], 1);

%read (higher order) k-space coefficients of 2nd dynamic
%these coefficients relate to the basis set in kbase_spha.m and kbase_coco.m
kcoco =         scan.getData('kcoco', [], [], [], 1);
%these coefficients relate to kbase.m (spherical harmonics)
kspha =         scan.getData('kspha', [], [], [], 1);

%smooth data - use BW of gradient system
kFiltered = filterPhaseData(kspha(:,:,1,1), 1e-6, 1e-5);

%plot (linear) 2d k-space
figure, plot(kFiltered(:,2),kFiltered(:,3)); xlabel('kx [rad/m]'), ylabel('ky [rad/m]'), axis equal, title('k parametric')
figure, colororder(fieldDataColors); plot(kFiltered(:,1:4)); xlabel('Samples'), ylabel('k_0 [rad], k_x_y_z [rad/m]'), legend('k_0','k_x','k_y','k_z'), title('k vs time')

%% example of how to relate the phase coefficients k with x and phase

%phase model:
%phase(x,t) = SUM_basisInd (k(t)*kbase(x))
%           = SUM_sphaBasisInd (kspha(t)*kbase_spha(x)) + SUM_cocoBasisInd (k(t)*kbase_coco(x))
nrPos = 5;
% phase is evaluated at 5 random positions for demonstration
phase = zeros(size(kspha,1),nrPos);
pos = rand(nrPos,3)*0.1; %[m]
addpath('kbase');
for indb = 1:scan.kBasis.nrBasisTerms
    phase = phase + (kspha(:,indb)*kbase_spha(indb,pos)');
end
for indb = 1:4
    phase = phase + (kcoco(:,indb)*kbase_coco(indb,pos)');
end
% figure, plot(phase,'DisplayName','phase'),xlabel('Samples'), ylabel('Phase [rad]'), title('phase a 5 random positions')

% clear to close file handle
clear scan