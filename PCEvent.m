classdef PCEvent < handle
    % PCEVENT
    %
    
    properties
        eventName
        fireJudger
    end
    
    methods
        function obj = PCEvent(eventName, fireJudger, runloopRef)
            obj.eventName = eventName;
            obj.fireJudger = fireJudger;
        end
        
    end
    
end
