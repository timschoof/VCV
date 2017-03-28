function order=VCVorder(InDir)

% generate a random order of VCVS, sampled without replacement
% For each vowel, consonant and speaker, a random wave is chosen
%  Here the files are assumed to be named:
%     VC[C or _]Vxx_[KM or TG].wav
%     where xx is a two-digit number 01, 02, etc.
%     KM = K Mair (F) TG = T Green (M)
%

% Use one directory, 2 speakers, 3 vowels, 13 consonants = 78 stimuli
vowels = {'I' 'A' 'U'};
% consonants = {'b_' 'ch' 'd_' 'f_' 'g_' 'j_' 'k_' 'l_' 'm_' 'n_' 'p_' 'r_' 's_' 'sh' 't_' 'th' 'v_' 'w_' 'y_' 'z_' 'zh'};
consonants = {'B_' 'D_' 'F_' 'G_' 'K_' 'L_' 'M_' 'N_' 'P_' 'V_' 'W_' 'Y_' 'Z_' };
speakers= {'KM' 'TG'};
% get information about all the files available
AllFiles = VCVcodes(InDir);
nAllFiles = size(AllFiles);
nAllFiles = nAllFiles(2);

% construct a list of all the possible file names
i=1;
for s=1:size(speakers')
    for v=1:size(vowels')
        for c=1:size(consonants')
            % Find all the .wav files that match consonant, vowel and speaker
            matches=0;
            for n=1:nAllFiles
                if (vowels{v}==AllFiles(n).vowel & strcmp(consonants{c},AllFiles(n).consonant) & speakers{s}==AllFiles(n).speaker)
                    matches=matches+1;
                    numbers(matches).number=AllFiles(n).number;
                    numbers(matches).order=n; % save away index to get back to this item
                end
            end
            if (matches==0) % no stimuli of this type are available
                fprintf('ERROR! No stimuli available: %s %s %s\n', vowels{v}, consonants{c}, speakers{s});
                return
            end
            % pick a random number from list
            % n = orandint(1,1,[1 matches]);
            n = randi(matches);
            while AllFiles(numbers(n).order).played==1
                n = randi(matches);
            end   % found an unplayed file
            AllFiles(numbers(n).order).played=1;
            % construct the file name, and save away any further information
            tmp(i).wave=[vowels{v} consonants{c} vowels{v} numbers(n).number '_' speakers{s} '.wav' ];
            tmp(i).vowel=vowels{v};
            tmp(i).consonant=consonants{c};
            tmp(i).speaker = speakers{s};
            i=i+1;
        end
    end
end

% generate a random permutation of the list
total = size(speakers').*size(vowels').*size(consonants');
ll=3; % fake value to get loop to compute at least once
while max(ll)>2
    permutation = randperm(total(1)); 
    
    for i=1:total
        order(i).wave = tmp(permutation(i)).wave;
        order(i).vowel = tmp(permutation(i)).vowel;
        order(i).consonant = strrep(tmp(permutation(i)).consonant,'_','');
        order(i).speaker = tmp(permutation(i)).speaker;
    end
   
    [vv, ll]=rleSR(char(extractfield(order,'consonant')));
    
end





