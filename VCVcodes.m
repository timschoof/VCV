function table = VCVcodes(InDir)
%
%  construct a table of file names from an arbitrary set of directories, coding the essential differences between files
%

%
%	Stuart Rosen November 2001 -- Dominique's non-native perceivers
%	stuart@phon.ucl.ac.uk

Files = dir(fullfile(InDir, '*.wav'));
nFiles = size(Files);

for i=1:nFiles
   % construct full path file names, and decode
   table(i).wave =  fullfile(InDir, Files(i).name);
   [~,name,~] = fileparts(Files(i).name); 
   table(i).vowel = (name(1));
   % leave _ after singletons for ease of generating order
   table(i).consonant=(Files(i).name([2:3]));
   table(i).speaker = (Files(i).name(8:9));
   table(i).number = Files(i).name([5:6]);
   table(i).played = 0;
end
   
