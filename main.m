runloop = PCRunloop(@(obj)GetSecs()-obj.startTime>3);
zPressed = PCEvent('zPressed',keyboardPressedFireJudgerBuilder('z'),runloop);
runloop.register(zPressed, @()disp('z Pressed!'));
runloop.register(zPressed, @()disp('z Pressed!!'));
xPressed = PCEvent('xPressed',keyboardPressedFireJudgerBuilder('x'),runloop);
runloop.register(xPressed, @()disp('x Pressed!'));
timeReached = PCEvent('2sReached', @(obj)GetSecs()-obj.startTime>2, runloop);
runloop.register(timeReached, @()disp('2s Reached!!'));
runloop.run();