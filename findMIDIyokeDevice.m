function myDev = findMIDIyokeDevice(verbose)
% FINDMIDIYOKEDEVICE
% searches through the available MIDI devices to find the device called
% 'Out To MIDI Yoke:  1' and returns the handle to it. If the device can't
% be found, it returns empty. This assumes that the MIDI yoke available
% from midiox.com has been installed.
%
% Usage:    myDev = findMIDIyokeDevice(verbose)
% Input parameter:
%           verbose - optional binary parameter to output status to the 
%               command window while running (default is 0 or not verbose)
%
% 20120511 Eric Thompson

% if no input argument, then default is not verbose
if(nargin<1)
    verbose = 0;
end

% load java libraries for MIDI
import javax.sound.midi.*

% get list of MIDI devices
info = MidiSystem.getMidiDeviceInfo;

% find the appropriate MIDI device (look for 'Out To MIDI Yoke:  1')
myDevIdx = -1;
for devIdx = 1:length(info)
    midiDevice = MidiSystem.getMidiDevice(info(devIdx));
    if(verbose)
        disp([num2str(devIdx) ': ' char(midiDevice.getDeviceInfo.toString)])
    end
    if(~isempty(findstr(char(midiDevice.getDeviceInfo.toString),'Out To MIDI Yoke:  1'))) % change this if your device is called something different
         myDevIdx = devIdx;
        break
    end
end

if(myDevIdx<0) % if the device can't be found
    warning('findMIDIyokeDevice:noMIDIdev','Could not find MIDI output device')
    myDev = [];
    return
else
    if(verbose)
        disp('MIDI Device found')
    end
end

% try opening device
if(verbose)
    disp('Testing connection to MIDI device')
end
myDev = MidiSystem.getMidiDevice(info(myDevIdx));
myDev.open;
tic
while(~myDev.isOpen && toc<2) % 2 second timeout
    pause(0.1)
end
if(~myDev.isOpen) % if device can't be opened
    warning('findMIDIyokeDevice:notOpen','Could not open device')
    myDevIdx = [];
    return
else
    if(verbose)
        disp('MIDI device opened')
        disp('Closing device...')
    end
end
% close the device again for cleanliness
myDev.close;
while(myDev.isOpen && toc<2) % 2 second timeout
    pause(0.1)
end
if(verbose && ~myDev.isOpen)
    disp('...closed')
end
end
%eof