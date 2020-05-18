--------------------- Enemy --------------------
Enemy = {}
Enemy.__index = Enemy

ENEMIES = {}

function Enemy:new()
	local t = {}
	setmetatable(t,Enemy)
	t:pre_init()
	return t
end
function Enemy:pre_init()
	self.isAlive = true
	-- self.position = Vector(0,0)
	self.rotation = 0
	self.level = 0
	self.speed = 0
	
	self.time_factor = 1
	self.time_change_duration = 0
	self.isTimeChanged = false
	self.stencil_func = nil
	
	self.stand = nil
	
	self.maxHealth = 20
	self.health = self.maxHealth
end
function Enemy:SetTime(timefactor, duration)
	self.time_factor = timefactor
	self.isTimeChanged = true
	self.time_change_duration = duration
end
function Enemy:UltimateAttack()
	if self.stand then
		self.stand:UltimateAttack(self.position.x,self.position.y,self.rotation)
	end
end
function Enemy:SpecialAttack()
	if self.stand then
		self.stand:SpecialAttack(self.position.x,self.position.y,self.rotation)
	end
end
function Enemy:Attack()
	if self.stand then
		self.stand:Attack(self.position.x,self.position.y,self.rotation)
	end
end
function Enemy:setStand(s)
	self.stand = s
end
function Enemy:setStencilFunction(func)
	self.stencil_func = func
end
function Enemy:getHit(dmg)
	if self.isAlive then
		self.health = self.health - dmg
		if self.health <= 0 then
			Level_Handler:onEnemyDeath()
			self.isAlive = false
			ENEMIES[self.index] = nil
		end
	end
end

function Enemy:isOutOfBounds()
	return not pointInPolygon( {{x=0,y=0},{x=WIDTH,y=0},{x=WIDTH,y=HEIGHT},{x=0,y=HEIGHT},{x=0,y=0}}, {x=self.position.x,y=self.position.y} )
end
function Enemy:updateHitbox()
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
function Enemy:init()
end
function Enemy:update(dt)
end
function Enemy:draw()
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
function Enemy:draw_()
end
function Enemy:Chase(x,y,dt)
	if self.time_factor ~= 0 then
		self.rotation = Angle(x,y,self.position.x,self.position.y) - math.pi/2
	end

	self.position.x = self.position.x + math.cos(self.rotation-math.pi/2) * self.speed * dt * self.time_factor
	self.position.y = self.position.y + math.sin(self.rotation-math.pi/2) * self.speed * dt * self.time_factor
end

function CreateEnemy()
	local obj = Enemy:new()
	obj:init()
	return obj
end