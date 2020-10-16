local voicelib = require 'voice'
local voice = {} -- voice allocator

local s = {} -- supertype thing
local nv = {}

setmetatable(nv, { __index = s })

function s.name(name) 
    engine.name = name
end

s.count = 16

function s.init(count) 
    s.count = count
    engine.nv_voicecount(count)
    voice = voicelib.new(count)
    
    for i = 1, count do 
        local n = i -- upvalue for the closure
        nv[i] = {}

        setmetatable(nv[i], { __index = function(t, k) 
            return function(v) 
                if k == "peak" then
                    if v > 0 then 
                        -- voice allocator stuff here ? what if this voice wasn't allocated ?

                        engine.nv_start(n, v)
                    else
                        for k,w in pairs(voice.pairings) do 
                            if w.id == n then
                                local slot = voice:pop(k)
                                voice:release(slot)
                            end
                        end
                        
                        engine["nv_peak"](n, v)
                    end
                else 
                    if engine["nv_" .. k] then
                        engine["nv_" .. k](n, v)
                    else
                        print("nv: command ".. tostring(k) .." does not exist")
                    end
                end
            end
        end })
    end
end

s.all = {}

setmetatable(s.all, { __index = function(t, k) 
    if k == "peak" then return engine.nv_all_start
    else return engine["nv_all_" .. k] or function() 
        print("nv: command ".. tostring(k) .." does not exist") end 
    end
end })

function s.id(key) 
    local slot
    slot = voice.pairings[key]
    
    if not slot then 
        slot = voice:get()
        voice:push(key, slot)
    end
        
    return nv[slot.id]
end

return nv
