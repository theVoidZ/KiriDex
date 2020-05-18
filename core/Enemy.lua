--------------------- Enemy --------------------
Enemy = {}
Enemy.__index = Enemy

ENEMIES = {}

function Enemy:new()
	local t = {}
	setmetatable(t,Enemy)
	return t
end
function Enemy:init(x,y)
	self.exists = true
	self.x,self.y = x or 0,y or 0
	self.time_factor = 1
	self.speed = math.random(100,250)
	self.rotation = 0
	self.player_image = love.graphics.newImage("gfx/Car"..math.random(1,4)..".png")
	self.hitbox = {}
	self.img_w = self.player_image:getWidth()
	self.img_h = self.player_image:getHeight()
	self.scale = 0.8
	self.explosion_timer = 300
	self.stencil_func = nil
	self.time_stop_long = 0
	self.time_stopped = false
	
	self.roam_target = {x=0,y=0}
	
	self.mode = "chase" -- roam if player is dead
	
	------ Sounds 
	self.explosion_sounds = {}
	for i =1,15 do
		self.explosion_sounds[i] = love.audio.newSource("sfx/explosion ("..i..").wav","stream")
	end
end
function Enemy:update(dt)
	if self.time_stopped then
		if self.time_stop_long > 0 then
			self.time_stop_long = self.time_stop_long - 1000*dt
			self.time_factor = 0
		else
			self.time_stop_long = 0
			self.time_stopped = false
		end
	else
		if not self.exists then
			if self.explosion_timer > 0 then
				self.explosion_timer = self.explosion_timer - 1000*dt*self.time_factor
			else
				self.explosion_timer = 0
				ENEMIES[self.index] = nil
			end
		else
			if self.mode == "chase" then
				self.rotation = Angle(player.x,player.y,self.x,self.y) - math.pi/2
				
				self.x = self.x + math.cos(self.rotation-math.pi/2) * self.speed * dt * self.time_factor
				self.y = self.y + math.sin(self.rotation-math.pi/2) * self.speed * dt * self.time_factor
			elseif self.mode == "roam" then
				local dist = Distance(self.x,self.y,self.roam_target.x,self.roam_target.y)
				if dist <= 50 then
					self.roam_target = {x=math.random(1,WIDTH),y=math.random(1,HEIGHT)}
				else
					
					self.rotation = Angle(self.roam_target.x,self.roam_target.y,self.x,self.y) - math.pi/2
					
					self.x = self.x + math.cos(self.rotation-math.pi/2) * self.speed * dt * self.time_factor
					self.y = self.y + math.sin(self.rotation-math.pi/2) * self.speed * dt * self.time_factor
				end
			end
			self:update_timezone()
			self:updateHitbox()
			self:updateCollision()
		end
	end
end
function Enemy:updateCollision()
	local dist = Distance(self.x,self.y,player.x,player.y)
	if dist <= 25 then
		player:onDeath()
		self.mode = "roam"
		self.roam_target = {x=math.random(1,WIDTH),y=math.random(1,HEIGHT)}
	end
end
function Enemy:update_timezone()
	local x = math.floor(self.x/Level_Handler.cell_size.x) + 1
	local y = math.floor(self.y/Level_Handler.cell_size.y) + 1
	local time_factor = Level_Handler:getTimeFactorAt(x,y)
	self.time_factor = time_factor
end
function Enemy:setStencilFunction(func)
	self.stencil_func = func
end
function Enemy:getHit()
	self.exists = false
	local snd = math.random(1,#self.explosion_sounds)
	self.explosion_sounds[snd]:play()
	self.explosion_sounds[snd]:setPitch(self.time_factor)
end
function Enemy:updateHitbox()
	local rot = self.rotation
	local diam = Distance(self.img_w/2,self.img_h/2,self.img_w,self.img_h)*self.scale
	local diam_ang = Angle(self.img_w/2,self.img_h/2,self.img_w,self.img_h)

	local x1 = self.x + math.cos(diam_ang+rot) * diam
	local y1 = self.y + math.sin(diam_ang+rot) * diam

	local x2 = x1 + math.cos(rot-math.pi/2) * self.img_h * self.scale
	local y2 = y1 + math.sin(rot-math.pi/2) * self.img_h * self.scale

	local x3 = x2 + math.cos(rot-math.pi) * self.img_w * self.scale
	local y3 = y2 + math.sin(rot-math.pi) * self.img_w * self.scale

	local x4 = x3 + math.cos(rot+math.pi/2) * self.img_h * self.scale
	local y4 = y3 + math.sin(rot+math.pi/2) * self.img_h * self.scale

	self.hitbox = {
				{x = x1, y = y1},
				{x = x2, y = y2},
				{x = x3, y = y3},
				{x = x4, y = y4},
				{x = x1, y = y1}}
end
function Enemy:StopTime(long)
	self.time_stopped = true
	self.time_stop_long = long
end
function Enemy:draw()
	if self.stencil_func then
		love.graphics.stencil(self.stencil_func,"replace",1)
		love.graphics.setStencilTest("greater", 0)
	end
	if not self.exists then
		if self.explosion_timer ~= 0 then
			love.graphics.setColor(1,1,1,1)
			local r = math.min((-self.explosion_timer + 340)/4,100)
			love.graphics.circle("fill",self.x,self.y,r)
		end
	else
		love.graphics.setColor(1,1,1,1)
		-- love.graphics.circle("fill",self.x,self.y,16)
		local w = self.player_image:getWidth()
		local h = self.player_image:getHeight()
		local x,y = self.x, self.y
		love.graphics.draw(self.player_image,self.x,self.y,self.rotation,self.scale,self.scale,w/2,h/2)
		love.graphics.setColor(1,0,1,1)
		-- love.graphics.polygon("line",self.hitbox[1].x,self.hitbox[1].y,
									-- self.hitbox[2].x,self.hitbox[2].y,
									-- self.hitbox[3].x,self.hitbox[3].y,
									-- self.hitbox[4].x,self.hitbox[4].y)
	end
	love.graphics.setStencilTest()
end
function CreateAEnemy(x,y)
	local obj = Enemy:new()
	obj:init(x,y)
	obj.index = #ENEMIES+1
	ENEMIES[#ENEMIES+1] = obj
	return obj
end