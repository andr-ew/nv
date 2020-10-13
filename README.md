# nv
n voice library

`nv.name(name)` : select engine from the nv lib

`nv.init(n)` : initialize n voices

`nv.vc` : list of voices and parameters per voice (e.g. `nv.vc[1].hz = 440` )

`nv.all` : list of global parameters, summed (multiplied if `.hz`) with voice parameters per voice

`.hz` : required parameter, frequency in hz

`.peak` : required prameter, specifies the peak of an envelope or volume of a sound

`vc.list` : list of additional parameter keys supplied by engine

`nv.active` : list of active voices, populated via engine polls

`nv.free`: list of free voices, populated via engine pools

`nv.id(id)` : voice allocator, assigns an id to a free voice & returns the voice if id does not exist, or returns actice voice if exists

`nv.update()` : sends table data to supercollider
