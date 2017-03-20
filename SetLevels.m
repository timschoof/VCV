function [SoundMasterLevel,SoundWaveLevel, InRMS, OutRMS] = SetLevels(VolumeSettingsFile, babyface)
%
% Routine to set levels at the beginning of a test
%
% Version 1.0 July 2011
% Version 2.0 September 2011
%   version specific for SentInNoise
% Version 3.0 May 2012
%   allow use of the babyface
%
% Stuart Rosen - stuart@phon.ucl.ac.uk
%

if nargin<2
    babyface=1;
end

%% Settings for level
% ensure the file is avilable
if exist(VolumeSettingsFile,'file')
    [SoundMasterLevel,SoundWaveLevel,InRMS,OutRMS]=textread(VolumeSettingsFile,'%f %f %f %f',1);
else
    FileMissingErrorMessage=sprintf('Missing file: %s does not exist', VolumeSettingsFile);
    h=msgbox(FileMissingErrorMessage, 'Missing file', 'error', 'modal'); uiwait(h);
    error(FileMissingErrorMessage);
end

%% set the volume controls on the basis of the size of the numbers in VolumeSettingsFile
if babyface  % need CoreAudioApi.dll for Windows 7 & Vista
    sendRMEmessage(0,7,SoundMasterLevel);
    SetMatlabVolume(SoundWaveLevel);
elseif max(SoundMasterLevel,SoundWaveLevel)<=1 % this is not Windows XP
    system(sprintf('SetWindowsVolume.exe %f',SoundMasterLevel));
    SetMatlabVolume(SoundWaveLevel);
else % Windows XP
    % need a VB .dll for this
    objSC= actxserver('SoundControl.General');
    invoke(objSC,'SetMasterLevel',SoundMasterLevel);
    invoke(objSC,'SetWaveLevel',SoundWaveLevel);
end


