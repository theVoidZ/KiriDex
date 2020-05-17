local class = require 'libs.middleclass'

Spike = class('Spike',Entity)

function Spike:initialize(x,y)
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
	self.image = love.graphics.newImage("gfx/spikes_anim_f0-sheet.png")
	self.image:setFilter("nearest")
	
	
	self.spikeopen_sound = MapHandler:getAsset("SpikeOpen")
	self.spikeopen_sound:setVolume(MapHandler:getVolume())
	
	self.damage_frame = 3
	self.frame = 1
	
	self.quads = {}
	
	for i = 1,4 do
		local x = (i-1)*16
		local y = 0
		table.insert(self.quads,love.graphics.newQuad(x,y,16,16,self.image:getWidth(),16))
	end
	
	self.max_frames = #self.quads
	
	self.order = 1
	
	
	self.pos_tile_og = self.pos_tile.copy
	
	self.history = {}
end

function Spike:onAction()
	if not self.canMove or not self.isActive then return false end
	
	self:onMove()
end


function Spike:CalculatePos(speed_mult)
	speed_mult = speed_mult or 1
	local tw = MapHandler:getTileX()
	local th = MapHandler:getTileY()
	
	-- self.pos.x = (self.pos_tile.x-1) * (tw) + tw/2 - self.size.x/2
	-- self.pos.y = (self.pos_tile.y-1) * (th) + th/2 - self.size.y/2
	local target_x = (self.pos_tile.x-1) * (tw)
	local target_y = (self.pos_tile.y-1) * (th)
	
	Flux.to(self, self.move_timer/1000/speed_mult, {target_x = target_x,target_y = target_y})
end


function Spike:onCollision(id,type)
	if self.frame == self.damage_frame then
		MapHandler:Damage(id,self.class.name)
		self.spikeopen_sound:stop()
		self.spikeopen_sound:play()
	end
end

function Spike:onReach(isTrigger)
	self.canMove = true
	self.frame = self.frame + 1
	if self.frame > self.max_frames then
		self.frame = 1
	end
	-- self:SaveCurrent()
end

function Spike:SaveCurrent()
	table.insert(self.history,{pos_tile = self.pos_tile.copy,
								isActive = self.isActive,
								frame = self.frame})
end

function Spike:update(dt)
	self.pos.x = self.target_x
	self.pos.y = self.target_y
end

function Spike:draw()
	if not self.isActive then return false end
	-- if self.canMove then
		-- love.graphics.setColor(1,0,0,1)
	-- else
		-- love.graphics.setColor(1,1,0,1)
	-- end
	-- love.graphics.rectangle("fill",self.pos.x,self.pos.y,self.size.x,self.size.y)
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(self.image,self.quads[self.frame],self.pos.x,self.pos.y,0,2*self.scale,2*self.scale)
	
	self:draw_over()
end