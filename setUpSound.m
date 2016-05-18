function tone = setUpSound()
% SETUPSOUND generate the sound used in this expriment
% because the first play of Snd('play', sound) need some time to load Snd,
% I'don't want the main expriment to be disturbed by this delay, so after
% setup I'll play it for the first time.

    sf = 44100;
    t = 1;
    f = 500;
    tmp = linspace(0, t, sf * t);
    tone = sin(2 * pi * f * tmp);
    Snd('play', tone);
    
end

