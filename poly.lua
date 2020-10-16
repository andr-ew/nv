-- nv poly

nv = include 'lib/nv'
controlspec = require 'controlspec'
musicutil = require "musicutil"

nv.name 'NvPolySub'

keyboard = midi.connect()

function init()
    nv.init(8) -- 8 voice polyphony

    --nv.params() --add the author supplied params instead of rolling your own

    params:add {
        id="cut",
        type='control',
        controlspec = controlspec.new(0, 32, "lin", 0, 8, ''),
        action = function(v)
            nv.all.cut(v)
        end
    }
    params:add {
        id="lvl",
        type='control',
        controlspec = controlspec.new(0, 1, "lin", 0, 1, ''),
        action = function(v)
            nv.all.level(v * 0.75)
        end
    }
    params:add {
        id="pitchbend",
        type='control',
        controlspec = controlspec.BIPOLAR,
        action = function(v)
            nv.all.hz(math.pow(2, v)) -- actual hz is vc.hz * all.hz
        end
    }
    params:add {
        id="cut_span",
        type='control',
        controlspec = controlspec.new(0, 4, "lin", 0, 0, ''),
        action = function(v)
            for i,vc in ipairs(nv) do
                vc.cut(v * (i / #nv)) -- actual cut is vc.cut + nv.all.cut
            end
        end
    }
end

keyboard.event = function(data)
    local msg = midi.to_msg(data)
    if msg.type == "note_on" then
        nv.id(msg.note).hz(musicutil.note_num_to_freq(msg.note)) -- actual hz is vc.hz * all.hz
        nv.id(msg.note).peak((msg.vel / 127 / 4) + 0.75)
    elseif msg.type == "note_off" then
        nv.id(msg.note).peak(0)
    end
end
