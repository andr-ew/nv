-- nv arps
-- view the repl, imagine sounds

c4 = 261.626

nv = include 'lib/nv'
controlspec = require 'controlspec'
musicutil = require "musicutil"

nv.name 'PolySub'

function init()
    --nv.params() --add the author supplied params instead of rolling your own

    nv.init(2) -- 2 voices
    nv.update()
 
    params:add {
        id="cut1",
        type='control',
        controlspec = controlspec.new(0, 32, "lin", 0, 8, ''),
        action = function(v)
            nv.vc[1].cut = v
            nv.update()
        end
    }
    params:add {
        id="lvl1",
        type='control',
        controlspec = controlspec.new(0, 1, "lin", 0, 1, ''),
        action = function(v)
            nv.vc[1].lvl = v
            nv.update()
        end
    }
    params:add {
        id="cut2",
        type='control',
        controlspec = controlspec.new(0, 32, "lin", 0, 8, ''),
        action = function(v)
            nv.vc[2].cut = v
            nv.update()
        end
    }
    params:add {
        id="lvl2",
        type='control',
        controlspec = controlspec.new(0, 1, "lin", 0, 1, ''),
        action = function(v)
            nv.vc[2].lvl = v
            nv.update()
        end
    }

    arp = [ 2, 4, 5, 8, 10 ]
    i1 = 1
    i2 = 1

    metro.init(function()
        nv.vc[1].hz = arp[i1 % #arp + 1] / 12 * c4
        nv.update()
    end, 0.3) 
    metro.init(function()
        nv.vc[2].hz = arp[i2 % #arp + 1] / 12 * c4
        nv.update()
    end, 0.5)
    metro.init(function()
        nv.vc[1].peak = nv.vc[1].peak == 0 and 1 or 0
        nv.update()
    end, 0.7)
    metro.init(function()
        nv.vc[2].peak = nv.vc[2].peak == 0 and 1 or 0
        nv.update()
    end, 0.5)
end
