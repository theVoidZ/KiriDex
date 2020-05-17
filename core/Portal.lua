local class = require 'libs.middleclass'

Portal = class('Portal',Entity)

function Portal:initialize(x,y,color)
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
	
	self.color = color or "Orange"
	
	self.scale = 2
	self.image = MapHandler:getAsset("Portal"..self.color)
	self.image:setFilter("nearest")
	
	
	self.use_sound = MapHandler:getAsset("PortalUse")
	self.use_sound:setVolume(MapHandler:getVolume())
		
	self.order = 2
	
	self.pos_tile_og = self.pos_tile.copy
	
	self.history = {}
end

function Portal:onAction()
	if not self.canMove or not self.isActive then return false end
	
	self:onMove()
end


function Portal:CalculatePos(speed_mult)
	speed_mult = speed_mult or 1
	local tw = MapHandler:getTileX()
	local th = MapHandler:getTileY()
	
	local target_x = (self.pos_tile.x-1) * (tw)
	local target_y = (self.pos_tile.y-1) * (th)
	
	Flux.to(self, self.move_timer/1000/speed_mult, {target_x = target_x,target_y = target_y})
end

function Portal:SaveCurrent()
	table.insert(self.history,{pos_tile = self.pos_tile.copy,
								isActive = self.isActive,
								keys_count = self.keys_count})
end

function Portal:onCollision(id,type)
	if not self.isActive then return false end
	local color = "Orange"
	if self.color == "Orange" then color = "Blue" end
	local otherPortal_x,otherPortal_y = MapHandler:getPortalPos(color)
	if otherPortal_x and otherPortal_y then
		MapHandler:ChangePosition(id,otherPortal_x,otherPortal_y,type)
		self.use_sound:stop()
		self.use_sound:play()
	end
end
function Portal:update(dt)
	self.pos.x = self.target_x
	self.pos.y = self.target_y
end

function Portal:draw()
	if not self.isActive then return false end
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(self.image,self.pos.x,self.pos.y,0,2*self.scale,2*self.scale)
	
	self:draw_over()
end