function [ func ] = keyboardPressedFireJudgerBuilder( key )
%KEYBOARDPRESSEDFIREJUDGER Summary of this function goes here
%   Detailed explanation goes here
    keyCode = KbName(key);
    function isPressed = keyboardPressedFireJudger(obj)
        [~, ~, KC] = KbCheck;
        isPressed = false;
        if KC(keyCode)
            isPressed = true; 
        end
    end
    func = @(obj)keyboardPressedFireJudger(obj);
end