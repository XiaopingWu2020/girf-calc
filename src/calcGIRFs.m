function [Hw,freqs,Hw0,freqs0] = calcGIRFs(myseq,scan,kspha)
%calcGIRFs calculate gradient impulse response functions 
% following eq. 12 in Vannesjo et al MRM 2013
%
%   Usage: [Hw,freqs,Hw0,freqs0] = calcGIRFs(myseq,scan,kspha)
%
% Input
% myseq: pulseq seq object of the .seq file used for girf measurement, 
% that is myseq= mr.Sequence(); If empty, girf_calib.seq will be read.
%
% scan: skope scan object of the field measurement, that is scan = AqSysData(dataFolder,scanId);
%
% kspha: phase coefficients to be used. If empty, skope created kspha will be used.
% defaults to [];
% 
% Output
% Hw: GIRFs [nSamples0, nInputChannels, nOutputChannels], matched to
% gradient bandwidth.
% 
% freqs: corresponding frequencies in Hz.
%
% Hw0: GIRFs [nSamples, nInputChannels, nOutputChannels], of entire measurement bandwidth. 
% 
% freqs0: corresponding frequencies in Hz.
%
% see also: predictOutputFromGIRFs
%
% created by Xiaoping Wu, 1/3/2023

if nargin< 3
    kspha= [];
end
if isempty(myseq.blockEvents)
    myseq.read('girf_calib.seq');
end
% create input gradient
dt= myseq.gradRasterTime;
ngrads= length(myseq.gradLibrary.lengths)-1; % last gradient is a dummy one.
gradlib= cell(1,ngrads);
tDwell= scan.k.tDwell;
for idx= 1: ngrads
    igrad= myseq.gradLibrary.get(idx);
    if igrad.type == 't'        
        gradlib{idx}= createTrapGrad(igrad,tDwell);
    else % igrad.type == 'g'
        %error('-> creation of arbitray gradient is not implemented yet...')
        ishape= myseq.shapeLibrary.get(igrad.data(2));
        gradlib{idx}= createGrad(igrad,ishape,tDwell,dt);
    end
end

% create gradient timing
nBlocks= length(myseq.blockEvents)- 1; % remove the last dummy block
gradevents=struct([]);
gcounter=1;
for idx= 1:nBlocks
    iblock= myseq.blockEvents{idx};
    if iblock(3)>0
        gradevents(gcounter).gxID= iblock(3);
        gcounter= gcounter+ 1;
    elseif iblock(4)>0
        gradevents(gcounter).gyID= iblock(4);
        gcounter= gcounter+ 1;
    elseif iblock(5)>0
        gradevents(gcounter).gzID= iblock(5);
        gcounter= gcounter+ 1;
    else
    end
end

if isempty(kspha)
    kspha= scan.getData('kspha');
end

if length(gradevents) ~= size(kspha,4)
    error('-> number of gradient events must be equal to number of skope measurements...')
end

nInputChannels= 3; % gx, gy and gz
nOutputChannels= size(kspha,2); % number of basis functions
%
nSamples= size(kspha,1);
npts= 2.^ nextpow2(nSamples);

df= 1./tDwell./npts;
freqs0= ((1-npts)/2: npts/2)* df;

%
IOw= complex(zeros(npts,nInputChannels,nOutputChannels));
ssIw= zeros(npts,nInputChannels);

poolobj = gcp('nocreate'); % If no pool, do not create new one.
if isempty(poolobj)
    parpool(); %parpool(nOutputChannels);
% else
%     if poolobj.NumWorkers ~= nOutputChannels
%         delete(gcp('nocreate'));
%         parpool(nOutputChannels);
%     end
end

delayTrig2blip= myseq.getDefinition('skope_girfDelay');
if isempty(delayTrig2blip)
    tshift= 0;
    disp('-> NOTE: trigger to blip delay is missing in .seq file...')
    disp('-> So no delay correction...')
else
    tshift= round((delayTrig2blip- scan.k.extTrigDelay)./tDwell);
end

nGradEvents= length(gradevents);
for idx= 1: nGradEvents
    fprintf('-> processing gradient event #%d out of %d...\n', idx,nGradEvents)
    ige= gradevents(idx);
    if ~isempty(ige.gxID)
        inputChannel= 1;
        ig = (-1).* gradlib{ige.gxID};
    elseif ~isempty(ige.gyID)
        inputChannel= 2;
        ig = gradlib{ige.gyID};
    elseif ~isempty(ige.gzID)
        inputChannel= 3;
        ig = gradlib{ige.gzID};
    else
        error('-> missing gradient event...')
    end
    iIw= fftshift(fft(ig,npts));
    ssIw(:,inputChannel)= ssIw(:,inputChannel)+ abs(iIw(:)).^2;

    ikspha= kspha(1:nSamples,:,:,idx);
    parfor jdx= 1: nOutputChannels
        jkspha= squeeze(ikspha(:,jdx,:));
        jfield= deriveBfieldFromPhase(jkspha,tDwell,dt,tshift); %
        jOw= fftshift(fft(jfield,npts));
        IOw(:,inputChannel,jdx)= IOw(:,inputChannel,jdx)+ conj(iIw(:)).* jOw(:);
    end
    
%     % filter out blind spots %%% decided to not do this since it would
%     result in discontinuity in GIRFs especially outside the frequency range of +-5kHz.
%     iidxs= abs(iIw)<= 0.0001*max(abs(iIw));
%     IOw(iidxs,inputChannel,:)= 0;
end
delete(gcp('nocreate'));

Hw0= IOw./ repmat(ssIw, [1 1 size(IOw,3)]);

% match the bandwidth of the input gradient.
idxs= freqs0<= 1/dt/2& freqs0>= -1/dt/2;
Hw= Hw0(idxs,:,:);
freqs= freqs0(idxs);

disp('-> GIRF calculation is done...')
end

%
function grad= createGrad(igrad,ishape,dt,dt_g)
% create arbitrary gradient given pulseq gradient structure.
amp= igrad.data(1);
%shape_id= igrad.data(2);
%time_id= igrad.data(3);
delay= igrad.data(4);
%
shape.data= ishape.data(2:end);
shape.num_samples= ishape.data(1);
grad= mr.decompressShape(shape);

% match skope dwell time. 
t_vec0= (1:length(grad)).* dt_g;

nt= round(length(grad).* dt_g./ dt);
t_vec= (1:nt).* dt;
grad= interp1(t_vec0, grad, t_vec);
grad(isnan(grad))= 0;

%
%grad= [0 0 0 0 grad zeros(1,100)]; % added 4 more zeros at the beginning to align with measurement, such that the resulting GIRFs can be used to predict a gradient that is closer to the measurement. 
grad= [grad zeros(1,100)]; % 

% delay
ntdelay= round(delay./dt);
grad= circshift(grad,ntdelay,2);

grad= amp.* grad;

end
%
function grad= createTrapGrad(igrad,dt)
% create trapezoidal gradient given pulseq trapezoidal gradient structure.
amp= igrad.data(1);
rise= igrad.data(2);
flat= igrad.data(3);
fall= igrad.data(4);
delay= igrad.data(5);

% rise
ntrise= round(rise./dt);
ampinc= amp./ ntrise;
grise= ampinc:ampinc:amp;
% flat
ntflat= round(flat./dt);
gflat= amp*ones(1,ntflat);
% fall
ntfall= round(fall./dt);
ampinc= amp./ ntfall;
gfall= amp:-ampinc:ampinc;
% delay
ntdelay= round(delay./dt);

%grad= [0 0 0 0 0 grise gflat gfall 0 zeros(1,100)]; % added 4 more zeros at the beginning to align with measurement, such that the resulting GIRFs can be used to predict a gradient that is closer to the measurement. 
grad= [0 grise gflat gfall 0 zeros(1,100)]; % this resulted in best prediction for 10.5 T head gradient. 
grad= circshift(grad,ntdelay,2);
% t_vec0= (0:length(grad0)-1).* dt;
% 
% nt= round(length(grad0).* dt./ tDwell);
% t_vec= (0:nt-1).* tDwell;
% grad= interp1(t_vec0, grad0, t_vec);
% grad(isnan(grad))= 0;
end
