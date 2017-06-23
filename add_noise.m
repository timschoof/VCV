function [sig, Fs, start, SigAlone, NoiseAlone, correction] = ...
        add_noise(SignalWav, NoiseWav, MaskerWavStart, ... % 3
                snr, duration, fixed, in_rms, out_rms, ... % 5
                warning_noise_duration, NoiseRiseFall) % 2
%
% function [sig, Fs, start, SigAlone, NoiseAlone] = add_noise(SignalWav, NoiseWav, MaskerWavStart, ...                                           
%                 snr, duration, fixed, in_rms, out_rms, warning_noise_duration, NoiseRiseFall)
%                  4       5       6       7       8              9                  10             
%                         
% 	Combine a noise and signal waveform at an arbitrary signal-to-noise ratio
%   Return the wave and the sampling frequency of the WAV files, and the
%   start of the masker waveform (in samples)
%	The level of the signal or noise can be fixed, and the output level can be normalised
%	Randomize the starting point of the noise
%
%  'SignalWav' - the name of a .wav file containing the signal or target
%  'NoiseWav' - the name of a .wav file containing the noise (must be longer in duration than signal)
%  MaskerWavStart
%  snr - signal-to-noise ratio at which to combine the waveforms
%  duration - (ms) of final waveform. If 0, the signal duration is used
%  fixed - 'noise' or 'signal' to be fixed in level at level specified by in_rms
%  in_rms - if 0, level of signal or noise left unchanged
%  out_rms - rms output of final combined wave. Signal unchanged if rms=0
%		(Note! rms values are calculated Matlab style with waveform values assumed to 
%		be in the range +/- 1)
%  warning_noise_duration - extra section of noise to serve as precursor to
%       stimulus word (ms)
%  NoiseRiseFall - taper the noise on and off, adding this duration to
%       start and finish of the signal. This is in addition to the warning_noise_duration(ms)
%  HRIRmatFile -
%  Azimuths - for target and masker (horizontal plane only)
%
% Version 2.0 -- December 2001: modified from combine.m (December 1999) Isaac 
% Version 2.1 -- protect against stereo waveforms, taking only one channel (December 2002)
% Version 3.0 -- lengthen signal so as to account for rise/fall times on noise wave
% Version 3.1 -- allow 10 dB attenuation, instead of 5.
% Version 3.2 -- allow longer start time of noise to be specified
% Version 4.0 -- restrict calculation of SNR to original duration of signal wave
%               (older versions included total length with added warning
%               silences) June 2003
% Version 5.0 -- allow specification of which part of the noise wave is selected
% Version 6.0 -- enable threshold determination for waves in silence
% Version 6.1 -- output noise alone, as well as signal alone: April 2009
% Version 7.0 -- enable use of stereo waveforms, for binaural presentations
%       if the target is a stereo file, then a stereo masker file must also
%       be specified. Binaural signals not fully implemented! OK until line
%       130
% Version 7.1 -- add NoiseRiseFall to args
%                   add correction of output level (if necessary to avoid
%                   overloads) to output args, and eliminate breaking out
%                   if a maximum degree of attenutation is breached
% Version 7.2 -- fixed signal level option with signal scaled to specified in_rms value implemented
%                   as in AddNoiseVectorInputs.m

%
% Stuart Rosen stuart@phon.ucl.ac.uk

VERSION = 'AOHL_CI_tests';
                   
                                       
%% get signal/target and its properties

if ~isnumeric(SignalWav)
    
    if ~strcmpi(SignalWav(end-3:end),'.wav')
        SignalWav = [SignalWav '.wav'];
    end
    
    [sig, Fs] = audioread(SignalWav);
    % remove Lx channel, if present
    if size(sig,2)>1
        sig = sig(:,1);
    end
else
    sig = SignalWav;
    Fs = 22050; % just assume 22050 for now - should really do something else
end

[nz, Fn] = audioread(NoiseWav);
if size(nz,2)>1
    nz = nz(:,1);
end

if Fs~=Fn, 
   error('The sampling rate of the noise and signal waveforms must be equal.'); 
end

nz_samples = length(nz);
n_samples = length(sig);
n_original_sig = length(sig);

%% check if a constant duration for the output wave is desired
n_augmented = 0;
if (duration>0) % make output waveform this duration
   duration = Fs * duration/1000; % number of sample points in total
   % ensure signal is not longer than this already
   if n_samples>duration 
      error('The signal waveform is too long for given duration.'); 
   end
   % augment signal with zeros
   n_augmented = duration-n_samples;
   sig = [sig; zeros(duration-n_samples,size(sig,2))];
   n_samples=length(sig);
end

%%  add extra time for rises and falls, and extra silences
rise_fall = floor(Fs * NoiseRiseFall/1000); % number of sample points for rise and fall
if NoiseRiseFall>0 || warning_noise_duration>0
   warning_noise_duration = floor(Fs * warning_noise_duration/1000); 
                            % number of sample points for extra noise
   % augment signal with zeros at start and finish zeros(duration-n_samples,size(sig,2))
   sig = [  zeros(rise_fall,size(sig,2)); ...
            zeros(warning_noise_duration,size(sig,2)); ...
            sig; ...
            zeros(rise_fall,size(sig,2))];
   n_samples=length(sig);
end

%% keep a spare copy of signal
SigAlone = sig;

%% select a random portion of the noise file, of the appropriate length, 
%  ensuring there is a sufficiently long noise
if nz_samples<n_samples 
   error('The noise waveform is not long enough.'); 
end
if MaskerWavStart<1
    start = floor((nz_samples-n_samples)*rand);
else
    start=MaskerWavStart;
end
% copy the original noise waveform
noise = nz;
% and delete the unwanted samples
noise(1:start-1,:)=[];
noise(n_samples+1:length(noise),:)=[];

%% put rises and falls on to the noise/masker
noise = NewTaper(noise, NoiseRiseFall, NoiseRiseFall, Fs);
% extra copy of noise
NoiseAlone = noise;


%% Calculate the rms levels of the signal and noise
% !!OBS!! The extra bits of noise for the rise and fall, and the warning signal duration
% are NOT included in this calculation (although they used to be)
% possible extras
%   n_augmented - at end of stimulus for fixed duration output signals
%   rise_fall - at start and end of signal
%   warning_noise_duration - at start of signal
%   n_original_sig - original signal duration

genuine_signal = [1+rise_fall+warning_noise_duration:n_original_sig+rise_fall+warning_noise_duration];
rms_sig = rms(sig(genuine_signal));
rms_noise = rms(noise(genuine_signal));

% calculate the multiplicative factor for the signal-to-noise ratio
snr = 10^(snr/20);
   
if strcmp(fixed, 'signal') % fix the signal level and scale the noise
   if in_rms>0 % scale the signal to the desired level, then scale the level of the noise and add it in to the signal
      sig = (sig * in_rms/rms_sig) + noise * in_rms/(snr * rms_noise);
      SigAlone = SigAlone * in_rms/rms_sig;
      NoiseAlone = NoiseAlone * in_rms/(snr * rms_noise);      
   else % leave the signal as is, then scale the level of the noise and add it in to the signal
      sig = sig + noise * (rms_sig/(snr * rms_noise));
      NoiseAlone = NoiseAlone * (rms_sig/(snr * rms_noise)); 
   end   
elseif strcmp(fixed, 'noise') % fix the noise level and scale the signal
   if in_rms>0 % scale the noise to the desired level, then scale the level of the signal and add it to the noise
      sig = (noise * in_rms/rms_noise) + sig * (snr*in_rms)/rms_sig;
      SigAlone = SigAlone * (snr*in_rms)/rms_sig;
      NoiseAlone = NoiseAlone * in_rms/rms_noise;
   else % leave the noise as is, then scale the level of the signal and add it to the noise
      sig = noise +   sig * (snr*rms_noise)/rms_sig;
      SigAlone = SigAlone * (snr*rms_noise)/rms_sig;      
   end  
else
   error('Fixed wave must be signal or noise.');
end  
    
% See if entire output waveform should be scaled to a particular rms
if (out_rms>0) 
   % Calculate rms level of combined signal+noise
   rms_total = max(rms(sig));
   % Scale total to obtain desired rms
   sig = sig * out_rms/rms_total;
   SigAlone = SigAlone * out_rms/rms_total;
   NoiseAlone = NoiseAlone * out_rms/rms_total;
end

% do something if clipping occurs
[sig, correction] = no_clip(sig);
% correct signal alone for clipping too!
SigAlone = SigAlone * 10^(-correction/20);
NoiseAlone = NoiseAlone * 10^(-correction/20);

% if correction<-15 % allow a maximum of 15 dB attenuation 
%    error('Output signal attenuated by too much.'); 
% end

