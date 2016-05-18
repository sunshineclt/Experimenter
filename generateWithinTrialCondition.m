function colorChangeInterval = generateWithinTrialCondition(specialTrialIndex)
% GENERATEWITHINTRIALCONDITION calculate the duration of the intervals
% between color changes

    colorChangeInterval = zeros(1, 19);
    colorChangeInterval(1:7) = 0.05;
    colorChangeInterval(8:14) = 0.1;
    colorChangeInterval(15:19) = 0.15;
    colorChangeInterval = Shuffle(colorChangeInterval);
    colorChangeInterval(specialTrialIndex + 2:21) = colorChangeInterval(specialTrialIndex:19);
    colorChangeInterval(specialTrialIndex:specialTrialIndex + 1) = 0.15;
end