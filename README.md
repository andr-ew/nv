# nv
n voice library

`nv.name(name)` : set engine name

`nv.n()` : set engine voice count

`nv[1]` : get voice 1

`nv.list_commands()` : print available voice commands (there may be more params in the engine not related to voices)

`nv[1].command(0.5)` : set a command named 'command' on voice 1 to 0.5

`nv.all.command(0.5)` : set the `all` value for `command`, which is summed (multiplied if .hz) with the individual voice `command` value

`.hz()` : required parameter, frequency in hz

`.peak()` : required prameter, specifies the peak of an envelope or volume of a sound, peak > 0 starts a sound, peak = 0 stops the sound, peak <= -1 kills a sound

`nv.id(id)` : voice allocator, assigns an id to a free voice & returns the voice if id does not exist, or returns active voice if exists

`nv.active` : list of active voices

`nv.free`: list of free voices

`nv.add_params(arg)` : add params for either a voice number or all commands when `arg` = `"all"`

`nv.add_params_switch()` : set up the params to switch between all of the nv engines within a script

`nv.engines` : list of engines in the nv library (as reflected by `lib/spec`)

`nv.spec[name]` : list of controlspecs for the engine name, if it exists
