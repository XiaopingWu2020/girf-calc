% function out = filterPhaseData(p, dt, T)
% Filters input. For phase data bandwidth should be set to the bandwidth of
% gradient system.
% INPUT:
%   p       [matrix: samples x channels] phase data 
%   dt      [scalar] sampling rate 
%   T       [scalar]; 1/BW at FWHM of the window
% INPUT:
%   p       [matrix: samples x channels] phase data 
