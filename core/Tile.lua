local class = require 'libs.middleclass'

Tile = class('Tile')

function Tile:initialize(x,y,t)
	self.isActive = false
	self.pos = Vector(x,y)
	local tw = MapHandler:getTileX()
	local th = MapHandler:getTileY()
	self.size = Vector(tw,th)
	self.type = t
	self.image = MapHandler:getAsset("Floor")
	-- if t == 0 then
	-- elseif t == 1 then
		-- self.image = MapHandler:getAsset("Wall")		
	-- end
	self.image:setFilter("nearest")
	
end

function Tile:update(dt)

end

function Tile:getType()
	return self.type
end

function Tile:draw()
	if not self.isActive then return end
	local tw = MapHandler:getTileX()
	local th = MapHandler:getTileY()
	local x = (self.pos.x-1)* tw
	local y = (self.pos.y-1)* th
	love.graphics.setColor(1,1,1,1)
	-- if self.type == 1 then
		-- love.graphics.setColor(0,0,0,1)
	-- elseif self.type == 0 then
		-- love.graphics.setColor(81/255,64/255,71/255,1)
	-- end
	-- love.graphics.rectangle("fill",x,y,tw,th)
	-- love.graphics.setColor(1,1,1,1)
	-- love.graphics.rectangle("line",x,y,tw,th)
	
	local sx = self.size.x/self.image:getWidth()
	local sy = self.size.y/self.image:getHeight()
	love.graphics.draw(self.image,x,y,0,sx,sy)
end