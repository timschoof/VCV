function [status, message_out] = CheckOpenFile(FileName,excel_close)
% CheckOpenFile Check whether the specified file is open and close it automatically if possible

%   Intended for situation where a summary csv file may have been left open in excel and 
%   writing to it would cause a crash.
%   status = 0   -  file wasn't open
%   status = 1   -  file was open but has been shut
%   status = 2   -  file remains open, so will need to be shut manually 

if nargin<2
    excel_close = 1;
end
status = 0;

full_record_file = fullfile(cd,FileName);

message_out = sprintf('File %s not open.\n', FileName);

if excel_close
    try
        %Check if an Excel server is running
        ex = actxGetRunningServer('Excel.Application');
    catch ME
        disp(ME.message)
    end
    
    if exist('ex','var')
        %Get the names of all open Excel files
        wbs = ex.Workbooks;
        for i = 1:wbs.Count
            if strcmp(full_record_file,wbs.Item(i).FullName)
                wbs.Item(i).Close;
                status = 1;
                message_out = sprintf('File %s was open, but has been closed.\n', full_record_file);  
            end
        end
    end
end

%% try another approach in case closing excel doesn't work or isn't wanted
    [fid, message] = fopen(FileName, 'r+');
    if ~isempty(message)
%         fprintf('Problem accessing %s. Make sure file is closed and re-try.\n', FileName);
%         delete(findobj('Type','figure'));
        status = 2;
        message_out = sprintf('File %s is open, and needs to be closed.\n', full_record_file);
        return
    else
        fclose(fid);
    end
end

