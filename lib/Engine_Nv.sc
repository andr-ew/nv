// nv superclass

Engine_Nv : CroneEngine {
    
	classvar <def; //synthdef using synthFunc
	
    var <numVoices = 16;
	var <voice; //voice array

	var <paramVoice; //param array of dictionaries (value per voice)
    var <paramAll; //dictionary of param global offsets
    var <mixVoice; //param mixed value per voice
	
	*new { arg context, callback;
		^super.new(context, callback);
	}
	
	synthFunc {^{
        arg peak = 1, hz = 0;
        var sig, env;
        env = EnvGen.kr(Env.asr(0.01, peak, 0.01), peak, doneAction:2);
        sig = SinOsc.ar(hz) * env;
        Out.ar(context.out_b.index, sig!2);
    }}

    setVoiceCount { arg count; 
        numVoices = count;
        
		voice.do({ arg v;
		  if(v.isPlaying, {
		    v.free;
		  });
		});

        voice = List.newClear(numVoices);
        paramVoice = List.new();
        mixVoice = List.new();
          
        count.do({ arg n;
            var pv = Dictionary.new;
            var mv = Dictionary.new;

            def.allControlNames.do({ arg ctl;
                pv.put(ctl.name, 0);
                mv.put(ctl.name, ctl.defaultValue);
            });

            pv[\peak] = 0;
            mv[\peak] = 0;
            
            pv[\hz] = 0;
            mv[\hz] = 0;

            paramVoice.add(pv);
            mixVoice.add(mv);
        });

        paramAll = Dictionary.new;

        def.allControlNames.do({ arg ctl;
            paramAll.put(ctl.name, ctl.defaultValue);
        });
            
        paramAll[\peak] = 0;
        paramAll[\hz] = 0;
    }

    startVoice { arg n, peak;
        if(n < numVoices, {            

            if(voice[n].isPlaying, {
                voice[n].set(\peak, -1); // ?
            });

            paramVoice[n][\peak] = peak;
            mixVoice[n][\peak] = peak + paramAll[\peak];

            voice[n] = Synth.new(\nvdef, mixVoice[n].getPairs);
            NodeWatcher.register(voice[n]);

        }, { postln("voice " ++ n ++ " out of range") });
    }
    
    startAll { arg peak;
        voice.do({ arg vc, n;
            if(vc.isPlaying, {
                vc.set(\peak, -1)
            });
            
            paramAll[\peak] = peak;
            mixVoice[n][\peak] = peak + paramVoice[n][\peak];

            voice[n] = Synth.new(\nvdef, mixVoice[n].getPairs);
            NodeWatcher.register(voice[n]);
        });
    }

    setVoice { arg n, name, v;
        if(n < numVoices, {
    
            paramVoice[n][name] = v;

            if(name == "hz", {
                mixVoice[n][name] = v * paramAll[name];
            }, {
                mixVoice[n][name] = v + paramAll[name];
            });

            if(voice[n].isPlaying, {
                voice[n].set(name, mixVoice[n][name]);
            });
    
        }, { postln("voice " ++ n ++ " out of range") });
    }

    setAll { arg name, v;
        paramAll[name] = v;

        paramVoice.do({ arg p, n;
            if(name == "hz", {
                mixVoice[n][name] = v * p[name];
            }, {
                mixVoice[n][name] = v + p[name];
            });
        });
        
        voice.do({ arg vc, n;
            if(vc.isPlaying, {
                vc.set(name, mixVoice[n][name])
            });
        });
    }
	
	alloc {
        def = SynthDef.new(\nvdef, this.synthFunc()).add;
        
        this.setVoiceCount(numVoices);

        this.addCommand(\nv_start, "if", { arg msg;
              this.startVoice(msg[1], msg[2]);
        });

        this.addCommand(\nv_voicecount, "i", { arg msg;
              this.setVoiceCount(msg[1]);
        });

        this.addCommand(\nv_all_start, "f", { arg msg;
              this.startAll(msg[1]);
        });

        def.allControlNames.do({ arg ctl;
            var name;

            name = ctl.name;
            
            this.addCommand("nv_" ++ name, "if", { arg msg;
                  this.setVoice(msg[1], name, msg[2]);
            });

            this.addCommand("nv_all_" ++ name, "f", { arg msg;
                  this.setAll(name, msg[1]);
            });
        });
	}

	free {
		voice.do({ arg v;
		  if(v.isPlaying, {
		    v.free;
		  });
		});
	}
}
