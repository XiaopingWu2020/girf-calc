function bfield = deriveBfieldFromPhase(phase,dt,gradRasterTime,ntshift)
%deriveBfieldFromPhase derive B field with time shift correction given phase timecourse.
%
%  Usage: bfield = deriveBfieldFromPhase(phase,dt,gradRasterTime,ntshift)
%
% Output
%
% bfield: estimated b field in Hz or Hz/m etc., depending on input phase.
%
% Input
%
% phase:  [matrix: samples x channels] .phase (signal phase) or .kspha (phase coeffs) data provided by skope-fm.
%
% dt: dwell time of phase data in sec.
%
% gradRasterTime: gradient raster time for filtering the phase data. If
% empty, no filtering is performed.
%
% ntshift: number of time points to shift the estimated b field.
%
%
% see also: estimateProbePosition estimateProbPos.m
%
%
% created by Xiaoping Wu, 12/29/2022

if nargin< 4
    ntshift= 0;
end
if nargin< 3
    gradRasterTime= [];
end
if ~isempty(gradRasterTime)
    phase= filterPhaseData(phase, dt, gradRasterTime);
end
bfield_meas= diff(phase)./ dt./ 2/pi;
%bfield= circshift(bfield_meas,-ntshift);
bfield= bfield_meas(ntshift+1:end,:);
end