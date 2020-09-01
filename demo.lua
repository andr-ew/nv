include 'lib/nv'

nv.name 'PolySub'

keyboard = midi.connect()

function init()
    nv.init(8)
    
    params:add {
        id="cutoff",
        controlspec = controlspec.FREQ,
        action = function(v)
        end
    }
    params:add {
        id="volume",
        controlspec = controlspec.DB,
        action = function(v)
        end
    }
    params:add {
        id="pitchbend",
        controlspec = controlspec.BIPOLAR,
        action = function(v)
        end
    }
    params:add {
        id="pitch_span",
        controlspec = controlspec.BIPOLAR,
        action = function(v)
        end
    }
    params:add {
        id="cutoff_span",
        controlspec = controlspec.BIPOLAR,
        action = function(v)
        end
    }
end

keyboard.event = function(data)
  
  local msg = midi.to_msg(data)
    if msg.type == "note_off" then
    
    elseif msg.type == "note_on" then
      
    elseif msg.type == "key_pressure" then
      
    elseif msg.type == "pitchbend" then

    end
end
