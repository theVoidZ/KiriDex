--------------------- Bullet --------------------
Bullet = {}
Bullet.__index = Bullet

BULLETS = {}

function Bullet:new()
	local t = {}
	setmetatable(t,Bullet)
	return t
end
function Bullet:init(x,y,ang,player)
	self.exists = true
	self.x = x
	self.y = y
	self.rotation = ang
	self.time_factor = 1
	self.speed = 1000
	self.player = player -- boolean
	
	self.time_stop_long = 0
	self.time_stopped = false
end
function Bullet:draw()
	if self.exists then
		if self.stencil_func then
			love.graphics.stencil(self.stencil_func,"replace",1)
			love.graphics.setStencilTest("greater", 0)
		end
		love.graphics.setColor(1,1,0,1)
		local x = self.x + math.cos(self.rotation) * 40
		local y = self.y + math.sin(self.rotation) * 40
		love.graphics.line(self.x,self.y,x,y)
		love.graphics.setStencilTest()
	end
end
function Bullet:update_timezone()
	local x = math.floor(self.x/Level_Handler.cell_size.x) + 1
	local y = math.floor(self.y/Level_Handler.cell_size.y) + 1
	local time_factor = Level_Handler:getTimeFactorAt(x,y)
	self.time_factor = time_factor
end
function Bullet:updateCollision()
	for k,v in pairs(ENEMIES) do
		if v then
			if v.exists then
				if pointInPolygon( v.hitbox, {x=self.x,y=self.y} ) or pointInPolygon( v.hitbox, {x=self.x + math.cos(self.rotation) * 40,y=self.y + math.sin(self.rotation) * 40} ) then
					v:getHit()
					player:onKill()
				end
			end
		end
	end
end

function Bullet:StopTime(long)
	self.time_stopped = true
	self.time_stop_long = long
end
function Bullet:setStencilFunction(func)
	self.stencil_func = func
end
function Bullet:update(dt)
	if self.exists then
		if self.time_stopped then
			if self.time_stop_long > 0 then
				self.time_stop_long = self.time_stop_long - 1000*dt
				self.time_factor = 0
			else
				self.time_stop_long = 0
				self.time_stopped = false
			end
		else
			local x = self.x + math.cos(self.rotation) * self.speed*dt * self.time_factor
			local y = self.y + math.sin(self.rotation) * self.speed*dt * self.time_factor
			self:updateCollision()
			self.x = x
			self.y = y
			self:update_timezone()
			self:updateCollision()
			if self:isOutOfBounds() then
				self.exists = false
				BULLETS[self.index] = nil
			end
		end
	end
end
function Bullet:isOutOfBounds()
	return not pointInPolygon( {{x=0,y=0},{x=WIDTH,y=0},{x=WIDTH,y=HEIGHT},{x=0,y=HEIGHT},{x=0,y=0}}, {x=self.x,y=self.y} )
end
function CreateABullet(x,y,ang,player)
	local obj = Bullet:new()
	obj:init(x,y,ang,player)
	obj.index = #BULLETS+1
	BULLETS[#BULLETS+1] = obj
	return obj
end