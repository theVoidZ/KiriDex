--------------------- FallIt --------------------
FallIt = Content:new()
FallIt.__index = FallIt

function FallIt:new()
	local t = {}
	setmetatable(t,FallIt)
	return t
end
function FallIt:init(x,y,w,h)
	self.position = Vector(x,y)
	self.size = Vector(w,h)
	
	---------------- Physics ---------------
	self.physics = {}
	self.physics.world = love.physics.newWorld(0,9.81*100,true)
	self.isFinished = false
	
	
	self.physics.beginContact =  function(a, b, coll)
		if a:getUserData() == "FallIt bottom edge" or b:getUserData() == "FallIt bottom edge" then
			if a:getUserData() == "FallIt player" or b:getUserData() == "FallIt player" then
				if not self.isFinished then
					self:initDemoEndScript()
					self.isFinished = true
				end
			end
		end
	end
	self.physics.endContact = function(a, b, coll)
	end
	self.physics.preSolve = function (a, b, coll)
	end
	self.physics.postSolve = function(a, b, coll, normalimpulse, tangentimpulse)
	end
	self.physics.world:setCallbacks(self.physics.beginContact, self.physics.endContact, self.physics.preSolve, self.physics.postSolve)
	
	
	self.physics.edges = {}
	self.physics.walls = {}
	self.physics.player = {}
	self.physics.player.body = love.physics.newBody(self.physics.world,self.position.x + self.size.x/2,self.position.y,"dynamic")
	self.physics.player.shape = love.physics.newCircleShape(4)
	self.physics.player.fixture = love.physics.newFixture(self.physics.player.body,self.physics.player.shape)
	self.physics.player.fixture:setUserData("FallIt player")
	
	self.physics.edges[1] = {}
	self.physics.edges[1].body = love.physics.newBody(self.physics.world,self.position.x,self.position.y+self.size.y/2,"static")
	self.physics.edges[1].shape = love.physics.newRectangleShape(20,self.size.y)
	self.physics.edges[1].fixture = love.physics.newFixture(self.physics.edges[1].body,self.physics.edges[1].shape)
	self.physics.edges[1].fixture:setUserData("FallIt left edge")
	
	self.physics.edges[2] = {}
	self.physics.edges[2].body = love.physics.newBody(self.physics.world,self.position.x+self.size.x,self.position.y+self.size.y/2,"static")
	self.physics.edges[2].shape = love.physics.newRectangleShape(20,self.size.y)
	self.physics.edges[2].fixture = love.physics.newFixture(self.physics.edges[2].body,self.physics.edges[2].shape)
	self.physics.edges[2].fixture:setUserData("FallIt left edge")
	
	self.physics.edges[3] = {}
	self.physics.edges[3].body = love.physics.newBody(self.physics.world,self.position.x+self.size.x/2,self.position.y+self.size.y,"static")
	self.physics.edges[3].shape = love.physics.newRectangleShape(self.size.x,20)
	self.physics.edges[3].fixture = love.physics.newFixture(self.physics.edges[3].body,self.physics.edges[3].shape)
	self.physics.edges[3].fixture:setUserData("FallIt bottom edge")
	
	local gap = 20
	local obs_cound = 46
	
	for i = 1,obs_cound do
		local id = #self.physics.walls+1
		local x1 = self.position.x
		local y1 = self.position.y + i*10
		local w1 = math.random(50,self.size.x-50)
		
		local x2 = x1 + w1 + gap
		local y2 = y1
		local w2 = self.size.x - w1 - gap
		
		self.physics.walls[id] = {}
		self.physics.walls[id].body = love.physics.newBody(self.physics.world,0,0,"static")
		self.physics.walls[id].shape = love.physics.newEdgeShape(x1,y1,x1+w1,y1)
		self.physics.walls[id].fixture = love.physics.newFixture(self.physics.walls[id].body,self.physics.walls[id].shape)
		self.physics.walls[id].fixture:setUserData("FallIt wall "..id)
		id = #self.physics.walls
		
		self.physics.walls[id+1] = {}
		self.physics.walls[id+1].body = love.physics.newBody(self.physics.world,0,0,"static")
		self.physics.walls[id+1].shape = love.physics.newEdgeShape(x2,y2,x2+w2,y2)
		self.physics.walls[id+1].fixture = love.physics.newFixture(self.physics.walls[id+1].body,self.physics.walls[id+1].shape)
		self.physics.walls[id+1].fixture:setUserData("FallIt wall "..id+1)
	end
end
function FallIt:setStats(pos,size,open)
	self:update_stats(pos,size,open)
	self:setGravityScale(1)
end
function FallIt:update(dt)
	self.physics.world:update(dt)
	if love.keyboard.isDown("left") then
		self.physics.player.body:applyForce(-200*dt,0)
	elseif love.keyboard.isDown("right") then
		self.physics.player.body:applyForce(200*dt,0)
	end
end
function FallIt:initDemoEndScript()
	local dx,dy = Main_Desktop:getAppFromName("Discord")
	local discord = Main_Desktop:getAppAt(dx,dy)
	if discord then
		if discord.window then
			if discord.window.content then
				discord.window.content:initDemoEndScript()
			end
		end
	end
end
function FallIt:draw_physics()
	love.graphics.setColor(0,1,0,1)
	for k,v in pairs(self.physics.edges) do
		if v then
			love.graphics.polygon("fill", v.body:getWorldPoints(v.shape:getPoints()))
		end
	end
	-- for k,v in pairs(self.physics.walls) do
		-- if v then
			-- love.graphics.line(v.body:getWorldPoints(v.shape:getPoints()))
		-- end
	-- end
	-- love.graphics.circle("fill", self.physics.player.body:getX(), self.physics.player.body:getY(), self.physics.player.shape:getRadius())
end
function FallIt:draw_()
	love.graphics.setColor(1,1,1,1)
	if DRAW_PHYSICS then
		self:draw_physics()
	end
	
	love.graphics.setColor(0,0,0,1)
	for k,v in pairs(self.physics.walls) do
		if v then
			love.graphics.line(v.body:getWorldPoints(v.shape:getPoints()))
		end
	end
	love.graphics.circle("fill", self.physics.player.body:getX(), self.physics.player.body:getY(), self.physics.player.shape:getRadius())
end
function CreateFallIt(x,y,w,h)
	local obj = FallIt:new()
	obj:init(x,y,w,h)
	return obj
end