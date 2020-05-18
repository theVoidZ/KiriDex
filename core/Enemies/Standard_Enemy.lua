--------------------- Standard_Enemy --------------------
Standard_Enemy = Enemy:new()
Standard_Enemy.__index = Standard_Enemy

function Standard_Enemy:new()
	local t = {}
	setmetatable(t,Standard_Enemy)
	return t
end
function Standard_Enemy:init(x,y,lvl)
	
	self.isAlive = true
	self.position = Vector(x,y)
	self.level = lvl
	self.speed = 175
	
	self.stand = nil
	
	self.player_image = love.graphics.newImage("gfx/player.png")
	
	self.img_w = self.player_image:getWidth() + 5
	self.img_h = self.player_image:getHeight() + 5
	self.scale = 1
	
	self.maxHealth = 25*self.level + 5
	self.health = self.maxHealth
end
function Standard_Enemy:update(dt)
	if self.isAlive then
		if self.isTimeChanged then
			if self.time_change_duration > 0 then
				self.time_change_duration = self.time_change_duration - 1000*dt
			else
				self.time_change_duration = 0
				self.isTimeChanged = false
				self.time_factor = 1
			end
		else
			self:updateHitbox()
			if self.stand then
				local dist = Distance(PLAYERS[1].position.x, PLAYERS[1].position.y,self.position.x, self.position.y)
				if dist <= self.stand.range then
					if self.time_factor ~= 0 then
						self.rotation = Angle(PLAYERS[1].position.x, PLAYERS[1].position.y,self.position.x,self.position.y) - math.pi/2
					end
					if not self:isOutOfBounds() then
						self:UltimateAttack()
						-- self:SpecialAttack()
						self:Attack()
					end
				else
					self:Chase(PLAYERS[1].position.x, PLAYERS[1].position.y, dt)
				end
				self.stand:update(dt*self.time_factor)
			end
		end
	end
end
function Standard_Enemy:draw_()
	if self.isAlive then
		love.graphics.setColor(1,1,1,1)
		local w = self.player_image:getWidth()
		local h = self.player_image:getHeight()
		love.graphics.draw(self.player_image,self.position.x,self.position.y,self.rotation,1,1,w/2,h/2)
		if self.stand then
			self.stand:draw(self.position.x, self.position.y,self.rotation)
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
	end
end

function CreateStandard_Enemy(x,y,lvl)
	local obj = Standard_Enemy:new()
	obj:init(x,y,lvl)
	obj.index = #ENEMIES+1
	ENEMIES[#ENEMIES+1] = obj
	return obj
end