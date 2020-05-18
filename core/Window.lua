--------------------- Window --------------------
Window = {}
Window.__index = Window

function Window:new()
	local t = {}
	setmetatable(t,Window)
	return t
end
function Window:init(name,path,type)
	self.isOpen = false
	self.size = Vector(WIDTH/1.25, HEIGHT/1.25)
	-- self.size = Vector(WIDTH, HEIGHT-80)
	self.position = Vector(WIDTH/2 - self.size.x/2,HEIGHT/2 - self.size.y/2)
	self.taskbar_height = 30
	self.isFocused = false
	
	self.type = type
	self.content = nil
	self.name = name
	self.icon = path
	if self.type then
		if APPs[self.type] then
			self.content = APPs[self.type](self.position.x,self.position.y,self.size.x,self.size.y)	
			self:update_icon()
		end
	end
	
	self.isGrabbed = false
	self.offset = Vector(0,0)
	
end
function Window:wheelmoved(x,y)
	if self.content then
		self.content:wheelmoved(x,y)
	end
end
function Window:onClick(x,y)
	if 	x > self.position.x + self.size.x - self.taskbar_height - 5 and x < self.position.x + self.size.x - self.taskbar_height - 5 + self.taskbar_height and
		y > self.position.y - self.taskbar_height and y < self.position.y then
		Main_Desktop:CloseCurrent()
	elseif 	x > self.position.x + self.size.x - self.taskbar_height*2 - 5*2 and x < self.position.x + self.size.x - self.taskbar_height*2 - 5*2 + self.taskbar_height and
		y > self.position.y - self.taskbar_height and y < self.position.y then
		print("WILL MAXIMIZE")
	elseif 	x > self.position.x + self.size.x - self.taskbar_height*3 - 5*3 and x < self.position.x + self.size.x - self.taskbar_height*3 - 5*3 + self.taskbar_height and
		y > self.position.y - self.taskbar_height and y < self.position.y then
		print("WILL MINIMIZE")
	elseif x > self.position.x and x < self.position.x + self.size.x and y > self.position.y - self.taskbar_height and y < self.position.y then
		-- self.isGrabbed = true
		self.offset.x = self.position.x - x - 6
		self.offset.y = self.position.y - y - 10
	else
		if self.content then
			self.content:mousepressed(x,y)
		end
	end
end
function Window:onRelease(x,y,b)
	self.isGrabbed = false
end
function Window:setFocus(focus)
	self.isFocused = focus
end
function Window:keypressed(k)
	if self.isFocused then
		if self.content then
			self.content:keypressed(k)
		end
	end
end
function Window:setGravity(x,y)
	if self.content then
		self.content:setGravity(x,y)
	end
end
function Window:setGravityScale(g)
	if self.content then
		self.content:setGravityScale(g)
	end
end
function Window:update_icon()
	if self.content then
		self.content:update_icon(self.name,self.icon)
	end
end
function Window:textinput(t)
	if self.isFocused then
		if self.content then
			self.content:textinput(t)
		end
	end
end
function Window:isGrabbed()
	return self.isGrabbed
end
function Window:isOpen()
	return self.isOpen
end
function Window:Close()
	self.isOpen = false
	self.isFocused = false
end
function Window:Open()
	self.isOpen = true
	if self.content then
		self.content:onOpen()
	end
end
function Window:update(dt)
	if self.isGrabbed then
		local mx, my = love.mouse.getPosition()
		self.position.x = mx + self.offset.x
		self.position.y = my + self.offset.y
	end
	if self.content then
		self.content:setStats(self.position,self.size,self.isOpen)
		self.content:update(dt)
	end
end
function Window:draw_taskbar()
	love.graphics.setColor(0,98/255,243/255,1)
	love.graphics.rectangle("fill",self.position.x,self.position.y - self.taskbar_height,self.size.x,self.taskbar_height)
	
	love.graphics.setColor(224/255,67/255,67/255,1)
	love.graphics.rectangle("fill",self.position.x + self.size.x - self.taskbar_height - 5,self.position.y - self.taskbar_height,self.taskbar_height,self.taskbar_height) -- X
	love.graphics.setColor(1,1,1,1)
	love.graphics.line(self.position.x + self.size.x - self.taskbar_height,self.position.y - self.taskbar_height + 5, self.position.x + self.size.x - self.taskbar_height + 20,self.position.y - self.taskbar_height + 25) -- x
	love.graphics.line(self.position.x + self.size.x - self.taskbar_height + 20,self.position.y - self.taskbar_height + 5, self.position.x + self.size.x - self.taskbar_height,self.position.y - self.taskbar_height + 25) -- x
	love.graphics.setColor(0,64/255,192/255,1)
	love.graphics.rectangle("fill",self.position.x + self.size.x - self.taskbar_height*2 - 5*2,self.position.y - self.taskbar_height,self.taskbar_height,self.taskbar_height) -- Maximize
	love.graphics.setColor(1,1,1,1)
	love.graphics.rectangle("line",self.position.x + self.size.x + 5 - self.taskbar_height*2 - 5*2,self.position.y - self.taskbar_height + 5,self.taskbar_height - 10,self.taskbar_height - 10) -- Maximize
	love.graphics.setColor(0,64/255,192/255,1)
	love.graphics.rectangle("fill",self.position.x + self.size.x - self.taskbar_height*3 - 5*3,self.position.y - self.taskbar_height,self.taskbar_height,self.taskbar_height) -- Minimize
	love.graphics.setColor(1,1,1,1)
	love.graphics.line(self.position.x + self.size.x - self.taskbar_height*3 + 5 - 5*3,self.position.y - self.taskbar_height + 15,self.position.x + self.size.x - self.taskbar_height*3 + 25 - 5*3,self.position.y - self.taskbar_height + 15) -- Minimize
	
	love.graphics.setColor(89/255,155/255,1)
	love.graphics.setLineWidth(2)
	love.graphics.rectangle("line",self.position.x,self.position.y - self.taskbar_height,self.size.x,self.taskbar_height)
	love.graphics.setLineWidth(1)
	
	love.graphics.setColor(1,1,1,1)
	local fh = love.graphics.getFont():getHeight()
	love.graphics.print(self.name,self.position.x + self.taskbar_height + 10,self.position.y - self.taskbar_height + self.taskbar_height/2 - fh/2) -- Name
	
	love.graphics.setColor(1,1,1,1)
	local sx = (self.taskbar_height - 10) / self.icon:getWidth()
	local sy = (self.taskbar_height - 10) / self.icon:getHeight()
	love.graphics.draw(self.icon,self.position.x + 5,self.position.y - self.taskbar_height + 5,0,math.min(sx,sy),math.min(sx,sy)) -- Icon
end

function Window:draw()
	if self.isOpen then
		love.graphics.setColor(0.7,0.7,0.7,1)
		love.graphics.rectangle("fill",self.position.x,self.position.y,self.size.x,self.size.y)
		love.graphics.setColor(0.85,0.85,0.85,1)
		love.graphics.rectangle("line",self.position.x,self.position.y,self.size.x,self.size.y)
		self:draw_taskbar()
		if self.content then
			self.content:draw()
		end
	end
end
function Window:draw_notifications()
	if self.content then
		if self.content.notifier then
			self.content.notifier:draw()
		end
	end
end

function CreateWindow(name,path,type)
	local obj = Window:new()
	obj:init(name,path,type)
	return obj
end