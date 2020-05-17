local class = require 'libs.middleclass'

Map = class('Map')

function Map:initialize()
	self.levels = {}
	self.current_level = -1
	
	self.hasWon = false
	
	self.isChangingLevel = false
	self.transition_time = 1
	self.transition_radius = 0
	self.hideLevel = false
	
	self.assets = {}
	self:initAssets()
	
	self.tile = Vector(64,64)
	
	self.tileset_data = require "maps.Walls baba is you"
	
	self.autotile_func = function(id)
							if id == 2 then
								return 1
							else
								return 0
							end
	end
	self.autoobject_func = function(id)
		for k,v in pairs(self.tileset_data.tiles) do
			if id == v.id then
				return v.type
			end
		end				
	end
	
	
	self.volume = 0.5
end

function Map:initAssets()
	--[[ Map:addAsset(type,path,name)
	arguments :
		- type : "image", "sound"
		- path : "path/to/asset.ext"
		- name : "reference name"
	
	]]
	
	--- Images
	self:addAsset("image","gfx/Tile1.png","Floor")
	self:addAsset("image","gfx/Tile2.png","Wall")
	self:addAsset("image","gfx/Tile3.png","Door")
	
	self:addAsset("image","gfx/player1.png","Player")
	self:addAsset("image","gfx/enemy1.png","Enemy")
	self:addAsset("image","gfx/enemy2.png","Charger")
	
	self:addAsset("image","gfx/Cake.png","Cake")
	self:addAsset("image","gfx/Key.png","Key")
	self:addAsset("image","gfx/Box.png","Box")
	
	self:addAsset("image","gfx/PortalBlue.png","PortalBlue")
	self:addAsset("image","gfx/PortalOrange.png","PortalOrange")
	
	--- Sounds
	
	self:addAsset("sound","sfx/player_move.wav","PlayerMove")
	self:addAsset("sound","sfx/player_pickup1.wav","PlayerPickup")
	self:addAsset("sound","sfx/player_death.wav","PlayerDeath")
	self:addAsset("sound","sfx/door_open.wav","DoorOpen")
	self:addAsset("sound","sfx/spike_open.wav","SpikeOpen")
	self:addAsset("sound","sfx/cakewin.wav","CakeEat")
	self:addAsset("sound","sfx/portal1.wav","PortalUse")
end

function Map:getVolume()
	return self.volume
end
function Map:getAsset(name)
	return self.assets[name]
end

function Map:addAsset(type,path,name)
	if type == "image" then
		-- table.insert(self.assets,love.graphics.newImage(path))
		self.assets[name] = love.graphics.newImage(path)
	elseif type == "sound" then
		self.assets[name] = love.audio.newSource(path,"stream")
	end
end

function Map:addLevelFromLevel(path)
	local file = require(path)
	local grid_map = {}
	local ents = {}
	local create_object_func = function(type,x,y)
		if type == "player" then
			table.insert(ents,Player:new(x,y))
		elseif type == "wall" then
			table.insert(ents,Wall:new(x,y))
		elseif type == "enemy1u" then
			table.insert(ents,Enemy:new(x,y))
			ents[#ents]:setMoveDirection(1)
		elseif type == "enemy1r" then
			table.insert(ents,Enemy:new(x,y))
			ents[#ents]:setMoveDirection(2)
		elseif type == "enemy1d" then
			table.insert(ents,Enemy:new(x,y))
			ents[#ents]:setMoveDirection(3)
		elseif type == "enemy1l" then
			table.insert(ents,Enemy:new(x,y))
			ents[#ents]:setMoveDirection(4)
		elseif type == "spike" then
			table.insert(ents,Spike:new(x,y))
		elseif type == "cake" then
			table.insert(ents,Cake:new(x,y))
		elseif type == "key" then
			table.insert(ents,Key:new(x,y))
		elseif type == "door" then
			table.insert(ents,Door:new(x,y))
		elseif type == "box" then
			table.insert(ents,Box:new(x,y))
		elseif type == "enemy2u" then
			table.insert(ents,Charger:new(x,y))
			ents[#ents]:setMoveDirection(1)
		elseif type == "enemy2r" then
			table.insert(ents,Charger:new(x,y))
			ents[#ents]:setMoveDirection(2)
		elseif type == "enemy2d" then
			table.insert(ents,Charger:new(x,y))
			ents[#ents]:setMoveDirection(3)
		elseif type == "enemy2l" then
			table.insert(ents,Charger:new(x,y))
			ents[#ents]:setMoveDirection(4)
		elseif type == "portalorange" then
			table.insert(ents,Portal:new(x,y,"Orange"))
		elseif type == "portalblue" then
			table.insert(ents,Portal:new(x,y,"Blue"))
		end
	end
	local wd = 0
	local ht = 0
	if file then
		for k,v in pairs(file.layers) do
			if v.type == "tilelayer" then
				local w = v.width
				local h = v.height
				wd = w
				ht = h
				local x = 1
				local y = 1
				for a,b in pairs(v.data) do
					if not grid_map[y] then grid_map[y] = {} end
					grid_map[y][x] = self.autotile_func(b)
					create_object_func(self.autoobject_func(b-1),x,y)
					x = x + 1
					if x > w then
						x = 1
						y = y + 1
					end
				end				
			end
		end
	end
	local sort_func = function(a,b)
		return a.order < b.order
	end
	table.sort(ents,sort_func)
	
	
	for k,v in pairs(ents) do
		ents[k].id = k
	end
	self:addLevel(grid_map,ents,{w = wd,h = ht},file.properties.description)
end

function Map:addLevel(level,ents,size,desc) -- grid.txt and entities
	local lvl = {}
	lvl.grid = {}
	lvl.size = Vector(size.w or 0, size.h or 0)
	lvl.history_count = 0
	lvl.desc = desc or ""

	for x = 1,#level[1] do
		lvl.grid[x] = {}
		for y = 1,#level do
			lvl.grid[x][y] = Tile:new(x,y,level[y][x])
		end
	end
	lvl.data = {}
	lvl.entities = ents or {}
	
	table.insert(self.levels,lvl)
end

function Map:DisableObjects(id)
	if self.levels[id] then
		for k,v in pairs(self.levels[id].entities) do
			if v then
				v.isActive = false
			end
		end
		for i,v in pairs(self.levels[id].grid) do
			for l,k in pairs(v) do
				if k then
					k.isActive = false
				end
			end
		end
	end
end

function Map:EnableObjects(id)
	if self.levels[id] then
		for k,v in pairs(self.levels[id].entities) do
			if v then
				v.isActive = true
			end
		end
		for i,v in pairs(self.levels[id].grid) do
			for l,k in pairs(v) do
				if k then
					k.isActive = true
				end
			end
		end
	end
end

function Map:NextLevelEffect()
	if not self.levels[self.current_level] then
		self.hasWon = true
	else
		self:Restart()
	end
end
function Map:NextLevel(id)
	self:SelectLevel(self.current_level+1)
end
function Map:Restart()
	if self.levels[self.current_level] then
		for k,v in pairs(self.levels[self.current_level].entities) do
			if v then
				v:Restart()
			end
		end
	end
end
function Map:RequestUndo(trigger)
	if self.levels[self.current_level] then
		for k,v in pairs(self.levels[self.current_level].entities) do
			if v then
				v:Undo(self.levels[self.current_level].history_count)
				self.levels[self.current_level].history_count = self.levels[self.current_level].history_count - 1
			end
		end
	end
end
function Map:getKeys(id)
	if self.levels[self.current_level] then
		return self.levels[self.current_level].entities[id]:getKeys()
	end
end
function Map:ChangeKey(id,amount)
	if self.levels[self.current_level] then
		self.levels[self.current_level].entities[id]:ChangeKey(amount)
	end
end
function Map:Damage(id)
	if self.levels[self.current_level] then
		self.levels[self.current_level].entities[id]:getDamaged()
	end
end
function Map:onReach(id,trigger)
	-- do the Checking for player
	if self.levels[self.current_level] then
		local x = self.levels[self.current_level].entities[id].pos_tile.x or -1
		local y = self.levels[self.current_level].entities[id].pos_tile.y or -1
		local ents = self:getEntitiesAtPos(x,y,id)
		if trigger then
			self.levels[self.current_level].history_count = self.levels[self.current_level].history_count + 1
		end
		for k,vid in pairs(ents) do
			local v = self.levels[self.current_level].entities[vid]
			if v then
				-- self.levels[self.current_level].entities[id]:onCollision(v.id,v.class.name)
				v:onCollision(id,self.levels[self.current_level].entities[id].class.name)
			end
		end
	end
end

function Map:ChangePosition(id,x,y,type)
	if self.levels[self.current_level] then
		for k,v in pairs(self.levels[self.current_level].entities) do
			if v then
				if v.isActive then
					if v.id == id then
						v:ChangePosition(x,y)
					end
				end
			end
		end
	end
end

function Map:getPortalPos(color)
	if self.levels[self.current_level] then
		for k,v in pairs(self.levels[self.current_level].entities) do
			if v then
				if v.isActive then
					if v.class.name == "Portal" then
						if v.color == color then
							return v.pos_tile.x,v.pos_tile.y
						end
					end
				end
			end
		end
	end
end

function Map:getEntitiesAtPos(x,y,exc)
	local tab = {}
	if self.levels[self.current_level] then
		for k,v in pairs(self.levels[self.current_level].entities) do
			if v then
				if v.pos_tile.x == x and v.pos_tile.y == y and exc ~= v.id then
					table.insert(tab,k)
				end
			end
		end
	end
	return tab
end

function Map:onAction(id)
	if self.levels[self.current_level] then
		for k = 1, #self.levels[self.current_level].entities do
			if self.levels[self.current_level].entities[k].id ~= id then
				self.levels[self.current_level].entities[k]:onAction()
			end
		end
	end
end

function Map:getTileType(x,y)
	if self.levels[self.current_level] then
		if self.levels[self.current_level].grid[x] then
			if self.levels[self.current_level].grid[x][y] then
				return self.levels[self.current_level].grid[x][y]:getType()
			end
		end
	end
	return nil
end

function Map:getTile(x,y)
	if self.levels[self.current_level] then
		if self.levels[self.current_level].grid[x] then
			if self.levels[self.current_level].grid[x][y] then
				return self.levels[self.current_level].grid[x][y]
			end
		end
	end
	return nil
end
function Map:getTileX()
	return self.tile.x
end
function Map:getTileY()
	return self.tile.y
end

function Map:SelectLevel(id)
	self.isChangingLevel = true	
	self.hideLevel = false
	Flux.to(self,self.transition_time*0.5,{transition_radius = math.max(WIDTH,HEIGHT)}):oncomplete(function() self.hideLevel = true end)
			:after(self.transition_time*0.5,{transition_radius = 0}):oncomplete(function() self.hideLevel = false end)
			
	Timer.after(self.transition_time,function(timer,dt)
									self.isChangingLevel = false
									self.transition_radius = 0
									
									self:DisableObjects(id)
									self.current_level = id
									self:EnableObjects(id)
									
									self:AdjustCamera()
									
									self:NextLevelEffect()
	end
	)
end

function Map:AdjustCamera()
	if self.levels[self.current_level] then
		local w = self.levels[self.current_level].size.x * self.tile.x
		local h = self.levels[self.current_level].size.y * self.tile.y
		
		local goal_scale = math.min(math.min(HEIGHT/h,WIDTH/w),1)
		
		-- camera:setWorld(-goal_scale*self.tile.x,-goal_scale*self.tile.y,w+goal_scale*self.tile.x*2,h+goal_scale*self.tile.y*2)
		camera:setWorld(0,0,w,h)
		
		camera:setPosition(w/2,h/2)
		camera:setScale(goal_scale)
	else
		camera:setWorld(0,0,WIDTH,HEIGHT)
		camera:setPosition(WIDTH/2,HEIGHT/2)
		camera:setScale(1)
	end
end

function Map:GenerateRandom(w,h)
	local g = {}
	for x = 1, w do
		g[x] = {}
		for y = 1, h do
			g[x][y] = math.random(0,1)
		end
	end
	return g
end

function Map:keypressed(key)
	if self.isChangingLevel then return false end
	if self.levels[self.current_level] then
		for k = 1,#self.levels[self.current_level].entities do
			self.levels[self.current_level].entities[k]:keypressed(key)
		end
	end
end
function Map:update(dt)
	if self.levels[self.current_level] then
		for k = 1,#self.levels[self.current_level].entities do
			self.levels[self.current_level].entities[k]:update(dt)
		end
	end
end

function Map:draw()
	if self.isChangingLevel then
		local func = function()
			local cx,cy = camera:toWorld(WIDTH/2,HEIGHT/2)
			love.graphics.circle("fill",cx,cy,self.transition_radius)
		end
		love.graphics.stencil(func,"replace",1)
		love.graphics.setStencilTest("equal",0)
		
	end
	if not self.hideLevel then
		if self.levels[self.current_level] then
			for i,v in pairs(self.levels[self.current_level].grid) do
				for l,k in pairs(v) do
					if k then
						k:draw()
					end
				end
			end
			for k = 1,#self.levels[self.current_level].entities do
				self.levels[self.current_level].entities[k]:draw()
			end
		end
	end
	love.graphics.setStencilTest()
	local s = camera:getScale()
	if self.hasWon then
		love.graphics.setColor(1,1,1,1)
		love.graphics.print("YOU WON!",WIDTH/2-100,HEIGHT/2-115,0,1/s)
		love.graphics.print("THANKS FOR PLAYING!",WIDTH/2-100,HEIGHT/2-100,0,1/s)
	else
		love.graphics.setColor(1,1,1,1)
		local desc = ""
		if self.levels[self.current_level] then
			desc = self.levels[self.current_level].desc
		end
		love.graphics.print("Level : "..self.current_level.." | "..desc,0,0,0,1/s)
	end
	if self.isChangingLevel then
		love.graphics.setColor(0,0,0,1)
		local cx,cy = camera:toWorld(WIDTH/2,HEIGHT/2)
		love.graphics.circle("fill",cx,cy,self.transition_radius)
	end
end