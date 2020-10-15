// nv superclass

Engine_Nv : CroneEngine {
    
	classvar <def; //synthdef using synthFunc
	
    var <numVoices = 16;
	var <voice; //voice array
	var <param; //param array of dictionaries
	
	*new { arg context, callback;
		^super.new(context, callback);
	}
	
	synthFunc {^{
        arg peak = 1, hz = 440;
        var sig, env;
        env = EnvGen.kr(Env.asr(0.01, peak, 0.01), peak, doneAction:2);
        sig = SinOsc.ar(hz) * env;
        Out.ar(context.out_b.index, sig!2);
    }}

    setVoiceCount { arg count; 
        numVoices = count;

        this.setAll("peak", 0, 0);
        voice = List.newClear(numVoices);
        param = List.new();
          
        count.do({ arg n;
            var dict = Dictionary.new;

            def.allControlNames.do({ arg ctl;
                dict.put(ctl.name, ctl.defaultValue);
            });

            param.add(dict);
        });
    }

    startVoice { arg n, peak;
      
        if(n < numVoices, {
            if(voice[n].isPlaying, {
                voice[n].set(\peak, -1); // ?
            });

            param[n][\peak] = peak;
            voice[n] = Synth.new(\nvdef, param[n].getPairs);
            NodeWatcher.register(voice[n]);

        }, { postln("voice " ++ n ++ " out of range") });
    }
    
    startAll { arg peak;
        voice.do({ arg vc, n;
            if(vc.isPlaying, {
                vc.set(\peak, -1)
            });

            param[n][\peak] = peak;
            voice[n] = Synth.new(\nvdef, param[n].getPairs);
            NodeWatcher.register(voice[n]);
        });
    }

    setVoice { arg n, name, v;

        if(n < numVoices, {

            param[n][name] = v;

            if(voice[n].isPlaying, {
                voice[n].set(name, v)
            });
    
        }, { postln("voice " ++ n ++ " out of range") });
    }

    setAll { arg name, v, span = 0;
        param.do({ arg p, n;
             p[name] = v + (((n/numVoices) - 0.5) * span)
        });
        
        voice.do({ arg vc, n;
            if(vc.isPlaying, {
                vc.set(name, param[n][name])
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

            this.addCommand("nv_all_" ++ name, "ff", { arg msg;
                  this.setAll(name, msg[1], msg[2]);
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
