local class = require 'libs.middleclass'

Box = class('Box',Entity)

function Box:initialize(x,y)
	Entity:initialize()
	-- self.id = #ENTITIES + 1
	self.id = Entity.static.entities_count
	self.canMove = true
	self.move_timer = Entity.move_timer
	self.pos_tile = Vector(x or 3,y or 3)
	local tw = MapHandler:getTileX()
	local th = MapHandler:getTileY()
	self.pos = Vector(self.pos_tile.x*tw,self.pos_tile.y*th)
	
	self.size = Vector(tw,th)
	self:CalculatePos()
	
	self.target_x = self.pos.x
	self.target_y = self.pos.y
	
	self.scale = 2
	self.image = MapHandler:getAsset("Box")
	self.image:setFilter("nearest")
	
	self.order = 1000
	
	self.pos_tile_og = self.pos_tile.copy
	
	self.isSolid = true
	
	self.history = {}
end

function Box:onAction()
	if not self.canMove or not self.isActive then return false end
	
	self:onMove()
end
function Box:onPreCollision(id,type) -- can overwrite for extra effect, like door open
	-- if type ~= self.class.name then
		local dx = MapHandler.levels[MapHandler.current_level].entities[id].pos_tile.x - self.pos_tile.x
		local dy = MapHandler.levels[MapHandler.current_level].entities[id].pos_tile.y - self.pos_tile.y
		local col = self:CheckCollision(-dx,-dy)
		if dx ~= 0 then -- move h
			self:MoveX(-dx)
		elseif dy ~= 0 then
			self:MoveY(-dy)
		end
		return not col
	-- end
	-- return self.isSolid
end

function Box:CalculatePos(speed_mult)
	speed_mult = speed_mult or 1
	local tw = MapHandler:getTileX()
	local th = MapHandler:getTileY()
	
	local target_x = (self.pos_tile.x-1) * (tw)
	local target_y = (self.pos_tile.y-1) * (th)
	
	Flux.to(self, self.move_timer/1000/speed_mult, {target_x = target_x,target_y = target_y})
end

function Box:update(dt)
	self.pos.x = self.target_x
	self.pos.y = self.target_y
end

function Box:draw()
	if not self.isActive then return false end
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(self.image,self.pos.x,self.pos.y,0,2*self.scale,2*self.scale)
	
	self:draw_over()
end