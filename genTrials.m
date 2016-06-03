function trials=genTrials(withinblock_repetitions, withinblock_factors, betweenblock_repetitions, betweenblock_factors)
% Generating randomized trials based repetition and factors
% syntax: genTrials(withinblock_repetition, betweenblock_repetition, withinblock_factors, [ betweenblock_factors])
% eg: genTrials(2, 10, [2 3]); generate two factors (2 levels and 3 levels
% resp. ) with within block repetition 2 and between block repetition 10
 
if  nargin < 2
        error('Incorrect number of arguments for genTrials function');
elseif nargin == 2
        betweenblock_repetitions = 1;
        betweenblock_factors  = [];
elseif nargin == 3
    % when there's only betweenblock_repetitions, which is equal to swap
    % between block repetitions and factors -strongway 14. Dec. 2006
        betweenblock_factors = betweenblock_repetitions;
        betweenblock_repetitions  = 1;
end
 
trials = [];
block_design = [];
numblock = betweenblock_repetitions;
if length(betweenblock_factors) > 0
    block_design = fullfact(betweenblock_factors);
    block_design = repmat(block_design, betweenblock_repetitions,1);
    idxb = randperm(length(block_design));
    block_design = block_design(idxb,:);
    numblock = length(block_design);
end
 
for iblock = 1:numblock
    %generate within block trials
    inblock_trials = fullfact(withinblock_factors);
    inblock_trials = repmat(inblock_trials,withinblock_repetitions,1);
    idx=randperm(size(inblock_trials,1));
    inblock_trials = inblock_trials(idx,:);
    if length(block_design)>0
        %add between factors
        blockwise_factors = repmat(block_design(iblock,:),length(inblock_trials),1);
        inblock_trials = [inblock_trials blockwise_factors];
    end
    trials = [trials; inblock_trials];
end
