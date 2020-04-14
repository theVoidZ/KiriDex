--------------------- Trampoline --------------------
Trampoline = Collectable:new()
Trampoline.__index = Trampoline

function Trampoline:new()
	local t = {}
	setmetatable(t,Trampoline)
	return t
end
function Trampoline:init(dx,dy)
	self.isActive = true
	self.position = Vector(0,0)
	
	self.isCollected = false
	
	self.isRespawnable = true
	self.respawn_time_const = 80
	self.respawn_time = 0
	
	
	self.direction = Vector(dx,dy)
	self.rotation = self.direction.angle + math.pi/2
	
	self.push_power = 1000
	
	self.willPlay = false
	self.willPlay2 = false
	
	self.frame = 1
	self.anim_speed_const = 50
	self.anim_speed = 50
	
	
	self.images = {
					love.graphics.newImage("gfx/trampoline1.png"),
					love.graphics.newImage("gfx/trampoline2.png"),
					love.graphics.newImage("gfx/trampoline3.png"),
					love.graphics.newImage("gfx/trampoline4.png")}
					
	-------- Sounds
	self.sounds = {}
	self.sounds.trampoline = love.audio.newSource("sfx/Player/trampoline.wav","stream")
	--------
	
	self.collect_target = "Human" -- Human / All / Enemies
	
	self.id = 0
	self.pick_range = 15
	self.hover_offset = 0
	self.onPickUp = function(id)
		if ACTORS[id] then
			if not ACTORS[id].isDead then
				self.sounds.trampoline:play()
				ACTORS[id]:ForceMove(350)
				ACTORS[id].velocity.x = self.push_power * self.direction.x
				ACTORS[id].velocity.y = self.push_power * self.direction.y
			end
		end
	end
end

function Trampoline:onCollect(id)
	self.willPlay = true
	self.anim_speed = self.anim_speed_const
	
	self.isCollected = true	
	if self.isRespawnable then
		self.respawn_time = self.respawn_time_const
	else
		self.isActive = false
	end
end

function Trampoline:setPickFunction(func)
	self.onPickUp = func
end


function Trampoline:update(dt)
	if self.isActive then
		if not self.isCollected then
			for k,v in pairs(ACTORS) do
				if v then
					if v.isActive then
						-- if v.isHuman then
							local w = self.images[self.frame]:getWidth()
							local h = self.images[self.frame]:getHeight()
							local dist = Distance(self.position.x, self.position.y, v.position.x + v.size.x/2, v.position.y + v.size.y/2)
							if dist < self.pick_range then
								self:onCollect(k)
								self.id = k
								break
							end
						-- end
					end
				end
			end
		else
			if self.isRespawnable then
				if self.respawn_time > 0 then
					self.respawn_time = self.respawn_time - 1000*dt
				else
					self.respawn_time = 0
					self.isCollected = false
				end
			end
		end
		if self.willPlay then
			if self.anim_speed > 0 then
				self.anim_speed = self.anim_speed - 1000*dt
			else
				self.anim_speed = self.anim_speed_const
				self.frame = self.frame + 1
				if self.frame == 2 then
					self.onPickUp(self.id)
				end
				if self.frame > #self.images then
					self.frame = 4
					self.willPlay = false
					self.willPlay2 = true
				end
			end
		end
		if self.willPlay2 then
			if self.anim_speed > 0 then
				self.anim_speed = self.anim_speed - 1000*dt
			else
				self.anim_speed = self.anim_speed_const
				self.frame = self.frame - 1
				if self.frame < 1 then
					self.frame = 1
					self.willPlay2 = false
				end
			end
		end
	end
end

function Trampoline:draw()
	if self.isActive then
		local w = self.images[self.frame]:getWidth()
		local h = self.images[self.frame]:getHeight()
		love.graphics.setColor(1,1,1,1)
		love.graphics.draw(self.images[self.frame],self.position.x, self.position.y + self.hover_offset, self.rotation,1,1,w/2,h/2)
	end
end

function CreateTrampoline(dx,dy)
	local obj = Trampoline:new()
	obj:init(dx,dy)
	return obj
end