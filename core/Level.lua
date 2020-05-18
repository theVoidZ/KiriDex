--------------------- Level_Handler --------------------
Level = {}
Level.__index = Level

function Level:new()
	local t = {}
	setmetatable(t,Level)
	return t
end
function Level:init()
	self.level_count = 0
	self.enemies_till_boss = 0
	self.enemies_count = 0
	self.enemies_spawned_count = 0
	self.enemies_spawned_level_count = 0
	self.enemies_spawned_level_max = 0
	self.enemies_killed_count = 0
	self.enemies_killed_level_count = 0
	self.score_level_count = 0
	
	self.boss_spawned = false
	self.will_spawn = true
	self.level_ended = true
	
	self.spawn_rate_const = 0
	self.spawn_rate = 0
	
	-- self:nextLevel()
end
function Level:onEnemyKill()
	self.enemies_killed_count = self.enemies_killed_count + 1
	self.enemies_killed_level_count = self.enemies_killed_level_count + 1
	
	if self.score_level_count == self.enemies_killed_level_count and self.boss_spawned then
		GAMESTATE = "MENU"
		Player_Menu.skillPoints = Player_Menu.skillPoints + 1
		-- self:nextLevel()
	end
end
function Level:keypressed(key)
	if key == "r" then
		if not PLAYERS[1].isAlive then
			love.event.quit("restart")
		end
	end
end
function Level:Enemy_hit(id)
	ENEMIES[id]:getHit()
end
function Level:nextLevel()
	self.level_count = self.level_count + 1
	self.enemies_till_boss = self.level_count*25-5
	self.enemies_spawned_level_max = self.enemies_till_boss
	self.enemies_killed_level_count = 0
	self.will_spawn = true
	self.level_ended = false
	self.spawn_rate_const = math.random(200,450)
	self.spawn_rate = self.spawn_rate_const
	self.boss_spawned = false
	self.score_level_count = 0
end

function Level:update(dt)
	if not self.level_ended then
		if self.will_spawn then
			if self.spawn_rate > 0 then
				self.spawn_rate = self.spawn_rate - 1000*dt
			else
				if self.enemies_spawned_level_count < self.enemies_spawned_level_max then
					self.spawn_rate = self.spawn_rate_const
					local n = {-1,1}
					local x = math.random(0,WIDTH) + n[math.random(1,2)]*WIDTH
					local y = math.random(0,HEIGHT) + n[math.random(1,2)]*HEIGHT
					local r = math.clamp(math.random(3,math.ceil(self.level_count/3)+2),3,7)
					CreateEnemy(x,y,{r=1,g=0,b=0},r)
					self.score_level_count = self.score_level_count + Count(r)
					self.enemies_spawned_level_count = self.enemies_spawned_level_count + 1
				else
					if self.enemies_killed_level_count >= self.score_level_count and not self.boss_spawned then
						local boss_count = math.ceil(self.enemies_till_boss/50)
						for i = 1,boss_count do
							local n = {-1,1}
							local x = math.random(0,WIDTH) + n[math.random(1,2)]*WIDTH
							local y = math.random(0,HEIGHT) + n[math.random(1,2)]*HEIGHT
							local r = math.clamp(math.ceil(self.level_count/3)+math.random(3,5),3,7)
							CreateEnemy(x,y,{r=1,g=0,b=0},r,20)
							self.score_level_count = self.score_level_count + Count(r)
							self.enemies_spawned_level_count = self.enemies_spawned_level_count + 1
							self.boss_spawned = true
						end
					end
				end
			end
		end
	end
end

function Level:draw()
	love.graphics.setColor(1,1,1,1)
	local str = "Enemies killed : "..self.enemies_killed_count
	local s,w = love.graphics.getFont():getWrap(str,1000)
	love.graphics.print(str,math.floor(WIDTH/2-s/2),30)
	
	love.graphics.setFont(Font0)
	love.graphics.setColor(1,1,1,0.4)
	local str2 = "Wave "..self.level_count
	local s2,w2 = love.graphics.getFont():getWrap(str2,2000)
	local h2 = love.graphics.getFont():getHeight()
	love.graphics.print(str2,math.floor(WIDTH/2-s2/2),math.floor(HEIGHT/3-h2/2))
	
	
	local str3 = SecondsToClock(time_played/1000)
	local s3,w3 = love.graphics.getFont():getWrap(str3,2000)
	local h3 = love.graphics.getFont():getHeight()
	love.graphics.print(str3,math.floor(WIDTH/2-s3/2),math.floor(HEIGHT/3*2-h3/2))
	
	love.graphics.setFont(mainFont)
	
	if not PLAYERS[1].isAlive then
		love.graphics.setColor(1,1,1,1)
		local ss,ww = love.graphics.getFont():getWrap("Press R to restart",2000)
		love.graphics.print("Press R to restart",math.floor(WIDTH/2-ss/2),HEIGHT-15)
	end
end

function Count(n)
	if n == 3 then
		return 1
	else
		return Count(n-1)*(n-1)+1
	end
end

function CreateLevel()
	local obj = Level:new()
	obj:init()
	GameLoop:addObject(obj)
	Renderer:addToLayer("HUD",obj)
	return obj
end