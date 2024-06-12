classdef AqSysData < handle
% Class that reads output data from the acquisition system as well as meta
% data
%
% CONSTRUCTOR
% scan = AqSysData(folder,id);
% IN
% folder:  path of the folder containing the scan data files
% id:      scan id
% OUT
% obj      scan object holding meta data
%
% PROPERTIES
%     scanId:                ID of scan  
%     fileBaseName:          filename of scan without extentions  
%     filePath:              path of data files
%     versionNr:             version number of .scan file
%     scanName:              name of scan
%     scanDescription:       description of scan
% 
%     % data cluster
%     nrInterleaves:         nr of acquired interleaves per dynamic
%     interleaveTR:          interleaves repetition time
%     dynamicTR:             dynamic repetition time
%     nrDynamics:            nr of acquired dynamics  
%
%     raw = [];              raw data parameters : DataTypeParameters
%     phase = [];            phase : DataTypeParameters
%     k = [];                k data parameters : DataTypeParameters
%     Bfit = [];             fitted field parameters : DataTypeParameters
%     Gfit = [];             fitted gradient parameters : DataTypeParameters
% 
%     probePositions         probes positions
%     offresFrequencies      offresonance frequencies 
%     kBasis = []            basis parameters : KBasisParameters
%
% DataTypeParameters PROPERTIES
%         channels:                    channels as boolean array relating to all available channels (absolute)
%         nrChannels:                  nr of acquired channels
%         nrInterleaveSamples:         nr of samples per interleave
%         tDwell:                      sampling dwell time
%         extTrigDelay;                time between rising flank of external trigger and first sample
%
% KBasisParameters PROPERTIES
%         inputChannels:               (phase or field) input channels that were used for the spatial expansion
%         basisID:                     name of basis set
%         selectedBasisTerms:          boolean array of selected basis functions relating to all available basis functions
%         nrBasisTerms:                number of calculated basis coefficients
%         isAnalytic:                  true if based basis is calculated, as opposed to numeric basis such as used for shim feedback
%         isCoco:                      true if a concomitant field correction was performed
%
%
% FUNCTIONS
% getData(this, type, samples, channels, interleaves, dynamics)
% IN
%    type:         string data type. Type names are defined by the Acq System output file extensions 
%    samples:      numberic vector of requested samples. If empty ([]) all acquired samples are returned 
%    channels:     numberic vector of requested channels. Relative to acquired channels! If empty ([]) all acquired channels are returned
%    interleaves:  numberic vector of requested interleaves. If empty ([]) all acquired interleaves are returned  
%    dynamics:     numberic vector of requested dynamics. If empty ([]) all acquired dynamics are returned 
%    if only type is present, all acquired data is returned
% OUT
%    data:         size = [samples,channels,interleaves,dynamics]
%
% EXAMPLE USAGE
% 
% % read scan meta data
% scan = AqSysData(dataFolder,scanId)
% 
% % read raw data. sample 1-1000, (rel.)channel 1:5, interleave 1, dynamic 2-3
% raw =   scan.getData('dat', 1:1000, 1:5, 1, 2:3);
% % read all phase data
% phase = scan.getData('phase');

end




