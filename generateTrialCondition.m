function trials = generateTrialCondition()
% GENERATETRIALCONDITION generate the trials within a block

    SOA = 1:11;
    SOA = repmat(SOA, [1, 4]);
    SOA = Shuffle(SOA);
    tone = 0:1;
    tone = repmat(tone, [1, 22]);
    tone = Shuffle(tone);
    target_position = 0:1;
    target_position = repmat(target_position, [1, 22]);
    target_position = Shuffle(target_position);
    trials = cell(44);
    for i = 1:44
        trials{i} = Trial(SOA(i), tone(i), target_position(i));
    end
end