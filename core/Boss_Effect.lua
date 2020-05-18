--------------------- Boss_Effect --------------------
Boss_Effect = {}
Boss_Effect.__index = Boss_Effect

function Boss_Effect:new()
	local t = {}
	setmetatable(t,Boss_Effect)
	return t
end
function Boss_Effect:init()
	self.menacing_symbol1 = love.graphics.newImage("gfx/Go.png")
	
	self.giorno_symbols = {}
	self.giorno_symbols[1] = love.graphics.newImage("gfx/g1.png")
	self.giorno_symbols[2] = love.graphics.newImage("gfx/g2.png")
	self.giorno_symbols[3] = love.graphics.newImage("gfx/g3.png")
	
	self.font_good = love.graphics.newFont("fonts/coolvetica rg.ttf",50)
	self.font_normal = love.graphics.newFont("fonts/SF Fedora.ttf",30)
	self.font_shadow = love.graphics.newFont("fonts/SF Fedora Shadow.ttf",30)
	
	self.rumble_symbols = {}
	self.rumble_symbols[1] = love.graphics.newImage("gfx/m1.png")
	self.rumble_symbols[2] = love.graphics.newImage("gfx/m2.png")
	self.rumble_symbols[3] = love.graphics.newImage("gfx/m3.png")
	self.rumble_symbols[4] = love.graphics.newImage("gfx/m4.png")
	self.rumble_symbols[5] = love.graphics.newImage("gfx/m5.png")
	
	self.rumble_suspence_sound = love.audio.newSource("sfx/Menacing_suspence1.wav","stream")
	self.awaken_theme_sound = love.audio.newSource("sfx/Awaken Theme.wav","stream")
	self.giorno_theme_sound = love.audio.newSource("sfx/Giorno theme.wav","stream")
	
	self.rumble_text_list = {"Menacing","Rumble","Loom","Bam"}
	self.rumbe_text = ""
	
	self.isPlaying = false
	self.playing_name = ""
	self.duration_const = 0
	self.duration = 0
	self.speed = 100
	self.total_height = 0
	
	self.times = {
					Menacing = 12000,
					Awaken = 9000,
					Giorno = 15100}
	
	self.objects = {}
end
function Boss_Effect:play(name)
	if not self.isPlaying then
		if name == "Menacing" then
			self.rumble_suspence_sound:play()
			self.rumble_suspence_sound:setVolume(MASTER_VOLUME)
			self.objects = {}
			self.isPlaying = true
			self.duration = self.times[name] or 10000
			self.duration_const = self.times[name] or 10000
			self.playing_name = name
			self.rumbe_text = self.rumble_text_list[math.random(1,#self.rumble_text_list)]
			
			local height = 0
			while height < HEIGHT do
				self.objects[#self.objects+1] = {img = self.rumble_symbols[math.random(1,#self.rumble_symbols)],x=10,y=height+HEIGHT,target_x=10,target_y=height+HEIGHT,delay=200,offset=0}
				
				self.objects[#self.objects].h = self.objects[#self.objects].img:getHeight()
				self.objects[#self.objects].w = self.objects[#self.objects].img:getWidth()
			
				self.objects[#self.objects].ox = self.objects[#self.objects].x
				self.objects[#self.objects].oy = self.objects[#self.objects].y
				self.objects[#self.objects].spawn_delay = 0
				
				height = height + self.objects[#self.objects].img:getHeight()+20
			end
			self.objects[#self.objects+1] = {img = self.rumble_symbols[math.random(1,#self.rumble_symbols)],x=10,y=height+HEIGHT,target_x=10,target_y=height+HEIGHT,delay=200,offset=0}
			
			self.objects[#self.objects].h = self.objects[#self.objects].img:getHeight()
			self.objects[#self.objects].w = self.objects[#self.objects].img:getWidth()
			
			self.objects[#self.objects].ox = self.objects[#self.objects].x
			self.objects[#self.objects].oy = self.objects[#self.objects].y
			self.objects[#self.objects].spawn_delay = 0
			height = height + self.objects[#self.objects].img:getHeight()+20
			
			self.total_height = height
		elseif name == "Awaken" then
			self.awaken_theme_sound:play()
			self.awaken_theme_sound:setVolume(MASTER_VOLUME)
			self.objects = {}
			self.isPlaying = true
			self.duration = self.times[name] or 10000
			self.duration_const = self.times[name] or 10000
			self.playing_name = name
			self.rumbe_text = self.rumble_text_list[math.random(1,#self.rumble_text_list)]
			local pos = {{x=100,y=379},{x=165,y=240},{x=208,y=74},{x=698,y=12},{x=798,y=231},{x=848,y=364}}
			
			for i = 1 , 6 do
				self.objects[#self.objects+1] = {img = self.menacing_symbol1,x=pos[i].x,y=pos[i].y,target_x=pos[i].x,target_y=pos[i].y,delay=200,offset=0}
				
				self.objects[#self.objects].h = self.objects[#self.objects].img:getHeight()
				self.objects[#self.objects].w = self.objects[#self.objects].img:getWidth()
			
				self.objects[#self.objects].ox = self.objects[#self.objects].x
				self.objects[#self.objects].oy = self.objects[#self.objects].y
				
				self.objects[#self.objects].scale = math.random(0.9,1.1)
				
				self.objects[#self.objects].spawn_delay = 2500
				
			end
		elseif name == "Giorno" then
			self.giorno_theme_sound:play()
			self.giorno_theme_sound:setVolume(MASTER_VOLUME)
			self.objects = {}
			self.isPlaying = true
			self.duration = self.times[name] or 10000
			self.duration_const = self.times[name] or 10000
			self.playing_name = name
			self.rumbe_text = self.rumble_text_list[math.random(1,#self.rumble_text_list)]
			local pos = {{x=200,y=83},{x=500,y=50},{x=749,y=120}}
			
			for i = 1 , 3 do
				self.objects[#self.objects+1] = {img = self.giorno_symbols[i],x=pos[i].x,y=pos[i].y,target_x=pos[i].x,target_y=pos[i].y,delay=200,offset=0}
				
				self.objects[#self.objects].h = self.objects[#self.objects].img:getHeight()
				self.objects[#self.objects].w = self.objects[#self.objects].img:getWidth()
			
				self.objects[#self.objects].ox = self.objects[#self.objects].x
				self.objects[#self.objects].oy = self.objects[#self.objects].y
				
				self.objects[#self.objects].spawn_delay = 1200
				
			end
		end
		return self.times[name] or 10000
	end
	return 0
end
function Boss_Effect:update(dt)
	if self.isPlaying then
		if self.duration > 0 then
			self.duration = self.duration - 1000*dt
		else
			self.duration = 0
			self.isPlaying = false
			self.playing_name = ""
		end
		if self.playing_name == "Menacing" then
			for k = 1,#self.objects do
				if self.objects[k] then
					self.objects[k].offset = self.objects[k].offset - self.speed*dt
					local dist = Distance(self.objects[k].x,self.objects[k].y,self.objects[k].target_x,self.objects[k].target_y)
					local ang = Angle(self.objects[k].x,self.objects[k].y,self.objects[k].target_x,self.objects[k].target_y)
					if dist <= self.speed*dt*2 then
						self.objects[k].x = self.objects[k].target_x
						self.objects[k].y = self.objects[k].target_y
						if self.objects[k].delay == 0 then
							self.objects[k].target_x = self.objects[k].ox + math.random(-10,10)
							self.objects[k].target_y = self.objects[k].oy + math.random(-10,10)
							self.objects[k].delay = math.random(50,100)
						end
					else
						self.objects[k].x = self.objects[k].x + math.cos(ang)*self.speed*dt*2
						self.objects[k].y = self.objects[k].y + math.sin(ang)*self.speed*dt*2
					end
					if self.objects[k].delay > 0 then
						self.objects[k].delay = self.objects[k].delay - 1000*dt
					else
						self.objects[k].delay = 0
					end
					if self.objects[k].offset + self.objects[k].h + self.objects[k].y + 20 < 0 then
						self.objects[k].offset = self.objects[k].offset + self.total_height
					end
				end
			end
		elseif self.playing_name == "Awaken" then
			for k = 1,#self.objects do
				if self.objects[k] then
					local dist = Distance(self.objects[k].x,self.objects[k].y,self.objects[k].target_x,self.objects[k].target_y)
					local ang = Angle(self.objects[k].x,self.objects[k].y,self.objects[k].target_x,self.objects[k].target_y)
					if dist <= self.speed*dt*2 then
						self.objects[k].x = self.objects[k].target_x
						self.objects[k].y = self.objects[k].target_y
						if self.objects[k].delay == 0 then
							self.objects[k].target_x = self.objects[k].ox + math.random(-10,10)
							self.objects[k].target_y = self.objects[k].oy + math.random(-10,10)
							self.objects[k].delay = math.random(50,100)
						end
					else
						self.objects[k].x = self.objects[k].x + math.cos(ang)*self.speed*dt*2
						self.objects[k].y = self.objects[k].y + math.sin(ang)*self.speed*dt*2
					end
					if self.objects[k].delay > 0 then
						self.objects[k].delay = self.objects[k].delay - 1000*dt
					else
						self.objects[k].delay = 0
					end
					if self.objects[k].spawn_delay > 0 then
						self.objects[k].spawn_delay = self.objects[k].spawn_delay - 1000*dt
					else
						self.objects[k].spawn_delay = 0
					end
				end
			end
		elseif self.playing_name == "Giorno" then
			for k = 1,#self.objects do
				if self.objects[k] then
					local dist = Distance(self.objects[k].x,self.objects[k].y,self.objects[k].target_x,self.objects[k].target_y)
					local ang = Angle(self.objects[k].x,self.objects[k].y,self.objects[k].target_x,self.objects[k].target_y)
					if dist <= self.speed*dt*3 then
						self.objects[k].x = self.objects[k].target_x
						self.objects[k].y = self.objects[k].target_y
						if self.objects[k].delay == 0 then
							self.objects[k].target_x = self.objects[k].ox + math.random(-10,10)
							self.objects[k].target_y = self.objects[k].oy + math.random(-10,10)
							self.objects[k].delay = math.random(30,70)
						end
					else
						self.objects[k].x = self.objects[k].x + math.cos(ang)*self.speed*dt*3
						self.objects[k].y = self.objects[k].y + math.sin(ang)*self.speed*dt*3
					end
					if self.objects[k].delay > 0 then
						self.objects[k].delay = self.objects[k].delay - 1000*dt
					else
						self.objects[k].delay = 0
					end
					if self.objects[k].spawn_delay > 0 then
						self.objects[k].spawn_delay = self.objects[k].spawn_delay - 1000*dt
					else
						self.objects[k].spawn_delay = 0
					end
				end
			end
		end
	end
end
function Boss_Effect:draw()
	if self.isPlaying then
		-- if self.playing_name == "Menacing" then
		for k = 1,#self.objects do
			if self.objects[k] then
				if self.objects[k].spawn_delay == 0 then
					love.graphics.setColor(1,1,1,1)
					love.graphics.draw(self.objects[k].img,self.objects[k].x,self.objects[k].y+self.objects[k].offset,0,self.objects[k].scale or 1)
					if self.playing_name == "Menacing" then
						love.graphics.draw(self.objects[k].img,self.objects[k].x+WIDTH-150,self.objects[k].y+self.objects[k].offset)
					end
					love.graphics.setColor(0.5,0,0.5,0.9)
					if self.playing_name == "Giorno" then
						love.graphics.setColor(0.8,0.8,0,0.9)
					end
					love.graphics.setFont(self.font_good)
					local s,w = love.graphics.getFont():getWrap(self.rumbe_text,1000)
					love.graphics.print(self.rumbe_text,math.floor(WIDTH/2-s/2)+math.random(-1,1),HEIGHT-80+math.random(-1,1))
					love.graphics.setFont(font1)
				end
			end
		end
		-- end
	end
end

function CreateBoss_Effect()
	local obj = Boss_Effect:new()
	obj:init()
	GameLoop:addObject(obj)
	Renderer:addToLayer("HUD",obj)
	return obj
end