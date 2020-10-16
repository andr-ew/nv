-- nv arps

c4 = 261.626

nv = include 'lib/nv'
controlspec = require 'controlspec'

nv.name 'NvPolySub'

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
        controlspec = controlspec.new(0, 1, "lin", 0, 0.02, ''),
        action = function(v)
            nv[1].level(v)
        end
    }
    params:add {
        id="cut2",
        type='control',
        controlspec = controlspec.new(0, 32, "lin", 0, 8, ''),
        action = function(v)
            nv[2].level(v)
        end
    }
    params:add {
        id="lvl2",
        type='control',
        controlspec = controlspec.new(0, 1, "lin", 0, 0.02, ''),
        action = function(v)
            nv[2].level(v)
        end
    }

    arp = { 2, 4, 7, 9 }
    gate = { 0, 0 }
    i1 = 1
    i2 = 1

    metro.init(function()
        i1 = i1 % #arp + 1
        nv[1].hz(math.pow(2,arp[i1] / 12) * c4 * 0.5)
    end, 0.3):start() 
    metro.init(function()
        i2 = i2 % #arp + 1
        nv[2].hz(math.pow(2, arp[i2] / 12) * c4)
    end, 0.5):start()
    metro.init(function()
        gate[1] = gate[1] == 0 and 1 or 0
        nv[1].peak(gate[1])
    end, 0.7):start()
    metro.init(function()
        gate[2] = gate[2] == 0 and 1 or 0
        nv[2].peak(gate[2])
    end, 0.9):start()
end
