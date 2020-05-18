--------------------- Player --------------------
Player = {}
Player.__index = Player

PLAYERS = {}

function Player:new()
	local t = {}
	setmetatable(t,Player)
	return t
end
function Player:init()
	self.isAlive = true
	self.name = "WexDex"
	
	self.player_image = love.graphics.newImage("gfx/player.png")
	
	self.img_w = self.player_image:getWidth() + 5
	self.img_h = self.player_image:getHeight() + 5
	self.scale = 1
	
	self.position = Vector(WIDTH/2,HEIGHT/2)
	self.rotation = 0
	
	self.speed = 200
	
	self.maxHealth = 800
	self.health = self.maxHealth
	
	self.canMove = true
	
	self.time_factor = 1
	self.time_change_duration = 0
	self.isTimeChanged = false
	self.stencil_func = nil
	
	self.current_stand = 1
	self.stands = {
					[1] = CreateNone(1),
					[2] = CreateStar_Platinum(1),
					[3] = CreateThe_World(1),
					[4] = CreateSix_Pistols(1)
	}
	
	self.stands[self.current_stand]:setActive(true)
end

function Player:updateHitbox()
	local rot = self.rotation
	local diam = Distance(self.img_w/2,self.img_h/2,self.img_w,self.img_h)*self.scale
	local diam_ang = Angle(self.img_w/2,self.img_h/2,self.img_w,self.img_h)

	local x1 = self.position.x + math.cos(diam_ang+rot) * diam
	local y1 = self.position.y + math.sin(diam_ang+rot) * diam

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
function Player:setStencilFunction(func)
	self.stencil_func = func
end
function Player:update(dt)
	if self.isAlive then
		self:updateHitbox()
		if self.isTimeChanged then
			if self.time_change_duration > 0 then
				self.time_change_duration = self.time_change_duration - 1000*dt
			else
				self.time_change_duration = 0
				self.isTimeChanged = false
				self.time_factor = 1
			end
		else
			self:handleControls(dt*self.time_factor)
			if self.stands[self.current_stand] then
				self.stands[self.current_stand]:update(dt*self.time_factor)
			end
		end
	end
end
function Player:keypressed(k)
	if self.isAlive then
		if k == "space" then
			if self:getStand() then
				self:getStand():UltimateAttack(self.position.x,self.position.y,self.rotation)
			end
		end
	end
end
function Player:handleControls(dt)
	if self.canMove then
		if love.keyboard.isDown(love.keyboard.getKeyFromScancode("a")) then
			self.position.x = self.position.x - self.speed*dt
		elseif love.keyboard.isDown(love.keyboard.getKeyFromScancode("d")) then
			self.position.x = self.position.x + self.speed*dt
		end
		if love.keyboard.isDown(love.keyboard.getKeyFromScancode("w")) then
			self.position.y = self.position.y - self.speed*dt
		elseif love.keyboard.isDown(love.keyboard.getKeyFromScancode("s")) then
			self.position.y = self.position.y + self.speed*dt
		end
		local mx, my = love.mouse.getPosition()
		self.rotation = Angle(mx,my,self.position.x,self.position.y) - math.pi/2
	end
	if love.mouse.isDown(1) then
		if self:getStand() then
			self:getStand():Attack(self.position.x,self.position.y,self.rotation)
		end
	elseif love.mouse.isDown(2) then
		if self:getStand() then
			self:getStand():SpecialAttack(self.position.x,self.position.y,self.rotation)
		end
	end
end
function Player:SetTime(timefactor, duration)
	self.time_factor = timefactor
	self.isTimeChanged = true
	self.time_change_duration = duration
end
function Player:getHit(dmg)
	if self.isAlive then
		self.health = self.health - dmg
		if self.health <= 0 then
			Level_Handler:onPlayerDeath()
			self.isAlive = false
		end
	end
end
function Player:getStand()
	return self.stands[self.current_stand]
end
function Player:draw()
	if self.isAlive then
		if self.stencil_func then
			self:draw_()
			love.graphics.setShader(shaders.invert)
			love.graphics.stencil(self.stencil_func,"replace",1)
			love.graphics.setStencilTest("greater", 0)
		end
		self:draw_()
		love.graphics.setStencilTest()
		love.graphics.setShader()
	end
end
function Player:draw_()
	love.graphics.setColor(1,1,1,1)
	local w = self.player_image:getWidth()
	local h = self.player_image:getHeight()
	love.graphics.draw(self.player_image,self.position.x,self.position.y,self.rotation,1,1,w/2,h/2)
	if self.stands[self.current_stand] then
		self.stands[self.current_stand]:draw(self.position.x, self.position.y,self.rotation)
	end
	
	
	local s = love.graphics.getShader()
	love.graphics.setShader()
	if s then
		local ratio = self.health/self.maxHealth
		love.graphics.setColor(1,1,1,1)
		love.graphics.rectangle("fill",self.position.x-w,self.position.y-20-h,w*2,10)
		love.graphics.setColor(1,0,1,1)
		love.graphics.rectangle("fill",self.position.x-w,self.position.y-20-h,w*2*ratio,10)
		love.graphics.setColor(1,1,1,1)
		love.graphics.rectangle("line",self.position.x-w,self.position.y-20-h,w*2,10)
	else
		local ratio = self.health/self.maxHealth
		love.graphics.setColor(0,0,0,1)
		love.graphics.rectangle("fill",self.position.x-w,self.position.y-20-h,w*2,10)
		love.graphics.setColor(0,1,0,1)
		love.graphics.rectangle("fill",self.position.x-w,self.position.y-20-h,w*2*ratio,10)
		love.graphics.setColor(0,0,0,1)
		love.graphics.rectangle("line",self.position.x-w,self.position.y-20-h,w*2,10)
	end
	love.graphics.setShader(s)
	
	love.graphics.setColor(1,1,1,1)
	-- love.graphics.print("Stand User : "..self.name,5,HEIGHT-35)
	love.graphics.print("Stand Name : "..self:getStand().name,5,HEIGHT-20)
end
function CreatePlayer()
	local obj = Player:new()
	obj:init()
	obj.index = #PLAYERS+1
	PLAYERS[#PLAYERS+1] = obj
	return obj
end