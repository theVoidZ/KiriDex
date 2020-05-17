local class = require 'libs.middleclass'

Entity = class('Entity')

Entity.static.move_timer = 250
Entity.static.entities_count = 0

function Entity:initialize()
	self.isActive = false
	Entity.static.entities_count = Entity.static.entities_count + 1
	-- self.isSolid = false
end

function Entity:SaveCurrent()
	table.insert(self.history,{pos_tile = self.pos_tile.copy,isActive = self.isActive})
end

function Entity:MoveX(dir,callback)
	if self.class.name == "Charger" then
	end
	if not self.isActive then return false end
	if self:CheckCollision(dir,0) then
		self.pos_tile.x = self.pos_tile.x + dir
	else
		if callback then
			callback()
		end
	end
	self:CalculatePos()
end

function Entity:MoveY(dir,callback)
	if self.class.name == "Charger" then
	end
	if not self.isActive then return false end
	if self:CheckCollision(0,dir) then
		self.pos_tile.y = self.pos_tile.y + dir
	else
		if callback then
			callback()
		end
	end
	self:CalculatePos()
end

function Entity:setMoveDirection(d)
	self.move_direction = d
end

function Entity:CheckCollision(x,y)
	local t = MapHandler:getTileType(self.pos_tile.x + x,self.pos_tile.y + y)
	if not t then return false end
	local ents = MapHandler:getEntitiesAtPos(self.pos_tile.x + x,self.pos_tile.y + y,self.id)
	local solid = false
	for k,vid in pairs(ents) do
		local v = MapHandler.levels[MapHandler.current_level].entities[vid]
		if v then
			if v.isActive then
				solid = v:onPreCollision(self.id,self.class.name)
			end
		end
	end
	return not solid
end
function Entity:keypressed(k)
end
function Entity:onPreCollision(id,type) -- can overwrite for extra effect, like door open or Push
	return self.isSolid
end
function Entity:onCollision(id,type)
end
function Entity:getDamaged()
	self.isActive = false
end
function Entity:onAction()
end

function Entity:onMove(isTrigger)
	-- self:SaveCurrent()
	if self.isActive then
		if isTrigger then
			MapHandler:onAction(self.id)
		end
		self.canMove = false
		Timer.after((self.move_timer+10)/1000,function() self:onReach(isTrigger) end)
	end
end

function Entity:onReach(isTrigger)
	-- if isTrigger then
	Timer.after(1/1000,function() MapHandler:onReach(self.id,isTrigger);self.canMove = true end)
	-- end
end
function Entity:getHistory()
	return self.history
end

function Entity:Undo(count)
	if #self.history <= 1 then
		self:Restart()
		self.history = {}
	else
		for k,v in pairs(self.history[#self.history-1]) do
			if k == "pos_tile" then
				self.pos_tile.x = v.x
				self.pos_tile.y = v.y
			else
				self[k] = v
			end
		end
		table.remove(self.history,#self.history)
		self:CalculatePos()
	end
end

function Entity:ChangePosition(x,y)
	self.pos_tile.x = x
	self.pos_tile.y = y
	self:CalculatePos(2)
end

function Entity:Restart()
	self.isActive = true
	self.canMove = true
	self.pos_tile = self.pos_tile_og.copy
	self.move_direction = self.move_direction_og
	
	self:CalculatePos()
	
	self.frame = 1
	self.keys_count = 0
end

function Entity:draw_over()
	-- if not self.isActive then return false end
	-- love.graphics.setColor(1,1,1,1)
	-- love.graphics.print(tostring(#self.history),self.pos.x,self.pos.y)
end
function Entity:CalculatePos(speed_mult)
	speed_mult = speed_mult or 1
	local tw = MapHandler:getTileX()
	local th = MapHandler:getTileY()
	
	-- self.pos.x = (self.pos_tile.x-1) * (tw) + tw/2 - self.size.x/2
	-- self.pos.y = (self.pos_tile.y-1) * (th) + th/2 - self.size.y/2
	local target_x = (self.pos_tile.x-1) * (tw) + tw/2 - self.size.x/2
	local target_y = (self.pos_tile.y-1) * (th) + th/2 - self.size.y/2
	
	Flux.to(self, (self.move_timer+10)/1000/speed_mult, {target_x = target_x,target_y = target_y})
end