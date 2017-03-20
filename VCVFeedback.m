function varargout = VCVFeedback(varargin)
% VCVFEEDBACK MATLAB code for VCVFeedback.fig
%      VCVFEEDBACK, by itself, creates a new VCVFEEDBACK or raises the existing
%      singleton*.
%
%      H = VCVFEEDBACK returns the handle to a new VCVFEEDBACK or the handle to
%      the existing singleton*.
%
%      VCVFEEDBACK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VCVFEEDBACK.M with the given input arguments.
%
%      VCVFEEDBACK('Property','Value',...) creates a new VCVFEEDBACK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VCVFeedback_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VCVFeedback_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VCVFeedback

% Last Modified by GUIDE v2.5 21-Jan-2016 16:22:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VCVFeedback_OpeningFcn, ...
                   'gui_OutputFcn',  @VCVFeedback_OutputFcn, ...
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


% --- Executes just before VCVFeedback is made visible.
function VCVFeedback_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VCVFeedback (see VARARGIN)

% Choose default command line output for VCVFeedback
% handles.output = hObject;

% Move the GUI to the center of the screen.
movegui(hObject,'center')

%% Display appropriate buttons according to response correct or not
if varargin{1}
    set(handles.Incorrect, 'Visible', 'Off');
    set(handles.Played_text, 'Visible', 'Off');
    set(handles.Response_text, 'Visible', 'Off');
    set(handles.PlayButton, 'Visible', 'Off');
else
    set(handles.Correct, 'Visible', 'Off');
    
    VCVFileName = varargin{2};
    V = VCVFileName(1);
    VCV = [lower(V) '_' upper(varargin{3}) '_' lower(V)];
    
    set(handles.Response_text, 'String', ['You pressed    ' upper(varargin{4})]);
    set(handles.Played_text, 'String', ['It was    ' VCV]);
    handles.y = varargin{5};
    handles.Fs = varargin{6};
    handles.OutRMS = varargin{7};
end


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VCVFeedback wait for user response (see UIRESUME)
uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = VCVFeedback_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;

delete(handles.figure1);

% --- Executes on button press in PlayButton.
function PlayButton_Callback(hObject, eventdata, handles)
% hObject    handle to PlayButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

scaled_y = handles.y * handles.OutRMS/rms(handles.y);

aud_obj = audioplayer(scaled_y,handles.Fs);
playblocking(aud_obj);


% --- Executes on button press in OKButton.
function OKButton_Callback(hObject, eventdata, handles)
% hObject    handle to OKButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


uiresume(handles.figure1);
