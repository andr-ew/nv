-- nv poly
-- connect a keyboard, view the repl, imagine sounds

nv = include 'lib/nv'
controlspec = require 'controlspec'
musicutil = require "musicutil"

nv.name 'PolySub'

keyboard = midi.connect()

function init()
    nv.init(8) -- 8 voice polyphony
    --nv.params() --add the author supplied params instead of rolling your own

    nv.update()
 
    params:add {
        id="cut",
        controlspec = controlspec.new(0, 32, "lin", 0, 8, ''),
        action = function(v)
            nv.all.cut = v
            nv.update()
        end
    }
    params:add {
        id="lvl",
        controlspec = controlspec.new(0, 1, "lin", 0, 1, ''),
        action = function(v)
            nv.all.lvl = v * 0.75
            nv.update()
        end
    }
    params:add {
        id="pitchbend",
        controlspec = controlspec.BIPOLAR,
        action = function(v)
            nv.all.hz = math.pow(2, v) -- actual hz is vc.hz * all.hz
            nv.update()
        end
    }
    params:add {
        id="cut_span",
        controlspec = controlspec.new(0, 4, "lin", 0, 0, ''),
        action = function(v)
            for i,vc in ipairs(nv.vc) do
                vc.cut = v * (i / #nv.vc) -- actual cut is vc.cut + all.cut
            end
            nv.update()
        end
    }
end

keyboard.event = function(data)
    local msg = midi.to_msg(data)
    if msg.type == "note_on" then
        nv.id(msg.note).hz = musicutil.note_num_to_freq(msg.note) -- actual hz is vc.hz * all.hz
        nv.id(msg.note).peak = (msg.vel / 127 / 4) + 0.75
    elseif msg.type == "note_off" then
        nv.id(msg.note).peak = 0
    end

    nv.update()
end
