function VCVInNoise(varargin)
% % Run VCV in noise either fixed or adaptively,
%   using a pre-computed noise waveform
%
% All masker files are assumed to be in the directory 'Maskers'
% Keeps track of the talker (KM or TG) for each stimulus -- assumes this to
% be coded in the stimulus filename as the last two letters

%% initialisations
VERSION = 'HHL';
player = 0; % are you using playrec? yes = 1, no = 0

warning_noise_duration = 500;         Info.warning_noise_duration = warning_noise_duration;
NoiseRiseFall = 200;                  Info.NoiseRiseFall = NoiseRiseFall;
OutputDir = 'VCV_results';
MAX_SNR_dB = 15;
PermuteMaskerWave = 0;      % minimise repeated playing of sections of masker wav
START_change_dB = 8.0;
MIN_change_dB = 3.0;
INITIAL_TURNS = 2;   % need one for the initial sentence up from the bottom if adaptiveUp
FINAL_TURNS = 15;
n_trials = 35; % max number of trials
MaxBumps = 3;
tracking = 50; % tracking 50% or 71% correct
IgnoreTrials = 3;
mInputArgs = varargin;

% % initialise the random number generator
% rng('shuffle');
% warning('off', 'MATLAB:fileparts:VersionToBeRemoved')

%% Get audio device ID based on the USB name of the device.
if player == 1 % if you're using playrec
    dev = playrec('getDevices');
    d = find( cellfun(@(x)isequal(x,'ASIO Fireface USB'),{dev.name}) ); % find device of interest - RME FireFace channels 3+4
    playDeviceInd = dev(d).deviceID; 
    recDeviceInd = dev(d).deviceID;
end

%% get essential information for running a test
% [TestType, ear, TargetDirectory, NoiseFile, SNR_dB, OutFile, Reps, MIN_change_dB,...
%     ~, ~, Session, Train, SNR_adj_file,VolumeSettingsFile] = VCVTestSpecs(mInputArgs);

if nargin==0
    [TestType, ear, TargetDirectory, NoiseFile, SNR_dB, OutFile, Reps, MIN_change_dB,...
        Session, Train, SNR_adj_file,VolumeSettingsFile,itd_invert,lateralize,ITD_us,RMEslider] = VCVTestSpecs(mInputArgs);
    
else % pick up defaults and specified values from args
    if ~rem(nargin,2)
        error('You should not have an even number of input arguments');
    end
    SpecifiedArgs=VCVparseArgs(varargin{1},varargin{2:end});
    % now set all parameters obtained
    fVars=fieldnames(SpecifiedArgs);
    for f=1:length(fVars)
        if ischar(eval(['SpecifiedArgs.' char(fVars{f})]))
            eval([char(fVars{f}) '=' '''' eval(['SpecifiedArgs.' char(fVars{f})]) ''';']);
        else % it's a number
            eval([char(fVars{f}) '='  num2str(eval(['SpecifiedArgs.' char(fVars{f})])) ';'])
        end
    end
end

% extract level from VolumeSettingsFile
Num = regexp(VolumeSettingsFile,'\d');
Level = VolumeSettingsFile(Num);
    
% revert back to some default values if necessary
if ~strcmp(ear,'B') % if signal is to be monaural
    itd_invert = 'none';
end
if ~strcmp(itd_invert,'ITD') % if no ITD is to be applied
    ITD_us = 0; % set ITD to 0 microseconds if it's not being used anyway - for saving in output file
end
if strcmp(itd_invert,'none') % if no ITD or inverted polarity is to be applied
   lateralize = 'none'; % set lateralize (i.e. whether to apply ITD or inverted polarity to the signal, noise, or signz) to 'none' if no manipulation is applied - for saving in output file 
end

TargetType = upper(TargetDirectory([1:3]));
if strcmp(TestType,'fixed')
    START_change_dB = 0;
    MIN_change_dB = 0;
    %     FINAL_TURNS = MaxTrials;
    MAX_SNR_dB = 99;
    csv_summary = 'VCV_summary_fixed.csv';
    if ~exist(fullfile(csv_summary))
        summary_csv_File = fullfile(csv_summary);
        fout = fopen(summary_csv_File, 'at');
        fprintf(fout, 'Date,Time,Listener,Session,Targets,Masker,SNR,N_correct,Total_KW,p_corr');
        fclose(fout);
    end
else
    csv_summary = 'VCV_summary_adapt.csv';
    if ~exist(csv_summary)
        summary_csv_File = fullfile(csv_summary);
        fout = fopen(summary_csv_File, 'at');
        fprintf(fout, 'Date,Time,Listener,Session,Sentences,Masker,SRT,Std_Dev');
        fclose(fout);
    end
end

if strcmpi(NoiseFile, 'none') || strcmpi(NoiseFile, 'Maskers\None')
    TestType = 'fixed';
    SNR_dB = 999;
    PermuteMaskerWave = 0;
end

Info.TestType = TestType;
Info.MAX_SNR_dB = MAX_SNR_dB;
Info.PermuteMaskerWave = PermuteMaskerWave;
Info.START_change_dB = START_change_dB;
Info.MIN_change_dB = MIN_change_dB;
Info.INITIAL_TURNS = INITIAL_TURNS;
Info.FINAL_TURNS = FINAL_TURNS;
Info.MaxBumps = MaxBumps;
Info.SNR_adj_file = SNR_adj_file;

if ~strcmpi(SNR_adj_file, 'none')  % Read in list of SNR adjustments for specified stimuli
    fid = fopen(SNR_adj_file);
    C_Adjust = textscan(fid, '%s%s', 'delimiter', ',');
    fclose(fid);
end

%% Settings for level
[InRMS, OutRMS] = SetLevels(VolumeSettingsFile); 

% Info.SoundMasterLevel = SoundMasterLevel;
% Info.SoundWaveLevel = SoundWaveLevel;
% Info.InRMS = InRMS;
% Info.OutRMS = OutRMS;

%% Set RME Slider
if strcmp(RMEslider,'TRUE')
    % read in RME settings file
    RMEsetting=robustcsvread('RMEsettings.csv');
    % select columns with relevant info
    LevelCol=strmatch('dBSPL',strvcat(RMEsetting{1,:}));
    SliderCol=strmatch('slider',strvcat(RMEsetting{1,:}));
    % find index of dBSPL level
    index = find(strcmp({RMEsetting{:,LevelCol}}, num2str(Level)));
    % find the corresponding RME slider setting
    RMEattn = RMEsetting{index,SliderCol};
    % set RME slider
    SetMainSlider(str2double(RMEattn))
end

%% create output files
status = mkdir(OutputDir);
if status==0
    error('Cannot create new output directory for results: %s', OutputDir);
end

% get the starting date & time of the session
StartTime = fix(clock);
StartTimeString = sprintf('%02d:%02d:%02d',...
    StartTime(4),StartTime(5),StartTime(6));
FileNamingStartTime = sprintf('%02d-%02d-%02d',StartTime(4),StartTime(5),StartTime(6));
StartDate = date;

% construct the output data file name
[~, ListenerName, ext] = fileparts(OutFile);
% get the root name of the noise file
[~, NoiseFileName, ext] = fileparts(NoiseFile);

% put method, date and time on filenames so as to ensure a single file per test
if strcmp(itd_invert,'ITD')
    FileListenerName=[ListenerName '_T-' TargetDirectory '_M-' NoiseFileName(1:3) '_' num2str(ITD_us) 'us_' itd_invert '_' lateralize '_' StartDate '_' FileNamingStartTime];
elseif strcmp(itd_invert,'inverted')
    FileListenerName=[ListenerName '_T-' TargetDirectory '_M-' NoiseFileName(1:3) '_' itd_invert '_' lateralize '_' StartDate '_' FileNamingStartTime];
elseif strcmp(itd_invert,'none')
    FileListenerName=[ListenerName '_T-' TargetDirectory '_M-' NoiseFileName(1:3) '_' itd_invert '_' StartDate '_' FileNamingStartTime];
end
OutFile = fullfile(OutputDir, [FileListenerName '.csv']);
SummaryOutFile = fullfile(OutputDir, [FileListenerName '_sum.csv']);
% write some headings and preliminary information to the output file
fout = fopen(OutFile, 'at');
fprintf(fout, 'listener,date,sTime,tracking,trial,targets,talker,SNR,adj_SNR,OutLevelChange,VolumeSettings,manipulation,lateralized,ITD,masker,wave,V,C,response,correct,rTime,rev');
fclose(fout);

%% check whether results summary file has been left open and if so quit *** use CheckOpenFile?
[fid, message] = fopen(csv_summary, 'r+');

if ~isempty(message)
    fprintf('Problem accessing %s. Make sure file is closed and re-try.\n', csv_summary);
    delete(findobj('Type','figure'));
    return
else
    fclose(fid);
end

%% Generate a random order in which to play the stimuli %%
for i=1:Reps
    order = VCVorderWithConstraints(TargetDirectory);
    if i == 1
        trial_order = order;
    else
        trial_order = [trial_order, order];
    end
end

% calculate the number of trials to be performed %
% n_trials = size(trial_order,2);

% reduce number of trials if practice run
if strcmpi(ListenerName(1),'p')
    n_trials = 6;
end

if strcmpi(ListenerName(1),'r')
    n_trials = 12;
end

if strcmpi(TestType, 'fixed')
    FINAL_TURNS = n_trials;
end

%% record parameter info in log file
Info.date = StartDate;
Info.time = FileNamingStartTime;
InfoFileName = fullfile('VCV Test Logs',['VCV_Tests' Info.date '_' Info.time '_' ListenerName '_test_param.csv']);
writetable(struct2table(Info),InfoFileName);

%% setup a few starting values
if strcmp(TestType,'adaptiveUp')
    previous_change = 1; % assume track is initially moving from hard to easy
else
    previous_change = -1; % assume track is initially moving from easy to hard
end
num_turns = 0;
change = START_change_dB;
inc = (START_change_dB-MIN_change_dB)/INITIAL_TURNS;
limit = 0;
response_count = 0;
trial = 0;
nWavSection = 0;
totalCorrect = 0;

criterion = 1; % number of correct answers before change - one till first reversal
if tracking == 50
    final_criterion = 1;
elseif tracking == 71
    final_criterion = 2;
else
    error('Only tracking of 50% or 71% implemented')
end
correct_count = 0;
reversals = zeros(1,n_trials);
levels_visited = zeros(1,n_trials);
levels_count = 0;

mean_revs = 999;  % set to impossible value to avoid crash in case not set later
sd_revs = 999;

pause(1);

nominal_SNR_dB = SNR_dB;

%% wait to start
Image = imread('DP119115(640x472).jpg','jpg');
% Print appropriate message on Go button
GoOrMessageButton('String', StartMessage, Image)

%% run the test (do adaptive tracking until stop criterion)
while (num_turns<FINAL_TURNS  && limit<=MaxBumps && trial<n_trials)
    trial = trial+1;
    nWavSection=nWavSection+1;
    
    %    InFile = deblank(full_stim_list(trial_order(trial),:));
    InFile = trial_order(trial).wave;
    StimulusFile = fullfile(TargetDirectory, InFile);
    
    %% identify the target consonant from the file name
    pos = strfind(InFile, '_');
    if isempty(pos)
        consonant = InFile(2:3);
    else
        consonant = InFile(2);
    end
    
    if strcmpi(NoiseFileName, 'none')
        
        [y, Fs] = audioread([StimulusFile '.wav']);
        OutLevelChange = 0;
        % check if stereo -- if so, take only one channel
        if size(y,2)>1
            y = y(:,1);
        end
        
        % *** should allow for InRMS here also?
        if OutRMS
            y = y*OutRMS/rms(y);
        end
        
        % apply 50 ms cosine rise and fall
        y = NewTaper(y,50,50,Fs);
        
    else
        % May 2009 -- different function for adding noise
        if PermuteMaskerWave % keep track of masker sections used
            MaskerWavStart = wavSections(nWavSection);
        else
            MaskerWavStart = -1;
        end
        
        if ~strcmpi(SNR_adj_file, 'none')
            SNR_Adjustment = FindSNR_Adjustment(C_Adjust, InFile);
            if ~isempty(SNR_Adjustment)
                SNR_dB = nominal_SNR_dB + SNR_Adjustment;
                %                fprintf('%g\n', SNR_dB);
            else
                SNR_dB = nominal_SNR_dB;
                fprintf('WARNING! - SNR Adjustment. File name not found in list.\n');
            end
        end
        
        % combine the signal and masker
        [y,Fs,~,sigAlone,noiseAlone,OutLevelChange] = add_noise(StimulusFile, NoiseFile, MaskerWavStart, SNR_dB, 0, ...
            'noise', InRMS, OutRMS, warning_noise_duration, NoiseRiseFall);
        
        % if required, apply crude spatialization (based on overall ITD or by simply inverting the polarity)
        if strcmp(itd_invert,'ITD') && ~ITD_us==0 % if ITD is to be applied (i.e. is not zero)
            if strcmp(lateralize,'signal')
                % create lagging and leading signal
                sig_lead = [sigAlone; zeros(round(((ITD_us*Fs)/10^6)),1)];
                sig_lag = [zeros(round(((ITD_us*Fs)/10^6)),1); sigAlone]; % NB: ITD is in microseconds
                % equate length of noiseAlone with that of signal by adding zeros at the end
                nz_front = [noiseAlone; zeros(round(((ITD_us*Fs)/10^6)),1)];
                % combine signal and noise
                lead = sig_lead + nz_front;
                lag = sig_lag + nz_front;
                % combine left and right channels
                y = [lag,lead]; % position of the signal is on the right
            elseif strcmp(lateralize,'noise')
                % create lagging and leading noise
                noise_lead = [noiseAlone; zeros(round(((ITD_us*Fs)/10^6)),1)];
                noise_lag = [zeros(round(((ITD_us*Fs)/10^6)),1); noiseAlone]; % NB: ITD is in microseconds
                % equate length of sigAlone with that of noise by adding zeros at the end
                sig_front = [sigAlone; zeros(round(((ITD_us*Fs)/10^6)),1)];
                % combine signal and noise
                lead = sig_front + noise_lead;
                lag = sig_front + noise_lag;
                % combine left and right channels
                y = [lag,lead]; % position of the noise is on the right
            elseif strcmp(lateralize,'signz')
                % create lagging and leading signal
                sig_lead = [sigAlone; zeros(round(((ITD_us*Fs)/10^6)),1)];
                sig_lag = [zeros(round(((ITD_us*Fs)/10^6)),1); sigAlone]; % NB: ITD is in microseconds
                % create lagging and leading noise
                noise_lead = [noiseAlone; zeros(round(((ITD_us*Fs)/10^6)),1)];
                noise_lag = [zeros(round(((ITD_us*Fs)/10^6)),1); noiseAlone]; % NB: ITD is in microseconds
                % combine signal and noise (one leads, other lags)
                lead = sig_lead + noise_lag;
                lag = sig_lag + noise_lead;
                % combine left and right channels
                y = [lag,lead]; % position of the signal is on the right
            else
                error('If ITD_invert is set to ITD, lateralize should be either signal, noise, or signz (i.e. both)')
            end
        elseif strcmp(itd_invert,'ITD') && ITD_us==0
            error('If laterlize is set to ITD, then an ITD >0 should be specified')
        elseif strcmp(itd_invert,'inverted')
            if strcmp(lateralize,'signal')
                % invert signal polarity
                sig_inv = -1*sigAlone;
                % combine signal and noise
                sig_nz_inv = sig_inv + noiseAlone;
                sig_nz = sigAlone + noiseAlone;
                % combine left and right channels
                y = [sig_nz_inv, sig_nz]; % left channel is always inverted
            elseif strcmp(lateralize,'noise')
                % invert noise polarity
                nz_inv = -1*noiseAlone;
                % combine signal and noise
                sig_nz_inv = nz_inv + sigAlone;
                sig_nz = sigAlone + noiseAlone;
                % combine left and right channels
                y = [sig_nz_inv, sig_nz]; % left channel is always inverted
            elseif strcmp(lateralize,'signz')
                % invert signal and noise polarities
                sig_inv = -1*sigAlone;
                nz_inv = -1*noiseAlone;
                % combine signal and noise, where one is inverted and the
                % other isn't
                nz_sig_inv = sig_inv + noiseAlone; % inverted signal + non-inverted noise
                sig_nz_inv = nz_inv + sigAlone; % non-inverted signal + inverted noise
                y = [sig_nz_inv, nz_sig_inv]; % left: inverted noise, right: inverted signal
            else
                error('If ITD_invert is set to inverted, lateralize should be either signal, noise, or signz (i.e. both)')
            end
        end
        
        if PermuteMaskerWave % keep track of masker sections used
            if nWavSection==nSections
                nWavSection = 0;
                [nSections, wavSections] = GenerateWavSections(NoiseFile, MaxDurTargetSamples);
            end
        end
    end
    
    
    if ~strcmp(itd_invert,'ITD') && ~strcmp(itd_invert,'inverted') % if no ITD or inverting polarity is applied
        ContraNoise = zeros(size(y)); % make a silent contralateral noise for monaural presentations
        % determine the ear(s) to play out the stimuli
        switch upper(ear)
            case 'L', y = [y ContraNoise];
            case 'R', y = [ContraNoise y];
            case 'B', y = [y y];
            otherwise error('variable ear must be one of L, R or B')
        end
    end
    
%     y = [y;y;y;y;y;y;y;y;y;y;y;y;y;y;y;y;y;y]; % for calibration
    
    % intialize playrec
    if player == 1 % if you're using playrec
        if playrec('isInitialised')
            playrec('reset');
        end
        playrec('init', Fs, playDeviceInd, recDeviceInd);
    end
    
    %% collect response
    response = VCVresponses(y,Fs,player);
    correct = strcmpi(response,consonant);
    
    %% record response
    TmpTimeOfResponse = fix(clock);
    TimeOfResponse=sprintf('%02d:%02d:%02d',...
        TmpTimeOfResponse(4),TmpTimeOfResponse(5),TmpTimeOfResponse(6));
    % test for quitting
    if strcmp(response,'quit')
        break
    end
    
    % extract talker from stimulus filename (assumes this is coded
    tlk = StimulusFile(length(StimulusFile)-1:length(StimulusFile));
    
    fout = fopen(OutFile, 'at');
    % print out relevant information
    % fprintf(fout, 'listener,date,sTime,trial,targets,SNR,adj_SNR,OutLevelChange,VolumeSettings,masker,wave,V,C,response,correct,rTime,rev');
    fprintf(fout, '\n%s,%s,%s,%d,%d,%s,%s,%+5.1f,%+5.1f,%+5.1f,%s,%s,%s,%+5.1f,%s,%s,%s,%s,%s,%d,%s', ...
        ListenerName,StartDate,StartTimeString,tracking,trial,TargetDirectory,tlk,nominal_SNR_dB,SNR_dB,...
        OutLevelChange,Level,itd_invert,lateralize,ITD_us,NoiseFileName,InFile,InFile(1),consonant,response,correct,TimeOfResponse);
    fclose(fout);
    
    %% feedback here if training
    if strcmpi(Train, 'train')
        VCVFeedback(correct, InFile, consonant, response, y, Fs, OutRMS);
    end
    
    %%  adaptive down procedure
    if ~strcmpi(TestType,'fixed')
        % ignore initial errors
        if ((trial>IgnoreTrials) || correct) % do the normal thing
            %% mark the direction and adjust correct_count
            if correct
                correct_count = correct_count + 1;

                if correct_count == criterion
                    current_change = -1;
                    next_nominal_SNR = nominal_SNR_dB +  change*current_change;
                    correct_count = 0;
                else
                    next_nominal_SNR = nominal_SNR_dB;
                end
            else
                current_change = 1;
                correct_count = 0;
                next_nominal_SNR = nominal_SNR_dB +  change*current_change;
            end

            % are we at a turnaround? If so, do a few things
            if (previous_change ~= current_change)
                % reduce step proportion if not minimum */
                if ((change-0.001) > MIN_change_dB) % allow for rounding error
                    change = change-inc;
                else % final turnarounds, so start keeping a tally
                    num_turns = num_turns + 1;
                    reversals(num_turns) = nominal_SNR_dB;
                    fprintf(fout,',*');
                end
                % reset change indicator and count of correct responses
                previous_change = current_change;
                criterion = final_criterion;
            end

            % record all levels visted over final reversals
            if num_turns
                levels_count = levels_count + 1;
                levels_visited(levels_count) = nominal_SNR_dB;
            end

            %% set level for next trial
            nominal_SNR_dB = next_nominal_SNR;

            % ensure that the current level is within the possible range and keep track of hitting the endpoints
            if nominal_SNR_dB>MAX_SNR_dB
                nominal_SNR_dB = MAX_SNR_dB;
                limit = limit+1;
            end
        else
            totalCorrect = totalCorrect + correct;
        end
    end
end  % end of a single trial */

levels_visited = levels_visited(1:levels_count);

%% We're done!
EndTime=fix(clock);
EndTimeString=sprintf('%02d:%02d:%02d',EndTime(4),EndTime(5),EndTime(6));

%% output summary statistics
fout = fopen(SummaryOutFile, 'at');
fprintf(fout, 'listener,date,sTime,endTime,TestType,tracking,SentType,stimuli,noise,VolumeSettings,manipulation,lateralised,ITD,version');
% adaptive procedures
if ~strcmp(TestType,'fixed')
    fprintf(fout, ',finish,uRevs,sdRevs,nRevs,nTrials,uLevs,sdLevs');
    fprintf(fout, '\n%s,%s,%s,%s,%s,%d,%s,%s,%s,%s,%s,%s,%+5.1f,%s', ...
        ListenerName,StartDate,StartTimeString,EndTimeString,...
        TestType,tracking,TargetType,TargetDirectory,NoiseFileName,Level,itd_invert,lateralize,ITD_us,VERSION);
    
    % print out summary statistics -- how did we get here?
    if (limit>=3) % bumped up against the limits
        fprintf(fout,',BUMPED');
    elseif strcmp(response,'quit')  % test for quitting
        fprintf(fout, ',QUIT');
    elseif (num_turns>=FINAL_TURNS)
        fprintf(fout, ',RanOut');
    else
        fprintf(fout, ',OK');
    end
    if num_turns>1
        reversals = reversals(1:num_turns);
        if rem(num_turns,2)
            mean_revs = mean(reversals(2:end));
            sd_revs = std(reversals(2:end));
        else
            mean_revs = mean(reversals);
            sd_revs = std(reversals);
        end
        fprintf(fout, ',%5.2f,%5.2f', mean_revs, sd_revs);
        mean_levs = mean(levels_visited);
        sd_levs = std(levels_visited);
    else
        mean_revs = 999;
        sd_revs = 0;
        mean_levs = 999;
        sd_levs = 0;
        fprintf(fout, ',,');
    end
    fprintf(fout, ',%d,%d,%5.2f,%5.2f', num_turns, trial, mean_levs, sd_levs);
else % fixed test
    fprintf(fout, ',SNR,nCorrect,nKW,pCorrect');
    fprintf(fout, '\n%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%+5.1f,%s', ...
        ListenerName,StartDate,StartTimeString,EndTimeString,...
        TestType,TargetType,TargetDirectory,NoiseFileName,VolumeSettingsFile,itd_invert,lateralize,ITD_us,VERSION);
    
    fprintf(fout, ',%g,%d,%d,%f', nominal_SNR_dB,totalCorrect, trial, totalCorrect/trial);
end

fclose(fout);
fclose('all');

%% write data to overall summary file
% Omit if it's a practice run, indicated by p at start of Listener code, or
% a training run

if ~strcmpi(ListenerName(1),'p')  && ~strcmpi(Train, 'train')
    
    fsum = fopen(csv_summary, 'at');
    if strcmpi(TestType, 'Fixed')
        fprintf(fsum, '%s,%s,%s,%s,%s,%s,%g,%d,%d,%4.3f\n', ...
            StartDate,StartTimeString,ListenerName,Session,TargetDirectory,NoiseFileName,nominal_SNR_dB,totalCorrect,trial,totalCorrect/trial);
    else
        fprintf(fsum, '%s,%s,%s,%d,%s,%s,%s,%5.1f,%5.1f\n', ...
            StartDate,StartTimeString,ListenerName,tracking,Session,TargetDirectory,NoiseFileName,mean_revs,sd_revs);
    end
    fclose(fsum);
end

set(0,'ShowHiddenHandles','on');
delete(findobj('Type','figure'));

if player==1
    if playrec('isInitialised')
        playrec('reset');
    end
end

finish; % indicate test is over



