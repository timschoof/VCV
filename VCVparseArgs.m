function SpecifiedArgs=VCVparseArgs(ListenerName,varargin)

% There is probably a smarter way to deal with numeric parameters being
% passed and converted, yet still allow the checking of the variable type
% November 2010 -- strategic decision to do it dumbly!
% January 2012 -- adapted from CCRMparseArgs

% get arguments for VCVInNoise.m

%     Session, Train

p = inputParser;
p.addRequired('OutFile', @ischar);
p.addParamValue('TestType', 'adaptiveDown', @ischar); % options: adaptiveUp, adaptiveDown, fixed
p.addParamValue('ear', 'B', @ischar); % options: B = both ears, L = left ear, R = right ear
p.addParamValue('TargetDirectory', 'VCV_KM&TG', @ischar);
p.addParamValue('NoiseFile', 'Maskers\SpNz44100.wav', @ischar);
p.addParamValue('SNR_dB', 8, @isnumeric); % SNR of first trial
p.addParamValue('MIN_change_dB', 2, @isnumeric); % final step size in dB
p.addParamValue('Reps', 1, @isnumeric);
p.addParamValue('SNR_adj_file', 'VCV_adjust_SNR_KM&TG.csv', @ischar); %
p.addParamValue('VolumeSettingsFile', 'VolumeSettings-80dBSPL.txt', @ischar);   
p.addParamValue('itd_invert', 'inverted', @ischar); % options: ITD = interaural time difference, inverted = invert polarity in one ear, none = no manipulation
p.addParamValue('lateralize', 'signal', @ischar); % apply ITD or inverted polarity manipulation to: signal, noise, signz (i.e. both), or none - this defaults to 'none' if no manipulation is applied
p.addParamValue('Train', 'test', @ischar); 
p.addParamValue('Session', '1', @ischar);
p.addParamValue('ITD_us', 0, @isnumeric); % ITD in microseconds (if ITD is applied) - this defaults to 0 if ITD is not applied
p.addParamValue('StartMessage', 'none', @ischar);
p.addParameter('RMEslider','TRUE',@ischar); % ajust sliders on RME TotalMix if necesary - TRUE or FALSE

p.parse(ListenerName, varargin{:});

SpecifiedArgs=p.Results;

% [OutFile, TestType, ear, SentenceDirectory, InitialSNR_dB, START_change_dB, ...
%      AudioFeedback, MaxTrials, ListNumber, TrackingLevel, ...
%      NoiseFile, StartMessage, NAL] = TestSpecs(mInputArgs);