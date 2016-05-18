function [ w, rect ] = setUp( isFullScreen )
% setup app
% @param isFullScreen is full screen mode or not

global SCREEN_SIZE_INCH VIEW_DISTANCE
SCREEN_SIZE_INCH = 19;
VIEW_DISTANCE = 80;
Screen('Preference', 'SkipSyncTests', 1);
InitializeMatlabOpenGL;
if (isFullScreen)
    [w, rect]=Screen('OpenWindow', 0, [80 80 80]);
else
    [w, rect]=Screen('OpenWindow', 0, [80 80 80], [0 0 600 600]);
end
Screen('TextFont', w, 'Calibri');
Screen('TextSize', w, 18);
ListenChar(2);
HideCursor;

end
