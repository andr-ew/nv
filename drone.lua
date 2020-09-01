-- nv drone
-- view the repl, imagine sounds

nv = include 'lib/nv'
controlspec = require 'controlspec'

nv.name 'PolySub'

function init()
    nv.init(20) -- 20 voices
    --nv.params() --add the author supplied params instead of rolling your own

    nv.all.peak = 1
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
            nv.all.lvl = v
            nv.update()
        end
    }
    params:add {
        id="freq",
        controlspec = controlspec.FREQ,
        action = function(v)
            nv.all.hz = v
            nv.update()
        end
    }
    params:add {
        id="detune",
        controlspec = controlspec.BIPOLAR,
        action = function(v)
            for i,vc in ipairs(nv.vc) do
                vc.hz = math.pow(2, v) * (i / #nv.vc) -- actual hz is vc.hz * all.hz
            end
            nv.update()
        end
    }
end
