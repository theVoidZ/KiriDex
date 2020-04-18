--------------------- Level --------------------
Level = {}
Level.__index = Level

function Level:new()
	local t = {}
	setmetatable(t,Level)
	return t
end

function Level:init()
	self.levels = {}
	self.current_level = 0
	self.isLoaded = false
	
	---------------------------------
	self.IMAGES = {}
	self.IMAGES.Companions = {}
	self.IMAGES.Collectables = {}
	table.insert(self.IMAGES.Companions,love.graphics.newImage("gfx/strawberry2.png"))
	table.insert(self.IMAGES.Collectables,love.graphics.newImage("gfx/Crystal1.png"))
end
function Level:getCurrentLevel()
	if self.current_level ~= 0 then
		return self.levels[self.current_level]
	end
end
function Level:getSpawnPoints()
	if self.current_level ~= 0 then
		if self.levels[self.current_level] then
			return self.levels[self.current_level].spawn_points[math.random(1,#self.levels[self.current_level].spawn_points)] -- Vector position
			-- return self.levels[self.current_level].spawn_points[1] -- Vector position
		end
	end
end
function Level:SelectLevelByName(name)
	for k,v in pairs(self.levels) do
		if v then
			if v.name == name then
				self:DisableCollisions(self.current_level)
				self.current_level = k
				self:EnableCollisions(k)
				break
			end
		end
	end
end
function Level:SelectLevel(id)
	self:DisableCollisions(self.current_level)
	self.current_level = id
	self:EnableCollisions(id)
end

function Level:DisableCollisions(id)
	if self.levels[id] then
		for k,v in pairs(self.levels[id].objects) do
			if v then
				v.isActive = false
			end
		end
		for k,v in pairs(self.levels[id].hazards) do
			if v then
				v.isActive = false
			end
		end
	end
end

function Level:EnableCollisions(id)
	if self.levels[id] then
		for k,v in pairs(self.levels[id].objects) do
			if v then
				v.isActive = true
			end
		end
		for k,v in pairs(self.levels[id].hazards) do
			if v then
				v.isActive = true
			end
		end
	end
end

function Level:addLevel(path,name)
	local info = love.filesystem.getInfo(path, "file")
	local level_info = {}
	level_info.darkness = 1
	level_info.objects = {}
	level_info.spawn_points = {}
	level_info.collectables = {}
	level_info.triggers = {}
	level_info.hazards = {}
	level_info.trampolines = {}
	-- level_info.fragileWalls = {}
	level_info.movingPlatforms = {}
	if info then
		local data = require((string.gsub(path,".lua","")))
		if data then
			level_info.image = love.graphics.newImage((string.gsub(path,".lua",".png")))
			level_info.name = name or "Level "..#self.level_info+1
			level_info.width = data.width * data.tilewidth-18
			level_info.height = data.height * data.tileheight-9
			level_info.darkness = data.properties["darkness"]
			for k,v in pairs(data.layers) do
				if v.type == "objectgroup" then
					if v.name == "Walls" then
						for a,b in pairs(v.objects) do
							table.insert(level_info.objects,CreateObstacle(b.x, b.y, b.width, b.height))
							level_info.objects[#level_info.objects].isActive = false
						end
					elseif v.name == "FragilePlatforms" then
						for a,b in pairs(v.objects) do
							table.insert(level_info.objects,CreateObstacle(b.x, b.y, b.width, b.height, false, true))
							level_info.objects[#level_info.objects].isActive = false
						end
					elseif v.name == "Hazards" then
						for a,b in pairs(v.objects) do
							table.insert(level_info.hazards,CreateObstacle(b.x, b.y, b.width, b.height,true))
							level_info.hazards[#level_info.hazards].isActive = false
						end
					elseif v.name == "PlayerObjects" then
						for a,b in pairs(v.objects) do
							if b.name == "player_spawn" then
								table.insert(level_info.spawn_points,Vector(b.x,b.y))
							elseif b.name == "player_checkpoint" then
								table.insert(level_info.collectables,CreateCollectable(self.IMAGES.Collectables[1]))
								
								level_info.collectables[#level_info.collectables].position.x = b.x
								level_info.collectables[#level_info.collectables].position.y = b.y
								local func = function(id)
									if ACTORS[id] then
										if not ACTORS[id].isDead then
											ACTORS[id].respawn_point.x = b.x
											ACTORS[id].respawn_point.y = b.y
										end
									end
								end
								level_info.collectables[#level_info.collectables]:setPickFunction(func)
								level_info.collectables[#level_info.collectables].isRespawnable = true
							end
						end
					elseif v.name == "AutoMovingPlatforms" then
						for a,b in pairs(v.objects) do
							table.insert(level_info.movingPlatforms,CreateMovingPlatform(b.x, b.y, b.width, b.height,b.properties.isDeadly,{b.properties.sx,b.properties.ex},{b.properties.sy,b.properties.ey}))
							level_info.movingPlatforms[#level_info.movingPlatforms].speed = b.properties.speed or 200
						end
					elseif v.name == "MovingPlatform" then
						for a,b in pairs(v.objects) do
							table.insert(level_info.movingPlatforms,CreateMovingPlatform(b.x, b.y, b.width, b.height,b.properties.isDeadly,{b.properties.sx,b.properties.ex},{b.properties.sy,b.properties.ey}))
							level_info.movingPlatforms[#level_info.movingPlatforms].speed = b.properties.speed or 200
						end
					elseif v.name == "EventTriggers" then
						for a,b in pairs(v.objects) do
							table.insert(level_info.triggers,{name=b.name,x=b.x,y=b.y,width=b.width,height=b.height,isTriggered=false})
						end
					elseif v.name == "Trampolines" then
						for a,b in pairs(v.objects) do
							table.insert(level_info.trampolines,CreateTrampoline(b.properties.directionX, b.properties.directionY))
							level_info.trampolines[#level_info.trampolines].position.x = b.x + b.width/2
							level_info.trampolines[#level_info.trampolines].position.y = b.y + b.height/2
						end
					elseif v.name == "Collectables" then
						for a,b in pairs(v.objects) do
							if b.name == "dash" then
								table.insert(level_info.collectables,CreateCollectable(self.IMAGES.Collectables[1]))
								level_info.collectables[#level_info.collectables].position.x = b.x
								level_info.collectables[#level_info.collectables].position.y = b.y
								local func = function(id)
									if ACTORS[id] then
										if not ACTORS[id].isDead then
											if ACTORS[id].companions[#ACTORS[id].companions] then
												Event.game_event = Event.game_event_list.Tutorial_Dash
												ACTORS[id].companions[#ACTORS[id].companions]:Say("Nicee you got a Dash",2500,20)
												ACTORS[id].companions[#ACTORS[id].companions]:Say("Just Press U to Dash!",2500,20)
												ACTORS[id]:ChangeAbility("Dash",true)
											end
										end
									end
								end
								level_info.collectables[#level_info.collectables]:setPickFunction(func)
							elseif b.name == "strawberry" then
								-- table.insert(level_info.collectables,CreateCollectable(self.IMAGES.Companions[1]))
								table.insert(level_info.collectables,CreateCollectable(self.IMAGES.Companions[1]))
								level_info.collectables[#level_info.collectables].position.x = b.x
								level_info.collectables[#level_info.collectables].position.y = b.y
								local func = function(id)
									if ACTORS[id] then
										if not ACTORS[id].isDead then
											Event.game_event = Event.game_event_list.Tutorial_Companion
											ACTORS[id]:addCompanion()
											ACTORS[id].companions[#ACTORS[id].companions].position.x = b.x
											ACTORS[id].companions[#ACTORS[id].companions].position.y = b.y
											ACTORS[id].companions[#ACTORS[id].companions]:Say("Oh",1000,10)
											ACTORS[id].companions[#ACTORS[id].companions]:Say("Hello there.",2000,15)
											ACTORS[id].companions[#ACTORS[id].companions]:Say("What brings you here?",2000,20)
											ACTORS[id].companions[#ACTORS[id].companions]:Say("You look Lost... and Confused",2000,40)
											ACTORS[id].companions[#ACTORS[id].companions]:Say("Okay, I'll Guide you through this",2000,40)
											ACTORS[id].companions[#ACTORS[id].companions]:Say("So. Let us get going",2000,20)
											ACTORS[id].companions[#ACTORS[id].companions]:Say("Go?",2500,20)
											ACTORS[id].companions[#ACTORS[id].companions]:Say("Hmm, Looks like you're having trouble jumping",2500,20,function() ACTORS[id]:ChangeAbility("Jump",true) end)
											ACTORS[id].companions[#ACTORS[id].companions]:Say("Let me help you, Try it!",2000,20)
											ACTORS[id].companions[#ACTORS[id].companions]:Say("Press Y to Jump",2000,20)
											-- 
										end
									end
								end
								level_info.collectables[#level_info.collectables]:setPickFunction(func)
							end
						end
					end
				end
			end
		end
	end
	table.insert(self.levels,level_info)
end

function Level:update(dt)
	for k,v in pairs(self.levels[self.current_level].collectables) do
		if v then
			v:update(dt)
		end
	end
	for k,v in pairs(self.levels[self.current_level].trampolines) do
		if v then
			v:update(dt)
		end
	end
end

function Level:draw()
	if self.current_level ~= 0 then
		if self.levels[self.current_level] then
			-- love.graphics.setColor(0.5, 0.5, 0.5)
			-- love.graphics.rectangle("fill",0,0,self.levels[self.current_level].width,self.levels[self.current_level].height)
			love.graphics.setColor(1,1,1,1)
			love.graphics.draw(self.levels[self.current_level].image,0,0)
			for k,v in pairs(self.levels[self.current_level].collectables) do
				if v then
					v:draw()
				end
			end
			for k,v in pairs(self.levels[self.current_level].trampolines) do
				if v then
					v:draw()
				end
			end
			if DEBUG then
				for k,v in pairs(self.levels[self.current_level].triggers) do
					if v then
						if v.isTriggered then
							love.graphics.setColor(1,0,0,0.5)
						else
							love.graphics.setColor(0,1,0,0.5)
						end
						love.graphics.rectangle("fill",v.x,v.y,v.width,v.height)
						love.graphics.setColor(1,1,1,1)
						love.graphics.print(v.name,v.x,v.y)
					end
				end
				for k,v in pairs(self.levels[self.current_level].collectables) do
					if v then
						love.graphics.setColor(1,1,0,0.5)
						love.graphics.rectangle("fill",v.position.x,v.position.y,32,32)
						love.graphics.setColor(1,1,1,1)
						love.graphics.print("Collectable #"..k,v.position.x,v.position.y)
					end
				end
			end
		end
	end
end

function CreateLevel()
	local obj = Level:new()
	obj:init()
	return obj
end