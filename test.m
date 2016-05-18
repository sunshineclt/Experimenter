function [ f,g ] = test(  )
%TEST Summary of this function goes here
%   Detailed explanation goes here
    for i = 1:2
        count = i;
        if i==1
            f = @()tester;
        else
            g = @()tester;
        end
    end
    function value = tester()
        count = count + 1;
        value = count;
    end
end

