classdef Trial
    % TRIAL defines a trial in this experiment
    
    properties
        SOA % the SOA between two target, negative SOA means left first
        tone % to indicate whether the tone will be presented
        distractorLocation % 0 means left and 1 means right
    end
    
    methods
        function obj = Trial(SOA, tone, distractorLocation)
            SOATime = [-108, -50, -25, -17, -8, 0, 8, 17, 25, 50, 108];
            obj.SOA = SOATime(SOA) / 1000;
            obj.tone = tone;
            obj.distractorLocation = distractorLocation;
        end
    end
    
end

