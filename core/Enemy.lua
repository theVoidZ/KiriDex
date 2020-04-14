--------------------- Enemy --------------------
Enemy = Actor:new()
Enemy.__index = Enemy

ACTORS = {}

function Enemy:new()
	local t = {}
	setmetatable(t,Enemy)
	t:post_init()
	return t
end
function Enemy:post_init()
	self.index = #ACTORS+1
	ACTORS[#ACTORS+1] = self
end
function Enemy:init()
	self.isActive = true
	self.size = Vector(30,30)
	self.scale = Vector(1,1)
	
	self.player_image = love.graphics.newImage("gfx/box2.png")
	
	self.time_factor = 1
	
	self.isGrounded = false
	
	self.speed = 400
	self.jump_power = 100
	
	self.timeFromLastGround_const = 150
	self.timeFromLastGround = 0
	
	self.look_direction = 1
	
	
	self.dash_direction = Vector(0,0)
	self.dash_power = 1000
	self.dash_duration_const = 160 -- 90cd and 1500speed == 174px
	self.dash_duration = 0
	self.isDashing = false
	self.canDash = true
	self.dash_pos = self.position.copy
	self.EndDashSpeed = self.dash_power*0.4
	self.EndDashUpMult = 0.75
	
	self.color = {r=0,g=1,b=0}
	
	
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
	
	self.up = false
	self.down = false
	self.left = false
	self.right = true
	self.jump = true
	
	self.companions = {}
	self:addCompanion()
	
	---- Lighting
	-- self.light_body = LightWorld:newPolygon(unpack(RectToPoly(self.position.x, self.position.y, self.size.x, self.size.y)))
end

function Enemy:addCompanion()
	table.insert(self.companions,CreateCompanion())
	self.companions[#self.companions].position = self.position.copy
end

function Enemy:onDeath()
	Animator:playAt(self.position.x + self.size.x/2,self.position.y + self.size.y/2,self.color,{r=1,g=1,b=1})
	self.isActive = false
	-- self.light_body:setVisible(false)
	
	for k = 1,#self.companions do
		if self.companions[k] then
			self.companions[k]:onDeath()
		end
	end
end

function Enemy:BetterJump(dt) ---- on update
	local vx,vy = self.velocity.x,self.velocity.y
	local gravity = self.gravity
	if(vy > 0) then
		self.velocity.x = vx
		self.velocity.y = vy + gravity * (self.fallMultiplier - 1) * dt
	elseif vy < 0 and not (self.jump) then
		self.velocity.x = vx
		self.velocity.y = vy + gravity * (self.lowJumpMultiplier - 1) * dt
	end
end
function Enemy:CalculateJumpSpeed(jumpHeight, gravity)
	return math.sqrt(2 * jumpHeight * gravity)
end
function Enemy:update(ddt)
	local dt = ddt * self.time_factor
	if self.isActive then
		if not self.isDashing then
			if self.scale.y < 1 then
				self.scale.y = math.clamp(self.scale.y + 30*dt,0,1)
			end
			
			self:BetterJump(dt)
			self:handleControls(dt)
			if not self.isGrounded or self.velocity.x ~= 0 then
				self.velocity.y = self.velocity.y + self.gravity*dt
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

function Enemy:handleDashing(dt)
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

function Enemy:handleMoving(dt)
	if self.isGrounded then
		self:NormalJump()
	end
	-- if self.canDash then
		-- self:Dash()
	-- end
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
				self.right = not self.right
				self.left = not self.left
				print(self.left,self.right)
			end)
	end
	if self.velocity.y ~= 0 then
		self:MoveY(self.velocity.y*dt,function(side)
			if side == 1 then
				self.isGrounded = true
				self.canDash = true
				if self.hasJumped then
					self.timeFromLastGround = self.timeFromLastGround_const
				end
				self.velocity.y = 0
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

function Enemy:handleControls(dt)
	if self.left then
		self.velocity.x = -self.speed
		self.look_direction = -1
		self.dash_direction.x = -1
		
		if self.up then
			self.dash_direction.y = -1
		elseif self.down then
			self.dash_direction.y = 1
		else
			self.dash_direction.y = 0
		end
	elseif self.right then
		self.velocity.x = self.speed
		self.look_direction = 1
		
		self.dash_direction.x = 1
		
		if self.up then
			self.dash_direction.y = -1
		elseif self.down then
			self.dash_direction.y = 1
		else
			self.dash_direction.y = 0
		end
	else
		self.velocity.x = 0
		self.dash_direction.x = self.look_direction
		
		
		if self.up then
			self.dash_direction.y = -1
			self.dash_direction.x = 0
		elseif self.down then
			self.dash_direction.y = 1
			self.dash_direction.x = 0
		else
			self.dash_direction.y = 0
		end
	end
end

function Enemy:keypressed(k)
	-- if k == "y" then
		-- if self.isGrounded then
				-- self:NormalJump()
			-- end
	-- elseif k == "u" then
		-- if self.canDash then
			-- self:Dash()
		-- end
	-- end
end

function Enemy:EndDash()
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

function Enemy:Dash()
	self.dash_pos = self.position.copy
	self.canDash = false
	self.dash_duration = self.dash_duration_const
	self.isDashing = true
	self.isGrounded = false
	self.trail_has_stopped = false
end
function Enemy:NormalJump()
	-- self.velocity.y = -self.jump_power
	self.isGrounded = false
	local modifier = 1
	if self.timeFromLastGround > 0 then
		modifier = 1.35
	end
	self.velocity.y = -self:CalculateJumpSpeed(self.jump_power*modifier, self.gravity)
	self.hasJumped = true
end
function Enemy:draw()
	if self.isActive then
		-- for k,v in pairs(self.trail) do
			-- if v then
				-- love.graphics.setColor(0,1,0,k/10*0.45)
				-- love.graphics.rectangle("fill",v.x,v.y,self.size.x,self.size.y)
				-- love.graphics.setColor(0,0,0,1)
				-- love.graphics.rectangle("line",v.x,v.y,self.size.x,self.size.y)	
			-- end
		-- end
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
		glowShape(self.color.r,self.color.g,self.color.b,"rectangle",10,self.position.x+ox,self.position.y+oy,self.size.x*self.scale.x,self.size.y*self.scale.y)
		
		
		for k = 1,#self.companions do
			if self.companions[k] then
				self.companions[k]:draw()
			end
		end
		
		love.graphics.setColor(1,1,1,1)
		love.graphics.print(tostring(#self.trail_images),50,30)
		love.graphics.print(tostring(self.velocity),50,45)
		love.graphics.setColor(1,0,0,1)
		
		local dx = self.position.x + self.size.x/2 + self.dash_direction.x * 120
		local dy = self.position.y + self.size.y/2 + self.dash_direction.y * 120
		love.graphics.line(self.position.x + self.size.x/2, self.position.y + self.size.y/2, dx, dy)
	end
end

function CreateEnemy()
	local obj = Enemy:new()
	obj:init()
	return obj
end