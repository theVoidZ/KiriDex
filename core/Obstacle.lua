--------------------- Obstacle --------------------
Obstacle = Solid:new()
Obstacle.__index = Obstacle

function Obstacle:new()
	local t = {}
	setmetatable(t,Obstacle)
	return t
end
function Obstacle:init(x,y,w,h,deadly)
	self.isActive = true
	self.Collidable = true
	self.position = Vector(x,y)
	self.size = Vector(w,h)
	
	self.isDeadly = deadly
	
	-- self.light_body = LightWorld:newPolygon(unpack(RectToPoly(self.position.x, self.position.y, self.size.x, self.size.y)))
end
function Obstacle:update(dt)
	if self.index == 6 then
		if love.keyboard.isDown("up") then
			self:Move(0, -300*dt)
		elseif love.keyboard.isDown("down") then
			self:Move(0, 300*dt)
		end
		
		if love.keyboard.isDown("left") then
			self:Move(-300*dt, 0)
		elseif love.keyboard.isDown("right") then
			self:Move(300*dt, 0)
		end
	end
	-- self.light_body:setPoints(unpack(RectToPoly(self.position.x, self.position.y, self.size.x, self.size.y)))
end
function Obstacle:draw()
	-- if self.isActive then
		-- if self.Collidable then
			-- love.graphics.setColor(0,0,0,1)
		-- else
			-- love.graphics.setColor(1,0,0,1)
		-- end
		-- love.graphics.rectangle("fill",self.position.x,self.position.y,self.size.x,self.size.y)
		-- love.graphics.setColor(1,1,1,1)
		-- love.graphics.print(self.index,self.position.x+self.size.x/2,self.position.y+self.size.y/2-8)
	-- end
end

function CreateObstacle(x,y,w,h,deadly)
	local obj = Obstacle:new()
	obj:init(x,y,w,h,deadly)
	obj.index = #SOLIDS+1
	SOLIDS[#SOLIDS+1] = obj
	return obj
end