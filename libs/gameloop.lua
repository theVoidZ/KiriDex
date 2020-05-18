--------------------- GameLoop --------------------
local GameLoop = {}

function GameLoop:new()
    o = {}
    setmetatable(o, self)
    self.__index = self
	o:init()
	return o
end

function GameLoop:init()
	self.objects = {}
end
function GameLoop:RemoveObj(obj)
	for k,v in pairs(self.objects) do
		if v == obj then
			table.remove(self.objects,k)
			break
		end
	end
end
function GameLoop:addObject(obj)
	self.objects[#self.objects+1] = obj
end

function GameLoop:update(dt)
	for i = 1 , #self.objects do
		if self.objects[i] then
			self.objects[i]:update(dt)
		end
	end
end

return GameLoop