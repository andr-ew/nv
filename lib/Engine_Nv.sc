// a subtractive polysynth engine

Engine_Nv : CroneEngine {

	classvar <numVoices = 16;
	
	var <voice; //voice array
	var <param; //param array of dictionaries
	var <def; //synthdef using synthFunc
	
	*new { arg context, callback;
		^super.new(context, callback);
	}
	
	synthFunc {
	  arg peak = 1, hz = 440;
	  var sig, env;
	  env = EnvGen.kr(Env.asr(0.01, peak, 0.01), peak, doneAction:2);
	  sig = SinOsc.ar(hz) * env;
	  Out.ar(context.out_b.index, sig!2);
	}
	
	alloc {
	  voice = Array.newClear(numVoices);
	  
	  param = Array.fill(numVoices, {
	    var dict;
	    dict = Dictionary.new;

	    def.allControlNames.do({ arg ctl;
		    var name, val;

		    name = ctl.name;
		    val = ctl.defaultValue;
		    
		    dict.put(name, val);
      });

	    dict;
    });
	  
    def = SynthDef.new(\nvdef, this.synthFunc).add;
    
    this.addCommand(\start, "if", { arg msg;
		  this.startVoice(msg[1], msg[2]);
		});
		
		def.allControlNames.do({ arg ctl; 
		  var name = ctl.name;
		
		  this.addCommand("nv_" ++ name, "if", { arg msg;
		    this.setVoice(msg[1],  name, msg[2]);
		  });
		});
	  
	  startVoice { arg n, peak;
	  
	    if(voice[n].isPlaying, {
		    voice[n].set(\peak, -1); // ?
  	  });

	    param[n][\peak] = peak;
	    voice[n] = Synth.new(\nvdef, param[n].getPairs);
      NodeWatcher.register(voice[n]);
    };

    setVoice { arg n, name, v;
    
	    param[n][name] = v;

	    if(voice[n].isPlaying, {
		    voice[n].set(name, v)
	    });
    };

		postln("nv initialized");
	}

	free {
		voice.do({ arg v;
		  if(v.isPlaying, {
		    v.free;
		  });
		});
	}
}
