function varargout = VCVTestSpecs(varargin)
%
%   output variables:  ** needs updating **
%   1: test type:   'fixed' 'adaptiveup' 'adaptivedown'
%   2: Ear(s) to test:  'Both' 'L' 'R'
%   3: Target directory: e.g., 'IEEE'
%   4: Masker: e.g., 'SpchNz.wav'
%   5: SNR in dB: e.g., -4,
%   6: Listener code: e.g., LGP01
%   
%
% VCVTESTSPECS M-file for VCVTestSpecs.fig
%      VCVTESTSPECS, by itself, creates a new VCVTESTSPECS or raises the existing
%      singleton*.
%
%      H = VCVTESTSPECS returns the handle to a new VCVTESTSPECS or the handle to
%      the existing singleton*.
%
%      VCVTESTSPECS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VCVTESTSPECS.M with the given input arguments.
%
%      VCVTESTSPECS('Property','Value',...) creates a new VCVTESTSPECS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TestSpecs_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VCVTestSpecs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VCVTestSpecs

% Last Modified by GUIDE v2.5 08-Jun-2017 10:35:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VCVTestSpecs_OpeningFcn, ...
                   'gui_OutputFcn',  @VCVTestSpecs_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before VCVTestSpecs is made visible.
function VCVTestSpecs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VCVTestSpecs (see VARARGIN)

% Move the GUI to the center of the screen.
movegui(hObject,'center')

% Choose default command line output for VCVTestSpecs
handles.output = hObject;

% set default session number
handles.Session = '0';

% set default test mode
handles.Train = 'test';

% set default for no adjustment to SNRs across individual 
handles.SNR_adj_file = 'none';

% set default Volume Settings file 
handles.VolumeSettingsFile = 'VolumeSettings.txt';

% process any arguments to re-set the VCVTestSpecs GUI
if length(varargin{1})>1
    for index=1:2:length(varargin{1})
        if length(varargin{1}) < index+1
            break;
        elseif strcmpi('NoiseFile', varargin{1}(index))
            set(handles.MaskerFile,'String',['Maskers\' char(varargin{1}(index+1))]);
        elseif strcmpi('SentenceDirectory', varargin{1}(index))
            set(handles.OrderFile,'String',char(varargin{1}(index+1)));
        elseif strcmpi('SNR_adj_file', varargin{1}(index))
            set(handles.adjFile,'String',char(varargin{1}(index+1)));
        elseif strcmpi('VolumeSettingsFile', varargin{1}(index))
            set(handles.VolSetFile,'String',char(varargin{1}(index+1)));
        elseif strcmpi('ListName', varargin{1}(index))
            set(handles.ListName,'String',num2str(cell2mat(varargin{1}(index+1)))); 
        elseif strcmpi('Listener', varargin{1}(index))
            set(handles.ListenerCode,'String',char(varargin{1}(index+1)));
        elseif strcmpi('SNR', varargin{1}(index))
            set(handles.StartLevel,'String',num2str(cell2mat(varargin{1}(index+1))));
        elseif strcmpi('Channels', varargin{1}(index))
            set(handles.Channels_edit,'String',char(varargin{1}(index+1)));
        elseif strcmpi('ear', (varargin{1}(index)))
            if strcmpi(char(upper(varargin{1}(index+1))),'B')
                set(handles.Both, 'Value', 1)
            elseif strcmpi(char(upper(varargin{1}(index+1))),'L')
                set(handles.Left, 'Value', 1)    
            elseif strcmpi(char(upper(varargin{1}(index+1))),'R')
                set(handles.Right, 'Value', 1)                         
            end         
        elseif strcmpi('TestType', varargin{1}(index))
            if strcmpi('adaptiveUp', char(varargin{1}(index+1)))
                set(handles.adaptiveUp,'Value',1);
            elseif strcmpi('adaptiveDown', char(varargin{1}(index+1)))
                set(handles.adaptiveDown,'Value',1);
            else
                set(handles.fixed,'Value',1)
            end                 
        elseif strcmpi('FinalStep', varargin{1}(index))
            set(handles.FinalStepSize,'String',num2str(cell2mat(varargin{1}(index+1))));  
        elseif strcmpi('Repetitions', varargin{1}(index))
            set(handles.Repetitions,'String',num2str(cell2mat(varargin{1}(index+1))));
            
        elseif strcmpi('Session', varargin{1}(index))
            handles.Session = char(varargin{1}(index+1));
        elseif strcmpi('Train', varargin{1}(index))
            handles.Train = char(varargin{1}(index+1));
        elseif strcmpi('SNR_adj_file', varargin{1}(index))
            handles.SNR_adj_file = char(varargin{1}(index+1));
        elseif strcmpi('ITD_us', varargin{1}(index))
            set(handles.itd_us,'String',num2str(cell2mat(varargin{1}(index+1))));
        elseif strcmpi('itd_invert', (varargin{1}(index)))
            if strcmpi(char(upper(varargin{1}(index+1))),'ITD')
                set(handles.ITD, 'Value', 1)
            elseif strcmpi(char(upper(varargin{1}(index+1))),'inverted')
                set(handles.inverted, 'Value', 1) 
            elseif strcmpi(char(upper(varargin{1}(index+1))),'none')
                set(handles.none, 'Value', 1) 
            end   
        elseif strcmpi('lateralize', (varargin{1}(index)))
            if strcmpi(char(upper(varargin{1}(index+1))),'signal')
                set(handles.signal, 'Value', 1)
            elseif strcmpi(char(upper(varargin{1}(index+1))),'noise')
                set(handles.noise, 'Value', 1) 
            elseif strcmpi(char(upper(varargin{1}(index+1))),'signz')
                set(handles.signz, 'Value', 1) 
            end  
        elseif strcmpi('VolumeSettingsFile', varargin{1}(index))
            handles.VolumeSettingsFile = char(varargin{1}(index+1));
        else
            error('Illegal option: %s -- Legal options are:\nTestType\nNoiseFile\nSentenceDirectory\nListName\nListener\nFinalStep\nRepetitions\nSNR\nSession\nTrain\nSNR_adj_file\nVolumeSettingsFile', ...
                char(varargin{1}(index)));
        end
    end
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VCVTestSpecs wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VCVTestSpecs_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.AorF;
varargout{2} = handles.Ear;
varargout{3} = handles.O;
varargout{4} = handles.M;
varargout{5} = handles.SNR;
varargout{6} = handles.L;
varargout{7} = handles.Reps;
varargout{8} = handles.List;
varargout{9} = handles.step;
varargout{10} = handles.Session;
varargout{11} = handles.Train;
varargout{12} = handles.SNR_adj_file;
varargout{13} = handles.VolumeSettingsFile;
varargout{14} = handles.itd_invert;
varargout{15} = handles.lateralize;
varargout{16} = handles.itd_us;

% The figure can be deleted now
delete(handles.figure1);


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function StartLevel_Callback(hObject, eventdata, handles)
% hObject    handle to StartLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StartLevel as text
%        str2double(get(hObject,'String')) returns contents of StartLevel as a double


% --- Executes during object creation, after setting all properties.
function StartLevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StartLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OrderFile_Callback(hObject, eventdata, handles)
% hObject    handle to OrderFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OrderFile as text
%        str2double(get(hObject,'String')) returns contents of OrderFile as a double


% --- Executes during object creation, after setting all properties.
function OrderFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OrderFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TestTrials_Callback(hObject, eventdata, handles)
% hObject    handle to TestTrials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TestTrials as text
%        str2double(get(hObject,'String')) returns contents of TestTrials as a double


% --- Executes during object creation, after setting all properties.
function TestTrials_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TestTrials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MaskerFile_Callback(hObject, eventdata, handles)
% hObject    handle to MaskerFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaskerFile as text
%        str2double(get(hObject,'String')) returns contents of MaskerFile as a double


% --- Executes during object creation, after setting all properties.
function MaskerFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaskerFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ListenerCode_Callback(hObject, eventdata, handles)
% hObject    handle to ListenerCode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ListenerCode as text
%        str2double(get(hObject,'String')) returns contents of ListenerCode as a double


% --- Executes during object creation, after setting all properties.
function ListenerCode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ListenerCode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.adaptiveUp,'Value')
    handles.AorF='adaptiveUp';
elseif get(handles.adaptiveDown,'Value')
    handles.AorF='adaptiveDown'; 
else
    handles.AorF='fixed';
end
if get(handles.Both,'Value')
    handles.Ear='B';
elseif get(handles.Left,'Value')
    handles.Ear='L';
elseif get(handles.Right,'Value')
    handles.Ear='R';
else
    handles.Ear='Other';
end
if get(handles.signal,'Value')
    handles.lateralize='signal';
elseif get(handles.noise,'Value')
    handles.lateralize='noise';
else get(handles.signz,'Value')
    handles.lateralize='signz';
end
if get(handles.ITD,'Value')
    handles.itd_invert='ITD';
elseif get(handles.inverted,'Value')
    handles.itd_invert='inverted';
elseif get(handles.none,'Value')
    handles.itd_invert='none';
end

handles.O = get(handles.OrderFile,'String');
handles.M = get(handles.MaskerFile,'String');
handles.SNR = str2num(get(handles.StartLevel,'String'));
handles.L = get(handles.ListenerCode,'String');
handles.Reps = str2num(get(handles.Repetitions,'String'));
handles.itd_us = str2num(get(handles.itd_us,'String'));
handles.List = get(handles.ListName,'String');
handles.step = str2num(get(handles.FinalStepSize,'String'));
handles.VolumeSettingsFile = get(handles.VolSetFile,'String');
handles.SNR_adj_file = get(handles.adjFile,'String');

guidata(hObject, handles); % Save the updated structure
uiresume(handles.figure1);

% --------------------------------------------------------------------
function AdaptiveOrFixed_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to AdaptiveOrFixed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles.AorF=lower(get(hObject,'Tag'))   % Get Tag of selected object

function Repetitions_Callback(hObject, eventdata, handles)
% hObject    handle to Repetitions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Repetitions as text
%        str2double(get(hObject,'String')) returns contents of Repetitions as a double


% --- Executes during object creation, after setting all properties.
function Repetitions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Repetitions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ListName_Callback(hObject, eventdata, handles)
% hObject    handle to ListName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ListName as text
%        str2double(get(hObject,'String')) returns contents of ListName as a double


% --- Executes during object creation, after setting all properties.
function ListName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ListName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function FinalStepSize_Callback(hObject, eventdata, handles)
% hObject    handle to FinalStepSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FinalStepSize as text
%        str2double(get(hObject,'String')) returns contents of FinalStepSize as a double


% --- Executes during object creation, after setting all properties.
function FinalStepSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FinalStepSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Channels_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Channels_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Channels_edit as text
%        str2double(get(hObject,'String')) returns contents of Channels_edit as a double


% --- Executes during object creation, after setting all properties.
function Channels_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Channels_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Shift_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Shift_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Shift_edit as text
%        str2double(get(hObject,'String')) returns contents of Shift_edit as a double


% --- Executes during object creation, after setting all properties.
function Shift_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Shift_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function itd_us_Callback(hObject, eventdata, handles)
% hObject    handle to itd_us (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of itd_us as text
%        str2double(get(hObject,'String')) returns contents of itd_us as a double


% --- Executes during object creation, after setting all properties.
function itd_us_CreateFcn(hObject, eventdata, handles)
% hObject    handle to itd_us (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function adjFile_Callback(hObject, eventdata, handles)
% hObject    handle to adjFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of adjFile as text
%        str2double(get(hObject,'String')) returns contents of adjFile as a double


% --- Executes during object creation, after setting all properties.
function adjFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to adjFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function VolSetFile_Callback(hObject, eventdata, handles)
% hObject    handle to VolSetFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VolSetFile as text
%        str2double(get(hObject,'String')) returns contents of VolSetFile as a double


% --- Executes during object creation, after setting all properties.
function VolSetFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VolSetFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
