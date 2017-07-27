% [TestType, ear, TargetDirectory, NoiseFile, SNR_dB, OutFile, Reps, MIN_change_dB,...
%     Session, Train, SNR_adj_file,VolumeSettingsFile,itd_invert,lateralize,ITD_us] = VCVTestSpecs(mInputArgs);

VCVInNoise('SNR_adj_file', 'VCV_adjust_SNR_KM&TG.csv','SNR', -10, ...
'Listener','L01','NoiseFile','SpNz44100.wav',...
'ITD_us','650','itd_invert','ITD','lateralize','noise',...
'ear','b','TestType','adaptiveUp',...
'VolumeSettingsFile','VolumeSettings-80dBSPL.txt')

VCVInNoise('SNR_adj_file', 'VCV_adjust_SNR_KM&TG.csv','SNR', -10, ...
'Listener','L01','NoiseFile','SpNz44100.wav',...
'ITD_us','650','itd_invert','ITD','lateralize','signz',...
'ear','b','TestType','adaptiveUp',...
'VolumeSettingsFile','VolumeSettings-80dBSPL.txt')

VCVInNoise('SNR_adj_file', 'VCV_adjust_SNR_KM&TG.csv','SNR', -10, ...
'Listener','L01','NoiseFile','SpNz44100.wav',...
'ITD_us','0','itd_invert','inverted','lateralize','signal',...
'ear','b','TestType','adaptiveUp',...
'VolumeSettingsFile','VolumeSettings-80dBSPL.txt')

VCVInNoise('SNR_adj_file', 'VCV_adjust_SNR_KM&TG.csv','SNR', -10, ...
'Listener','L01','NoiseFile','SpNz44100.wav',...
'ITD_us','0','itd_invert','inverted','lateralize','noise',...
'ear','b','TestType','adaptiveUp',...
'VolumeSettingsFile','VolumeSettings-80dBSPL.txt')

VCVInNoise('SNR_adj_file', 'VCV_adjust_SNR_KM&TG.csv','SNR', -10, ...
'Listener','L01','NoiseFile','SpNz44100.wav',...
'ITD_us','0','itd_invert','inverted','lateralize','signz',...
'ear','b','TestType','adaptiveUp',...
'VolumeSettingsFile','VolumeSettings-80dBSPL.txt')

VCVInNoise('SNR_adj_file', 'VCV_adjust_SNR_KM&TG.csv','SNR', -10, ...
'Listener','L01','NoiseFile','SpNz44100.wav',...
'ITD_us','0','itd_invert','none','lateralize','noise',...
'ear','b','TestType','adaptiveUp',...
'VolumeSettingsFile','VolumeSettings-80dBSPL.txt')

VCVInNoise('SNR_adj_file', 'VCV_adjust_SNR_KM&TG.csv','SNR', -10, ...
'Listener','L01','NoiseFile','SpNz44100.wav',...
'ITD_us','650','itd_invert','ITD','lateralize','signal',...
'ear','b','TestType','adaptiveUp',...
'VolumeSettingsFile','VolumeSettings-80dBSPL.txt')

