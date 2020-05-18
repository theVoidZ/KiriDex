local Renderer = {}

function Renderer:new()
    o = {}
    setmetatable(o, self)
    self.__index = self
	o:init()
	return o
end

function Renderer:init()
	self.order = {"BACKGROUND","ICONS","WINDOWS","CONTENTS","USER","HUD"}
	self.Layers = {BACKGROUND = {},ICONS = {},WINDOWS = {},CONTENTS = {},USER = {},HUD = {}} ---- objects : map objects (tree,stuff)
end
function Renderer:addToLayer(layer,obj,pos) --- layer = "Background" "Entities" "Top"
	self:RemoveObjFromLayer(obj)
	if pos == "last" then
		pos = #self.Layers[layer]+1
	end
	table.insert(self.Layers[layer],pos or #self.Layers[layer]+1,obj)
end
function Renderer:RemoveObjFromLayer(obj)
	for a,b in pairs(self.Layers) do
		for k,v in pairs(b) do
			if v == obj then
				table.remove(b,k)
				break
			end
		end
	end
end

function Renderer:draw()	
	-- camera:attach()
	for i = 1,#self.order do
		local b = self.Layers[self.order[i]]
		for k = 1, #b do
			local v = b[k]
			if v then
				if v.isIMG then
					love.graphics.setColor(255,255,255,255)
					love.graphics.draw(v.img,(v.x),(v.y),v.rot or 0,v.sx or 1,v.sy or 1,v.ox or 0,v.oy or 0)
				else
					v:draw()
				end
			end
		end
	end
	-- camera:detach()
	-- camera:draw()
end

return Renderer