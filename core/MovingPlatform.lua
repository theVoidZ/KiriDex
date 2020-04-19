--------------------- MovingPlatform --------------------
MovingPlatform = Obstacle:new()
MovingPlatform.__index = MovingPlatform

function MovingPlatform:new()
	local t = {}
	setmetatable(t,MovingPlatform)
	return t
end

function MovingPlatform:init(x,y,w,h,deadly,rangeX,rangeY) -- range = {min,max}
	self.isActive = true
	self.Collidable = true
	self.position = Vector(x,y)
	self.size = Vector(w,h)
	
	self.posX = {minX=rangeX[1], maxX = rangeX[2]}
	self.posY = {minY=rangeY[1], maxY = rangeY[2]}
	self.direction = Vector(math.random(0,1)*2-1,math.random(0,1)*2-1)
	
	if rangeY[1] == rangeY[2] then
		self.direction.y = 0
	end
	if rangeX[1] == rangeX[2] then
		self.direction.x = 0
	end
	
	self.speed = 200
	
	self.isDeadly = deadly
	
	-- self.light_body = LightWorld:newPolygon(unpack(RectToPoly(self.position.x, self.position.y, self.size.x, self.size.y)))
end
function MovingPlatform:update(dt)
	if self.direction.x == 1 then
		if self.position.x >= self.posX.maxX then
			self.direction.x = -self.direction.x
		end
	elseif self.direction.x == -1 then
		if self.position.x <= self.posX.minX then
			self.direction.x = -self.direction.x
		end
	end
	if self.direction.y == 1 then
		if self.position.y >= self.posY.maxY then
			self.direction.y = -self.direction.y
		end
	elseif self.direction.y == -1 then
		if self.position.y <= self.posY.minY then
			self.direction.y = -self.direction.y
		end
	end
	self:Move(self.direction.x * self.speed*dt, self.direction.y * self.speed*dt)
	
end
function MovingPlatform:draw()
	if self.isActive then
		if self.isDeadly then
			love.graphics.setColor(189/255,20/255,7/255,1)
		else
			love.graphics.setColor(6/255,109/255,152/255,1)
		end
		love.graphics.rectangle("fill",self.position.x,self.position.y,self.size.x,self.size.y)
		love.graphics.setColor(0.85,0.85,0.9,1)
		love.graphics.rectangle("line",self.position.x,self.position.y,self.size.x,self.size.y)
		-- love.graphics.setColor(1,1,1,1)
		-- love.graphics.print("ACTVE",self.position.x+self.size.x/2,self.position.y+self.size.y/2-8)
	end
end
function CreateMovingPlatform(x,y,w,h,deadly,rangeX,rangeY)
	local obj = MovingPlatform:new()
	obj:init(x,y,w,h,deadly,rangeX,rangeY)
	obj.index = #SOLIDS+1
	SOLIDS[#SOLIDS+1] = obj
	return obj
end