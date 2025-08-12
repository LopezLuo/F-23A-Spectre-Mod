local count = 0
--- Increments a device counter and returns the new value.
--- @return integer
local function counter()
	count = count + 1
	return count
end


devices = {}

devices["KNEEBOARD"]        = counter()
devices["electricalSystem"] = counter()
devices["MWB"]              = counter()
devices["inst_pnl"]         = counter()
devices["nozzle"]           = counter()
devices["lights"]           = counter()
devices["brakes"]           = counter()
devices["vms"]              = counter()
devices["displays"]         = counter()
devices["UFCD"]             = counter()
devices["UFD"]              = counter()
devices["flcs"]             = counter()
devices["fuel"]             = counter()
devices["engine"]           = counter()
devices["FC3"]              = counter()
devices["OP_Phases"]        = counter()
devices["countermeasures"]  = counter()