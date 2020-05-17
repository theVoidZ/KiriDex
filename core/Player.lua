local class = require 'libs.middleclass'

Player = class('Player',Entity)

function Player:initialize(x,y)
	Entity:initialize()
	-- self.id = #ENTITIES+1
	self.id = Entity.static.entities_count
	self.canMove = true
	self.move_timer = Entity.move_timer
	self.pos_tile = Vector(x or 5,y or 5)
	local tw = MapHandler:getTileX()
	local th = MapHandler:getTileY()
	self.pos = Vector(self.pos_tile.x*tw,self.pos_tile.y*th)
	self.scale = 2
	
	self.size = Vector(16*self.scale,21*self.scale)
	self:CalculatePos()
	
	self.target_x = self.pos.x
	self.target_y = self.pos.y
	
	self.image = MapHandler:getAsset("Player")
	self.image:setFilter("nearest")
	
	self.pickup_sound = MapHandler:getAsset("PlayerPickup")
	self.move_sound = MapHandler:getAsset("PlayerMove")
	self.death_sound = MapHandler:getAsset("PlayerDeath")
	
	
	self.pickup_sound:setVolume(MapHandler:getVolume())
	self.move_sound:setVolume(MapHandler:getVolume())
	self.death_sound:setVolume(MapHandler:getVolume())
	
	self.order = 99
	
	
	self.pos_tile_og = self.pos_tile.copy
	self.move_direction_og = self.move_direction
	
	self.keys_count = 0
	self.history = {}
end


function Player:SaveCurrent()
	table.insert(self.history,{pos_tile = self.pos_tile.copy,
								isActive = self.isActive,
								keys_count = self.keys_count})
end

function Player:keypressed(k)
	if not self.canMove or not self.isActive then return false end
	local pressed = self:CheckAndMove(k)
	-- if k == "w" then
		-- MapHandler:RequestUndo()
		-- pressed = false
	-- end
	if pressed then
		self:onMove(true)
		self.move_sound:stop()
		self.move_sound:play()
	end
end

function Player:CheckAndMove(k)
	local pressed = false
	if k == "left" then
		self:MoveX(-1)
		pressed = true
	elseif k == "right" then
		self:MoveX(1)
		pressed = true
	end
	if k == "up" then
		self:MoveY(-1)
		pressed = true
	elseif k == "down" then
		self:MoveY(1)
		pressed = true
	end
	if k == "r" then
		Timer.after(1/1000,function() MapHandler:Restart() end)
	end
	return pressed
end

function Player:update(dt)
	self.pos.x = self.target_x
	self.pos.y = self.target_y
	
	-- if love.keyboard.isDown("left") then
		-- self:keypressed("left")
	-- elseif love.keyboard.isDown("right") then
		-- self:keypressed("right")
	-- end
	
	-- if love.keyboard.isDown("up") then
		-- self:keypressed("up")
	-- elseif love.keyboard.isDown("down") then
		-- self:keypressed("down")
	-- end
end
function Player:getDamaged()
	self.isActive = false
	-- death sound plays
	self.death_sound:stop()
	self.death_sound:play()
	Timer.after(1/1000,function() MapHandler:Restart() end)
end
function Player:getKeys()
	return self.keys_count
end
function Player:ChangeKey(amount)
	self.keys_count = self.keys_count + amount
	if amount > 0 then
		self.pickup_sound:stop()
		self.pickup_sound:play()
	end
end

function Player:draw()
	if not self.isActive then return false end
	-- if self.canMove then
		-- love.graphics.setColor(0,1,0,1)
	-- else
		-- love.graphics.setColor(0,0,1,1)
	-- end
	-- love.graphics.rectangle("fill",self.pos.x,self.pos.y,self.size.x,self.size.y)
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(self.image,self.pos.x,self.pos.y,0,self.scale,self.scale)
	
	if self.keys_count ~= 0 then
		love.graphics.setColor(1,1,0,1)
		love.graphics.print(self.keys_count,self.pos.x,self.pos.y-15)
	end
	
	self:draw_over()
end