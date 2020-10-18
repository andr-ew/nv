# nv

collected voice engines with shared syntax for monome norns

# usage

`nv.name(name)` : set engine name

`nv.init(count)` : initilize the engine with the specified voice count

`nv[1]` : get voice 1

`nv[1].command(0.5)` : set a command named 'command' on voice 1 to 0.5

`nv.all.command(0.5)` : set the `all` value for `command`, which is summed (multiplied if .hz) with the individual voice `command` value

`.hz()` : required parameter, frequency in hz

`.peak()` : required prameter, specifies the peak of an envelope or volume of a sound, peak > 0 starts a sound, peak = 0 stops the sound, peak <= -1 kills a sound

`nv.id(id)` : voice allocator, assigns an id to a free voice & returns the voice if id does not exist, or returns active voice if exists

`nv.add_params(arg)` : add params for either a voice number or all commands when `arg` = `"all"`

`nv.add_params_switch()` : set up the params to switch between all of the nv engines within a script

`nv.engines` : list of engines in the nv library (as reflected by `lib/spec`)

`nv.spec[name]` : list of controlspecs for the engine name, if it exists
