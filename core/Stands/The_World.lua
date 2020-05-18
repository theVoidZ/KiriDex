--------------------- The_World --------------------
The_World = Stand:new()
The_World.__index = The_World

function The_World:new()
	local t = {}
	setmetatable(t,The_World)
	return t
end
function The_World:init(player,ai)
	self.isActive = false
	self.name = "The World"
	self.stand_image = love.graphics.newImage("gfx/stands/stand_The_World.png")
	self.punch_image = love.graphics.newImage("gfx/stands/The_World_punch.png")
	
	self.rateOfFire_const = 550
	self.rateOfFire = 0
	
	self.damage = 50
	self.range = 130
	
	self.special_desc = "MudaMudaMuda"
	self.ultimate_desc = "Time Stop"
	
	-----------------------------------
	self.sounds = {}
	self.sounds.attack = love.audio.newSource("sfx/Muda_once.wav","stream")
	self.sounds.special = love.audio.newSource("sfx/MudaMudaMuda.wav","stream")
	self.sounds.ultimate = love.audio.newSource("sfx/Za warudo.wav","stream")
	self.sounds.ultimate2 = love.audio.newSource("sfx/Za warudo Resume.wav","stream")
	--------------------
	
	self.canAttack = true
	self.isCastingSpecial = false
	self.special_cd_const = 3600
	self.special_cd = 0
	self.special_use_cd_const = 5000
	self.special_use_cd = 0
	self.special_use_cd = 0
	self.special_attack_cd_const = 100
	self.special_attack_cd = 0
	
	self.isChanneling = false
	self.timestop_channeltime_const = 1900
	self.timestop_channeltime = 0
	self.timestop_duration_const = 6000
	self.timestop_duration = 0
	self.timestop_bool = false
	
	self.timestop_cd_const = 10000
	self.timestop_cd = 0
	
	self.timestop_effect_radius = 0
	self.timestop_effect_speed = 1500
	self.timestop_effect_finished = false
	self.timestop_effect_direction = 0
	self.timestop_x = 0
	self.timestop_y = 0
	
	self.player = player
	self.isAI = ai
	self.stats = {1,0.9,0.5,0.6,0.95,1}
end
function The_World:setActive(active)
	self.isActive = active
end
function The_World:UltimateAttack(x,y,r)
	if self.timestop_cd == 0 then
		self.timestop_cd = self.timestop_cd_const
		self.timestop_bool = true
		self.isChanneling = true
		self.timestop_channeltime = self.timestop_channeltime_const
		self.sounds.ultimate:play()
		self.sounds.ultimate:seek(0)
		self.sounds.ultimate:setVolume(MASTER_VOLUME*1.2)
	end
end
function The_World:SpecialAttack(x,y,r)
	if not self.isCastingSpecial and self.special_use_cd == 0 then
		self.sounds.special:play()
		self.sounds.special:setVolume(MASTER_VOLUME*0.5)
		self.isCastingSpecial = true
		self.special_cd = self.special_cd_const
		self.special_use_cd = self.special_use_cd_const
		self.canAttack = false
	end
end
function The_World:Attack(x,y,r)
	if self.canAttack then
		self.rateOfFire = self.rateOfFire_const
		self.canAttack = false
		local rnd1 = ({-1,1})[math.random(1,2)]
		local rnd2 = math.random(0,15)
		local nx = x + math.cos(r-math.pi/2*rnd1+math.pi/2)*rnd2
		local ny = y + math.sin(r-math.pi/2*rnd1+math.pi/2)*rnd2
		
		local p = CreateThe_World_punch(nx,ny,r,self.punch_image,self.isAI)
		if self.timestop_bool then
			p:SetTime(0, self.timestop_duration)
		end
		
		self.sounds.attack:seek(0)
		self.sounds.attack:play()
		self.sounds.attack:setVolume(MASTER_VOLUME*0.35)
	end
end
function The_World:update(dt)
	if self.rateOfFire > 0 then
		self.rateOfFire = self.rateOfFire - 1000*dt
	else
		self.rateOfFire = 0
		self.canAttack = true and not self.isCastingSpecial
	end
	if self.timestop_cd > 0 then
		self.timestop_cd = self.timestop_cd - 1000*dt
	else
		self.timestop_cd = 0
	end
	if self.timestop_bool then
		if self.timestop_channeltime > 0 then
			self.timestop_channeltime = self.timestop_channeltime - 1000*dt
		else
			if self.isChanneling then
				self.timestop_channeltime = 0
				self.isChanneling = false
				self.timestop_effect_finished = false
				self.timestop_effect_radius = 0
				local x,y = 0,0
				if not self.isAI then
					x = PLAYERS[self.player].position.x
					y = PLAYERS[self.player].position.y
				else
					x = ENEMIES[self.player].position.x
					y = ENEMIES[self.player].position.y
				end
				self.timestop_x = x
				self.timestop_y = y
				self.timestop_duration = self.timestop_duration_const
				self.timestop_effect_direction = 1
				Level_Handler:SetTime(0, self.timestop_duration, not self.isAI,self.player)
			end
			if self.timestop_duration > 0 or not self.timestop_effect_finished or self.isChanneling then
				self.timestop_duration = self.timestop_duration - 1000*dt
				if self.timestop_duration < 700 then
					if self.timestop_effect_direction > 0 then
						self.timestop_effect_direction = -2
						self.timestop_effect_radius = 2*WIDTH
						local x,y = 0,0
						if not self.isAI then
							x = PLAYERS[self.player].position.x
							y = PLAYERS[self.player].position.y
						else
							x = ENEMIES[self.player].position.x
							y = ENEMIES[self.player].position.y
						end
						self.timestop_x = x
						self.timestop_y = y
					end
				end
			else
				self.timestop_duration = 0
				self.timestop_bool = false
				self.sounds.ultimate2:seek(0)
				self.sounds.ultimate2:play()
				self.sounds.ultimate2:setVolume(MASTER_VOLUME)
				self.timestop_effect_direction = 0
			end
		end
		if self.timestop_effect_direction ~= 0 then
			self.timestop_effect_radius = self.timestop_effect_radius + self.timestop_effect_speed*dt*self.timestop_effect_direction
			if self.timestop_effect_radius > 2*WIDTH and self.timestop_effect_direction > 0 then
				self.timestop_effect_finished = true
			elseif self.timestop_effect_radius < 0 then
				self.timestop_effect_radius = 0
			end
			local func = function()
				love.graphics.circle("fill",self.timestop_x,self.timestop_y,self.timestop_effect_radius)
			end
			Level_Handler:setStencilFunction(func)
		end
	end
	if self.special_use_cd > 0 then
		self.special_use_cd = self.special_use_cd - 1000*dt
	else
		self.special_use_cd = 0
	end
	if self.isCastingSpecial then
		if self.special_cd > 0 then
			self.special_cd = self.special_cd - 1000*dt
		else
			self.special_cd = 0
			self.isCastingSpecial = false
			self.canAttack = true
		end
		if self.special_attack_cd > 0 then
			self.special_attack_cd = self.special_attack_cd - 1000*dt
		else
			self.special_attack_cd = self.special_attack_cd_const
				local x,y,r = 0,0,0
			if not self.isAI then
				x = PLAYERS[self.player].position.x
				y = PLAYERS[self.player].position.y
				r = PLAYERS[self.player].rotation
			else
				x = ENEMIES[self.player].position.x
				y = ENEMIES[self.player].position.y
				r = ENEMIES[self.player].rotation
			end
			local rnd1 = ({-1,1})[math.random(1,2)]
			local rnd2 = math.random(0,15)
			local nx = x + math.cos(r-math.pi/2*rnd1+math.pi/2)*rnd2
			local ny = y + math.sin(r-math.pi/2*rnd1+math.pi/2)*rnd2
			
			local p = CreateThe_World_punch(nx,ny,r,self.punch_image,self.isAI)
			if self.timestop_bool then
				p:SetTime(0, self.timestop_duration)
			end
		end
	end
end
function The_World:draw(x,y,r)
	if self.isActive then
		love.graphics.setColor(1,1,1,1)
		local w = self.stand_image:getWidth()
		local h = self.stand_image:getHeight()
		love.graphics.draw(self.stand_image,x,y,r,1,1,w/2,h/2)
		love.graphics.setColor(0,0,0,0.5)
		love.graphics.circle("line",x,y,self.range+self.punch_image:getHeight())
		
		if self.timestop_effect_radius > 0 then
			local s = love.graphics.getShader()
			love.graphics.setShader()
			love.graphics.setColor(0.2,0.2,0.2,0.3)
			love.graphics.circle("fill",self.timestop_x,self.timestop_y,self.timestop_effect_radius)
			love.graphics.setShader(s)
		end
		love.graphics.setColor(1,1,1,1)
		-- love.graphics.print(self.timestop_duration,0,30)
		-- love.graphics.print(self.timestop_effect_direction,0,45)
	end
end

function CreateThe_World(player,ai)
	local obj = The_World:new()
	obj:init(player,ai)
	return obj
end