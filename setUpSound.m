function tone = setUpSound()
% SETUPSOUND generate the sound used in this expriment
% because the first play of Snd('play', sound) need some time to load Snd,
% I'don't want the main expriment to be disturbed by this delay, so after
% setup I'll play it for the first time.

    sf = 44100;
    t = 0.06;
    f = 500;
    tmp = linspace(0, t, sf * t);
    tone = sin(2 * pi * f * tmp);
    gatedur = .005;
    gate = cos(linspace(pi, 2*pi, sf*gatedur));
    gate = (gate + 1) / 2;
    offsetgate = fliplr(gate); 
    sustain = ones(1, (length(tone)-2*length(gate))); 
    envelope = [gate, sustain, offsetgate];
    smoothed_tone = envelope .* tone;
    Snd('play', smoothed_tone);
    
end

