function trials = generateTrialCondition()
% GENERATETRIALCONDITION generate the trials within a block

    conditions = genTrials(1, [11 2 2]);
    SOA = conditions(:,1);
    tone = conditions(:,2) - 1;
    target_position = conditions(:,3) - 1;
    trials = cell(44);
    for i = 1:44
        trials{i} = Trial(SOA(i), tone(i), target_position(i));
    end
end