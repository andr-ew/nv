nv = {
    list = { -- populated by synth choice, should align w/ supplied param ids
        'lvl',
        'cut' 
    },
    all = {},
    vc = {},
    free = {},
    active = {}
}

function nv.name() end -- checks for engine entry in lib & sets engine.name

function nv.init(count)
    nv.all.hz = 0
    nv.all.peak = 0        

    for _,v in ipairs(nv.list) do 
        nv.all[v] = 0
    end

    for i = 1, count do
        nv.vc[i] = {}
        nv.vc[i].hz = 0
        nv.vc[i].peak = 0

        nv.vc[i].id = nil
        nv.vc[i].active = 0

        for _,v in ipairs(nv.list) do 
            nv.vc[i][v] = 0
        end

        nv.free[i] = nv.vc[i]
    end    
end

function nv.id(id) -- voice allocator, returns active voice if id exists or free voice if new
    return nv.free[1] -- dummy function
end

function nv.update() 
    for i,vc in ipairs(nv.vc) do 
        print('vc ' .. i)
        print('hz ' .. nv.all.hz * vc.hz)
        print('peak ' .. nv.all.peak + vc.peak)

        for _,v in pairs(nv.list) do
            print(v .. ' ' .. vc[v] + nv.all[v])
        end    
    end 
end 

return nv
