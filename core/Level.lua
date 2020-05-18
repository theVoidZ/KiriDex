--------------------- Level_Handler --------------------
Level = {}
Level.__index = Level

function Level:new()
	local t = {}
	setmetatable(t,Level)
	return t
end
function Level:init()
	self.grid_size = {x=35,y=25}
	self.cell_size = {x=WIDTH/self.grid_size.x,y=HEIGHT/self.grid_size.y}
	self.data = {}
	self.max_slow = -math.huge
	self.min_slow = math.huge
	self:Create()
	self.frequencies = {"slow","fast"}
	self.frequencies_color = {{0,0,1},{1,0,0}}
	self:Randomize()
	self.enemies_spawnrate_const = 5000
	self.enemes_max_spawnrate = 3000
	self.enemes_min_spawnrate = 1000
	self.enemies_spawnrate = 0
	self.reposition_time_const = 10000
	self.reposition_time = self.reposition_time_const
	self.stencil_func = nil
	
	self.time_stopped = false
	self.time_stop_long_const = 0
	self.time_stop_long = 0
end
function Level:Clear()
	for x = 1,self.grid_size.x do
		for y = 1,self.grid_size.y do
			self.data[x][y] = 1
		end
	end
	self.max_slow = -math.huge
	self.min_slow = math.huge
end
function Level:Create()
	for x = 1,self.grid_size.x do
		if not self.data[x] then self.data[x] = {} end
		for y = 1,self.grid_size.y do
			if not self.data[x][y] then self.data[x][y] = 1 end -- Time Factor
		end
	end
end
function Level:Randomize()
	local rooms_count = math.random(3,15)
	local rooms_info = {}
	for i = 1,rooms_count do
		rooms_info[i] = {range=math.random(1,5),max_power=math.random(10,250)/100,x=math.random(1,self.grid_size.x),y=math.random(1,self.grid_size.y)}
	end
	for i = 1,#rooms_info do
		local range = rooms_info[i].range
		local max_power = rooms_info[i].max_power
		local x = rooms_info[i].x
		local y = rooms_info[i].y
		self.data[x][y] = max_power
		self.max_slow = math.max(self.max_slow,self.data[x][y])
		self.min_slow = math.min(self.min_slow,self.data[x][y])
		local ratio = (math.abs(max_power-1)/(range+1))/2
		for ix = -range,range do
			for iy = -range,range do
				if ix+x > 0 and ix+x <= self.grid_size.x then
					if iy+y > 0 and iy+y <= self.grid_size.y then
						if ix ~= 0 or iy ~= 0 then
							local nx = math.abs(ix)
							local ny = math.abs(iy)
							if max_power > 1 then
								self.data[x+ix][y+iy] = math.max(math.abs(max_power-math.max(nx,ny)*ratio),0.01)
								self.max_slow = math.max(self.max_slow,self.data[x+ix][y+iy])
								self.min_slow = math.min(self.min_slow,self.data[x+ix][y+iy])
							else
								self.data[x+ix][y+iy] = math.max(math.abs(max_power+math.max(nx,ny)*ratio),0.01)
								self.max_slow = math.max(self.max_slow,self.data[x+ix][y+iy])
								self.min_slow = math.min(self.min_slow,self.data[x+ix][y+iy])
							end
						end
					end
				end
			end
		end
	end
end
function Level:getTimeFactorAt(x,y)
	if x > 0 and x <= self.grid_size.x and y > 0 and y <= self.grid_size.y then
		return self.data[x][y]
	end
	return 1
end
function Level:update(dt)
	if self.time_stopped then
		if self.time_stop_long > 0 then
			self.time_stop_long = self.time_stop_long - 1000*dt
			self.time_factor = 0
		else
			self.time_stop_long = 0
			self.time_stopped = false
			player.music:play()
		end
	else
		if self.reposition_time > 0 then
			self.reposition_time = self.reposition_time - 1000*dt
		else
			self.reposition_time = self.reposition_time_const
			self:Clear()
			self:Randomize()
			if math.random(1,2) == 1 and not player.isDead then
				CreateATime(math.random(self.cell_size.x/2,WIDTH-self.cell_size.x/2),math.random(self.cell_size.y/2,HEIGHT-self.cell_size.y/2))
			end
		end
		if not player.isDead then
			if self.enemies_spawnrate > 0 then
				self.enemies_spawnrate = self.enemies_spawnrate - 1000*dt
			else
				local count = #ENEMIES
				local modifier = (775*count - 550)/9
				self.enemies_spawnrate_const = math.max(math.random(self.enemes_min_spawnrate,self.enemes_max_spawnrate) - modifier,800)
				self.enemies_spawnrate = self.enemies_spawnrate_const
				local n = {-1,1}
				local x = math.random(0,WIDTH) + n[math.random(1,2)]*WIDTH
				local y = math.random(0,HEIGHT) + n[math.random(1,2)]*HEIGHT
				for i = 1,math.random(1,3) do
					CreateAEnemy(x,y)
				end
			end
		end
	end
end
function Level:StopTime(long)
	self.time_stopped = true
	self.time_stop_long_const = long
	self.time_stop_long = long
	player.music:pause()
	for k,v in pairs(ENEMIES) do
		if v then
			if v.exists then
				v:StopTime(long)
			end
		end
	end
	for k,v in pairs(BULLETS) do
		if v then
			if v.exists then
				v:StopTime(long)
			end
		end
	end
end
function Level:setStencilFunction(func)
	self.stencil_func = func
	for k,v in pairs(ENEMIES) do
		if v then
			if v.exists then
				v:setStencilFunction(func)
			end
		end
	end
	for k,v in pairs(BULLETS) do
		if v then
			if v.exists then
				v:setStencilFunction(func)
			end
		end
	end
end
function Level:draw()
	if self.stencil_func then
		love.graphics.stencil(self.stencil_func,"replace",1)
		love.graphics.setStencilTest("greater", 0)
	end
	for x = 1,self.grid_size.x do
		for y = 1,self.grid_size.y do
			if self.data[x][y] < 1 then
				local ratio = math.max(1-0.10/self.data[x][y],0.5)
				love.graphics.setColor(self.frequencies_color[1][1]*ratio,self.frequencies_color[1][2]*ratio,self.frequencies_color[1][3]*ratio,255)
			elseif self.data[x][y] > 1 then
				local ratio = math.max(self.data[x][y]/2.5,0.5)
				love.graphics.setColor(self.frequencies_color[2][1]*ratio,self.frequencies_color[2][2]*ratio,self.frequencies_color[2][3]*ratio,255)
			else
				love.graphics.setColor(0,0.5,0,1)
			end
			local X = (WIDTH - (self.grid_size.x*self.cell_size.x))/2 + (x-1)*self.cell_size.x -- 
			local Y = (HEIGHT - (self.grid_size.y*self.cell_size.y))/2 + (y-1)*self.cell_size.y
			love.graphics.rectangle("fill",X,Y,self.cell_size.x,self.cell_size.y)
			love.graphics.setColor(1,1,1,1)
			-- love.graphics.rectangle("line",X,Y,self.cell_size.x,self.cell_size.y)
			---- Debug
			-- love.graphics.print(self.data[x][y],X,Y+self.cell_size.y/2)
		end
	end
	love.graphics.setStencilTest()
	if self.time_stopped then
		love.graphics.setColor(0,0,0,0.25)
		local angle = self.time_stop_long/self.time_stop_long_const * math.pi * 2
		love.graphics.arc("fill",WIDTH/2,HEIGHT/2,math.min(WIDTH,HEIGHT)/2,0,angle)
	end
end

function CreateALevel()
	local obj = Level:new()
	obj:init()
	GameLoop:addObject(obj)
	Renderer:addToLayer("PLAYERS",obj)
	return obj
end