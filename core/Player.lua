--------------------- Player --------------------
Player = {}
Player.__index = Player

function Player:new()
	local t = {}
	setmetatable(t,Player)
	return t
end
function Player:init()
	self.isDead = false
	self.x,self.y = 80,200
	self.time_factor = 1
	self.speed = 200
	self.rotation = 0
	self.player_image = love.graphics.newImage("gfx/player.png")
	self.gun_image = love.graphics.newImage("gfx/gun.png")
	self.slow_image = love.graphics.newImage("gfx/SlowMo.png")
	self.bullet_x = 0
	self.bullet_y = 0
	
	self.rateoffire_const = 200
	self.rateoffire = 0
	self.canfire = true
	self.kills = 0
	
	self.invincibility_cooldown_const = 3000
	self.invincibility_cooldown = 0
	self.isInvincible = false
	
	----- Sounds
	self.player_shoot_sounds = {}
	self.music = love.audio.newSource("sfx/music2.mp3","stream")
	self.music:play()
	self.music:setVolume(0.3)
	self.music:setLooping(true)
	for i = 1,4 do
		self.player_shoot_sounds[i] = love.audio.newSource("sfx/shoot ("..i..").wav","stream")
	end
end
function Player:update(dt)
	self:update_timezone()
	if not self.isDead then
		if love.keyboard.isDown(love.keyboard.getKeyFromScancode("a")) then
			self.x = self.x - self.speed*dt*self.time_factor
		elseif love.keyboard.isDown(love.keyboard.getKeyFromScancode("d")) then
			self.x = self.x + self.speed*dt*self.time_factor
		end
		if love.keyboard.isDown(love.keyboard.getKeyFromScancode("w")) then
			self.y = self.y - self.speed*dt*self.time_factor
		elseif love.keyboard.isDown(love.keyboard.getKeyFromScancode("s")) then
			self.y = self.y + self.speed*dt*self.time_factor
		end
		local mx, my = love.mouse.getPosition()
		self.rotation = Angle(mx,my,self.x,self.y) - math.pi/2
	end
		self.music:setPitch(self.time_factor)
		------------------------
	if self.rateoffire > 0 then
		self.rateoffire = self.rateoffire - dt*1000 * self.time_factor
	else
		self.rateoffire = 0
		self.canfire = true
	end
end
function Player:mousepressed(x,y,b)
	if not self.isDead then
		local w = self.player_image:getWidth()
		local h = self.player_image:getHeight()
		local wg = self.gun_image:getWidth()
		local hg = self.gun_image:getHeight()
		
		self.bullet_x = self.x + math.cos(self.rotation-math.pi/2)*(h/2+hg)
		self.bullet_y = self.y + math.sin(self.rotation-math.pi/2)*(h/2+hg)
		local x = self.bullet_x
		local y = self.bullet_y
		if self.canfire then
			local b = CreateABullet(x,y,self.rotation-math.pi/2,true)
			if Level_Handler.time_stopped then
				BULLETS[b.index]:StopTime(Level_Handler.time_stop_long)
			end
			self.canfire = false
			self.rateoffire = self.rateoffire_const
			local snd_shoot = math.random(1,#self.player_shoot_sounds)
			self.player_shoot_sounds[snd_shoot]:play()
			self.player_shoot_sounds[snd_shoot]:setPitch(self.time_factor)
		end
	end
end
function Player:update_timezone()
	local x = math.floor(self.x/Level_Handler.cell_size.x) + 1
	local y = math.floor(self.y/Level_Handler.cell_size.y) + 1
	local time_factor = Level_Handler:getTimeFactorAt(x,y)
	self.time_factor = time_factor
end
function Player:onDeath()
	self.isDead = true
end
function Player:onKill()
	self.kills = self.kills + 1
end
function Player:draw()
	if not self.isDead then
		love.graphics.setColor(1,1,1,1)
		local w = self.player_image:getWidth()
		local h = self.player_image:getHeight()
		local wg = self.gun_image:getWidth()
		local hg = self.gun_image:getHeight()
		local x,y = self.x, self.y
		love.graphics.draw(self.player_image,self.x,self.y,self.rotation,1,1,w/2,h/2)
		love.graphics.draw(self.gun_image,x + math.cos(self.rotation-math.pi/2)*w/2,y + math.sin(self.rotation-math.pi/2)*w/2,self.rotation,1,1,wg/2,hg)
		if self.time_factor > 1 then
			local alpha = (192*self.time_factor - 192)/1.5
			love.graphics.setColor(1,1,1,alpha/255)
			love.graphics.draw(self.slow_image,0,0,0)
		elseif self.time_factor < 1 then
			local alpha = (-192*self.time_factor + 192)/0.9
			love.graphics.setColor(1,1,1,alpha/255)
			love.graphics.draw(self.slow_image,0,0,0)
		end
	end
end

function CreateAPlayer()
	local obj = Player:new()
	obj:init()
	GameLoop:addObject(obj)
	Renderer:addToLayer("PLAYERS",obj)
	return obj
end