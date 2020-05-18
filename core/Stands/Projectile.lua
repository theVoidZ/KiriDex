--------------------- Projectile --------------------
Projectile = {}
Projectile.__index = Projectile

PROJECTILES = {}

function Projectile:new()
	local t = {}
	setmetatable(t,Projectile)
	t:pre_init()
	return t
end
function Projectile:pre_init()
	self.time_factor = 1
	self.time_change_duration = 0
	self.isTimeChanged = false
	self.stencil_func = nil
end
function Projectile:SetTime(timefactor, duration)
	self.time_factor = timefactor
	self.isTimeChanged = true
	self.time_change_duration = duration
end
function Projectile:init()
	
end
function Projectile:update_(dt)
end
function Projectile:update(dt)
	self:update_(dt)
end
function Projectile:draw_()
end
function Projectile:draw()
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

function Projectile:setStencilFunction(func)
	self.stencil_func = func
end

function Projectile:updateHitbox()
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
function Projectile:updateCollision()
	for k,v in pairs(PROJECTILES) do
		if v then
			if v.isAlive and k ~= self.index then
				local dist = Distance2(self.position.x,self.position.y,v.position.x,v.position.y)
				if dist <= 10000 and self.isAI ~= v.isAI then
					-- if pointInPolygon( v.hitbox, {x=self.x + math.cos(self.rotation) * self.size/2,y=self.y + math.sin(self.rotation) * self.size/2} ) then
					if ArePolygonsOverlapped(v.hitbox, self.hitbox,true) then
						Animation_Handler:play(self.position.x,self.position.y)
						if not PROJECTILES[v.index].will_pierce and PROJECTILES[v.index].last_hit ~= self.index then
							PROJECTILES[v.index].isActive = false
							PROJECTILES[v.index] = nil
						else
							PROJECTILES[v.index].last_hit = self.index
							PROJECTILES[v.index].will_pierce = false
						end
						if not self.will_pierce and self.last_hit ~= v.index then
							self.isActive = false
							PROJECTILES[self.index] = nil
						else
							self.last_hit = v.index
							self.will_pierce = false
						end
						return true
					end
				end
			end
		end
	end
	if not self.isAI then -- the shooter is the player
		for k,v in pairs(ENEMIES) do
			if v then
				local dist = Distance2(self.position.x,self.position.y,v.position.x,v.position.y)
				if dist <= 10000 then
					-- if pointInPolygon( v.hitbox, {x=self.x + math.cos(self.rotation) * self.size/2,y=self.y + math.sin(self.rotation) * self.size/2} ) then
					if ArePolygonsOverlapped(v.hitbox, self.hitbox,true) then
						Animation_Handler:play(self.position.x,self.position.y)
						if not self.will_pierce and self.last_hit ~= v.index then
							Level_Handler:Enemy_hit(v.index,self.damage)
							self.isActive = false
							PROJECTILES[self.index] = nil
						else
							if self.last_hit ~= v.index then
								Level_Handler:Enemy_hit(v.index,self.damage)
							end
							self.last_hit = v.index
							self.will_pierce = false
						end
						return true
					end
				end
			end
		end
	else
		for k,v in pairs(PLAYERS) do
			if v then
				local dist = Distance2(self.position.x,self.position.y,v.position.x,v.position.y)
				if dist <= 10000 then
					-- if pointInPolygon( v.hitbox, {x=self.x + math.cos(self.rotation) * self.size/2,y=self.y + math.sin(self.rotation) * self.size/2} ) then
					if ArePolygonsOverlapped(v.hitbox, self.hitbox,true) then
						Level_Handler:Player_hit(v.index,self.damage)
						Animation_Handler:play(self.position.x,self.position.y)
						if not self.will_pierce and self.last_hit ~= v.index then
							self.isActive = false
							PROJECTILES[self.index] = nil
						else
							self.last_hit = v.index
							self.will_pierce = false
						end
						return true
					end
				end
			end
		end
	end
end

function Projectile:isOutOfBounds()
	return not pointInPolygon( {{x=0,y=0},{x=WIDTH,y=0},{x=WIDTH,y=HEIGHT},{x=0,y=HEIGHT},{x=0,y=0}}, {x=self.position.x,y=self.position.y} )
end

function CreateProjectile()
	local obj = Projectile:new()
	obj:init()
	return obj
end