local class = require 'libs.middleclass'

Enemy = class('Enemy',Entity)

function Enemy:initialize(x,y)
	Entity:initialize()
	-- self.id = #ENTITIES+1
	self.id = Entity.static.entities_count
	self.canMove = true
	self.move_timer = Entity.move_timer
	self.pos_tile = Vector(x or 3,y or 3)
	local tw = MapHandler:getTileX()
	local th = MapHandler:getTileY()
	self.pos = Vector(self.pos_tile.x*tw,self.pos_tile.y*th)
	
	self.scale = 2
	self.size = Vector(16*self.scale,21*self.scale)
	self:CalculatePos()
	
	self.target_x = self.pos.x
	self.target_y = self.pos.y
	
	self.move_direction = math.random(1,4) -- 1 - up .. Clockwise
	
	
	self.image = MapHandler:getAsset("Enemy")
	self.image:setFilter("nearest")
	
	
	self.death_sound = MapHandler:getAsset("PlayerDeath")
	
	
	self.death_sound:setVolume(MapHandler:getVolume())
	
	self.order = 90
	
	
	self.pos_tile_og = self.pos_tile.copy
	self.move_direction_og = self.move_direction
	self.first_dir = false
	
	self.history = {}
end

function Enemy:setMoveDirection(d)
	if d > 4 then
		d = 1
	elseif d < 1 then
		d = 4
	end
	self.move_direction = d
	if not self.first_dir then
		self.move_direction_og = self.move_direction
		self.first_dir = true
	end
end


function Enemy:onCollision(id,type)
	if not self.isActive then return false end
	if type == "Player" then
		MapHandler:Damage(id)
	end
end

function Enemy:SaveCurrent()
	table.insert(self.history,{pos_tile = self.pos_tile.copy,
								isActive = self.isActive,
								move_direction = self.move_direction})
end

function Enemy:getDirection()
	if self.move_direction == 3 or self.move_direction == 2 then
		return 1
	else
		return -1
	end
end

function Enemy:onAction()
	if not self.canMove or not self.isActive then return false end
	if self.move_direction == 1 or self.move_direction == 3 then -- vertically
		local dir = 1 -- down
		if self.move_direction == 1 then
			dir = -1
		end
		self:MoveY(dir,function()
			if dir == -1 then
				self:setMoveDirection(3)
			else
				self:setMoveDirection(1)
			end
			self:MoveY(self:getDirection())
			end)
	end
	if self.move_direction == 2 or self.move_direction == 4 then -- horizontally
		local dir = 1 -- right
		if self.move_direction == 4 then
			dir = -1
		end
		self:MoveX(dir,function()
			if dir == -1 then
				self:setMoveDirection(2)
			else
				self:setMoveDirection(4)
			end
			self:MoveX(self:getDirection())
			end)
	end
	self:onMove()
end

function Enemy:getDamaged()
	self.isActive = false
	
	self.death_sound:stop()
	self.death_sound:play()
	-- death sound plays
end
function Enemy:update(dt)
	self.pos.x = self.target_x
	self.pos.y = self.target_y
end

function Enemy:draw()
	if not self.isActive then return false end
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(self.image,self.pos.x,self.pos.y,0,self.scale,self.scale)
	
	self:draw_over()
end