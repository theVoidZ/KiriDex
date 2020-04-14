--------------------- Companion --------------------
Companion = {}
Companion.__index = Companion

function Companion:new()
	local t = {}
	setmetatable(t,Companion)
	return t
end
function Companion:init()
	self.image = love.graphics.newImage("gfx/strawberry2.png")
	self.position = Vector(0,0)
	self.speed_const = 450
	self.min_speed = 10
	self.current_speed = self.min_speed
	self.acceleration = 600
	
	self.target_position = Vector(0,0)
	self.hover_offset = 0
	self.look_direction = 1
	-- self.time_cd = 0
	
	self.reached = true
	
	self.text_bulb = {}
	
	-- self.light = LightWorld:newLight(self.position.x, self.position.y, 1, 1, 1,200)
	-- self.light:setSmooth(0.25)
	
	------------- Sounds
	self.sounds = {}
	self.sounds.talk = love.audio.newSource("sfx/Companion/talksike.wav","stream")
	-- for i = 1,1 do
		-- table.insert(self.sounds.talk,love.audio.newSource("sfx/Companion/Talk ("..i..").wav","stream"))
		-- table.insert(self.sounds.talk,love.audio.newSource("sfx/Companion/talking_test.wav","stream"))
		-- table.insert(self.sounds.talk,love.audio.newSource("sfx/Companion/talk.wav","stream"))
		-- table.insert(self.sounds.talk,love.audio.newSource("sfx/Companion/talksike.wav","stream"))
		-- table.insert(self.sounds.talk,love.audio.newSource("sfx/Companion/Blip_Select.wav","stream"))
	-- end
end

function Companion:onDeath()
	-- self.light:setVisible(false)
end

function Companion:Say(text,delay,txt_speed,func) -- txt_speed or 0 (instant)
	table.insert(self.text_bulb,{full_text=text,text="",speed=txt_speed or 0,speed_const=txt_speed or 0,delay_const=delay or 2000,delay=delay or 2000,func = func})
	if self.text_bulb[#self.text_bulb].speed == 0 then
		self.text_bulb[#self.text_bulb].text = self.text_bulb[#self.text_bulb].full_text
	end
end

function Companion:setTarget(x, y)
	self.target_position.x = x
	self.target_position.y = y
	self.reached = false
	if self.position.x - x ~= 0 then
		self.look_direction = -sign(self.position.x - x)
	end
end

function Companion:update(dt)
	if not self.reached then
		self:MoveTowards(dt)
	end
	-- self.time_cd = self.time_cd + 1000*dt
	self.hover_offset = math.cos(os.clock()*2.5)*5
	-- self.light:setPosition(self.position.x, self.position.y + self.hover_offset)
	-- for i = #self.text_bulb,1,-1 do
	local i = 1 --- we show and update one at a time
	if self.text_bulb[i] then
		if self.text_bulb[i].speed > 0 then
			self.text_bulb[i].speed = self.text_bulb[i].speed - 1000*dt
		else
			self.text_bulb[i].speed = self.text_bulb[i].speed_const
			self:addLetter(i)
		end
		if self.text_bulb[i].text == self.text_bulb[i].full_text then
			if self.text_bulb[i].delay > 0 then
				self.text_bulb[i].delay = self.text_bulb[i].delay - 1000*dt
			else
				self.text_bulb[i].delay = 0
				if self.text_bulb[i].func then
					self.text_bulb[i].func()
				end
				table.remove(self.text_bulb,i)
			end
		end
	end
	-- end
end

function Companion:MoveTowards(dt)
	local dist = Distance(self.position.x, self.position.y, self.target_position.x, self.target_position.y)
	local ang = Angle(self.position.x, self.position.y, self.target_position.x, self.target_position.y)
	if dist < self.current_speed*dt then
		self.position = self.target_position.copy
		self.reached = true
		self.current_speed = math.max(self.current_speed*0.9, self.min_speed)
		-- self.current_speed = self.min_speed
	else
		if self.current_speed < self.speed_const then
			self.current_speed = self.current_speed + self.acceleration*dt
		else
			self.current_speed = self.speed_const
		end
		local x = self.position.x + math.cos(ang) * self.current_speed*dt
		local y = self.position.y + math.sin(ang) * self.current_speed*dt
		
		self.position.x = x
		self.position.y = y
	end
end

function Companion:MoveTowards_old(dt)
	local dist = Distance(self.position.x, self.position.y, self.target_position.x, self.target_position.y)
	local ang = Angle(self.position.x, self.position.y, self.target_position.x, self.target_position.y)
	if dist < self.current_speed*dt then
		self.position = self.target_position.copy
		self.reached = true
		self.current_speed = self.min_speed
	else
		if self.current_speed < self.speed_const then
			self.current_speed = self.current_speed + self.acceleration*dt
		else
			self.current_speed = self.speed_const
		end
		local x = self.position.x + math.cos(ang) * self.current_speed*dt
		local y = self.position.y + math.sin(ang) * self.current_speed*dt
		
		self.position.x = x
		self.position.y = y
	end
end

function Companion:addLetter(i)
	if #self.text_bulb[i].text < #self.text_bulb[i].full_text then
		self.text_bulb[i].text = string.sub(self.text_bulb[i].full_text,1,#self.text_bulb[i].text+2)
		if self.text_bulb[i].text:sub(-1) == " " then
			self:addLetter(i)
		else
			if self.sounds.talk:isPlaying() then
				self.sounds.talk:stop()			
			end
			self.sounds.talk:play()
		end
	end
end

function Companion:draw()
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(self.image, self.position.x, self.position.y+self.hover_offset,0,1,1,self.image:getWidth()/2,self.image:getHeight()/2)
	-- love.graphics.circle("fill",self.position.x, self.position.y + self.hover_offset + (15+self.hover_offset)/2,(20+self.hover_offset)/2)
	-- for i = #self.text_bulb,1,-1 do
	local i = 1
	if self.text_bulb[i] then
		local a = 0.8
		love.graphics.setColor(0,0,0,a)
		local x1 = self.position.x - 15 * self.look_direction
		local y1 = self.position.y - 15 + self.hover_offset
		local x2 = x1 - 20 * self.look_direction
		local y2 = y1 - 25
		local x3 = x1 - 50 * self.look_direction
		local y3 = y1 - 25
		
		local s,w = love.graphics.getFont():getWrap(self.text_bulb[i].full_text,130*2)
		local adds = 0
		if #w > 5 then
			adds = (#w-4)*15
		end
		
		local cx = x1 - 75 * self.look_direction
		local cy = y1-75-adds/2
		
		local rx = 170
		local ry = 60+adds/2
		
		
		love.graphics.setColor(1,1,1,a)
		love.graphics.ellipse("fill",cx,cy,rx,ry)
		love.graphics.setColor(0,0,0,a)
		love.graphics.ellipse("line",cx,cy,rx,ry)
		
		local func = function()
			love.graphics.ellipse("fill",cx,cy,rx,ry)
		end
		love.graphics.stencil(func)
		love.graphics.setStencilTest("equal",0)
		
		love.graphics.setColor(1,1,1,a)
		love.graphics.polygon("fill",x1,y1,x2,y2,x3,y3)
		love.graphics.setColor(0,0,0,a)
		love.graphics.polygon("line",x1,y1,x2,y2,x3,y3)
		love.graphics.setStencilTest()
		
		love.graphics.setColor(1,1,1,a)
		love.graphics.printf(self.text_bulb[i].text,cx-(rx-40),cy-(ry-30) - 15*(#w-1)+15,130*2)
	end
	-- end
end

function CreateCompanion()
	local obj = Companion:new()
	obj:init()
	return obj
end