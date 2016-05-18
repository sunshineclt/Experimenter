function main()
%% some prepare work
    [w, wrect] = setUp(true);
    global SCREEN_SIZE_INCH VIEW_DISTANCE
    tone = setUpSound();
%% all the callback needed by this expriment
    % show the fixationPoint (with flip)
    function showFixationPoint()
        fixationPoint.draw();
        Screen('Flip', w);
    end
    % show all disks together with fixationPoint (with flip)
    function showAllDisksAndFixationPoint()
        for i = 1:3
            for j = 1:3
                leftDisks{i, j}.draw();
                rightDisks{i, j}.draw();
            end
        end
        fixationPoint.draw();
        Screen('Flip', w);
    end
    % change one of the disks' color and then call showAllDisks()
    function changeColorAndShowAllDisks(direction)
        % direction means whether this time's change have direction
        % if direction == -1, it means no specific direction needed
        % if direction == 0, it means the change must happen on the left
        % if direction == 1, it means the change must happen on the right
        % and also the change can not happen on the 6th and 18th disk
        % because the 6th disk is the nearest disk to the left target
        % and the 18th disk is the nearest disk to the right target
        if direction == -1
            diskToChange = randi(18);
            while (diskToChange == 6) || (diskToChange == 13)
                diskToChange = randi(18);
            end
        elseif direction == 0
            diskToChange = randi(9);
            while (diskToChange == 6)
                diskToChange = randi(9);
            end
        elseif direction == 1
            diskToChange = randi(18);
            while (diskToChange == 13) || (diskToChange <= 9)
                diskToChange = randi(18);
            end
        end
        
        % if the diskToChange <= 9, it means the change happen on the left
        % side disks, otherwise on the right side disks
        if diskToChange <= 9
            % calculate the row index from diskToChange
            row = floor((diskToChange - 1) / 3) + 1;
            % calculate the column index from diskToChange
            column = mod((diskToChange - 1), 3) + 1;
            % change the color
            if isequal(leftDisks{row, column}.color, [221 122 96])
                leftDisks{row, column}.color = [0 145 73];
            else
                leftDisks{row, column}.color = [221 122 96];
            end
        else
            diskToChange = diskToChange - 9;
            % calculate the row index from diskToChange            
            row = floor((diskToChange - 1) / 3) + 1;
            % calculate the column index from diskToChange            
            column = mod((diskToChange - 1), 3) + 1;
            % change the color            
            if isequal(rightDisks{row, column}.color, [221 122 96])
                rightDisks{row, column}.color = [0 145 73];
            else
                rightDisks{row, column}.color = [221 122 96];
            end
        end
        
        % before the special change appointed in specialTrialIndex, the
        % leftTarget and rightTarget's color is the same as background, so
        % even though they are called draw() method, participants can not
        % recognize them. But after the specialTrialIndex's callback is
        % called, the leftTarget and rightTarget's color has changed to
        % [200 200 200] so the participants can recognize them.
        leftTarget.draw();
        rightTarget.draw();
        % draw the disks and fixationPoint with flip
        showAllDisksAndFixationPoint();
    end
    % show the first target (and also register 'z' and 'm' keyboard
    % event)(and also play the synchronized sound if needed)
    function showFirstTarget()
        % if the SOA is negative, it means the leftTarget will be shown
        % first, otherwise the rightTarget will be shown first
        if trial.SOA < 0
            leftTarget.color = [200 200 200];
            leftTarget.draw();
        else
            rightTarget.color = [200 200 200];
            rightTarget.draw();
        end
        % register 'z' & 'm' keyboard event to detect user's response to
        % the trial
        runloop.register(PCEvent('z_pressed', PCKeyboardPressedFireJudgerBuilder('z')), @()zPressed);
        runloop.register(PCEvent('m_pressed', PCKeyboardPressedFireJudgerBuilder('m')), @()mPressed);
        % if this trial contains the tone, then play it
        if trial.tone
            Snd('play', tone);
        end
        % draw the disks and fixationPoint with flip
        showAllDisksAndFixationPoint();
    end
    % show the second target
    function showSecondTarget()
        leftTarget.color = [200 200 200];
        rightTarget.color = [200 200 200];
        leftTarget.draw();
        rightTarget.draw();
        % draw the disks and fixationPoint with flip        
        showAllDisksAndFixationPoint();
    end
    % deregister the 'z' & 'm' keyboard event
    function destroyKeyListener()
        runloop.deregister('z_pressed');
        runloop.deregister('m_pressed');
    end
    % response to 'z_pressed' event
    function zPressed()
        disp('z pressed');
        % record this trial's response
        response = 0;
        % after participants' response, the listener should be destroyed
        destroyKeyListener();
    end
    % response to 'm_pressed' event
    function mPressed()
        disp('m pressed');
        % record this trial's response        
        response = 1;
        % after participants' response, the listener should be destroyed        
        destroyKeyListener();
    end
    % called when the trial is ended
    function trialEnd()
        Screen('Flip', w);
    end
    % called when 'esc' is pressed and quit the whole experiment
    function forceQuit()
        runloop.forceEndFlag = true;
    end

%% the main part of the expriment
    % for 15 blocks
    for block = 1:15
        % generate this block's trial condition
        trials = generateTrialCondition();
        % for 44 trials in one block
        for trialIndex = 1:44
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % prepare trial parameters %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % get this trial's info(it is a Trial instance)
            trial = trials{trialIndex};
            % choose the special change between 10 and 15 (target to be shown)
            specialChangeIndex = randi(6) + 9;
            % calculate the duration of the intervals between color changes
            colorChangeInterval = generateWithinTrialCondition(specialChangeIndex);
            % response record participant's response to this trial
            response = -1;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % prepare needed graphic object %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % instantialize the fixationPoint and set its center
            fixationPoint = PCFixationPoint(w, PCdeg2pix(0.5, SCREEN_SIZE_INCH, VIEW_DISTANCE),...
                PCdeg2pix(0.5, SCREEN_SIZE_INCH, VIEW_DISTANCE), PCFixationPointType.oval);
            fixationPoint.center = PCPoint(wrect(3) / 2, wrect(4) / 2);        
            % set up the leftDisks and rightDisks
            leftDisks = setUpDisks(w, fixationPoint.center.x - PCdeg2pix(3.75, SCREEN_SIZE_INCH, VIEW_DISTANCE), fixationPoint.center.y);
            rightDisks = setUpDisks(w, fixationPoint.center.x + PCdeg2pix(3.75, SCREEN_SIZE_INCH, VIEW_DISTANCE), fixationPoint.center.y);
            % set up the leftTarget and rightTarget
            % NOTICE: at first their color is the same as the background
            leftTarget = PCRectangle(w, PCdeg2pix(0.3, SCREEN_SIZE_INCH, VIEW_DISTANCE),...
                PCdeg2pix(0.3, SCREEN_SIZE_INCH, VIEW_DISTANCE), [80 80 80]);
            leftTarget.center = PCPoint(fixationPoint.center.x - PCdeg2pix(2, SCREEN_SIZE_INCH, VIEW_DISTANCE), fixationPoint.center.y);
            rightTarget = PCRectangle(w, PCdeg2pix(0.3, SCREEN_SIZE_INCH, VIEW_DISTANCE),...
                PCdeg2pix(0.3, SCREEN_SIZE_INCH, VIEW_DISTANCE), [80 80 80]);
            rightTarget.center = PCPoint(fixationPoint.center.x + PCdeg2pix(2, SCREEN_SIZE_INCH, VIEW_DISTANCE), fixationPoint.center.y);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % set up the flow using PCRunloop %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % instantialize a PCRunloop (a trial last for 3.1s)
            runloop = PCRunloop(@(obj)GetSecs() - obj.startTime > 3.1, @()Screen('Flip', w));
            % register esc_pressed event to runloop, when fired it caused
            % the experiment to quit
            escPressed = PCEvent('esc_pressed', PCKeyboardPressedFireJudgerBuilder('escape'));
            runloop.register(escPressed, @()forceQuit);
            % register begin event to runloop, it will be fired immediately
            % when the runloop begins, and it will show a fixationPoint
            beginEvent = PCEvent('begin', PCTimeReachedFireJudgerBuilder(0));
            runloop.register(beginEvent, @()showFixationPoint);
            % register the first show of all the disks
            runloop.register(PCEvent('1_show_disk', PCTimeReachedFireJudgerBuilder(1)), @()showAllDisksAndFixationPoint)
            % because of the fixationPoint will last for 1 seconds, so
            % now_time is 1
            time = 1;
            for changeIndex = 1:21
                % the next change will be happened after certain interval
                time = time + colorChangeInterval(changeIndex);
                % if this is the last change(21), it means end of trial
                % rather than color change
                if changeIndex ~= 21
                    event = PCEvent(sprintf('%d_show_disk', changeIndex + 1), PCTimeReachedFireJudgerBuilder(time));
                    % if this is the special change (target to be shown)
                    % then the color change's position need to be specified
                    % and the two target_show events need to be registered
                    if changeIndex ~= specialChangeIndex
                        runloop.register(event, @()changeColorAndShowAllDisks(-1));
                    else
                        runloop.register(event, @()changeColorAndShowAllDisks(trial.distractorLocation));
                        runloop.register(PCEvent('first_target_show', PCTimeReachedFireJudgerBuilder(time + 0.125)), @()showFirstTarget);
                        runloop.register(PCEvent('second_target_show', PCTimeReachedFireJudgerBuilder(time + 0.125 + abs(trial.SOA))), @()showSecondTarget);                   
                    end
                else
                    event = PCEvent('end_of_trial', PCTimeReachedFireJudgerBuilder(time));
                    runloop.register(event, @()trialEnd);
                end
            end
            % end of event register
            
            % run the whole flow
            runloop.run();
            % if the esc is pressed, the expriment should be terminated
            if runloop.forceEndFlag
                closeDown();
                return;
            end
            
            %%%%%%%%%%%%%
            % save data %
            %%%%%%%%%%%%%
            % TODO
        end
        % one block has over, give participant some time to rest
        DrawFormattedText(w, 'You can have a rest as you like\nPress any key to continue', 'center', 'center', [255 255 255]);
        Screen('Flip', w);
        pause;
    end
    % end of the experiment
    closeDown();
end

function disks = setUpDisks(w, x, y)
% SETUPDISKS initialize one side's 9 ovals
    disks = cell(3,3);
    global SCREEN_SIZE_INCH VIEW_DISTANCE
    interval = PCdeg2pix(0.83, SCREEN_SIZE_INCH, VIEW_DISTANCE);
    radius = PCdeg2pix(0.3, SCREEN_SIZE_INCH, VIEW_DISTANCE);
    for i = 1:3
        for j = 1:3
            randColor = randi(2);
            if randColor == 1
                % [221 122 96] is a red color
                disks{i, j} = PCOval(w, radius, radius, [221 122 96]);
            else
                % [0 145 73] is a green color
                disks{i, j} = PCOval(w, radius, radius, [0 145 73]);
            end
            disks{i, j}.center = PCPoint(x + (i - 2) * interval, y+ (j - 2) * interval);
        end
    end
end