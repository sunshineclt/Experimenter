function [ w, rect, userInfo ] = setUp( isFullScreen )
% setup app
% @param isFullScreen is full screen mode or not

javaaddpath('./MatlabExcelMac/Archive/jxl.jar');
javaaddpath('./MatlabExcelMac/Archive/MXL.jar');

import mymxl.*;
import jxl.*;   

prompt = {'id', 'Gender'};
dlgTitle = 'Experiment Participant"s Info';
numLines = 1;
defAns = {'', '0'};
userInfo = inputdlg(prompt, dlgTitle, numLines, defAns);

global SCREEN_SIZE_INCH VIEW_DISTANCE
SCREEN_SIZE_INCH = 19;
VIEW_DISTANCE = 80;
Screen('Preference', 'SkipSyncTests', 1);
InitializeMatlabOpenGL;
InitializePsychSound;
if (isFullScreen)
    [w, rect]=Screen('OpenWindow', 0, [80 80 80]);
else
    [w, rect]=Screen('OpenWindow', 0, [80 80 80], [0 0 400 400]);
end
Screen('TextFont', w, 'Calibri');
Screen('TextSize', w, 18);
ListenChar(2);
HideCursor;
DrawFormattedText(w, 'you will see 18 distractor disks\n and you will see two targets\nYou need to judge which target is presented first\nIf the left target is presented first, you should press "Z", otherwise you should press "M"\n The first block is a practice block', 'center', 'center', [255 255 255]);
Screen('Flip', w);
while true
    [~,~,KC] = KbCheck;
    if KC(KbName('space'))
        break;
    end
end

end
