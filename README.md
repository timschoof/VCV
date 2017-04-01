# VCV Read Me

These MATLAB scripts can be used to test consonant perception in the presence of background noise. 

The target speech consists of vowel-consonant-vowel (VCV) stimuli comprising the consonants 
/b, d, f, g, k, l, m, n, p, v, w, y, z/ in the context of the vowels /a,i,u/. 

_Note that the consonants /t,s,sh/ are not included. These stimuli are still available in the "all_stimuli" 
branch. However, SNR adjustment factors for these stimuli are not available for the KM&TG set (sampling rate: 44100 Hz)._

The masker is a pre-computed noise waveform. All masker files are assumed to be in the directory 'Maskers'.
You can find three example maskers in this directory: a speech-shaped noise (SpNz22050.wav and SpNz44100.wav,
with sampling rates of 22050 and 44100 Hz respectively) and a multi-talker babble (IHRBabble.wav).

You can run the VCV in noise test either at a fixed signal-to-noise ratio (SNR) or adaptively (tracking
the speech reception threshold (SRT) at 50% correct). VCVs can also be tested in quiet, by testing at a
fixed SNR of 999 dB. 

In addition, you can make adjustments for individual consonants in terms of the SNR. Some consonants 
are inherently easier, so you can take that into account by adjusting the SNR of a trial depending
on the consonant that is presented.

## How to run the test

You can either set parameters using the gui or by specifying them as a set of input arguments. 
Note that there are some parameters that aren't on the gui but that can be changed using input arguments.
Therefore, it is probably best to run this from the command line entirely. 

To run the test, type something like this:

VCVInNoise('SNR_adj_file', 'VCV_adjust_SNR_KM&TG.csv','Listener','test','NoiseFile','SpNz44100.wav','TestType')

If you wanted to run the test from the gui after all, just run VCVInNoise.m and the gui pops up. 

## Parameters

 - Listener: participant id
 - NoiseFile: name of masker file (don't include file path)
 - TestType: Fixed, AdaptiveUp, or AdaptiveDown
 - ear: l, r, b
 - TargetDirectory: stimulus folder (e.g. VCVa or VCVb)
 - MIN_change_dB: final step size (dB). If left unspecified, it will take the value specified at start of the script (VCVInNoise.m). 
 - Reps: number of repetitions of the stimulus list
 - SNR_dB: SNR of first stimulus presentation
 - Session: just gets written into the output file
 - Train: train or test (train option gives feedback), can also add 'p' at start of Listener code to indicate it's a practice trial
 - SNR_adj_file: csv file with SNR adjustment levels
 - OutFile: name of output file, this is constructed later on so perhaps best not to specify this here
 - VolumeSettings: text file that specifies volume settings, if left unspecified the default is VolumeSettings.txt 
 
There are some additional parameters in the VCVInNoise.m script (at the top):
 - warning_noise_duration = 500;  % noise starts e.g. 500 ms before the stimulus  
 - NoiseRiseFall = 200;     % Noise is tapered on and off across 200 ms
 - OutputDir = 'VCV_results'; % name of output directory (for results files)
 - MAX_SNR_dB = 15;    % maximum SNR (dB)
 - PermuteMaskerWave = 0;      % minimise repeated playing of sections of masker wav
 - START_change_dB = 10.0;   % intial step size (dB)
 - MIN_change_dB = 3.0; % final step size (dB)
 - INITIAL_TURNS = 2;   % need one for the initial sentence up from the bottom if adaptiveUp
 - FINAL_TURNS = 8;   % number of reversals after which run terminates
 - MaxBumps = 3;  % run terminates after e.g. 3 trials were presented at maximum SNR

## Specifying default settings

You can specify some default settings in the gui. To do this, type "guide VCVTespSpecs" on the command line,
and make adjustments to the gui. 

## SNR adjustments

There is a csv file with an adjustment value (in SNR dB) for every stimulus file.
The file is specified in an argument call e.g.,  VCVInNoise('SNR_adj_file', 'VCV_adjust_SNR.csv'). 
If SNR_adj_file is not specified, then no adjustments are made.
The adaptive procedure tracks the un-adjusted SNR.

## Result files

The results are saved as .csv files in the VCV_results folder. For each test block, you get two 
result files. The .csv file that ends in "sum" gives you the percent correct score or the SRT. 
The other excel files show trial-by-trial data. 