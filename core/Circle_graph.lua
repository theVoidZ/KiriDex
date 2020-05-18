--------------------- Circle_graph --------------------
Circle_graph = {}
Circle_graph.__index = Circle_graph

function Circle_graph:new()
	local t = {}
	setmetatable(t,Circle_graph)
	return t
end
function Circle_graph:init()
	self.stats = {}
	self.chart_image = love.graphics.newImage("gfx/chart_empty.png")
	self.w = self.chart_image:getWidth()
	self.h = self.chart_image:getHeight()
	self.size = 58
end
function Circle_graph:setStats(power,speed,range,durability,precision,potential) --- 0 - 1
	self.stats = {power,speed,range,durability,precision,potential}
end
function Circle_graph:draw(x,y)
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(self.chart_image,x+self.w/2,y+self.h/2,0,1,1,self.w/2,self.h/2)
	local poly = {}
	local ang = 0
	local ang_step = math.pi*2/6
	love.graphics.setColor(0.6,0,0.6,0.7)
	for i = 1 , #self.stats do
		poly[#poly+1] = x + math.cos(ang-math.pi/2) * self.size*self.stats[i] + self.w/2
		poly[#poly+1] = y + math.sin(ang-math.pi/2) * self.size*self.stats[i] + self.h/2
		ang = ang + ang_step
	end
	if #poly ~= 0 then
		love.graphics.polygon("fill",poly)
	end
end

function CreateCircle_graph()
	local obj = Circle_graph:new()
	obj:init()
	return obj
end