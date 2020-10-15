# nv
n voice library

`nv.name(name)` : set engine name

`nv.n()` : set engine voice count

`nv[1]` : get voice 1

`nv[1].param(0.5)` : set a parameter named 'param' on voice 1 to 0.5

`nv.all.param(0.5)` : set `param` to 0.5 on all voices. optional second `span` parameter spreads the values evenly across all voices by a given amount

`.hz()` : required parameter, frequency in hz

`.peak()` : required prameter, specifies the peak of an envelope or volume of a sound, peak > 0 starts a sound peak = 0 stops the sound, peak <= -1 kills a sound

`nv.active` : list of active voices

`nv.free`: list of free voices

`nv.id(id)` : voice allocator, assigns an id to a free voice & returns the voice if id does not exist, or returns actice voice if exists

`nv.add_params(arg)` : add params for either a supplied voice or the all commands when `arg` = `"all"`

`nv.add_params_switch()` : set up the params to switch between all of the nv engines within a script

`nv.engines` : list of engines in the nv library (as reflected by `lib/spec`)

`nv.spec[name]` : list of controlspecs for the engine name, if it exists
