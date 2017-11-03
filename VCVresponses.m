function answer = VCVresponses(varargin)
% RESPONSES Application M-file for responses.fig
%    FIG = RESPONSES launch responses GUI.
%    RESPONSES('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 29-Nov-2001 08:41:01

if nargin == 0 || isnumeric(varargin{1}) % LAUNCH GUI

    fig = openfig(mfilename,'reuse');
    movegui(fig, 'center');
    
    % Use system color scheme for figure:
    set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));
    
    % Generate a structure of handles to pass to callbacks, and store it.
    handles = guihandles(fig);
    guidata(fig, handles);
    
    %	if nargout > 0
    %		varargout{1} = fig;
    %	end
    pause(0.3);

    audio=varargin{1};
    if varargin{3} == 1 % if you're using playrec
        playrec('play', audio, [3,4]);
    elseif varargin{3} == 0 % if you're not using playrec
        aud_obj = audioplayer(varargin{1},varargin{2});
        playblocking(aud_obj);
    end
    
    % Wait for callbacks to run and window to be dismissed:
    uiwait(fig);
    
    % UIWAIT might have returned because the window was deleted using
    % the close box - in that case, return 'X' as the answer, and
    % don't bother deleting the window!
    if ~ishandle(fig)
        answer = 'quit';
    else
        % otherwise, we got here because the user pushed one of the two buttons.
        % retrieve the latest copy of the 'handles' struct, and return the answer.
        % Also, we need to delete the window.
        handles = guidata(fig);
        answer = handles.response;
        %	  delete(fig);
    end


elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
	catch
		disp(lasterr);
	end
end


%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.


% Row 1
% --------------------------------------------------------------------
function varargout = choice11_Callback(h, eventdata, handles, varargin) %B
% Stub for Callback of the uicontrol handles.choice11.
% get(handles.choice11, 'String');
handles.response = get(handles.choice11, 'String');
guidata(h, handles);
uiresume(handles.figure1);

% --------------------------------------------------------------------
function varargout = choice21_Callback(h, eventdata, handles, varargin) %D
% Stub for Callback of the uicontrol handles.choice21.
% get(handles.choice21, 'String');
handles.response = get(handles.choice21, 'String');
guidata(h, handles);
uiresume(handles.figure1);

% --------------------------------------------------------------------
function varargout = choice31_Callback(h, eventdata, handles, varargin) %F
% Stub for Callback of the uicontrol handles.choice31.
% get(handles.choice31, 'String');
handles.response = get(handles.choice31, 'String');
guidata(h, handles);
uiresume(handles.figure1);

% --------------------------------------------------------------------
function varargout = choice41_Callback(h, eventdata, handles, varargin) %G
% get(handles.choice41, 'String');
handles.response = get(handles.choice41, 'String');
guidata(h, handles);
uiresume(handles.figure1);

% Row 2
% --------------------------------------------------------------------
function varargout = choice12_Callback(h, eventdata, handles, varargin) %K
% Stub for Callback of the uicontrol handles.choice12.
% get(handles.choice12, 'String');
handles.response = get(handles.choice12, 'String');
guidata(h, handles);
uiresume(handles.figure1);

% --------------------------------------------------------------------
function varargout = choice44_Callback(h, eventdata, handles, varargin) %L
% get(handles.choice44, 'String');
handles.response = get(handles.choice44, 'String');
guidata(h, handles);
uiresume(handles.figure1);

% --------------------------------------------------------------------
function varargout = choice22_Callback(h, eventdata, handles, varargin) %M
% Stub for Callback of the uicontrol handles.choice22.
% get(handles.choice22, 'String');
handles.response = get(handles.choice22, 'String');
guidata(h, handles);
uiresume(handles.figure1);

% --------------------------------------------------------------------
function varargout = choice32_Callback(h, eventdata, handles, varargin) %N
% Stub for Callback of the uicontrol handles.choice31.
% get(handles.choice32, 'String');
handles.response = get(handles.choice32, 'String');
guidata(h, handles);
uiresume(handles.figure1);

% Row 3
% --------------------------------------------------------------------
function varargout = choice42_Callback(h, eventdata, handles, varargin) %P
% get(handles.choice42, 'String');
handles.response = get(handles.choice42, 'String');
guidata(h, handles);
uiresume(handles.figure1);

% --------------------------------------------------------------------
function varargout = choice43_Callback(h, eventdata, handles, varargin) %V
% get(handles.choice43, 'String');
handles.response = get(handles.choice43, 'String');
guidata(h, handles);
uiresume(handles.figure1);

% --------------------------------------------------------------------
function varargout = choice14_Callback(h, eventdata, handles, varargin) %W
% get(handles.choice13, 'String');
handles.response = get(handles.choice14, 'String');
guidata(h, handles);
uiresume(handles.figure1);

% --------------------------------------------------------------------
function varargout = choice24_Callback(h, eventdata, handles, varargin) %Y
% get(handles.choice24, 'String');
handles.response = get(handles.choice24, 'String');
guidata(h, handles);
uiresume(handles.figure1);

% Row 4
% --------------------------------------------------------------------
function varargout = choice34_Callback(h, eventdata, handles, varargin) %Z
% get(handles.choice11, 'String');
handles.response = get(handles.choice34, 'String');
guidata(h, handles);
uiresume(handles.figure1);


% --------------------------------------------------------------------
function varargout = QuitButton_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.QuitButton.
handles.response = 'quit';
guidata(h, handles);
uiresume(handles.figure1);

% --------------------------------------------------------------------
function varargout = StartButton_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.QuitButton.
handles.response = 'start';
guidata(h, handles);
set(handles.pushbutton22, 'Visible', 'off');
uiresume(handles.figure1);
