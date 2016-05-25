function pahandle = setUpSound()
% SETUPSOUND set up the PsychPortAudio and load the needed tone

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
    pahandle = PsychPortAudio('Open');
    PsychPortAudio('FillBuffer', pahandle, [smoothed_tone;zeros(size(smoothed_tone))]);
    
end

