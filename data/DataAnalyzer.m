% this script is for data analyze of a single participants
% it conduct a logit fitting, draw a graph and calculate the PSS and JND

javaaddpath('./MatlabExcelMac/Archive/jxl.jar');
javaaddpath('./MatlabExcelMac/Archive/MXL.jar');

import mymxl.*;
import jxl.*;   

% read data
storedResponse = xlsread('1_1_data.xls', 'response');
storedTone = xlsread('1_1_data.xls', 'tone');
storedSOA = xlsread('1_1_data.xls', 'SOA');
storedDistractorLocation = xlsread('1_1_data.xls', 'distractorLocation');
% transform SOA from actual SOA to code 1-11
% it is a fault to record the actual SOA in xls instead of code
% so I can only transform back here
for block = 1:16
    for trial = 1:44
        switch storedSOA(block,trial)
            case -0.108
                storedSOA(block,trial) = 1;
            case -0.050
                storedSOA(block,trial) = 2;
            case -0.025
                storedSOA(block,trial) = 3;
            case -0.017
                storedSOA(block,trial) = 4;
            case -0.008
                storedSOA(block,trial) = 5;
            case 0
                storedSOA(block,trial) = 6;
            case 0.008
                storedSOA(block,trial) = 7;
            case 0.017
                storedSOA(block,trial) = 8;
            case 0.025
                storedSOA(block,trial) = 9;
            case 0.050
                storedSOA(block,trial) = 10;
            case 0.108
                storedSOA(block,trial) = 11;
        end
    end
end

% response is a three-dimension matrix
% the first dimension menas tone(1 means no tone, 2 means have tone)
% the second dimension means distractorLocation(1 means left,2 means right)
% the thrid dimension means SOA
% leftResponse count on every condition how many left responses are there
rightResponse = zeros(2,2,11);
% totalResponse count on every condition how many valid responses are there
totalResponse = zeros(2,2,11);
% ignore the first practice block's data
for block = 2:16
    for trial = 1:44
        tone = storedTone(block,trial) + 1;
        distractorLocation = storedDistractorLocation(block,trial);
        SOA = storedSOA(block,trial);
        if storedResponse(block,trial) == 2
            rightResponse(tone, distractorLocation, SOA) = rightResponse(tone, distractorLocation, SOA) + 1;
        end
        if storedResponse(block,trial) ~= -1
            totalResponse(tone, distractorLocation, SOA) = totalResponse(tone, distractorLocation, SOA) + 1;
        end
    end
end
% calculate the rightResponse's percentage on every condition
rightPercentage = zeros(2,2,11);
for tone = 1:2
    for distractorLocation = 1:2
        for SOA = 1:11
            rightPercentage(tone,distractorLocation,SOA) = rightResponse(tone,distractorLocation,SOA) / totalResponse(tone,distractorLocation,SOA);
        end
    end
end

PSS = zeros(4,1);
JND = zeros(4,1);
SOACondition = [-108, -50, -25, -17, -8, 0, 8, 17, 25, 50, 108];

% logit fitting and graph drawing
hold on;

haveToneLeftDistractor = squeeze(rightPercentage(2,1,:));
[b,~,~] = glmfit(SOACondition, haveToneLeftDistractor, 'binomial', 'logit');
% draw the data point
plot(SOACondition, haveToneLeftDistractor,'^k','MarkerFaceColor',[0 0 0],'MarkerSize',8);
xc = -110:10:110;
curve = glmval(b,xc,'logit');
% draw the curve
plot(xc,curve,'-','LineWidth',2,'Color',[0.8 0.8 0.8]);
% calculate PSS & JND
PSS(1) = -b(1)/b(2);
JND(1) = log(3)/b(2);

haveToneRightDistractor = squeeze(rightPercentage(2,2,:));
[b,~,~] = glmfit(SOACondition, haveToneRightDistractor, 'binomial', 'logit');
plot(SOACondition, haveToneRightDistractor,'ok','MarkerFaceColor',[0 0 0],'MarkerSize',8);
xc = -110:10:110;
curve = glmval(b,xc,'logit');
plot(xc,curve,'k-','LineWidth',2);
PSS(2) = -b(1)/b(2);
JND(2) = log(3)/b(2);

noToneLeftDistractor = squeeze(rightPercentage(1,1,:));
[b,~,~] = glmfit(SOACondition, noToneLeftDistractor, 'binomial', 'logit');
plot(SOACondition, noToneLeftDistractor,'^k','MarkerSize',8);
xc = -110:10:110;
curve = glmval(b,xc,'logit');
plot(xc,curve,'--','LineWidth',2,'Color',[0.8 0.8 0.8]);
PSS(3) = -b(1)/b(2);
JND(3) = log(3)/b(2);

noToneRightDistractor = squeeze(rightPercentage(1,2,:));
[b,~,~] = glmfit(SOACondition, noToneRightDistractor, 'binomial', 'logit');
plot(SOACondition, noToneRightDistractor,'ok','MarkerSize',8);
xc = -110:10:110;
curve = glmval(b,xc,'logit');
plot(xc,curve,'k--','LineWidth',2);
PSS(4) = -b(1)/b(2);
JND(4) = log(3)/b(2);

set(gca, 'XTick', -110:20:110);
set(gca, 'XLim', [-110, 110]);
set(gca, 'YTick', 0:0.1:1);
set(gca, 'YTickLabel', {'0%', '10%', '20%', '30%', '40%', '50%', '60%', '70%', '80%', '90%', '100%'});

xlabel('Left appeared first                             SOA (ms)                             Right appeared first');
ylabel('Percentage "right first" responses');

% this part is for the edit of legend
% since there are 8 lines in the graph(every condition have data point and line, that's 2 "lines")
% and we only have 4 legends, so matlab will be confused about the legend's
% icons and will give the first 4 line's icons to the legend, which we do
% not want, so I explicitly assign the icons(though not elegend, it can
% reach the target we want)
[~,icons,~,~] = legend('Tone present; distractor left', 'Tone present; distractor right', 'Tone absent; distractor left', 'Tone absent; distractor right', 'location', 'NorthWest');
icons(5).LineStyle = '-';
icons(5).Color = [0.8 0.8 0.8];
icons(6).MarkerSize = 6;
icons(7).Color = [0 0 0];
icons(8).Marker = 'o';
icons(8).MarkerSize = 6;
icons(8).Color = [0 0 0];
icons(8).MarkerFaceColor = [0 0 0];
icons(9).LineStyle = '--';
icons(9).Color = [0.8 0.8 0.8];
icons(10).Marker = '^';
icons(10).MarkerSize = 6;
icons(10).Color = [0 0 0];
icons(10).MarkerFaceColor = [1 1 1];
icons(11).LineStyle = '--';
icons(11).Color = [0 0 0];
icons(12).Marker = 'o';
icons(12).MarkerSize = 6;
icons(12).MarkerFaceColor = [1 1 1];
icons(12).Color = [0 0 0];
legend('boxoff');

hold off;

% print the PSS and JND data
PSS
JND