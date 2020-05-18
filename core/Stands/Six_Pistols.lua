--------------------- Six_Pistols --------------------
Six_Pistols = Stand:new()
Six_Pistols.__index = Six_Pistols

function Six_Pistols:new()
	local t = {}
	setmetatable(t,Six_Pistols)
	return t
end
function Six_Pistols:init(player,ai)
	self.isActive = false
	self.name = "Six Pistols"
	self.stand_image = love.graphics.newImage("gfx/stands/stand_Six_Pistols.png")
	self.punch_image = love.graphics.newImage("gfx/stands/Six_Pistols_bullet.png")
	
	self.rateOfFire_const = 300
	self.rateOfFire = 0
	
	self.damage = 25
	self.range = 300
	
	self.special_desc = "Bullet Raffle"
	self.ultimate_desc = "Redirect Bullets (Passive)"
	
	-----------------------------------
	self.sounds = {}
	self.sounds.attack = love.audio.newSource("sfx/pistol_shot.wav","stream")
	self.sounds.special = love.audio.newSource("sfx/MudaMudaMuda.wav","stream")
	self.sounds.ultimate = love.audio.newSource("sfx/Za warudo.wav","stream")
	--------------------
	
	self.canAttack = true
	self.isCastingSpecial = false
	self.special_cd_const = 600
	self.special_cd = 0
	self.special_use_cd_const = 6000
	self.special_use_cd = 0
	self.special_attack_cd_const = 100
	self.special_attack_cd = 0
	
	self.player = player
	self.isAI = ai
	self.stats = {0.2,0.6,0.8,1,1,0.8}
end
function Six_Pistols:setActive(active)
	self.isActive = active
end
function Six_Pistols:UltimateAttack(x,y,r)

end
function Six_Pistols:SpecialAttack(x,y,r)
	if not self.isCastingSpecial and self.special_use_cd == 0 then
		self.isCastingSpecial = true
		self.special_cd = self.special_cd_const
		self.special_use_cd = self.special_use_cd_const
		self.canAttack = false
	end
end
function Six_Pistols:Attack(x,y,r)
	if self.canAttack then
		self.rateOfFire = self.rateOfFire_const
		self.canAttack = false
		local rnd1 = ({-1,1})[math.random(1,2)]
		local rnd2 = math.random(0,15)
		local nx = x + math.cos(r-math.pi/2*rnd1+math.pi/2)*rnd2
		local ny = y + math.sin(r-math.pi/2*rnd1+math.pi/2)*rnd2
		
		local p = CreateSix_Pistols_punch(nx,ny,r,self.punch_image,self.isAI)
		if self.timestop_bool then
			p:SetTime(0, self.timestop_duration)
		end
		
		self.sounds.attack:seek(0)
		self.sounds.attack:play()
		self.sounds.attack:setVolume(MASTER_VOLUME*0.35)
	end
end
function Six_Pistols:update(dt)
	if self.rateOfFire > 0 then
		self.rateOfFire = self.rateOfFire - 1000*dt
	else
		self.rateOfFire = 0
		self.canAttack = true and not self.isCastingSpecial
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
			
			local p = CreateSix_Pistols_punch(nx,ny,r,self.punch_image,self.isAI)
			self.sounds.attack:seek(0)
			self.sounds.attack:play()
			self.sounds.attack:setVolume(MASTER_VOLUME*0.35)
			if self.timestop_bool then
				p:SetTime(0, self.timestop_duration)
			end
		end
	end
end
function Six_Pistols:draw(x,y,r)
	if self.isActive then
		love.graphics.setColor(1,1,1,1)
		local w = self.stand_image:getWidth()
		local h = self.stand_image:getHeight()
		love.graphics.draw(self.stand_image,x,y,r,1,1,w/2,h/2)
		love.graphics.setColor(0,0,0,0.5)
		love.graphics.circle("line",x,y,self.range+self.punch_image:getHeight())
	end
end

function CreateSix_Pistols(player,ai)
	local obj = Six_Pistols:new()
	obj:init(player,ai)
	return obj
end