-- nv drone

nv = include 'lib/nv'
controlspec = require 'controlspec'

nv.name 'PolySub'

function init()
    nv.init(20) -- 20 voices
    --nv.add_params() --add the author supplied params instead of rolling your own

    nv.all.peak(1)
 
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
            nv.all.lvl(v)
        end
    }
    params:add {
        id="freq",
        type='control',
        controlspec = controlspec.FREQ,
        action = function(v)
            nv.all.hz(v)
        end
    }
    params:add {
        id="detune",
        type='control',
        controlspec = controlspec.BIPOLAR,
        action = function(v)
            for i,vc in ipairs(nv) do
                vc.hz(math.pow(2, v) * (i / #nv.vc)) -- actual hz is vc.hz * all.hz
            end
        end
    }
end
