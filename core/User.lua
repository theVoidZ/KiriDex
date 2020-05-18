--------------------- User --------------------
User = {}
User.__index = User

function User:new()
	local t = {}
	setmetatable(t,User)
	return t
end
function User:init()
	self.name = ""
	
	self.cursor_image = love.graphics.newImage("gfx/cursor.png")
	
	local sx = 20/self.cursor_image:getWidth()
	local sy = 20/self.cursor_image:getHeight()
	self.scale = math.min(sx,sy)
	local mx,my = love.mouse.getPosition()
	self.position = Vector(mx,my)
	self.rotation = 0
	
	-------------------------
	self.physics = {}
	self.physics.body = love.physics.newBody(Main_Desktop.physics.world,mx,my,"dynamic")
	self.physics.shape = love.physics.newRectangleShape(self.scale * self.cursor_image:getWidth(),self.scale * self.cursor_image:getHeight())
	self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
	self.physics.fixture:setUserData("user cursor")
	self.physics.body:setGravityScale(0)
	self.physics.body:setFixedRotation(true)
	self.physics.fixture:setCategory(2)
	self.physics.fixture:setMask(3)
	
	self.controllable_cursor = true
	
	self.physics.joint = love.physics.newMouseJoint(self.physics.body, mx, my)
	
	self.master_volume = 0.6
end
function User:getMouseBody()
	return self.physics.body
end
function User:wheelmoved(x,y)
	Main_Desktop:wheelmoved(x,y)
end
function User:textinput(t)
	Main_Desktop:textinput(t)
end
function User:keypressed(k)
	Main_Desktop:keypressed(k)
end
function User:mousereleased(b)
	local x,y = self.position.x, self.position.y
	if b == 1 then
		Main_Desktop:mousereleased(x,y,b)
	end
end
function User:getMousePos()
	return self.position.x, self.position.y
end
function User:mousepressed(b)
	local x,y = self.position.x, self.position.y
	if b == 1 then
		Main_Desktop:mousepressed(x,y,b)
	end
end
function User:update(dt)
	if self.controllable_cursor then
		local mx,my = love.mouse.getPosition()
		local target_x = mx + self.scale * self.cursor_image:getWidth()/2
		local target_y = my + self.scale * self.cursor_image:getHeight()/2
		self.physics.body:setPosition(target_x,target_y)
	else
		-- self.physics.joint:setTarget(love.mouse.getPosition())
	end
	local x,y = self.physics.body:getWorldPoints(self.physics.shape:getPoints())
	self.position.x = x
	self.position.y = y
	self.rotation = self.physics.body:getAngle()
end
function User:draw_physics()
	love.graphics.setColor(1,0,0,1)
	love.graphics.polygon("line", self.physics.body:getWorldPoints(self.physics.shape:getPoints()))
end
function User:draw()
	love.graphics.setColor(1,1,1,1)
	local x,y = self.physics.body:getWorldPoints(self.physics.shape:getPoints())
	love.graphics.draw(self.cursor_image,x,y,self.rotation,self.scale,self.scale)
	if DRAW_PHYSICS then
		self:draw_physics()
	end
end

function CreateUser()
	local obj = User:new()
	obj:init()
	GameLoop:addObject(obj)
	Renderer:addToLayer("USER",obj)
	return obj
end