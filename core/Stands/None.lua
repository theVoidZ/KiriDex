--------------------- None --------------------
None = Stand:new()
None.__index = None

function None:new()
	local t = {}
	setmetatable(t,None)
	return t
end
function None:init(player,ai)
	self.isActive = false
	self.name = "None"
	self.stand_image = love.graphics.newImage("gfx/stands/stand_none.png")
	self.punch_image = love.graphics.newImage("gfx/stands/normal.png")
	
	self.rateOfFire_const = 1000
	self.rateOfFire = 0
	
	self.range = 50
	self.damage = 35
	self.special_desc = "None"
	self.ultimate_desc = "None"
	
	
	-----------------------------------
	self.sounds = {}
	self.sounds.attack = {}
	for i = 1,5 do
		self.sounds.attack[i] = love.audio.newSource("sfx/normal_punch ("..i..").wav","stream")
	end
	-- self.sounds.special = love.audio.newSource("sfx/OraOraOra.wav","stream")
	--------------------
	
	self.canAttack = true
	self.player = player
	self.isAI = ai
	self.stats = {0.2,0.2,0.2,0.2,0.2,0.2}
end
function None:setActive(active)
	self.isActive = active
end
function None:UltimateAttack(x,y,r)
	
end
function None:SpecialAttack(x,y,r)
end
function None:Attack(x,y,r)
	if self.canAttack then
		self.rateOfFire = self.rateOfFire_const
		self.canAttack = false
		local rnd1 = ({-1,1})[math.random(1,2)]
		local rnd2 = math.random(0,15)
		local nx = x + math.cos(r-math.pi/2*rnd1+math.pi/2)*rnd2
		local ny = y + math.sin(r-math.pi/2*rnd1+math.pi/2)*rnd2
		
		CreateNormal(nx,ny,r,self.punch_image,self.isAI)
		
		local snd_shoot = math.random(1,#self.sounds.attack)
		self.sounds.attack[snd_shoot]:play()
		self.sounds.attack[snd_shoot]:setVolume(MASTER_VOLUME)
	end
end
function None:update(dt)
	if self.rateOfFire > 0 then
		self.rateOfFire = self.rateOfFire - 1000*dt
	else
		self.rateOfFire = 0
		self.canAttack = true
	end
end
function None:draw(x,y,r)
	if self.isActive then
		love.graphics.setColor(1,1,1,1)
		local w = self.stand_image:getWidth()
		local h = self.stand_image:getHeight()
		love.graphics.draw(self.stand_image,x,y,r,1,1,w/2,h/2)
	end
end

function CreateNone(player,ai)
	local obj = None:new()
	obj:init(player,ai)
	return obj
end