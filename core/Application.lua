--------------------- Application --------------------
Application = {}
Application.__index = Application

function Application:new()
	local t = {}
	setmetatable(t,Application)
	return t
end
function Application:init(name,ext,path,x,y,world,type)
	self.name = name
	self.extension = ext
	self.icon = love.graphics.newImage(path)
	
	self.position = Vector(x,y) -- Position on Desktop grid size
	self.text_position = Vector(x,y)
	self.rotation = 0
	self.type = type
	
	self.window = CreateWindow(self.name,self.icon,self.type)
	
	-----------------------------------------------
	local sx, sy = Main_Desktop.cell_size.x, Main_Desktop.cell_size.y
	local scalex = (sx*0.5) / self.icon:getWidth()
	local scaley = (sy*0.5) / self.icon:getHeight()
	scalex = math.min(scalex,scaley)
	scaley = math.min(scalex,scaley)
	
	---- Physics
	self.physics = {}
	local xpos = self.position.x * sx - sx/2 - self.icon:getWidth()/2*scalex + scalex * self.icon:getWidth()/2
	local ypos = self.position.y * sy - sy/1.5 - self.icon:getHeight()/2*scaley + scaley * self.icon:getHeight()/2
	
	self.physics.body = love.physics.newBody(Main_Desktop.physics.world,xpos ,ypos,"dynamic")
	self.physics.shape = love.physics.newRectangleShape(scalex * self.icon:getWidth(),scaley * self.icon:getHeight())
	self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
	self.physics.fixture:setUserData(self.name..self.extension)
	self.physics.fixture:setMask(2,6)
	-- self.physics.body:applyAngularImpulse(math.random(500,1000))
	
	--------------
	local fh =  love.graphics.getFont():getHeight()
	local text = ""
	local s,w = love.graphics.getFont():getWrap(self.name..self.extension,sx-15)
	if #w > 2 then
		text = w[1]..string.sub(w[2],#w[2]-5,#w[2]).." ..."
	else
		text = table.concat(w)
	end
	
	local tx = math.floor(self.position.x*sx - sx/2)
	local ty = math.floor((self.position.y)*sy - fh*math.min(#w,2) + 12)
	self.physics.text_body = love.physics.newBody(Main_Desktop.physics.world,tx ,ty - (fh-2)*(math.min(#w,2)%2+1),"dynamic")
	self.physics.text_shape = love.physics.newRectangleShape(s,fh*math.min(#w,2))
	self.physics.text_fixture = love.physics.newFixture(self.physics.text_body, self.physics.text_shape)
	self.physics.text_fixture:setUserData(self.name.." text")
	self.physics.text_fixture:setMask(2,6) ---- ,6 Notif
	
	self.physics.text_body:setGravityScale(0)
	self.physics.body:setGravityScale(0)
	self.physics.body:setActive(false)
	self.physics.text_body:setActive(false)
	----
	self:post_init()
end
function Application:post_init()
end
function Application:wheelmoved(x,y)
	self.window:wheelmoved(x,y)
end
function Application:setGravity(x,y)
	self.window:setGravity(x,y)
end
function Application:keypressed(k)
	self.window:keypressed(k)
end
function Application:textinput(t)
	self.window:textinput(t)
end
function Application:setGravityScale(g)
	self.physics.body:setGravityScale(g or 1)
	self.physics.text_body:setGravityScale(g or 1)
	self.window:setGravityScale(g or 1)
	self.physics.body:setActive(true)
	self.physics.text_body:setActive(true)
end
function Application:setFocus(focus)
	self.window:setFocus(focus)
end
function Application:Close()
	self.window:Close()
end
function Application:isOpen()
	return self.window.isOpen
end
function Application:update(dt)
	local x,y = self.physics.body:getWorldPoints(self.physics.shape:getPoints())
	local xt,yt = self.physics.text_body:getWorldPoints(self.physics.text_shape:getPoints())
	self.position.x = x
	self.position.y = y
	self.text_position.x = xt
	self.text_position.y = yt
	self.rotation = self.physics.body:getAngle()
	self.text_rotation = self.physics.text_body:getAngle()
	
	self.window:update(dt)
end

function Application:onRelease(x,y,b)
	self.window:onRelease(x,y,b)
end
function Application:isCursorInside(x,y)
	local a,b,c,d,e,f,g,h = self.physics.body:getWorldPoints(self.physics.shape:getPoints())
	local poly = {{x=a,y=b},{x=c,y=d},{x=e,y=f},{x=g,y=h}}
	return pointInPolygon(poly,{x=x,y=y})
end
function Application:onClick()
	self.window:Open()
end
function Application:draw_notifications()
	self.window:draw_notifications()
end
function Application:draw_physics()
	love.graphics.setColor(1,0,0,1)
	love.graphics.polygon("line", self.physics.body:getWorldPoints(self.physics.shape:getPoints()))
	love.graphics.polygon("line", self.physics.text_body:getWorldPoints(self.physics.text_shape:getPoints()))
end

function Application:draw()
	local sx, sy = Main_Desktop.cell_size.x, Main_Desktop.cell_size.y
	local scalex = (sx*0.5) / self.icon:getWidth()
	local scaley = (sy*0.5) / self.icon:getHeight()
	scalex = math.min(scalex,scaley)
	scaley = math.min(scalex,scaley)
	
	
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(self.icon,self.position.x, self.position.y,self.rotation,scalex,scaley)
	
	local fh =  love.graphics.getFont():getHeight()
	local text = ""
	local s,w = love.graphics.getFont():getWrap(self.name..self.extension,sx-15)
	if #w > 2 then
		text = w[1]..string.sub(w[2],1,#w[2]).." ..."
	else
		text = table.concat(w)
	end
	
	-- local TX = math.floor((self.position.x - 1)*sx + 5)
	-- local TY = math.floor((self.position.y)*sy - fh*math.min(#w,2))
	 -- - (sx - scalex*self.icon:getWidth())/2
	-- local TX = self.text_position.x + math.cos(-math.pi) * ((sx - scalex*self.icon:getWidth())/2 - 10)
	-- local TY = self.text_position.y + math.sin(math.pi/2) * (scaley*self.icon:getWidth())
	
	local TX = self.text_position.x
	local TY = self.text_position.y
	
	love.graphics.printf(text,math.floor(TX),math.floor(TY),sx-15,"left",self.text_rotation)
	if DRAW_PHYSICS then
		self:draw_physics()
	end
end

APPs = {
		Notepad = function(x,y,w,h) return CreateNotepad(x,y,w,h) end,
		Discord = function(x,y,w,h) return CreateDiscord(x,y,w,h) end,
		GameJam = function(x,y,w,h) return CreateGameJam(x,y,w,h) end,
		FallIt = function(x,y,w,h) return CreateFallIt(x,y,w,h) end
}

function Application:draw_window()
	self.window:draw()
end
function CreateApplication(name,ext,path,x,y,world,type)
	local obj = Application:new()
	obj:init(name,ext,path,x,y,world,type)
	return obj
end