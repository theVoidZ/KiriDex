--------------------- NAME --------------------
NAME = {}
NAME.__index = NAME

function NAME:new()
	local t = {}
	setmetatable(t,NAME)
	return t
end


function CreateNAME()
	local obj = NAME:new()
	obj:init()
	return obj
end