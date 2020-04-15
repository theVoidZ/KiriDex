--------------------- Player --------------------
Player = Actor:new()
Player.__index = Player

ACTORS = {}

function Player:new()
	local t = {}
	setmetatable(t,Player)
	t:post_init()
	return t
end
function Player:post_init()
	self.index = #ACTORS+1
	ACTORS[#ACTORS+1] = self
end
function Player:init()
	self.isActive = true
	self.isHuman = true
	self.size = Vector(30,30)
	self.scale = Vector(1,1)
	
	self.player_image = love.graphics.newImage("gfx/box2.png")
	
	self.time_factor = 1
	
	self.isGrounded = false
	self.canMove = false
	
	self.gravity_scale_const = 1
	self.gravity_scale = self.gravity_scale_const
	
	self.speed_const = 350
	self.speed = 350
	self.jump_power_const = 100
	self.jump_power = 100
	
	self.time_inAir = 0
	
	self.respawn_point = self.position.copy
	self.respawn_time_const = 2000
	self.respawn_time = 0
	self.isRespawning = false
	self.isDead = true
	
	self.trail_freq = 2
	self.move_trail = {}
	self.max_move_trail = 20
	
	self.timeFromLastGround_const = 160
	self.timeFromLastGround = 0
	self.isPowered_jump = false
	
	self.abilities = {
						Jump = true,
						Powered_Jump = false,
						Super_Speed = false,
						Super_Jump = false,
						Super_Dash = false,
						Feather_Fall = false,
						Dash = false}
	self.look_direction = 1
	
	
	self.dash_direction = Vector(0,0)
	self.dash_power_const = 800
	self.dash_power = self.dash_power_const
	self.dash_duration_const_const = 160
	self.dash_duration_const = 160 -- 90cd and 1500speed == 174px
	self.dash_duration = 0
	
	self.isForcedMoving = false
	self.forceMoving_const = 200
	self.forceMoving = 200
	
	self.isDashing = false
	self.canDash = true
	self.dash_pos = self.position.copy
	self.EndDashSpeed = self.dash_power*0.4
	self.EndDashUpMult = 0.75
	
	-- self.color = {r=6/255,g=152/255,b=23/255}
	-- self.colorglow = {r=192/255,g=229/255,b=197/255}
	local c = {100,100,100}
	self.color_radius = 200
	self.color = {r=(c[1])/255,g=(c[2])/255,b=(c[3])/255}
	self.colorglow = {r=(c[1]+100)/255,g=(c[2]+100)/255,b=(c[3]+100)/255}
	
	self.color_target = self.color
	self.colorglow_target = self.colorglow
	self.color_timer_const = 1000
	self.color_timer = 0
	self.isChangingColor = false
	
	
	self.fallMultiplier = 2.5
	self.lowJumpMultiplier = 2.5
	
	self.gravity = 981
	-- self.gravity = 1500
	self.velocity = Vector(0,0)
	
	
	self.trail_images = {}
	self.trail_cd_const = self.dash_duration_const/6
	self.trail_cd = 0
	self.trail_fade_time_const = 125
	self.trail_has_stopped = false
	
	
	self.isImage = false
	
	self.companions = {}
	-- for i = 1,50 do
		-- self:addCompanion()
	-- end
	
	
	------------ Graphics
	
	
	------------ Sounds
	self.sounds = {}
	self.sounds.jump1 = love.audio.newSource("sfx/Player/jump3.wav","stream")
	self.sounds.jump2 = love.audio.newSource("sfx/Player/jump2.wav","stream")
	self.sounds.dash1 = love.audio.newSource("sfx/Player/dash2.wav","stream")
	self.sounds.land1 = love.audio.newSource("sfx/Player/jumpland3.wav","stream")
	self.sounds.death1 = love.audio.newSource("sfx/Player/CelesteDeath.wav","stream")
	self.sounds.death2 = love.audio.newSource("sfx/Player/CelesteDeath2.wav","stream")
	self.sounds.powerup1 = love.audio.newSource("sfx/Player/Powerup10.wav","stream")
	---- Lighting
	-- self.light_body = LightWorld:newPolygon(unpack(RectToPoly(self.position.x, self.position.y, self.size.x, self.size.y)))
end

function Player:Spawn(x, y)
	self.respawn_point.x = x
	self.respawn_point.y = y
	
	self.position = self.respawn_point.copy
	self.isDead = false
	self.isRespawning = false
	
	self:GenerateRandomColor(true)
end
function Player:onDeadlyCollision()
	self:onDeath()
end

function Player:ChangeAbility(name,bool)
	self.abilities[name] = bool
	if name == "Super_Speed" then
		if bool then
			self.speed = self.speed_const*2
			
		else
			self.speed = self.speed_const
			
		end
	end
	if name == "Super_Jump" then
		if bool then
			self.jump_power = self.jump_power_const*1.4
		else
			self.jump_power = self.jump_power_const
		end
	end
	if name == "Super_Dash" then
		if bool then
			self.dash_power = self.dash_power_const*1.5
			self.dash_duration_const = self.dash_duration_const_const*1.3
			
		else
			self.dash_power = self.dash_power_const
			self.dash_duration_const = self.dash_duration_const_const
		end
	end
		for k,v in pairs(self.companions) do
			if v then
				v.speed_const = self.speed + 25
			end
		end
	
	self:GenerateRandomColor(true)
end
function Player:GenerateRandomColor(isTarget)
	
	local c = RandomColor()
	if isTarget then
		self.color_target = {r=(c[1])/255,g=(c[2])/255,b=(c[3])/255}
		self.colorglow_target = {r=(c[1]+100)/255,g=(c[2]+100)/255,b=(c[3]+100)/255}
		self.color_timer = self.color_timer_const
		self.isChangingColor = true
	else
		self.color = {r=(c[1])/255,g=(c[2])/255,b=(c[3])/255}
		self.colorglow = {r=(c[1]+100)/255,g=(c[2]+100)/255,b=(c[3]+100)/255}
	end
end

function Player:hasAbility(name)
	return self.abilities[name]
end

function Player:addCompanion()
	table.insert(self.companions,CreateCompanion())
	self.companions[#self.companions].position = self.position.copy
end

function Player:onDeathEnd(x, y)
	self.isRespawning = true
	self.position.x = x
	self.position.y = y
end

function Player:onDeath()
	if not self.isDead then
		-- Animator:playAt(self.position.x + self.size.x/2,self.position.y + self.size.y/2,self.color,{r=1,g=1,b=1})
		local skip = (math.random(0,1) == 0)
		Event:getAnimator():playAt(self.position.x + self.size.x/2,self.position.y + self.size.y/2,self.color,self.colorglow,skip,self.index)
		-- self.isActive = false
		self.isDead = true
		self.respawn_time = self.respawn_time_const
		if skip then
			self.sounds.death2:play()
		else
			self.sounds.death1:play()
		end
		
		-- self.light_body:setVisible(false)
		-- for k = 1,#self.companions do
			-- if self.companions[k] then
				-- self.companions[k]:onDeath()
			-- end
		-- end
	end
end

function Player:BetterJump(dt) ---- on update
	local vx,vy = self.velocity.x,self.velocity.y
	local gravity = self.gravity * self.gravity_scale
	if(vy > 0) then
		self.velocity.x = vx
		self.velocity.y = vy + gravity * (self.fallMultiplier - 1) * dt
	elseif vy < 0 and not (love.keyboard.isDown(love.keyboard.getKeyFromScancode("y")) or self.isPowered_jump) then
		self.velocity.x = vx
		self.velocity.y = vy + gravity * (self.lowJumpMultiplier - 1) * dt
	end
end
function Player:CalculateJumpSpeed(jumpHeight, gravity)
	return math.sqrt(2 * jumpHeight * gravity)
end
function Player:MakeCameraFollow(cam)
	cam:setPosition(self.position.x, self.position.y)
end
function Player:update(ddt)
	local dt = ddt * self.time_factor
	if self.isActive then
		if not self.isDead then
			if self.isChangingColor then
				if self.color_timer > 0 then
					self.color_timer = self.color_timer - 1000*dt
					self:GenerateRandomColor(false)
				else
					self.color_timer = 0
					self.isChangingColor = false
					self.color = self.color_target
					self.colorglow = self.colorglow_target
					self.sounds.powerup1:play()
				end
			end
			if not self.isDashing  then
				if self.scale.y < 1 then
					self.scale.y = math.clamp(self.scale.y + 30*dt,0,1)
				end			
				
				self:BetterJump(dt)
				self:handleControls(dt)
				-- if not self.isGrounded or self.velocity.x ~= 0 then
				if not self:collideAt(SOLIDS,self.position + Vector(0,1)) then
					self.velocity.y = self.velocity.y + self.gravity*dt * self.gravity_scale
				end
			else
				self:handleDashing(dt)
			end
			
			self:handleMoving(dt)
			
			if self.isGrounded then
				if self.timeFromLastGround > 0 then
					self.timeFromLastGround = self.timeFromLastGround - 1000*dt
				else
					self.timeFromLastGround = 0
					self.hasJumped = false
				end
			end
		else
			if self.respawn_time > 0 then
				self.respawn_time = self.respawn_time - 1000*dt
			else
				self.respawn_time = 0
			end
			if self.isRespawning then
				local dist = Distance(self.position.x, self.position.y, self.respawn_point.x, self.respawn_point.y)
				local ang = Angle(self.position.x, self.position.y, self.respawn_point.x, self.respawn_point.y)
				if dist < self.speed*2*dt*3 then
					self.position = self.respawn_point.copy
					self:Spawn(self.respawn_point.x, self.respawn_point.y)
				else
					local x = self.position.x + math.cos(ang) * self.speed*2*dt*3
					local y = self.position.y + math.sin(ang) * self.speed*2*dt*3
					self.position.x = x
					self.position.y = y
				end
			end
		end
		if self.isForcedMoving then
			if self.forceMoving > 0 then
				self.forceMoving = self.forceMoving - 1000*dt
			else
				self.forceMoving = 0
				self.isForcedMoving = false
			end
		end
		for k = 1,#self.companions do
			if self.companions[k] then
				local tx = (self.position.x + self.size.x/2) - (self.size.x * self.look_direction) * k
				local ty = (self.position.y) - self.size.y/2
				self.companions[k]:setTarget(tx, ty)
				self.companions[k]:update(dt)
			end
			-- self.light_body:setPoints(unpack(RectToPoly(self.position.x, self.position.y, self.size.x, self.size.y)))
		end
	end
end

function Player:handleDashing(dt)
	if self.trail_cd > 0 then
		self.trail_cd = self.trail_cd - 1000*dt
	else
		self.trail_cd = self.trail_cd_const
		if not self.trail_has_stopped then
			local count = #self.trail_images
			local x = self.dash_pos.x + self.dash_direction.x * 50 * count
			local y = self.dash_pos.y + self.dash_direction.y * 50 * count
			table.insert(self.trail_images,{x=x,y=y,fade=self.trail_fade_time_const})
		end
	end
	for k = #self.trail_images,1,-1 do
		if self.trail_images[k] then
			if self.trail_images[k].fade > 0 then
				self.trail_images[k].fade = self.trail_images[k].fade - 1000*dt
			else
				self.trail_images[k].fade = 0
				table.remove(self.trail_images,k)
			end
		end
	end
	if self.dash_duration > 0 then

		self.dash_duration = self.dash_duration - 1000*dt
		-- self.velocity.x = self.dash_power * self.look_direction
		-- self.velocity.y = 0
		
		self.velocity.x = self.dash_power * self.dash_direction.x
		self.velocity.y = self.dash_power * self.dash_direction.y
	else
		self:EndDash()
	end
end

function Player:handleMoving(dt)
	table.insert(self.move_trail,{x=self.position.x,y=self.position.y})
	if #self.move_trail > self.max_move_trail then
		table.remove(self.move_trail,1)
	end
	if self.velocity.x ~= 0 then
		self:MoveX(self.velocity.x*dt,function(side)
				if self.isDashing then
					if side == self.dash_direction.x then
						if self.dash_direction.y == 0 then
							self:EndDash()
						else
							self.trail_has_stopped = true
						end
					end
				end
			end)
			if self.isForcedMoving then
				self.velocity.x = self.velocity.x * 0.9
			end
	end
	if self.velocity.y ~= 0 then
		self:MoveY(self.velocity.y*dt,function(side)
			if side == 1 then
				self.sounds.land1:play()
				if self.hasJumped and not self.isGrounded then
					self.timeFromLastGround = self.timeFromLastGround_const
				end
				self.isGrounded = true
				print(self.isGrounded)
				self.isPowered_jump = false
				self.canDash = true
				self.velocity.y = 0
			else
				self.velocity.y = self.velocity.y*0.75
			end
			if self.isDashing then
				if side == self.dash_direction.y then
					if self.dash_direction.x == 0 then
						self:EndDash()
					else
						self.trail_has_stopped = true
					end
				end
			end
			end)
	end
end

function Player:setMove(bool) -- set if Player can mùove
	self.canMove = bool
end
function Player:ForceMove(cd)
	self.forceMoving = cd or self.forceMoving_const
	self.isForcedMoving = true
	self.canDash = true
	if self.isDashing then
		self:EndDash()
	end
end

function Player:handleControls(dt)
	if not self.canMove or self.isDead then return false end
	if love.keyboard.isDown(love.keyboard.getKeyFromScancode("a")) then
		if not self.isForcedMoving then
			self.velocity.x = -self.speed
		else
			if self.velocity.x == 0 then
				self.velocity.x = -self.speed/2
			end
		end
		self.look_direction = -1
		self.dash_direction.x = -1
		
		if love.keyboard.isDown(love.keyboard.getKeyFromScancode("w")) then
			self.dash_direction.y = -1
		elseif love.keyboard.isDown(love.keyboard.getKeyFromScancode("s")) then
			self.dash_direction.y = 1
		else
			self.dash_direction.y = 0
		end
	elseif love.keyboard.isDown(love.keyboard.getKeyFromScancode("d")) then
		if not self.isForcedMoving then
			self.velocity.x = self.speed
		else
			if self.velocity.x == 0 then
				self.velocity.x = self.speed/2
			end
		end
		self.look_direction = 1
		
		self.dash_direction.x = 1
		
		if love.keyboard.isDown(love.keyboard.getKeyFromScancode("w")) then
			self.dash_direction.y = -1
		elseif love.keyboard.isDown(love.keyboard.getKeyFromScancode("s")) then
			self.dash_direction.y = 1
		else
			self.dash_direction.y = 0
		end
	else
		if not self.isForcedMoving then
			self.velocity.x = 0
		end
		self.dash_direction.x = self.look_direction
		
		
		if love.keyboard.isDown(love.keyboard.getKeyFromScancode("w")) then
			self.dash_direction.y = -1
			self.dash_direction.x = 0
		elseif love.keyboard.isDown(love.keyboard.getKeyFromScancode("s")) then
			self.dash_direction.y = 1
			self.dash_direction.x = 0
		else
			self.dash_direction.y = 0
		end
	end
	self:FeatherFall()
end

function Player:FeatherFall()
	if self:hasAbility("Feather_Fall") then
		if self.velocity.y > 0 then
			if love.keyboard.isDown(love.keyboard.getKeyFromScancode("y")) then
				self.gravity_scale = self.gravity_scale_const*0.2
			else
				self.gravity_scale = self.gravity_scale_const
			end
		else
			self.gravity_scale = self.gravity_scale_const
		end
	end
end

function Player:keypressed(k)
	if not self.canMove or self.isDead then return false end
	if k == "y" then
		if self.isGrounded then
				self:NormalJump()
			end
	-- elseif k == "t" then
		-- self:ChangeAbility("Super_Speed",not self:hasAbility("Super_Speed"))
	elseif k == "u" then
		if self.canDash then
			self:Dash()
		end
	end
end

function Player:EndDash()
	self.dash_duration = 0
	self.isDashing = false
	
	self.trail_has_stopped = true
	
	self.velocity.x = 0.01
	self.velocity.y = 0.01
	if self.dash_direction.y <= 0 then
		self.velocity.x = self.velocity.x + self.dash_direction.x * self.EndDashSpeed
		self.velocity.y = self.velocity.y + self.dash_direction.y * self.EndDashSpeed
	end
	if self.velocity.y < 0 then
		self.velocity.y = self.EndDashUpMult * self.velocity.y
	end
	self.trail_images = {}
	self.trail_cd = 0
end

function Player:Dash()
	if self:hasAbility("Dash") then
		Event:getCamera():Shake(5,100)
		self.dash_pos = self.position.copy
		self.canDash = false
		self.dash_duration = self.dash_duration_const
		self.dash_distance = self.dash_distance_const
		self.isDashing = true
		self.isGrounded = false
		self.trail_has_stopped = false
		self.sounds.dash1:stop()
		self.sounds.dash1:play()
	end
end
function Player:NormalJump()
	if self:hasAbility("Jump") then
		self.isGrounded = false
		local modifier = 1
		if self.timeFromLastGround > 0 and self:hasAbility("Powered_Jump") then
			modifier = 1.35
			self.sounds.jump2:play()
			self.isPowered_jump = true
		else
			self.sounds.jump1:play()
		end
		self.velocity.y = -self:CalculateJumpSpeed(self.jump_power*modifier, self.gravity)
		self.hasJumped = true
	end
end
function Player:draw()
	if self.isActive then
		-- for k,v in pairs(self.trail) do
			-- if v then
				-- love.graphics.setColor(0,1,0,k/10*0.45)
				-- love.graphics.rectangle("fill",v.x,v.y,self.size.x,self.size.y)
				-- love.graphics.setColor(0,0,0,1)
				-- love.graphics.rectangle("line",v.x,v.y,self.size.x,self.size.y)	
			-- end
		-- end
		if not self.isDead then
			local ox = (self.size.x - self.size.x*self.scale.x)/2
			local oy = (self.size.y - self.size.y*self.scale.y)/2
			if self.isDashing then
				for k = #self.trail_images,1,-1 do
					if self.trail_images[k] then
						local alpha = self.trail_images[k].fade/self.trail_fade_time_const
						love.graphics.setColor(self.color.r+0.5,self.color.g+0.5,self.color.b+0.5,alpha)
						if self.isImage then
							local offx = -self.size.x/4 * self.look_direction + self.size.x/2
							love.graphics.draw(self.player_image,self.trail_images[k].x+ox+offx,self.trail_images[k].y+oy,0,self.scale.x*self.look_direction,self.scale.y)
						else
							love.graphics.rectangle("fill",self.trail_images[k].x+ox,self.trail_images[k].y+oy,self.size.x*self.scale.x,self.size.y*self.scale.y)
						end
					end
				end
				if self.dash_duration >= self.dash_duration_const*0.25 then
					love.graphics.setColor(1,1,1,1)
					love.graphics.line(self.dash_pos.x+ self.size.x/2, self.dash_pos.y+ self.size.y/2, self.position.x+ self.size.x/2, self.position.y+ self.size.y/2)
				end
			end
			if self:hasAbility("Super_Speed") then
				for i = 1 ,#self.move_trail,self.trail_freq do
					-- love.graphics.setColor(self.color.r,self.color.g,self.color.b,1)
					local a = (1 / (#self.move_trail) ^ 2) * 20 * i
					love.graphics.setColor(self.color.r,self.color.g,self.color.b,a)
					love.graphics.rectangle("fill",self.move_trail[i].x+ox,self.move_trail[i].y+oy,self.size.x*self.scale.x,self.size.y*self.scale.y)
					love.graphics.setColor(self.colorglow.r,self.colorglow.g,self.colorglow.b,a)
					love.graphics.rectangle("line",self.move_trail[i].x+ox,self.move_trail[i].y+oy,self.size.x*self.scale.x,self.size.y*self.scale.y)
				end
			end
			love.graphics.setColor(self.color.r,self.color.g,self.color.b,1)
			
			if self.isImage then
				local offx = -self.size.x/4 * self.look_direction + self.size.x/2
				love.graphics.draw(self.player_image,self.position.x+ox+offx,self.position.y+oy,0,self.scale.x*self.look_direction,self.scale.y)
			else
				love.graphics.rectangle("fill",self.position.x+ox,self.position.y+oy,self.size.x*self.scale.x,self.size.y*self.scale.y)
			end
			love.graphics.setColor(0,0,0,1)
			-- love.graphics.rectangle("line",self.position.x+ox,self.position.y+oy,self.size.x*self.scale.x,self.size.y*self.scale.y)
			-- glowShape(self.color.r*0.8,self.color.g*0.8,self.color.b*0.8,"rectangle",7,self.position.x+ox,self.position.y+oy,self.size.x*self.scale.x,self.size.y*self.scale.y)
			glowShape(self.colorglow.r*0.8,self.colorglow.g*0.8,self.colorglow.b*0.8,"rectangle",7,self.position.x+ox,self.position.y+oy,self.size.x*self.scale.x,self.size.y*self.scale.y)
			
			if self.isChangingColor then
				if self.color_timer >= self.color_timer_const*0.75 then
					local ratio = 1-(self.color_timer/self.color_timer_const - 3/4)*4
					glowShape(self.color_target.r,self.color_target.g,self.color_target.b,"circle",7,self.position.x+ox+self.size.x/2,self.position.y+oy+self.size.y/2,self.color_radius*ratio)
				else
					local ratio = self.color_timer/self.color_timer_const * 4/3
					glowShape(self.color_target.r,self.color_target.g,self.color_target.b,"circle",7,self.position.x+ox+self.size.x/2,self.position.y+oy+self.size.y/2,self.color_radius*ratio)
				end
			end
			
			love.graphics.setColor(1,1,1,1)
			-- love.graphics.print(tostring(#self.trail_images),50,30)
			love.graphics.print(tostring(self.velocity.x),self.position.x,200)
			love.graphics.setColor(1,0,0,1)
			
			-- local dx = self.position.x + self.size.x/2 + self.dash_direction.x * 120
			-- local dy = self.position.y + self.size.y/2 + self.dash_direction.y * 120
			-- love.graphics.line(self.position.x + self.size.x/2, self.position.y + self.size.y/2, dx, dy)
		else
			if self.isRespawning then
				love.graphics.setColor(self.colorglow.r, self.colorglow.g, self.colorglow.b,1)
				love.graphics.circle("fill",self.position.x+self.size.x/2,self.position.y+self.size.y/2,20)
				love.graphics.setColor(0,0,0,1)
				love.graphics.circle("line",self.position.x+self.size.x/2,self.position.y+self.size.y/2,20)
			end
		end
		for k = 1,#self.companions do
			if self.companions[k] then
				self.companions[k]:draw()
			end
		end
	end
end

function CreatePlayer()
	local obj = Player:new()
	obj:init()
	return obj
end