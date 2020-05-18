--------------------- Enemy --------------------
Enemy = {}
Enemy.__index = Enemy

ENEMIES = {}
SPAWNED = 0

function Enemy:new()
	local t = {}
	setmetatable(t,Enemy)
	return t
end
function Enemy:init(x,y,color,hp,radius)
	SPAWNED= SPAWNED + 1
	self.isAlive = true
	self.x,self.y = x or 0,y or 0
	self.radius = radius or  10
	
	self.speed = math.random(100,150)
	self.rotation = 0
	
	self.color = color or {r=1,g=0,b=0}
	
	self.health = hp or 3
	self.radius = 13 + (self.health-3)*8
	
	self.isDying = false
	
	
	self.isSpawning = false
	self.spawn_rot = 0
	self.spawn_dist = 300
	
	self.roam_target = Vector(0,0)
	self.move_mode = "chase"
	
	self.explosion_timer = 300
	
	self.hitbox = PolygonFromCenter(self.x,self.y,self.radius,self.health,self.rotation,true)
	
	
	------ Sounds 
	self.explosion_sounds = {}
	for i =1,15 do
		self.explosion_sounds[i] = love.audio.newSource("sfx/explosion ("..i..").wav","stream")
	end
end
function Enemy:updateCollision()
	self.hitbox = PolygonFromCenter(self.x,self.y,self.radius,self.health,self.rotation,true)
	self.hitbox[#self.hitbox+1] = {x=self.hitbox[1].x,y=self.hitbox[1].y}
	-- local dist = Distance(self.x,self.y,player.x,player.y)
	-- if dist <= 25 then
		-- player:onDeath()
	-- end
end
function Enemy:getHit()
	if not self.isSpawning and not self.isDying then
		self:Split()
	end
end
function Enemy:Split(forFun)
	if self.health > 3 then
		for i = 1,self.health-1 do
			local p = CreateEnemy(self.x,self.y,({{r=0,g=0,b=1},{r=1,g=0,b=0},{r=0,g=1,b=0}})[math.random(1,3)],self.health-1)
			p.isSpawning = true
			p.spawn_rot = self.rotation+math.pi/2 + math.random(-math.pi/6,math.pi/6)
			p.spawn_dist = math.random(75,150)
			p.canMove = false
		end
		if forFun then
			self.health = self.health - 1
			self.radius = 13 + (self.health-3)*8
		end
	end
	if not forFun then
		self.isDying = true
		Level_Handler:onEnemyKill()
		local snd = math.random(1,#self.explosion_sounds)
		self.explosion_sounds[snd]:play()
		self.explosion_sounds[snd]:setVolume(0.5)
	end
end
function Enemy:update(dt)
	if self.isAlive then
		if not self.isDying then
			self:updateCollision()
			if not self.isSpawning then
				if self.move_mode == "chase" then
					self.rotation = Angle(PLAYERS[1].x,PLAYERS[1].y,self.x,self.y) - math.pi/2

					self.x = self.x + math.cos(self.rotation-math.pi/2) * self.speed * dt
					self.y = self.y + math.sin(self.rotation-math.pi/2) * self.speed * dt
					if not PLAYERS[1].isAlive then
						self.move_mode = "roam"
						self.roam_target = {x=math.random(1,WIDTH),y=math.random(1,HEIGHT)}
					end
				else
					local dist = Distance(self.x,self.y,self.roam_target.x,self.roam_target.y)
					if dist <= 50 then
						self.roam_target = {x=math.random(1,WIDTH),y=math.random(1,HEIGHT)}
						self:Split(true)
					else
						
						self.rotation = Angle(self.roam_target.x,self.roam_target.y,self.x,self.y) - math.pi/2
						
						self.x = self.x + math.cos(self.rotation-math.pi/2) * self.speed * dt
						self.y = self.y + math.sin(self.rotation-math.pi/2) * self.speed * dt
					end
				end
			else
				local x = self.x + math.cos(self.spawn_rot)*self.speed*3*dt
				local y = self.y + math.sin(self.spawn_rot)*self.speed*3*dt
				local dist = Distance(self.x,self.y,x,y)
				
				self.x = x
				self.y = y
				
				self.rotation = self.rotation + 1
				
				self.spawn_dist = self.spawn_dist - dist
				if self.spawn_dist <= 0 then
					self.isSpawning = false
				end
			end
		else
			if self.explosion_timer > 0 then
				self.explosion_timer = self.explosion_timer - 1000*dt
			else
				self.explosion_timer = 0
				self.isAlive = false
				ENEMIES[self.index] = nil
			end
		end
	end
end
function Enemy:draw()
	if self.isAlive then
		if not self.isDying then
			love.graphics.setColor(self.color.r,self.color.g,self.color.b,self.alpha)
			local shape = PolygonFromCenter(self.x,self.y,self.radius,self.health,self.rotation,false)
			glowShape(self.color.r, self.color.g, self.color.b, "polygon", 8, shape)
		else
			if self.explosion_timer ~= 0 then
				love.graphics.setColor(self.color.r,self.color.g,self.color.b,self.alpha)
				local r = math.min((-self.explosion_timer + 340)/4,100)
				-- love.graphics.circle("fill",self.x,self.y,r)
				glowShape(self.color.r, self.color.g, self.color.b, "circle", 8, self.x, self.y, r)
			end
		end
	end
end

function CreateEnemy(x,y,color,hp,radius)
	local obj = Enemy:new()
	obj:init(x,y,color,hp,radius)
	obj.index = #ENEMIES+1
	ENEMIES[#ENEMIES+1] = obj
	return obj
end