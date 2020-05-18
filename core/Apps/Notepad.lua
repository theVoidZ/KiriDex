--------------------- Notepad --------------------
Notepad = Content:new()
Notepad.__index = Notepad

function Notepad:new()
	local t = {}
	setmetatable(t,Notepad)
	return t
end
function Notepad:init(x,y,w,h)
	self.position = Vector(x,y)
	self.size = Vector(w,h)
	self.text = ""
	
	
	self.max_text_size = 100
	
	self.blinker_timer_const = 700
	self.blinker_timer = 0
	self.blinker_value = 1
	
	self.text_width = 0
	self.line = 1
	------------------------------------
	self.letters = {}
	
	love.physics.setMeter(100)
	self.physics = {}
	self.physics.GravityScale = 0
	
	self.minigame = false
	self.health = 3
	self.enemy_image = love.graphics.newImage("gfx/hazards/enemy1.png")
	self.enemies = {}
	
	self.minigame_time = 50000
	self.minigame_spawnrate_const = 3000
	self.minigame_spawnrate = 3000
	
end
function Notepad:attackEnemy()
	local bullet = self.text
	local target = 0
	for k,v in pairs(self.enemies) do
		if v.alive and not v.isDying then
			if string.find(string.upper(bullet),string.upper(v.name)) then
				target = k
				break
			end
		end
	end
	if target ~= 0 then
		self.enemies[target].isDying = true
		for k = 1,#bullet do
			self:keypressed("backspace")
		end
	end
end
function Notepad:allEnemiesDead()
	local dead = true
	for k,v in pairs(self.enemies) do
		if v.alive then
			dead = false
			break
		end
	end
	return dead
end
function Notepad:spawnEnemy(isBoss)
	local name = ""
	for i = 1,math.random(3,5) do
		name = name..string.char(math.random(65,90))
	end
	if isBoss then
		name = "Gravityyyyyyyyy"
	end
	self.enemies[#self.enemies+1] = {name=name,isDying=false,alive=true,x=self.position.x+self.size.x,y=math.random(self.position.y+40,self.position.y+40+self.size.y-80),explosion=300,image = self.enemy_image}
end
function Notepad:setStats(pos,size,open)
	self:update_stats(pos,size,open)
	self:setGravityScale(1)
end
function Notepad:keypressed(k)
	if k == "backspace" then
		local byteoffset = UTF8.offset(self.text, -1)
		if byteoffset then
			if #self.letters ~= 0 then
				self.text_width = self.text_width - Font5:getWidth(self.letters[#self.letters].letter) - 5
				if self.text_width < 0 and self.line > 1 then
					self.text_width = self.size.x - 50
					self.line = self.line - 1
				end
				self.text = string.sub(self.text, 1, byteoffset - 1)
				self.letters[#self.letters].body:destroy()
				self.letters[#self.letters] = nil
			else
				self.line = 1
				self.text_width = 0
				self.text = ""
			end
		end
	elseif k == "return" then
		self.text = self.text.."\n"
		self.text_width = 0
		self.line = self.line + 1
	end
end
function Notepad:textinput(t)
	if #self.text < self.max_text_size then
		self.text = self.text .. t
		self.text_width = self.text_width + Font5:getWidth(t) + 5
		if self.text_width > self.size.x - 50 then
			self.text_width = Font5:getWidth(t)
			self.line = self.line + 1
		end
		if string.byte(t) > 32 and string.byte(t) < 127 then
			self:CreateLetter(t)
		end
	end
	self:attackEnemy()
end
function Notepad:setGravity()
	self:setGravityScale(1)
	
	for k,v in pairs(self.letters) do
		if v then
			v.body:setActive(true)
			v.body:setGravityScale(1)
		end
	end
end
function Notepad:setGravityScale(g)
	self.physics.GravityScale = g
	for k,v in pairs(self.letters) do
		if v then
			v.body:setGravityScale(g)
		end
	end
end
function Notepad:CreateLetter(t)
	local w = Font5:getWidth(t)
	local h = Font5:getHeight(t)
	
	local tab = {}
	local x = self.position.x + 25+w/2 + self.text_width - w
	local y = self.position.y + 25 +h/2 + (self.line-1)*15
	tab.body = love.physics.newBody(Main_Desktop.physics.world, x, y,"dynamic")
	tab.shape = love.physics.newRectangleShape(w,h)
	tab.fixture = love.physics.newFixture(tab.body, tab.shape)
	tab.fixture:setUserData(t.." "..os.time())
	tab.body:setGravityScale(self.physics.GravityScale)
	-- tab.body:setFixedRotation(true)
	tab.body:setActive(self.minigame or self.isFinished)
	tab.letter = t
	tab.pos_diff = Vector(x,y) - self.position
	table.insert(self.letters,tab)
end
function Notepad:update_(dt)
	if self.blinker_timer > 0 then
		self.blinker_timer = self.blinker_timer - 1000*dt
	else
		self.blinker_timer = self.blinker_timer_const
		self.blinker_value = (self.blinker_value + 1)%2 -- 0 for empty 1 for |
	end
	if self.minigame and self.open then
		for k,v in pairs(self.enemies) do
			if v.alive and not v.isDying then
				self.enemies[k].x = self.enemies[k].x - 75*dt
			elseif v.isDying then
				if v.explosion > 0 then
					self.enemies[k].explosion = self.enemies[k].explosion - 1000*dt
				else
					self.enemies[k].explosion = 0
					self.enemies[k].alive = false
				end
			end
		end
		if self.minigame_time > 0 then
			self.minigame_time = self.minigame_time - 1000*dt
			if self.minigame_time <= 0 then
				self:spawnEnemy(true)
			end
		else
			self.minigame_time = 0
			if self:allEnemiesDead() then
				self.minigame = false
				self.isFinished = true
				self.enemies = {}
				local jx,jy = Main_Desktop:getAppFromName("Jam2020")
				local jam = Main_Desktop:getAppAt(jx,jy)
				if jam then
					jam.window.content:onEndGame("Notepad++")
				end
			end
		end
		if self.minigame_spawnrate > 0 then
			self.minigame_spawnrate = self.minigame_spawnrate - 1000*dt
		else
			if self.minigame_time ~= 0 then
				self.minigame_spawnrate = self.minigame_spawnrate_const + math.random(-1000,1000)
				self:spawnEnemy()
			end
		end
	end
end
function Notepad:draw_()
	love.graphics.setColor(1,1,1,1)
	love.graphics.rectangle("fill",self.position.x + 20,self.position.y + 20,self.size.x - 40,self.size.y - 40)
	love.graphics.setColor(0,0,0,1)
	local blinker = ""
	if self.blinker_value == 1 then
		blinker = "|"
	end
	love.graphics.setFont(Font5)
	local w = love.graphics.getFont():getWidth(string.sub(self.text,#self.text,#self.text))
	local h = love.graphics.getFont():getHeight(string.sub(self.text,#self.text,#self.text))
	
	local x = self.position.x + 25+w/2 + self.text_width - w
	local y = self.position.y + 25 + (self.line-1)*15
	love.graphics.printf(blinker,x, y,self.size.x - 50)
	for k,v in pairs(self.letters) do
		if v then
			love.graphics.setColor(1,0,0,1)
			local x,y = v.body:getWorldPoints(v.shape:getPoints())
			if DRAW_PHYSICS then
				love.graphics.polygon("line", v.body:getWorldPoints(v.shape:getPoints()))
			end
			love.graphics.setColor(0,0,0,1)
			love.graphics.print(v.letter,x,y,v.body:getAngle())
			self.letters[k].pos_diff.x = x - self.position.x
			self.letters[k].pos_diff.y = y - self.position.y
		end
	end
	love.graphics.setFont(Font2)
	if self.minigame then
		for k,v in pairs(self.enemies) do
			if v.alive and not v.isDying then
				love.graphics.setColor(1,1,1,1)
				local scale = 1
				if v.name == "Gravityyyyyyyyy" then scale = 2.5 end
				love.graphics.draw(self.enemy_image,v.x,v.y,0,-scale,scale)
				love.graphics.setColor(0,0,0,1)
				love.graphics.print(v.name,v.x,v.y)
			elseif v.isDying then
				if v.explosion ~= 0 then
					love.graphics.setColor(1,0.65,0,1)
					local r = math.min((-v.explosion + 340)/4,100)
					love.graphics.circle("fill",v.x,v.y,r)
				end
			end
		end
	end
	love.graphics.setFont(Font1)
end
function CreateNotepad(x,y,w,h)
	local obj = Notepad:new()
	obj:init(x,y,w,h)
	return obj
end