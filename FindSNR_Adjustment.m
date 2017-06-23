function SNR_Adjustment = FindSNR_Adjustment(C_Adjust, Stimulus)
%FindSNR_Adjustment Finds the required SNR adjustment for a specific stimulus from a list previously
% read-in as a cell array of strings using textscan.
% E.g., for VCV test  SNR_adj = FindSNR_Adjustment(C_VCV_adj, 'AB_A01a')

%   Detailed explanation goes here

VCV_name = C_Adjust{1};
SNR_adj = str2num(char(C_Adjust{2}));

SNR_Adjustment = SNR_adj(find(strcmp(VCV_name, Stimulus)));

end

