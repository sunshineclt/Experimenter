function [ func ] = test(  )
%TEST Summary of this function goes here
%   Detailed explanation goes here
    x = 0;
    function value = tester()
        x = x + 1;
        value = x;
    end
    func = @()tester;
end
