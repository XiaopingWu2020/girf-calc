function [ot,Ow] = predictOutputFromGIRFs(gradin,Hw,rbw)
%predictOutputFromGIRFs predict output responses given input gradients and GIRFs
% Usage: [ot,Ow] = predictOutputFromGIRFs(gradin,Hw,rbw)
%
% Output
%
% ot: output responses in time domain [ntpts, nOutputChannels].
%
% Ow: output responses in frequency domain [nfpts, nOutputChannels].
% Ow = FFT(ot).
%
% Input
% gradin: input gradients [ntpts, nInputChannels]
% 
% Hw: GIRFs [nfpts,3,nOutputChannels], with matched bandwidth to gradin. 
%
% rbw: relative bandwidth relative to the gradient bandwidth, for a low pass filtering
% that nulls Hw outside the bandwidth to filter out spurious high frequency components
% with huge amplitudes, especially when Hw is calculated with small averages data. 
% For example, rbw= 0.5 means that
% the relative bandwidth is half the entire gradient bandwidth and what is
% inside the range from -0.25*bw0 to 0.25*bw0 (where bw0 is the gradient bandwidth) 
% will remain unchanged but what is outside the range will be zeroed.
% defaults to 1, meaning no low pass filtering.
%
%
% see also: calcGIRFs
%
%
%
% Created by Xiaoping Wu, 1/11/2023

if nargin< 3
    rbw= 1;
end
nInputChannels= size(gradin,2);
nOutputChannels= size(Hw,3);
npts= size(Hw,1); 
Ow= complex(zeros(npts,nOutputChannels));

nzpts= round(npts.* (1- rbw)./2);
idxs= [1:nzpts (npts-nzpts+1):npts];
for idx= 1:nOutputChannels
    for jdx= 1:nInputChannels
        jIw= fftshift(fft(gradin(:,jdx), npts));
        % filter out high frequency noise
        %jIw(abs(jIw)<0.001*max(abs(jIw)))= 0;
        jIw(idxs)= 0;
        Ow(:,idx)= Ow(:,idx)+ jIw(:).* Hw(:,jdx,idx);
    end
end

if npts>= size(gradin,1)
    ot= ifft(ifftshift(Ow,1),[],1);
else
    ot= ifft(ifftshift(Ow,1),size(gradin,1),1);
end
ot= real(ot(1:size(gradin,1),:));

disp('-> Output responses prediction done...')
end