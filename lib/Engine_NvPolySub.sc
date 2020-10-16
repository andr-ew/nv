// a subtractive polysynth engine

Engine_NvPolySub : Engine_Nv {

	*new { arg context, callback;
		^super.new(context, callback);
	}
	
	synthFunc {^{
        arg peak=1, hz=0, level=0.2, // the basics
        shape=0.0, // base waveshape selection
        timbre=0.5, // modulation of waveshape
        sub=0.4, // sub-octave sine level
        noise = 0.0, // pink noise level (before filter)
        cut=8.0, // RLPF cutoff frequency as ratio of fundamental
        // amplitude envelope params
        ampAtk=0.05, ampDec=0.1, ampSus=1.0, ampRel=1.0, ampCurve= -1.0,
        // filter envelope params
        cutAtk=0.0, cutDec=0.0, cutSus=1.0, cutRel=1.0,
        cutCurve = -1.0, cutEnvAmt=0.0,
        fgain=0.0, // filter gain (moogFF model)
        detune=0, // linear frequency detuning between channels
        width=0.5,// stereo width
        hzLag = 0.1;

        var osc1, osc2, snd, freq, del, aenv, fenv;

        // TODO: could add control over these lag times if you wanna get crazy
        detune = Lag.kr(detune);
        shape = Lag.kr(shape);
        timbre = Lag.kr(timbre);
        fgain = Lag.kr(fgain.min(4.0));
        cut = Lag.kr(cut);
        width = Lag.kr(width);

        detune = detune / 2;
        hz = Lag.kr(hz, hzLag);
        freq = [hz + detune, hz - detune];
        osc1 = VarSaw.ar(freq:freq, width:timbre);
        osc2 = Pulse.ar(freq:freq, width:timbre);
        // TODO: could add more oscillator types


        // FIXME: probably a better way to do this channel selection
        snd = [SelectX.ar(shape, [osc1[0], osc2[0]]), SelectX.ar(shape, [osc1[1], osc2[1]])];
        snd = snd + ((SinOsc.ar(hz / 2) * sub).dup);
        aenv = EnvGen.ar(
            Env.adsr(ampAtk, ampDec, ampSus, ampRel, 1.0, ampCurve),
            peak, doneAction:2);

        fenv = EnvGen.ar(Env.adsr(cutAtk, cutDec, cutSus, cutRel), peak);

        cut = SelectX.kr(cutEnvAmt, [cut, cut * fenv]);
        cut = (cut * hz).min(SampleRate.ir * 0.5 - 1);

        snd = SelectX.ar(noise, [snd, [PinkNoise.ar, PinkNoise.ar]]);
        snd = MoogFF.ar(snd, cut, fgain) * aenv;

        Out.ar(context.out_b.index, level * SelectX.ar(width, [Mix.new(snd).dup, snd]));
    }}

	alloc {
        ^super.alloc()
	}

	free {
        ^super.free()
	}
}
