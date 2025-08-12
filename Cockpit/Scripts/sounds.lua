local count = 0
--- Increments a sound counter and returns the new value.
--- @return integer
local function counter()
	count = count + 1
	return count
end

SOUND_NOSOUND = -1
APUSTART      = counter()
APURUN        = counter()
APUSTOP       = counter()
PEENOR        = counter()