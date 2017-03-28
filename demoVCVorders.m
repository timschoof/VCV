% function table = VCVcodes(InDir)

% t = VCVcodes('KM&TG_V');
order= VCVorder('KM&TG_V');

XX =  extractfield(order,'wave');
[uniqueXX, ~, J]=unique(XX);
occ = histc(J, 1:numel(uniqueXX));
occ'

XX =  extractfield(order,'vowel');
[uniqueXX, ~, J]=unique(XX);
occ = histc(J, 1:numel(uniqueXX));
occ'

XX =  extractfield(order,'speaker');
[uniqueXX, ~, J]=unique(XX);
occ = histc(J, 1:numel(uniqueXX));
occ'

XX =  extractfield(order,'consonant');
[uniqueXX, ~, J]=unique(XX);
occ = histc(J, 1:numel(uniqueXX));
occ'




