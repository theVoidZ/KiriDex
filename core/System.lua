--------------------- System --------------------
System = {}
System.__index = System

function System:new()
	local t = {}
	setmetatable(t,System)
	return t
end
function System:init()
	self.loading_bar_progress = 0 -- 0 .. 100
	self.loading_bar_size = Vector(320,20)
	self.loading_total_time = 500
	self.phase = "booting"
	
	self.position = Vector(WIDTH/2,HEIGHT/3)
	
	self.images = {}
	self.images.win_xp_logo = love.graphics.newImage("gfx/winxp_logo.png")
	self.images.win_xp_logo2 = love.graphics.newImage("gfx/winxp_logo2.png")
	
	
	self.account_name = ""
	
	self.blinker_timer_const = 700
	self.blinker_timer = 0
	self.blinker_value = 1
	love.keyboard.setKeyRepeat(true)
	
	self.isImporting = true
	self.importing_id = 1
	self.import_lines = {}
	self.delay = 50
	self.import_phase = "accounts"
	self.memes_directory = "gfx/memes/"
	
	self.memes_images = {}
	self.memes_images2 = {} -- dictionnary
	self.meme_files = love.filesystem.getDirectoryItems(self.memes_directory)
	
	self.icons_imported = {} -- to avoid repetition
	self.icon_names = {}
	self.icons = {}
	self.selected_avatar = 1
	
	self.accounts = {}
	self.accounts[1] = {name = "",avatar = nil,color={51,140,219}}
	
	self.scroll_speed = 10
	self.scroll_height = 0
	self.scroll_offset = 0
	
	self.avatar_picker = {}
	local Y = self.position.y + 16 + self.images.win_xp_logo2:getHeight()*0.23
	self.avatar_picker.position = Vector(10,Y+10)
	self.avatar_picker.size = Vector(self.position.x-10,HEIGHT-100 - Y)
	
	self:setupAccounts()
	
	--------- Sounds
	
	self.startup = love.audio.newSource("sfx/windows-startup.mp3","stream")
end
function System:getAssets()
	return self.icons, self.accounts, self.memes_images, self.memes_images2
end
function System:addIcon(path)
	self.icons[#self.icons+1] = love.graphics.newImage(path)
end
function System:addAccount(name,avatar,color)
	self.accounts[#self.accounts+1] = {name = name,color = color or RandomColor(),avatar = avatar}
	print(name,"added",#self.accounts)
end
function System:getIcon(name)
	for k,v in pairs(self.icon_names) do
		if name == k then
			return v
		end
	end
	return nil
end
function System:manageAccounts()
	if self.import_phase == "accounts" then
		if self.importing_id <= #self.import_lines then
			local ico_id = 0
			if not contains(self.icons_imported,self.import_lines[self.importing_id][2]) then
				self.icons[#self.icons+1] = love.graphics.newImage("gfx/avatars/"..self.import_lines[self.importing_id][2])
				self.icon_names[self.import_lines[self.importing_id][2]] = #self.icons
				ico_id = #self.icons
				self.icons_imported[#self.icons_imported+1] = self.import_lines[self.importing_id][2]
			else
				ico_id = self:getIcon(self.import_lines[self.importing_id][2]) or #self.icons
			end
			self.accounts[#self.accounts+1] = {name = self.import_lines[self.importing_id][1],color = RandomColor(),avatar = self.icons[ico_id]}
			self.importing_id = self.importing_id + 1
			self.delay = 0
			self.loading_total_time = 3000
		else
			self:addIcon("gfx/avatars/LexLoco.png")
			self:addIcon("gfx/avatars/theDrDevin.png")
			self.images.acc_icon = self.icons[self.selected_avatar]
			self.accounts[1].avatar = self.images.acc_icon
			self.importing_id = 1
			self.import_phase = "memes"
		end
	elseif self.import_phase == "memes" then
		if self.importing_id <= #self.meme_files then
			self.memes_images[#self.memes_images+1] = love.graphics.newImage(self.memes_directory..self.meme_files[self.importing_id])
			self.memes_images2[self.meme_files[self.importing_id]] = #self.memes_images
			self.importing_id = self.importing_id + 1
			self.delay = 0
			self.loading_total_time = 3000
		else
			self.isImporting = false
		end
	end
end
function System:setupAccounts()
	local file = io.open("core/names.txt","r")
	if file then
		for line in file:lines() do
			local fields = line:split("|")
			self.import_lines[#self.import_lines+1] = fields
		end
	end
end
function System:wheelmoved(x,y)
	if y > 0 then -- wheel up
		self.scroll_offset = self.scroll_offset + self.scroll_speed
	elseif y < 0 then
		self.scroll_offset = self.scroll_offset - self.scroll_speed
	end
	self.scroll_offset = math.clamp(self.scroll_offset,-self.scroll_height+self.avatar_picker.size.y-45,0)
end
function System:LogToAccount()
	self.phase = "playing"
	GAMESTATE = "PLAYING"
	user.name = self.account_name
	self.accounts[1].name = self.account_name
	love.graphics.setBackgroundColor(48/255,10/255,36/255)
	love.mouse.setVisible(false)
	Main_Desktop:addApp("Discord",".exe","gfx/icons/Discord.png",6,4,"Discord")
	self.startup:setVolume(user.master_volume/2)
	self.startup:play()
end
function System:mousepressed(x,y,b)
	if b == 1 then
		if self.account_name ~= "" and self.phase == "accounts" then
			if x >= self.position.x + 170 + 162 - 25 and x <=  self.position.x + 170 + 162 and
			y >= self.position.y + 120 and y <= self.position.y + 145 then
				self:LogToAccount()
			end
		end
		if self.phase == "accounts" then
			local row = 0
			local line = 0
			local limit = math.floor((self.avatar_picker.size.x-5)/45) -- the -5 is for the first marge
			for i = 1,#self.icons do
				local img = self.icons[i]
				local ix = self.avatar_picker.position.x + 5 + row*45
				local iy = self.avatar_picker.position.y + 5 + line*45 + self.scroll_offset
				if x >= ix and x <=  ix + 40 and
				y >= iy and y <= iy + 40 then
					self:selectAvatar(i)
					break
				end
				row = row + 1
				if row == limit then
					row = 0
					line = line + 1
				end
			end
		end
	end
end
function System:selectAvatar(i)
	self.selected_avatar = i
	self.images.acc_icon = self.icons[i]
	self.accounts[1].avatar = self.images.acc_icon
end
function System:keypressed(k)
	if k == "backspace" then
		local byteoffset = UTF8.offset(self.account_name, -1)
		if byteoffset then
			self.account_name = string.sub(self.account_name, 1, byteoffset - 1)
		end
	elseif k == "return" then
		if self.account_name ~= "" and self.phase == "accounts" then
			self:LogToAccount()
		end
	end
end
function System:textinput(t)
	if #self.account_name < 20 and self.phase == "accounts" then
		self.account_name = self.account_name .. t
	end
end
function System:update(dt)
	if self.loading_bar_progress < 100 then
		self.loading_bar_progress = self.loading_bar_progress + 40*dt
	else
		self.loading_bar_progress = -20
	end
	if self.loading_total_time > 0 then
		self.loading_total_time = self.loading_total_time - 1000*dt
	else
		if not self.isImporting then
			if self.phase == "booting" then
				self.loading_total_time = 0
				self.phase = "accounts"
				love.graphics.setBackgroundColor(90/255,126/255,220/255)
			end
		else
			self.loading_total_time = 500
		end
	end
	if self.blinker_timer > 0 then
		self.blinker_timer = self.blinker_timer - 1000*dt
	else
		self.blinker_timer = self.blinker_timer_const
		self.blinker_value = (self.blinker_value + 1)%2 -- 0 for empty 1 for |
	end
	if self.delay > 0 then
		self.delay = self.delay - 1000*dt
	else
		self.delay = 0
		if self.isImporting then
			self:manageAccounts()
		end
	end
end
function System:draw()
	if self.phase == "booting" then
		love.graphics.setColor(1,1,1,1)
		love.graphics.draw(self.images.win_xp_logo,self.position.x,self.position.y,0,1,1,self.images.win_xp_logo:getWidth()/2,self.images.win_xp_logo:getHeight()/2)
		
		local w = self.loading_bar_size.x
		local h = self.loading_bar_size.y
		
		local bx = self.position.x - w/2
		local by = HEIGHT/1.5
		love.graphics.setColor(1,1,1,1)
		love.graphics.rectangle("fill",bx,by,w,h)
		love.graphics.setColor(181/255,181/255,181/255,1)
		love.graphics.rectangle("line",bx,by,w,h,2)
		love.graphics.setScissor(bx,by,w,h)
		
		-- Bars moving
		for i = 1,3 do
			local mx = math.floor(bx + (self.loading_bar_progress) * w / 100 + 10*(i-1))
			local my = by
			love.graphics.setColor(91/255,122/255,230/255,1,2)
			love.graphics.rectangle("fill",mx,my+1,8,h-2)
			love.graphics.setColor(0,0,43/255,1,2)
			love.graphics.rectangle("line",mx,my+1,8,h-2)
			
		end
		love.graphics.setScissor()
	elseif self.phase == "accounts" then
		love.graphics.setColor(1,1,1,1)
		love.graphics.draw(self.images.acc_icon,self.position.x + 71,self.position.y + 64,0,77/self.images.acc_icon:getWidth(),77/self.images.acc_icon:getHeight())
		
		love.graphics.setColor(1,1,1,1)
		love.graphics.setLineWidth(2)
		love.graphics.rectangle("line",self.position.x + 71,self.position.y + 64,77,77)
		
		love.graphics.setLineWidth(1)
		love.graphics.setColor(1,1,1,0.5)
		love.graphics.line(self.position.x + 10,0,self.position.x + 10,HEIGHT)
		
		love.graphics.setColor(1,1,1,1)
		local sc = math.max(211/self.images.win_xp_logo2:getWidth(),127/self.images.win_xp_logo2:getHeight())
		love.graphics.draw(self.images.win_xp_logo2,self.position.x - 22,self.position.y + 16,0,sc,sc,self.images.win_xp_logo2:getWidth(),0)
		
		love.graphics.setColor(1,1,1,1)
		love.graphics.rectangle("fill",self.position.x + 171,self.position.y + 64 + 28,160,20)
		
		love.graphics.setColor(181/255,181/255,181/255,1)
		love.graphics.rectangle("line",self.position.x + 170,self.position.y + 63 + 28,162,22)
		local blinker = ""
		if self.blinker_value == 1 then
			blinker = "|"
		end
		if self.account_name ~= "" then
			love.graphics.setColor(0,0,0,1)
			love.graphics.print(self.account_name..blinker,self.position.x + 174,self.position.y + 95)
		else
			love.graphics.setColor(0,0,0,1)
			love.graphics.print(blinker,self.position.x + 174,self.position.y + 95)
			love.graphics.setColor(0.6,0.6,0.6,0.6)
			love.graphics.print("ENTER NAME",self.position.x + 174,self.position.y + 95)
		end
		
		love.graphics.setColor(84/255,167/255,84/255,1)
		love.graphics.rectangle("fill",self.position.x + 170 + 162 - 25,self.position.y + 120,25,25)
		love.graphics.setColor(181/255,181/255,181/255,1)
		love.graphics.rectangle("line",self.position.x + 170 + 162 - 25,self.position.y + 120,25,25)
		love.graphics.setColor(1,1,1,1)
		love.graphics.print("OK",self.position.x + 170 + 162 - 20,self.position.y + 125)
		
		love.graphics.setColor(10/255,50/255,162/255,1)
		love.graphics.rectangle("fill",0,0,WIDTH,80)
		love.graphics.rectangle("fill",0,HEIGHT - 80,WIDTH,80)
		
		love.graphics.setColor(10/255,50/255,162/255,1)
		love.graphics.rectangle("line",self.avatar_picker.position.x,self.avatar_picker.position.y,self.avatar_picker.size.x,self.avatar_picker.size.y)
		local row = 0
		local line = 0
		local limit = math.floor((self.avatar_picker.size.x-5)/45) -- the -5 is for the first marge
		love.graphics.setScissor(self.avatar_picker.position.x+3,self.avatar_picker.position.y+3,self.avatar_picker.size.x-6,self.avatar_picker.size.y-6)
		for i = 1,#self.icons do
			local img = self.icons[i]
			local w,h = img:getWidth(), img:getHeight()
			local ix = self.avatar_picker.position.x + 5 + row*45
			local iy = self.avatar_picker.position.y + 5 + line*45 + self.scroll_offset
			love.graphics.setColor(1,1,1,1)
			love.graphics.draw(img,ix,iy,0,math.min(40/w,40/h),math.min(40/w,40/h))
			if i == self.selected_avatar then
				love.graphics.setLineWidth(3)
				love.graphics.rectangle("line",ix,iy,40,40)
				love.graphics.setLineWidth(1)
			end
			
			row = row + 1
			if row == limit then
				row = 0
				line = line + 1
			end
		end
		self.scroll_height = line*45 + 5
		love.graphics.setScissor()
		love.graphics.setColor(1,1,1,1)
		love.graphics.setFont(Font4)
		love.graphics.print("CHOSE AN AVATAR!",self.avatar_picker.position.x + 5,self.avatar_picker.position.y - 25)
		love.graphics.setFont(Font1)
	end
end

function CreateSystem()
	local obj = System:new()
	obj:init()
	return obj
end