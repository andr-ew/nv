-- nv drone

nv = include 'lib/nv'
controlspec = require 'controlspec'

nv.name 'NvPolySub'

function init()
    nv.init(20) -- 20 voices
    --nv.add_params() --add the author supplied params instead of rolling your own

    nv.all.peak(1)
    nv.all.level(0.01)
    nv.all.hz(440)
 
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
        controlspec = controlspec.new(0, 0.01, "lin", 0, 0.01, ''),
        action = function(v)
            nv.all.level(v)
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
                vc.hz(math.pow(2, v) * (i / #nv)) -- actual hz is vc.hz * all.hz
            end
        end
    }
end
