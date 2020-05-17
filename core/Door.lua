local class = require 'libs.middleclass'

Door = class('Door',Entity)

function Door:initialize(x,y)
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
	
	self.scale = 1
	self.image = MapHandler:getAsset("Door")
	self.image:setFilter("nearest")
	
	
	self.open_sound = MapHandler:getAsset("DoorOpen")
	self.open_sound:setVolume(MapHandler:getVolume())
	
	self.order = 1000
	
	self.pos_tile_og = self.pos_tile.copy
	
	self.isSolid = true
	
	self.history = {}
end

function Door:onAction()
	if not self.canMove or not self.isActive then return false end
	
	self:onMove()
end
function Door:onPreCollision(id,type) -- can overwrite for extra effect, like door open
	if type == "Player" then
		local keys = MapHandler:getKeys(id)
		if keys > 0 then
			MapHandler:ChangeKey(id,-1)
			self.open_sound:stop()
			self.open_sound:play()
			self:getDamaged(self.class.name)
		end
	end
	return self.isSolid
end

function Door:CalculatePos(speed_mult)
	speed_mult = speed_mult or 1
	local tw = MapHandler:getTileX()
	local th = MapHandler:getTileY()
	
	local target_x = (self.pos_tile.x-1) * (tw)
	local target_y = (self.pos_tile.y-1) * (th)
	
	Flux.to(self, self.move_timer/1000/speed_mult, {target_x = target_x,target_y = target_y})
end

function Door:update(dt)
	self.pos.x = self.target_x
	self.pos.y = self.target_y
end

function Door:draw()
	if not self.isActive then return false end
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(self.image,self.pos.x,self.pos.y,0,2*self.scale,2*self.scale)
	
	self:draw_over()
end