-- nv arps

c4 = 261.626

nv = include 'lib/nv'
controlspec = require 'controlspec'

nv.name 'PolySub'

function init()
    --nv.add_params() --add the author supplied params instead of rolling your own

    nv.init(2) -- 2 voices
 
    params:add {
        id="cut1",
        type='control',
        controlspec = controlspec.new(0, 32, "lin", 0, 8, ''),
        action = function(v)
            nv[1].cut(v)
        end
    }
    params:add {
        id="lvl1",
        type='control',
        controlspec = controlspec.new(0, 1, "lin", 0, 1, ''),
        action = function(v)
            nv[1].lvl(v)
        end
    }
    params:add {
        id="cut2",
        type='control',
        controlspec = controlspec.new(0, 32, "lin", 0, 8, ''),
        action = function(v)
            nv[2].cut(v)
        end
    }
    params:add {
        id="lvl2",
        type='control',
        controlspec = controlspec.new(0, 1, "lin", 0, 1, ''),
        action = function(v)
            nv[2].lvl(v)
        end
    }

    arp = { 2, 4, 5, 8, 10 }
    gate = { 0, 0 }
    i1 = 1
    i2 = 1

    metro.init(function()
        nv[1].hz(math.pow(2,arp[i1 % #arp + 1] / 12) * c4)
    end, 0.3) 
    metro.init(function()
        nv[2].hz(math.pow(2, arp[i2 % #arp + 1] / 12) * c4)
    end, 0.5)
    metro.init(function()
        gate[1] == 0 and 1 or 0
        nv[1].peak(gate[1])
    end, 0.7)
    metro.init(function()
        gate[2] == 0 and 1 or 0
        nv.vc[2].peak(gate[2])
    end, 0.5)
end
