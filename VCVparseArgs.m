function SpecifiedArgs=VCVparseArgs(ListenerName,varargin)

% There is probably a smarter way to deal with numeric parameters being
% passed and converted, yet still allow the checking of the variable type
% November 2010 -- strategic decision to do it dumbly!
% January 2012 -- adapted from CCRMparseArgs

% get arguments for VCVInNoise.m

%     Session, Train

p = inputParser;
p.addRequired('OutFile', @ischar);
p.addParamValue('TestType', 'adaptiveUp', @ischar);
p.addParamValue('ear', 'B', @ischar);
p.addParamValue('TargetDirectory', 'VCV_KM&TG', @ischar);
p.addParamValue('NoiseFile', 'Maskers\SpNz44100.wav', @ischar);
p.addParamValue('SNR_dB', -10, @isnumeric);
p.addParamValue('MIN_change_dB', 2, @isnumeric);
p.addParamValue('Reps', 1, @isnumeric);
p.addParamValue('SNR_adj_file', 'VCV_adjust_SNR_KM&TG.csv', @ischar);   
p.addParamValue('VolumeSettingsFile', 'VolumeSettings-80dBSPL.txt', @ischar);   
p.addParamValue('itd_invert', 'ITD', @ischar);  
p.addParamValue('lateralize', 'noise', @ischar); 
p.addParamValue('Train', 'test', @ischar); 
p.addParamValue('Session', '1', @ischar);
p.addParamValue('ITD_us', 650, @isnumeric); 

p.parse(ListenerName, varargin{:});

SpecifiedArgs=p.Results;

% [OutFile, TestType, ear, SentenceDirectory, InitialSNR_dB, START_change_dB, ...
%      AudioFeedback, MaxTrials, ListNumber, TrackingLevel, ...
%      NoiseFile, StartMessage, NAL] = TestSpecs(mInputArgs);