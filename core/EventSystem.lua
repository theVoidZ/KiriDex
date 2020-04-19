--------------------- EventSystem --------------------
EventSystem = {}
EventSystem.__index = EventSystem

function EventSystem:new()
	local t = {}
	setmetatable(t,EventSystem)
	return t
end

function EventSystem:init()
	-- self.game_state_list = {"MAIN","PLAYING","MENU"}
	self.game_state_list = enum({"MAIN","PLAYING","MENU"})
	self.game_state = self.game_state_list.MAIN
	
	self.camera = gamera.new(0,0,1280,640)
	self.camera:setWindow(0,0,WIDTH,HEIGHT)
	
	self.game_event_list = enum({"Tutorial_Intro","Tutorial_Standby","Tutorial_onGoing","Tutorial_Companion","Tutorial_Dash","Level1_start","Level2_start"})
	self.game_event = self.game_event_list.Tutorial_Intro
	
	self.timer = 10
end

function EventSystem:FirstInits()
	self.Level_Handler = CreateLevel()
	self.Animator = CreateDeathAnimator()
	self:addLevel("Maps/tutorial.lua","Tutorial")
	self:addLevel("Maps/Level1.lua","Level1")
	self:addLevel("Maps/Level2.lua","Level2")
	self:SelectLevel("Tutorial")
	
	local p = CreatePlayer()
	local lx,ly = self.Level_Handler:getSpawnPoints().x, self.Level_Handler:getSpawnPoints().y
	p.position.x = lx
	p.position.y = ly
	p:Spawn(lx,ly,true)
	
	p.respawn_point.x = lx
	p.respawn_point.y = ly
	
	-- p:ChangeAbility("Super_Speed",true)
	-- p:ChangeAbility("Super_Jump",true)
	-- p:ChangeAbility("Super_Dash",true)
	-- p:ChangeAbility("Powered_Jump",true)
	-- p:ChangeAbility("Dash",true)
	-- p:ChangeAbility("Jump",true)
	-- p:ChangeAbility("Wall_Jump",true)
	
	-- print(p.position.x)
end

function EventSystem:TriggerUpdate(dt)
	local level = self.Level_Handler:getCurrentLevel()
	if level then
		for k,v in pairs(level.triggers) do
			if ACTORS[1] then
				if ACTORS[1].isHuman then
					if ACTORS[1].isActive then
						local ax = ACTORS[1].position.x
						local ay = ACTORS[1].position.y
						local aw = ACTORS[1].size.x
						local ah = ACTORS[1].size.y
						if not v.isTriggered then
							if doOverlap(ax,ay,ax+aw,ay+ah, v.x,v.y,v.x+v.width,v.y+v.height) then
								if v.name == "trigger_first_jump" then
									if self.game_event == self.game_event_list.Tutorial_Companion then
										level.triggers[k].isTriggered = true
										ACTORS[1].companions[1]:Say("Here's Another one, Press Y again",1500,10)
									end
								elseif v.name == "trigger_long_jump" then
									if self.game_event == self.game_event_list.Tutorial_Companion then
										level.triggers[k].isTriggered = true
										ACTORS[1].companions[1]:Say("You can hold Y to Jump Higher",1500,10)
									end
								elseif v.name == "trigger_long_jump_end" then
									if self.game_event == self.game_event_list.Tutorial_Companion then
										level.triggers[k].isTriggered = true
										ACTORS[1].companions[1]:Say("Niiiiiice :D",500,20)
									end
								elseif v.name == "trigger_first_trampoline" then
									if self.game_event == self.game_event_list.Tutorial_Companion then
										level.triggers[k].isTriggered = true
										ACTORS[1].companions[1]:Say("Would you look at that, Trampolines",1500,20)
									end
								elseif v.name == "trigger_first_hazard" then
									if self.game_event == self.game_event_list.Tutorial_Companion then
										level.triggers[k].isTriggered = true
										ACTORS[1].companions[1]:Say("These will probably kill you, be carefull",1500,20)
									end
								elseif v.name == "trigger_second_hazard" then
									if self.game_event == self.game_event_list.Tutorial_Companion then
										level.triggers[k].isTriggered = true
										ACTORS[1].companions[1]:Say("This one looks hard",1500,20)
									end
								elseif v.name == "trigger_first_platform" then
									if self.game_event == self.game_event_list.Tutorial_Companion then
										level.triggers[k].isTriggered = true
										ACTORS[1].companions[1]:Say("You got some platforming to do",1500,20)
									end
								elseif v.name == "trigger_first_checkpoint" then
									if self.game_event == self.game_event_list.Tutorial_Companion then
										level.triggers[k].isTriggered = true
										ACTORS[1].companions[1]:Say("Checkpoints Nice",1500,20)
									end
								elseif v.name == "trigger_jump_fail" then
									if self.game_event ~= self.game_event_list.Tutorial_Dash then
										level.triggers[k].isTriggered = true
										ACTORS[1].companions[1]:Say("Looks lke you cant reach it for now",2000,20)
									end
								elseif v.name == "trigger_dash_remind" then
									if self.game_event == self.game_event_list.Tutorial_Dash then
										level.triggers[k].isTriggered = true
										ACTORS[1].companions[1]:Say("Don't forget you Dash, Press U",1500,20)
									end
								elseif v.name == "trigger_dash_tip_diag" then
									if self.game_event == self.game_event_list.Tutorial_Dash then
										level.triggers[k].isTriggered = true
										ACTORS[1].companions[1]:Say("You can Dash Diagonally, even Mid-Air, Press Q+W then U",1500,20)
									end
								elseif v.name == "trigger_diff_up" then
									if self.game_event == self.game_event_list.Tutorial_Dash then
										level.triggers[k].isTriggered = true
										ACTORS[1].companions[1]:Say("It's kinda getting harder, dont you think?",1500,20)
									end
								elseif v.name == "trigger_first_fragile" then
									if self.game_event == self.game_event_list.Tutorial_Dash then
										level.triggers[k].isTriggered = true
										ACTORS[1].companions[1]:Say("These platforms will disappear when you stand on them",2500,20)
									end
								elseif v.name == "trigger_level_end_chat" then
									if self.game_event == self.game_event_list.Tutorial_Dash then
										level.triggers[k].isTriggered = true
										ACTORS[1].companions[1]:Say("oof, that was. close.",1500,80)
									end
								elseif v.name == "trigger_next_level" then
									level.triggers[k].isTriggered = true
									self.game_event = self.game_event_list.Level1_start
									self:SelectLevel("Level1")
								elseif v.name == "trigger_next_level2" then
									print("fqopefkqosefjeoqsj")
									level.triggers[k].isTriggered = true
									self.game_event = self.game_event_list.Level2_start
									self:SelectLevel("Level2")
								end
							end
						end
					end
				end
			end
		end
	end
end

function EventSystem:getAnimator()
	return self.Animator
end
function EventSystem:getCamera()
	return self.camera
end

function EventSystem:SelectLevel(id) -- id can be Number or Name
	if type(id) == "number" then
		self.Level_Handler:SelectLevel(id)
	elseif type(id) == "string" then
		self.Level_Handler:SelectLevelByName(id)
	end
	local lvl = self.Level_Handler:getCurrentLevel()
	self.camera:setWorld(0,0,math.max(lvl.width,WIDTH),math.max(lvl.height,HEIGHT))
	
	local p = ACTORS[1]
	if p then
		local lx,ly = self.Level_Handler:getSpawnPoints().x, self.Level_Handler:getSpawnPoints().y
		p.position.x = lx
		p.position.y = ly
		p:Spawn(lx,ly,true)
		
		p.respawn_point.x = lx
		p.respawn_point.y = ly
	end
end
function EventSystem:addLevel(path,name)
	self.Level_Handler:addLevel(path,name)
end

function EventSystem:update(dt)
	-- print(self.camera:getPosition())
	if self.game_state == self.game_state_list.PLAYING then
		if self.timer > 0 then
			self.timer = self.timer - 1000*dt
		else
			self.timer = 0
			if self.game_event == self.game_event_list.Tutorial_Intro then
				self.game_event = self.game_event_list.Tutorial_Standby
				self.timer = 800
			elseif self.game_event == self.game_event_list.Tutorial_Standby then
				self.game_event = self.game_event_list.Tutorial_onGoing
				for k,v in pairs(ACTORS) do
					if v then
						ACTORS[k]:setMove(true)
					end
				end
			end
		end
		self.camera:update(dt)
		self:TriggerUpdate(dt)
		
		self.Level_Handler:update(dt)
		for k,v in pairs(ACTORS) do
			if v then
				if v.isHuman then
					v:MakeCameraFollow(self.camera)
				end
			end
		end
	end
end

function EventSystem:draw()
	if self:getGameState() == "PLAYING" then
		love.graphics.setColor(1,1,1,1)
		self:getCamera():draw(function(l,t,w,h)
			local cx,cy = self:getCamera():toWorld(0,0)
			local scale = self:getCamera():getScale()
			self.Level_Handler:draw()
			
			for k,v in pairs(ACTORS) do
				if v then
					v:draw()
				end
			end
			for k,v in pairs(SOLIDS) do
				if v then
					v:draw()
				end
			end
			self.Animator:draw()
			local d = self.Level_Handler:getCurrentLevel().darkness or 1
			if self.game_event == self.game_event_list.Tutorial_Intro then
				local ratio = self.timer/4000
				love.graphics.setColor(0,0,0,d+ratio)
				love.graphics.rectangle("fill",l,t,w,h)
				
			else
				love.graphics.setColor(0,0,0,d)
				love.graphics.rectangle("fill",l,t,w,h)
			end
			-- end)
		end)
		
	elseif self:getGameState() == "MAIN" then
		love.graphics.setColor(1,1,1,1)
		love.graphics.draw(PLAY_IMAGE,WIDTH/2-200,HEIGHT/2-50)
	elseif self:getGameState() == "MENU" then
	end
end

function EventSystem:setGameState(g)
	self.game_state = self.game_state_list[g]
end
function EventSystem:getGameState()
	return self.game_state.name
end

function CreateEventSystem()
	local obj = EventSystem:new()
	obj:init()
	Renderer:addToLayer("BACKGROUND",obj)
	GameLoop:addObject(obj)
	return obj
end