--------------------- Level --------------------
Level = {}
Level.__index = Level

function Level:new()
	local t = {}
	setmetatable(t,Level)
	return t
end
function Level:init()
	self.time_factor = 1
	self.wave_count = 0
	self.enemies_till_level = 0
	self.enemies_killed_total = 0
	self.waves_till_boss = 5
	self.isBoss = false
	self.spawn_rate_const = 400
	self.spawn_rate = 0
	self.enemies_killed_level = 0
	
	self.stencil_func = nil
	
	self.time_factor = 1
	self.time_change_duration = 0
	self.isTimeChanged = false
	
	self.background = love.graphics.newImage("gfx/Background.png")
	self.player_image = love.graphics.newImage("gfx/player.png")
	
	-- self:nextLevel()
	
end
function Level:setStencilFunction(func)
	self.stencil_func = func
	for k,v in pairs(PLAYERS) do
		if v then
			if v.isAlive then
				v:setStencilFunction(func)
			end
		end
	end
	for k,v in pairs(ENEMIES) do
		if v then
			if v.isAlive then
				v:setStencilFunction(func)
			end
		end
	end
	for k,v in pairs(PROJECTILES) do
		if v then
			if v.isAlive then
				v:setStencilFunction(func)
			end
		end
	end
end
function Level:getPlayerImage()
	return self.player_image
end

function Level:nextLevel()

	self.wave_count = self.wave_count + 1
	
	self.enemies_killed_level = 0
	self.waves_till_boss = self:getWavesTillBoss(self.wave_count)
	self.isBoss = (self.waves_till_boss == 0)
	
	if self.isBoss then
		self.enemies_till_level_const = 1
	else
		self.enemies_till_level_const = self:getRequiredEnemies(self.wave_count)*5+5
	end
	self.enemies_till_level = self.enemies_till_level_const
	self.spawn_rate_const = math.random(1000,1550)
	self.spawn_rate = self.spawn_rate_const
	
	Animation_Handler:play_text("Wave : "..self.wave_count,WIDTH/2,HEIGHT/2,3000)
	if self.wave_count == 16 then
		Animation_Handler:play_text("Endless mode",WIDTH/2,100,3000)
	end
end
function Level:SetTime(timefactor, duration, isplayer,p_id)
	self.time_factor = timefactor
	self.time_change_duration = duration
	self.isTimeChanged = true
	if isplayer then
		for k,v in pairs(ENEMIES) do
			if v then
				if v.isAlive then
					v:SetTime(timefactor, duration)
				end
			end
		end
	else
	
		for k,v in pairs(ENEMIES) do
			if v then
				if v.isAlive then
					if v.index ~= p_id then
						v:SetTime(timefactor, duration)
					end
				end
			end
		end
		for k,v in pairs(PLAYERS) do
			if v then
				if v.isAlive then
					v:SetTime(timefactor, duration)
				end
			end
		end
	end
	for k,v in pairs(PROJECTILES) do
		if v then
			if v.isAlive then
				v:SetTime(timefactor, duration)
			end
		end
	end
end
function Level:onPlayerDeath()
end
function Level:onEnemyDeath()
	self.enemies_killed_level = self.enemies_killed_level + 1
	if self.enemies_killed_level == self.enemies_till_level_const then
		GAMESTATE = "MENU"
	end
end
function Level:keypressed(key)
	if key == "r" then
		if not PLAYERS[1].isAlive then
			love.event.quit("restart")
		end
	end
end
function Level:Player_hit(id,dmg)
	PLAYERS[id]:getHit(dmg)
end
function Level:Enemy_hit(id,dmg)
	ENEMIES[id]:getHit(dmg)
end
function Level:getWavesTillBoss(wave)
	return (5-wave%5)%5
end
function Level:getRequiredEnemies(wave)
	return math.ceil(wave/5)
end
function Level:update(dt)
	if self.isTimeChanged then
		if self.time_change_duration > 0 then
			self.time_change_duration = self.time_change_duration - 1000*dt
		else
			self.time_change_duration = 0
			self.isTimeChanged = false
		end
	else
		if self.enemies_till_level > 0 then
			if self.spawn_rate > 0 then
				self.spawn_rate = self.spawn_rate - 1000*dt
			else
				self.spawn_rate = self.spawn_rate_const
				if self.isBoss then
					local enem = CreateStandard_Enemy(x,y,self.wave_count)
					local s = self.wave_count/5 + 1
					if s > #STANDS_NAMES then
						s = math.random(2,#STANDS_NAMES)
					end
					enem.stand = CreateStand(STANDS_NAMES[s],enem.index,true)
					enem.stand:setActive(true)
					enem.position.x = WIDTH/2
					enem.position.y = 50
					enem.maxHealth = enem.maxHealth * 10
					enem.health = enem.maxHealth
					
					PLAYERS[1].position.x = WIDTH/2
					PLAYERS[1].position.y = HEIGHT-150
					local themes = {"Menacing","Awaken","Giorno"}
					local theme = themes[math.random(1,#themes)]
					if s-1 <= #themes then
						theme = themes[s-1]
					end
					
					local time_to_pause = Effect_Handler:play(theme)
					self:SetTime(0, time_to_pause, false,0)
					self.enemies_till_level = self.enemies_till_level - 1
				else
					local n = {-1,1}
					local x = math.random(0,WIDTH) + n[math.random(1,2)]*WIDTH
					local y = math.random(0,HEIGHT) + n[math.random(1,2)]*HEIGHT
					local r = math.clamp(math.random(3,math.ceil(self.wave_count/3)+2),3,7)
					local enem = CreateStandard_Enemy(x,y,self.wave_count)
					
					enem.stand = CreateStand(STANDS_NAMES[1],enem.index,true)
					enem.stand:setActive(true)
					
					self.enemies_till_level = self.enemies_till_level - 1
				end
			end
		end
	end
end

function Level:draw()
	if self.stencil_func then
		love.graphics.setColor(1,1,1,1)
		love.graphics.draw(self.background,0,0)
		
		love.graphics.setShader(shaders.invert)
		love.graphics.stencil(self.stencil_func,"replace",1)
		love.graphics.setStencilTest("greater", 0)
	end
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(self.background,0,0)
	love.graphics.setStencilTest()
	love.graphics.setShader()
	
	
	if not PLAYERS[1].isAlive then
		love.graphics.setColor(1,1,1,1)
		local ss,ww = love.graphics.getFont():getWrap("Press R to restart",2000)
		local ss2,ww2 = love.graphics.getFont():getWrap("Survived for "..self.wave_count.." Wave(s)",2000)
		love.graphics.print("Press R to restart",math.floor(WIDTH/2-ss/2),HEIGHT-15)
		love.graphics.print("Survived for "..self.wave_count.." Wave(s)",math.floor(WIDTH/2-ss2/2),HEIGHT/2)
	end
end

function CreateLevel()
	local obj = Level:new()
	obj:init()
	GameLoop:addObject(obj)
	Renderer:addToLayer("HUD",obj)
	return obj
end