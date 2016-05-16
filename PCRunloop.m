classdef PCRunloop < handle
    % PCRUNLOOP
    % 
    
    properties
        startTime
        eventArray
        endJudger
    end
    
    methods
        function obj = PCRunloop(endJudger)
            obj.startTime = GetSecs();
            obj.eventArray = {};
            obj.endJudger = endJudger;
        end
        
        function register(obj, event, callback)
            found = false;
            for eventIndex = 1:size(obj.eventArray, 1)
                if strcmp(obj.eventArray{eventIndex, 1}.eventName, event.eventName) == 1
                    found = true;
                    hasAdded = false;
                    for callbackIndex = 2:size(obj.eventArray, 2)
                        if ~isa(obj.eventArray{eventIndex, callbackIndex}, 'function_handle')
                            hasAdded = true;
                            obj.eventArray{eventIndex, callbackIndex} = callback;
                            break;
                        end
                    end
                    if ~hasAdded
                        obj.eventArray{eventIndex, size(obj. eventArray, 2) + 1} = callback;
                    end
                    break;
                end
            end
            if ~found
                obj.eventArray{size(obj.eventArray, 1) + 1, 1} = event;
                obj.eventArray{size(obj.eventArray, 1), 2} = callback;
            end
        end
        
        function run(obj)
            while ~obj.endJudger(obj)
                eventIndex = 1;
                while eventIndex <= size(obj.eventArray, 1)
                    event = obj.eventArray{eventIndex, 1};
                    if event.fireJudger(obj)
                        callbackIndex = 2;
                        while callbackIndex <= size(obj.eventArray, 2) && isa(obj.eventArray{eventIndex, callbackIndex}, 'function_handle')
                            obj.eventArray{eventIndex, callbackIndex}();
                            callbackIndex = callbackIndex + 1;
                        end
                        obj.eventArray(eventIndex, :) = [];
                    end
                    eventIndex = eventIndex + 1;
                end
            end
        end
    end
    
end
