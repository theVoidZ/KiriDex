--------------------- Desktop --------------------
Desktop = {}
Desktop.__index = Desktop

--[[
	1: Darkhole sucked in
	2: User Cursor
	3: Desktop Edges
	6: Notification Box
]]


function Desktop:new()
	local t = {}
	setmetatable(t,Desktop)
	return t
end
function Desktop:init()
	local w, h = 10, 6
	self.taskbar_height = 40
	self.size = Vector(WIDTH, HEIGHT-self.taskbar_height)
	self.grid_size = Vector(w, h)
	self.cell_size = Vector(WIDTH/w, (HEIGHT-self.taskbar_height)/h)
	self.applications_grid = {} -- the APPs inside the desktop
	self.application_order = {} -- array of x,y pos
	self.current_app = nil
	self.gravity = 9.81*100
	
	self.back_img = love.graphics.newImage("gfx/Background.png")
	
	for x = 1,self.grid_size.x do
		if not self.applications_grid[x] then self.applications_grid[x] = {} end
		for y = 1,self.grid_size.y do
			if not self.applications_grid[x][y] then self.applications_grid[x][y] = nil end
		end
	end
	
	self.apps_list = {} -- Dictionnary
	--------------------------------------------------------------------
	
	love.physics.setMeter(100)
	self.physics = {}
	self.physics.world = love.physics.newWorld(0,9.81*100,true)
	----
	self.physics.beginContact =  function(a, b, coll)
	end
	self.physics.endContact = function(a, b, coll)
	end
	self.physics.preSolve = function (a, b, coll)
	end
	self.physics.postSolve = function(a, b, coll, normalimpulse, tangentimpulse)
	end
	self.physics.world:setCallbacks(self.physics.beginContact, self.physics.endContact, self.physics.preSolve, self.physics.postSolve)
	----
	self.physics.edges = {}
	self.physics.edges[1] = {}
	self.physics.edges[1].body = love.physics.newBody( self.physics.world, 0,0 ,"static")
	self.physics.edges[1].shape = love.physics.newEdgeShape(0, 0, self.size.x, 0)
	self.physics.edges[1].fixture = love.physics.newFixture(self.physics.edges[1].body, self.physics.edges[1].shape)
	self.physics.edges[1].fixture:setUserData("Top")
	
	self.physics.edges[2] = {}
	self.physics.edges[2].body = love.physics.newBody( self.physics.world, 0,0 ,"static")
	self.physics.edges[2].shape = love.physics.newEdgeShape(0, 0, 0, self.size.y + self.taskbar_height)
	self.physics.edges[2].fixture = love.physics.newFixture(self.physics.edges[2].body, self.physics.edges[2].shape)
	self.physics.edges[2].fixture:setUserData("Left")
	
	self.physics.edges[3] = {}
	self.physics.edges[3].body = love.physics.newBody( self.physics.world, 0,0 ,"static")
	self.physics.edges[3].shape = love.physics.newEdgeShape(self.size.x, 0, self.size.x, self.size.y + self.taskbar_height)
	self.physics.edges[3].fixture = love.physics.newFixture(self.physics.edges[3].body, self.physics.edges[3].shape)
	self.physics.edges[3].fixture:setUserData("Right")
	
	self.physics.edges[4] = {}
	self.physics.edges[4].body = love.physics.newBody( self.physics.world, 0,0 ,"static")
	self.physics.edges[4].shape = love.physics.newEdgeShape(0, self.size.y, self.size.x, self.size.y)
	self.physics.edges[4].fixture = love.physics.newFixture(self.physics.edges[4].body, self.physics.edges[4].shape)
	self.physics.edges[4].fixture:setUserData("Bottom")
	
	self.physics.edges[1].fixture:setCategory(3)
	self.physics.edges[2].fixture:setCategory(3)
	self.physics.edges[3].fixture:setCategory(3)
	self.physics.edges[4].fixture:setCategory(3)
	
	self.physics.darkhole = {}
	self.physics.darkhole.active = false
	self.physics.darkhole.x = WIDTH/2
	self.physics.darkhole.y = HEIGHT/2
	self.physics.darkhole.speed = 30
	self.physics.darkhole.radius = 2
	self.physics.darkhole.reached_max = false
	
	self.gravity_bool = false
end
function Desktop:setDarkhole(active)
	self.physics.darkhole.active = active
	if active then
		self:ShakeThings()
		user.controllable_cursor = false
	end
end
function Desktop:getAppAt(x,y)
	return self.applications_grid[x][y]
end
function Desktop:getWorld()
	return self.physics.world
end
function Desktop:CloseCurrent()
	self.current_app:Close()
	self.current_app = nil
end
function Desktop:MutateName(name)
	local result = name
	for i = 1, self.grid_size.x do
		for j = 1, self.grid_size.y do
			if self.applications_grid[i][j] then
				if self.applications_grid[i][j].name == name then
					if name:match("%(%d%)") then -- if there is "(number)"
						local number = tonumber(result:sub(#result-1,#result-1))
						result = self:MutateName(result:sub(1,#result-2)..number+1 ..")")
					else
						result = self:MutateName(result.." (1)")
					end
				end
			end
		end
	end
	return result
end
function Desktop:getAppFromName(name)
	return self.apps_list[name].x, self.apps_list[name].y
end
function Desktop:addApp(name,ext,path,x,y,type)
	if not x or not y then
		local found = false
		for j = 1, self.grid_size.y do
			for i = 1, self.grid_size.x do
				if not found then
					if not self.applications_grid[i][j] then
						local name_m = self:MutateName(name)
						self.applications_grid[i][j] = CreateApplication(name_m,ext,path,i,j,self:getWorld(),type)
						found = true
						self.apps_list[name_m] = {x=x,y=y}
					end
				end
			end
		end
	else
		self.applications_grid[x][y] = CreateApplication(name,ext,path,x,y,self:getWorld(),type)
		self.apps_list[name] = {x=x,y=y}
	end
end
function Desktop:ShakeThings()
	self.gravity_bool = true
	local r = {-1,1}
	self:setIconsGravityScale(1)
	-- user:getMouseBody():setActive(true)
	user:getMouseBody():setFixedRotation(false)
	user:getMouseBody():setGravityScale(1)
	-- user:getMouseBody():applyAngularImpulse(r[math.random(1,2)] * math.random(500,1000))
	-- user.controllable_cursor = false
end
function Desktop:keypressed(k)
	if k == "space" then
		-- self:ShakeThings()
	-- elseif k == "up" then
		-- self.physics.world:setGravity(0,-self.gravity)
		-- if self.current_app then
			-- if self.current_app:isOpen() then
				-- self.current_app:setGravity(0,-self.gravity)
			-- end
		-- end
		-- self:ShakeThings()
	-- elseif k == "down" then
		-- self.physics.world:setGravity(0,self.gravity)
		-- if self.current_app then
			-- if self.current_app:isOpen() then
				-- self.current_app:setGravity(0,self.gravity)
			-- end
		-- end
		-- self:ShakeThings()
	-- elseif k == "left" then
		-- self.physics.world:setGravity(-self.gravity,0)
		-- if self.current_app then
			-- if self.current_app:isOpen() then
				-- self.current_app:setGravity(-self.gravity,0)
			-- end
		-- end
		-- self:ShakeThings()
	-- elseif k == "right" then
		-- self.physics.world:setGravity(self.gravity,0)
		-- if self.current_app then
			-- if self.current_app:isOpen() then
				-- self.current_app:setGravity(self.gravity,0)
			-- end
		-- end
		-- self:ShakeThings()
	else
		if self.current_app then
			if self.current_app:isOpen() then
				self.current_app:keypressed(k)
			end
		end
	end
end
function Desktop:textinput(t)
	if self.current_app then
		if self.current_app:isOpen() then
			self.current_app:textinput(t)
		end
	end
end
function Desktop:wheelmoved(x,y)
	if self.current_app then
		if self.current_app:isOpen() then
			self.current_app:wheelmoved(x,y)
		end
	end
end
function Desktop:mousereleased(x,y,b)
	if self.current_app then
		if self.current_app:isOpen() then
			self.current_app:onRelease(x,y,b)
		end
	end
end
function Desktop:mousepressed(x,y,b)
	if b == 1 then
		local found = false
		if self.current_app then
			if self.current_app:isOpen() then
				if x > self.current_app.window.position.x and x < self.current_app.window.position.x + self.current_app.window.size.x and y > self.current_app.window.position.y - self.current_app.window.taskbar_height and y < self.current_app.window.position.y + self.current_app.window.size.y then -- inside Window
					self.current_app.window:onClick(x,y)
					found = true
				end
			end
		end
		--------------------------------------------
		if not found then
			for i = 1, self.grid_size.x do
				for j = 1, self.grid_size.y do
					local v = self.applications_grid[i][j]
					if v then
						if v:isOpen() then
							local name = ""
							if self.current_app then
								name = self.current_app.name
							end
							if name ~= v.name then
								if x > v.window.position.x and x < v.window.position.x + v.window.size.x and y > v.window.position.y - v.window.taskbar_height and y < v.window.position.y + v.window.size.y then -- inside Window
									self.current_app = self.applications_grid[i][j]
									self.current_app.window:onClick(x,y)
									found = true
									print("PRESS ON NOT CURRENT ",v.name)
								end
							end
						end
					end
				end
			end
		end
		--------------------------------------------
		if not found then
			for i = 1, self.grid_size.x do
				for j = 1, self.grid_size.y do
					if self.applications_grid[i][j] then
						if self.applications_grid[i][j]:isCursorInside(x,y) then
							self.applications_grid[i][j]:onClick()
							self.current_app = self.applications_grid[i][j]
							self.current_app:setFocus(true)
						end
					end
				end
			end
			-- if x > 0 and x < self.size.x and y > 0 and y < self.size.y then -- inside Desktop
				-- local gx, gy = math.ceil(x/self.cell_size.x), math.ceil(y/self.cell_size.y)
				-- if self.applications_grid[gx][gy] then
					-- self.applications_grid[gx][gy]:onClick()
					-- self.current_app = self.applications_grid[gx][gy]
				-- end
			-- end
		end
	end
end
function Desktop:update(dt)
	self:getWorld():update(dt)
	for i = 1, self.grid_size.x do
		for j = 1, self.grid_size.y do
			if self.applications_grid[i][j] then
				self.applications_grid[i][j]:update(dt)
			end
		end
	end
	if self.physics.darkhole.active then
		self.physics.darkhole.radius = math.min(self.physics.darkhole.radius + self.physics.darkhole.speed*dt,HEIGHT)
		self.physics.darkhole.speed = self.physics.darkhole.speed + 0.05*dt
		if self.physics.darkhole.radius == HEIGHT then
			GAMESTATE = "END"
		else
			local bodies = self.physics.world:getBodies()
			for k,v in pairs(bodies) do
				if v then
					if v:getType() == "dynamic" then
						local dx,dy = self.physics.darkhole.x, self.physics.darkhole.y
						local bx, by = v:getPosition()
						local dist = Distance(dx,dy,bx,by)
						local ang = Angle(bx,by,dx,dy)
						local force = 0
						if dist - 20 <= self.physics.darkhole.radius then
							force = 300
							v:setLinearVelocity(math.cos(ang)*force, math.sin(ang)*force)
							v:getFixtures()[1]:setCategory(1)
							v:getFixtures()[1]:setMask(1)
						elseif dist / 2 <= self.physics.darkhole.radius then
							force = 50
						end
						v:applyForce(math.cos(ang)*force, math.sin(ang)*force)
					end
				end
			end
		end
	end
end
function Desktop:setIconsGravityScale(g)
	for i = 1, self.grid_size.x do
		for j = 1, self.grid_size.y do
			if self.applications_grid[i][j] then
				self.applications_grid[i][j]:setGravityScale(g or 1)
				self.applications_grid[i][j]:setGravityScale(g or 1)
				
				local r = {-1,1}
				self.applications_grid[i][j].physics.body:applyAngularImpulse(r[math.random(1,2)] * math.random(500,1000))
				self.applications_grid[i][j].physics.text_body:applyAngularImpulse(r[math.random(1,2)] * math.random(500,1000))
			end
		end	
	end	
end
function Desktop:draw_taskbar()
	love.graphics.setColor(0,98/255,243/255,1)
	love.graphics.rectangle("fill",0,self.size.y,self.size.x,self.taskbar_height)
	love.graphics.setColor(89/255,155/255,1,1)
	love.graphics.setLineWidth(2)
	love.graphics.rectangle("line",0,self.size.y,self.size.x,self.taskbar_height)
	love.graphics.setLineWidth(1)
end

function Desktop:draw_physics()
	love.graphics.setColor(1,0,0,1)
	for i = 1 , #self.physics.edges do
		love.graphics.line(self.physics.edges[i].body:getWorldPoints(self.physics.edges[i].shape:getPoints()))
	end
end
function Desktop:draw_notifications()
	for i = 1, self.grid_size.x do
		for j = 1, self.grid_size.y do
			if self.applications_grid[i][j] then
				self.applications_grid[i][j]:draw_notifications()
			end
		end
	end
end
function Desktop:draw()
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(self.back_img,0,0)
	for i = 1, self.grid_size.x do
		for j = 1, self.grid_size.y do
			love.graphics.setColor(1,1,1,1)
			local x = (i-1) * self.cell_size.x
			local y = (j-1) * self.cell_size.y
			-- love.graphics.rectangle("line",x,y,self.cell_size.x,self.cell_size.y)
			if self.applications_grid[i][j] then
				self.applications_grid[i][j]:draw()
			end
		end
	end
	for i = 1, self.grid_size.x do
		for j = 1, self.grid_size.y do
			if self.applications_grid[i][j] then
				local name = ""
				if self.current_app then
					name = self.current_app.name
				end
				if self.applications_grid[i][j].name ~= name then
					self.applications_grid[i][j]:draw_window()
				end
			end
		end
	end
	if self.current_app then
		self.current_app:draw_window()
	end
	self:draw_notifications()
	if self.physics.darkhole.active then
		local cx, cy = self.physics.darkhole.x, self.physics.darkhole.y
		love.graphics.setColor(0,0,0,1)
		love.graphics.circle("fill",cx,cy,self.physics.darkhole.radius)
	end
	self:draw_taskbar()
	if DRAW_PHYSICS then
		self:draw_physics()
	end
end

function CreateDesktop()
	local obj = Desktop:new()
	obj:init()
	GameLoop:addObject(obj)
	Renderer:addToLayer("BACKGROUND",obj)
	return obj
end