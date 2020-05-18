--------------------- Player --------------------
Player = {}
Player.__index = Player

PLAYERS = {}

function Player:new()
	local t = {}
	setmetatable(t,Player)
	return t
end
function Player:init(x,y,color,hp)
	self.isAlive = true
	self.color = color or {r=1,g=1,b=1}
	self.alpha = 1
	
	self.x = x or WIDTH/2
	self.y = y or HEIGHT/2
	self.rotation = 0
	self.radius = 8
	
	self.bullet_x = self.x
	self.bullet_y = self.y
	
	self.speed = 350
	
	self.health = hp or 5
	
	self.rateOfFire_const = 400
	self.rateOfFire = self.rateOfFire_const
	self.canShoot = true
	self.canMove = true
	
	self.isSpawning = false
	self.spawn_rot = 0
	self.spawn_dist = 100
	-------- Upgrades
	self.icons = {}
	self.icons[#self.icons+1] = love.graphics.newImage("gfx/upgrades/Beam.png")
	self.icons[#self.icons+1] = love.graphics.newImage("gfx/upgrades/Shockwave.png")
	
	
	self.bullets_pierce = false
	self.spread = 0
	self.splits = 0
	
	self.beam = false
	self.can_use_beam = false
	self.isUsing_beam = false
	self.beam_cd_const = 30000
	self.beam_cd = 0
	self.beam_duration_const = 2000
	self.beam_duration = 2000
	
	self.shock = false
	self.can_use_shock = false
	self.isUsingShock = false
	self.shock_pos = Vector(0,0)
	self.shock_radius = 0
	self.shock_cd_const = 30000
	self.shock_cd = 0
	
	-------------------------
	self.player_shoot_sounds = {}
	self.player_power_sounds = {}
	self.music = love.audio.newSource("sfx/music2.mp3","stream")
	self.music:play()
	self.music:setVolume(0.3)
	self.music:setLooping(true)
	for i = 1,4 do
		self.player_shoot_sounds[i] = love.audio.newSource("sfx/shoot ("..i..").wav","stream")
	end
	for i = 1,5 do
		self.player_power_sounds[i] = love.audio.newSource("sfx/powerup ("..i..").wav","stream")
	end
end
function Player:handleControls(dt)
	if self.canMove then
		if love.keyboard.isDown(love.keyboard.getKeyFromScancode("a")) then
			self.x = self.x - self.speed*dt
		elseif love.keyboard.isDown(love.keyboard.getKeyFromScancode("d")) then
			self.x = self.x + self.speed*dt
		end
		if love.keyboard.isDown(love.keyboard.getKeyFromScancode("w")) then
			self.y = self.y - self.speed*dt
		elseif love.keyboard.isDown(love.keyboard.getKeyFromScancode("s")) then
			self.y = self.y + self.speed*dt
		end
		local mx, my = love.mouse.getPosition()
		self.rotation = Angle(mx,my,self.x,self.y) - math.pi/2
	end
	if self.isSpawning then
		local x = self.x + math.cos(self.spawn_rot)*self.speed*3*dt
		local y = self.y + math.sin(self.spawn_rot)*self.speed*3*dt
		local dist = Distance(self.x,self.y,x,y)
		
		self.x = x
		self.y = y
		
		self.spawn_dist = self.spawn_dist - dist
		if self.spawn_dist <= 0 then
			self.isSpawning = false
			self.canMove = true
		end
	end
	if love.mouse.isDown(1) then
		if self.canShoot and self.canMove then
			self.canShoot = false
			self.rateOfFire = self.rateOfFire_const
			CreateABullet(self.bullet_x,self.bullet_y,self.rotation-math.pi/2,self.color,true,self.bullets_pierce)
			local snd_shoot = math.random(1,#self.player_shoot_sounds)
			self.player_shoot_sounds[snd_shoot]:play()
			self.player_shoot_sounds[snd_shoot]:setVolume(0.5)
			if self.spread ~= 0 then
				for i = 1,self.spread do
					CreateABullet(self.bullet_x,self.bullet_y,self.rotation-math.pi/2-math.pi/60*i,self.color,true,self.bullets_pierce)					
					CreateABullet(self.bullet_x,self.bullet_y,self.rotation-math.pi/2+math.pi/60*i,self.color,true,self.bullets_pierce)					
				end
			end
		end
	end
end
function Player:keypressed(k)
	if not self.isSpawning then
		if k == "1" then
			-- if self.splits > 0 then
				-- self:Split()
				-- self.splits = self.splits - 1
			-- end
		elseif k == "2" then
			self:useBeam()
		elseif k == "3" then
			self:useShockWave()
		end
	end
end
function Player:useShockWave()
	if self.can_use_shock then
		self.can_use_shock = false
		self.shock_cd = self.shock_cd_const
		self.shock_pos.x = self.x
		self.shock_pos.y = self.y
		self.shock_radius = 0
		self.isUsingShock = true
		local snd_shoot = math.random(1,#self.player_power_sounds)
		self.player_power_sounds[snd_shoot]:play()
		self.player_power_sounds[snd_shoot]:setVolume(0.5)
	end
end
function Player:useBeam()
	if self.can_use_beam then
		self.can_use_beam = false
		self.isUsing_beam = true
		self.beam_duration = self.beam_duration_const
		local snd_shoot = math.random(1,#self.player_power_sounds)
		self.player_power_sounds[snd_shoot]:play()
		self.player_power_sounds[snd_shoot]:setVolume(0.5)
	end
end
function Player:Split()
	if self.health > 3 then
		for i = 1,self.health-1 do
			local p = CreatePlayer(self.x,self.y,{r=1,g=1,b=0},self.health-1)
			p.isSpawning = true
			p.spawn_rot = math.random(0,2*math.pi)
			p.spawn_dist = math.random(25,50)
			p.canMove = false
			
			p.bullets_pierce = self.bullets_pierce
			p.beam = self.beam
			p.shock = self.shock
			p.splits = self.splits
			p.rateOfFire_const = self.rateOfFire_const
			p.spread = self.spread
		end
		self.health = self.health - 1
	end
end
function Player:update(dt)
	if self.isAlive then
		if self.rateOfFire > 0 then
			self.rateOfFire = self.rateOfFire - 1000*dt
		else
			self.rateOfFire = 0
			self.canShoot = true
		end
		self:handleControls(dt)
		self:updateCollision(dt)
		if self.beam then
			if not self.isUsing_beam then
				if self.beam_cd > 0 then
					self.beam_cd = self.beam_cd - 1000*dt
				else
					self.beam_cd = 0
					self.can_use_beam = true
				end
			else
				if self.beam_duration > 0 then
					self.beam_duration = self.beam_duration - 1000*dt
					local x1 = self.bullet_x + math.cos(self.rotation)*8
					local y1 = self.bullet_y + math.sin(self.rotation)*8
					
					local x2 = x1 + math.cos(self.rotation-math.pi/2)*WIDTH
					local y2 = y1 + math.sin(self.rotation-math.pi/2)*WIDTH
					
					local x3 = x2 + math.cos(self.rotation-math.pi)*8
					local y3 = y2 + math.sin(self.rotation-math.pi)*8
					
					local x4 = self.bullet_x + math.cos(self.rotation-math.pi)*8
					local y4 = self.bullet_y + math.sin(self.rotation-math.pi)*8
					
					local poly = {{x=x1,y=y1},{x=x2,y=y2},{x=x3,y=y3},{x=x4,y=y4},{x=x1,y=y1}}
					
					for k,v in pairs(ENEMIES) do
						if v then
							if not v.isDying and not v.isSpawning then
								if ArePolygonsOverlapped(poly, v.hitbox,true) then
									Level_Handler:Enemy_hit(v.index)
								end
							end
						end
					end
				else
					self.beam_duration = 0
					self.beam_cd = self.beam_cd_const
					self.can_use_beam = false
					self.isUsing_beam = false
				end
			end
		end
		if self.shock then
			if not self.isUsingShock then
				if self.shock_cd > 0 then
					self.shock_cd = self.shock_cd - 1000*dt
				else
					self.shock_cd = 0
					self.can_use_shock = true
				end
			else
				if self.shock_radius < WIDTH then
					self.shock_radius = self.shock_radius + 400*dt
					for k,v in pairs(ENEMIES) do
						if v then
							if not v.isDying and not v.isSpawning then
								local dist = Distance(v.x,v.y,self.shock_pos.x,self.shock_pos.y)
								if dist <= self.shock_radius+30 and dist >= self.shock_radius-30 then
									Level_Handler:Enemy_hit(v.index)
								end
							end
						end
					end
				else
					self.isUsingShock = false
				end
			end
		end
	end
end

function Player:updateCollision(dt)
	for k,v in pairs(ENEMIES) do
		if v then
			if not v.isDying and not v.isSpawning then
				local dist = Distance(self.x,self.y,v.x,v.y)
				if dist <= v.radius/2 then
					self.isAlive = false
				end
			end
		end
	end
end
function Player:draw()
	if self.isAlive then
		love.graphics.setColor(self.color.r,self.color.g,self.color.b,self.alpha)
		local shape = PolygonFromCenter(self.x,self.y,self.radius,self.health,self.rotation,false)
		glowShape(self.color.r, self.color.g, self.color.b, "polygon", 8, shape)
		self.bullet_x = shape[#shape-1]
		self.bullet_y = shape[#shape]
		
		if self.isUsingShock then
			glowShape(1, 1, 0, "circle", 30,self.shock_pos.x, self.shock_pos.y,self.shock_radius)
		end	
		if self.isUsing_beam then
			glowShape(1, 1, 0, "line", 15,self.bullet_x, self.bullet_y, self.bullet_x + math.cos(self.rotation-math.pi/2)*WIDTH, self.bullet_y + math.sin(self.rotation-math.pi/2)*WIDTH)
			
			local r = 8 + math.cos(os.clock()*10)
			love.graphics.setColor(1,1,0,1)
			love.graphics.circle("fill",self.bullet_x, self.bullet_y,r)
			glowShape(1, 1, 0, "circle", 8,self.bullet_x, self.bullet_y,r)
		end
		
		if self.beam then
			love.graphics.setColor(1,1,1,1)
			love.graphics.draw(self.icons[1],5, HEIGHT-45, 0, 1.25, 1.25)
			
			if self.can_use_beam then
				glowShape(0, 0.7, 0, "rectangle", 8, 5, HEIGHT-45, 40, 40)
			else
				glowShape(0.7, 0.7, 0.7, "rectangle", 8, 5, HEIGHT-45, 40, 40)
			end
			
			if self.beam_cd > 0 then
				love.graphics.setScissor(5,HEIGHT-45,40,40)
				love.graphics.setColor(0,0,0,0.5)
				local ratio = self.beam_cd/self.beam_cd_const
				love.graphics.arc("fill",25,HEIGHT-25,40,0,ratio * 2 * math.pi)
				love.graphics.setScissor()
			end
			love.graphics.setColor(1,1,1,1)
			love.graphics.print("2",7,HEIGHT-20)
		end
		
		if self.shock then
			love.graphics.setColor(1,1,1,1)
			love.graphics.draw(self.icons[2],50, HEIGHT-45, 0, 1.25, 1.25)
			
			if self.can_use_shock then
				glowShape(0, 0.7, 0, "rectangle", 8, 50, HEIGHT-45, 40, 40)
			else
				glowShape(0.7, 0.7, 0.7, "rectangle", 8, 50, HEIGHT-45, 40, 40)
			end
			
			if self.shock_cd > 0 then
				love.graphics.setScissor(50,HEIGHT-45,40,40)
				love.graphics.setColor(0,0,0,0.5)
				local ratio = self.shock_cd/self.shock_cd_const
				love.graphics.arc("fill",70,HEIGHT-25,40,0,ratio * 2 * math.pi)
				love.graphics.setScissor()
			end
			
			love.graphics.setColor(1,1,1,1)
			love.graphics.print("3",52,HEIGHT-20)
		end
	end
end

function CreatePlayer(x,y,color,hp)
	local obj = Player:new()
	obj:init(x,y,color,hp)
	-- GameLoop:addObject(obj)
	-- Renderer:addToLayer("PLAYERS",obj)
	obj.index = #PLAYERS+1
	PLAYERS[#PLAYERS+1] = obj
	return obj
end