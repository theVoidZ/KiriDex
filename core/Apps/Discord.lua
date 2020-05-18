--------------------- Discord --------------------
Discord = Content:new()
Discord.__index = Discord

function Discord:new()
	local t = {}
	setmetatable(t,Discord)
	return t
end
function Discord:init(x,y,w,h)
	self.position = Vector(x,y)
	self.size = Vector(w,h)
	self.colors = {
					{47/255,49/255,54/255,1},
					{54/255,57/255,63/255,1},
					{67/255,69/255,74/255,1},
					{96/255,137/255,218/255,1}
					}
	
	self.server_name = "Untitled Game Jam"
	self.app_name = ""
	self.app_icon = nil
	
	self.notifier = CreateNotification_Handler()
	
	
	self.icons, self.accounts , self.memes, self.memes2= system:getAssets()
	
	self.channels_order = {"FUN","MESSAGE BOARD"}
	
	self.selected_group = "FUN"
	self.selected_channel = "#welcome" -- name
	
	self.hovered_channel = 0
	
	self.channels = {
					["FUN"] = { -- group of channels
										["#welcome"] = {text = {},new = false}, -- texts inside
										["#fun"] = {text = {},new = false}, -- the # means it's chat, % means voice chat
					},
					["MESSAGE BOARD"] = { -- group of channels
										["#announcements"] = {text = {},new = false},
										["#theme"] = {text = {},new = false},
										--["#jam-questions"] = {text = {},new = false}
										}
	}
	
	self.chat_text = ""
	self.max_text_size = 400
	
	self.chat_box = {}
	self.chat_box.size = Vector(self.size.x - 350,self.size.y - 45)
	self.chat_box.position = Vector(self.position.x+175,self.position.y+5)
	self.chat_box.offset = 0 -- the scroll
	self.chat_box.scroll_speed = 15
	
	self.blinker_timer_const = 700
	self.blinker_timer = 0
	self.blinker_value = 1
	
	self:markRead(self.selected_channel)
	self.specialUsers = {} -- WexDex = 2 example
	
	self.voting_poll = CreateVotePoll()
	
	self.voting_rampage = false -- if bots will vote
	self.voting_channel = "#theme"
	
	self.choices_icons = {
							love.graphics.newImage("gfx/emoji/illusion.png"),
							love.graphics.newImage("gfx/emoji/earth.png"),
							love.graphics.newImage("gfx/emoji/one.png"),
							love.graphics.newImage("gfx/emoji/police_officer.png"),
							love.graphics.newImage("gfx/emoji/PikaPika.png")}
	
	--------- Scripts of bots
	
	self.scripts = {}
	
	self.isOpennedOnce = false
	
	self.open = false
	
	--------- Sounds
	self.notif_sound = love.audio.newSource("sfx/discord-notification.mp3","stream")
	self.notif_sound:setVolume(user.master_volume)
end
function Discord:addChannel(group,name)
	if not self.channels[group] then self.channels[group] = {};self.channels_order[#self.channels_order+1] = group end
	self.channels[group][name] = {text = {},new = false}
end
function Discord:afterInit()
	self.accounts[1].name = user.name

	local acc_count = #self.icons
	self:addAccount("LexLoco",self.icons[acc_count-1],{8,255,0})
	self:addAccount("theDrDevin",self.icons[acc_count],{8,255,0})
	
	self:addSpecialUser("WexDex",2)
	self:addSpecialUser("Soon",3)
	self:addSpecialUser("Kirito",5)
	self:addSpecialUser("LexLoco",#self.accounts-1)
	self:addSpecialUser("theDrDevin",#self.accounts)
	
	self:addAccount("Gravity",self.choices_icons[2])
	self:addSpecialUser("Gravity",#self.accounts)
	
	self.voting_poll:addChoice("Illusions",self.choices_icons[1])
	self.voting_poll:addChoice("Gravity",self.choices_icons[2])
	self.voting_poll:addChoice("One Chance",self.choices_icons[3])
	self.voting_poll:addChoice("Escape",self.choices_icons[4])
	self.voting_poll:addChoice("Meme",self.choices_icons[5])
	
	self.voting_poll:setMaxVotes(#self.accounts-3)
	local end_func = function(winner)
		local func2 = function(id,msg,delay) self:SendToChannel(id,"#announcements",msg) end
		local func4 = function(id,msg,delay)
			self:SendToChannel(id,"#announcements",msg)
			Main_Desktop:addApp("Jam2020",".exe","gfx/icons/UntitledGameJam.png",5,4,"GameJam")
			local jx,jy = Main_Desktop:getAppFromName("Jam2020")
			local jam = Main_Desktop:getAppAt(jx,jy)
			if jam then
				self.notifier:Notify(jam.icon,"New App added","Jam2020.exe was Added to your desktop!",nil,nil,4000)
			end
			
		end
		local func3 = function(id,msg,delay)
			self:SendToChannel(id,"#announcements",msg)
			local jx,jy = Main_Desktop:getAppFromName("Jam2020")
			local jam = Main_Desktop:getAppAt(jx,jy)
			if jam then
				if jam.window then
					if jam.window.content then
						jam.window.content:initScripts()
					end
				end
			end
		end
		
		local admin = ({self:getSpecialUser("LexLoco"),self:getSpecialUser("theDrDevin")})[math.random(1,2)]
		self.scripts.after_voting = CreateScript()
		
		
		self.scripts.after_voting:addMessage(admin,"Looks like the results of the chosen theme are in",7000,func2)
		self.scripts.after_voting:addMessage(admin,"The theme for the Untitled Game Jam #18 is ... Gravity.",3500,func2)
		self.scripts.after_voting:addMessage(admin,"Good Luck everyone Games submissions will be on the Jam2020.exe File!",5000,func2)
		
		self.scripts.after_voting:addMessage(admin,"The Jam2020.exe file is added to you Desktop",3000,func4)
		self.scripts.after_voting:addMessage(admin,"Go ahead and Join the jam then submit your game:",4000,func3)
		self.scripts.after_voting:setActive(true)
		self.voting_rampage = false
	end
	self.voting_poll:setEndFunction(end_func)
end
function Discord:initDemoEndScript()
	self.scripts.demo_end = CreateScript()
	self:addChannel("CREDITS","#credits")
	local func2 = function(id,msg,delay)
		local dev = self:getSpecialUser("WexDex")
		self.scripts.end_game = CreateScript()
		local func3 = function(id,msg,delay)
			Main_Desktop:addApp("Notepad++",".exe","gfx/icons/Notepad++.png")
			user.controllable_cursor = false;
			user.physics.body:setGravityScale(1)
			user.physics.body:setFixedRotation(false)
			user.physics.fixture:setCategory()
			user.physics.fixture:setMask()
			local dx,dy = Main_Desktop:getAppFromName("Discord")
			local discord = Main_Desktop:getAppAt(dx,dy)
			if discord then
				discord:Close()
			end
		end
		local func4 = function(id,msg,delay) Main_Desktop:setDarkhole(true) end
		for k = 1,30 do
			self.scripts.end_game:addMessage(dev,"",2,func3)
		end
		self.scripts.end_game:addMessage(dev,"",1000,func4)
		self.scripts.end_game:setActive(true)
	end
	local func = function(id,msg,delay)
		self:SendToChannel(id,"#credits",msg)
	end
	self.scripts.demo_end:setCallbackFunction(func)
	
	local dev = self:getSpecialUser("WexDex")
	local dev2 = self:getSpecialUser("Kirito")
	self.scripts.demo_end:addMessage(dev,"this was all for this demo, Really sorry",4000,func)
	self.scripts.demo_end:addMessage(dev,"i kinda went short on time and on managing time :(",3000,func)
	self.scripts.demo_end:addMessage(dev,self.memes[self.memes2["sorry.jpg"]],3000,func)
	self.scripts.demo_end:addMessage(dev,"Credit for co helping goes to @Kirito",3000,func)
	self.scripts.demo_end:addMessage(dev2,"Hey!",3000,func)
	self.scripts.demo_end:addMessage(dev2,"we hate gravity and physics that made it a bit hard to get ideas",3000,func)
	self.scripts.demo_end:addMessage(dev,"yes xDD",3000,func)
	self.scripts.demo_end:addMessage(dev,"credits for users avatars goes to the sub reddit",2500,func)
	self.scripts.demo_end:addMessage(dev2,"r/PixelArt",3500,func)
	self.scripts.demo_end:addMessage(dev2,"their Art is great!!",3000,func)
	self.scripts.demo_end:addMessage(dev,"anyways",3000,func)
	self.scripts.demo_end:addMessage(dev,"Thanks for Playing!",2500,func)
	self.scripts.demo_end:addMessage(dev2,self.memes[self.memes2["face_smaller.png"]],3000,func)
	self.scripts.demo_end:addMessage(dev,"",2000,func2)
	
	self.scripts.demo_end:setActive(true)
end
function Discord:createVotingScript()
	if not self.scripts.voting then
		self.scripts.voting = CreateScript()
	else
		self.scripts.voting:setPos(1)
	end
	local func = function(id,msg,delay) self:SendToChannel(id,"#theme",msg) end
	self.scripts.voting:setCallbackFunction(func)
	local users = {}
	local votes_gravity = 0
	for i = 2,#self.accounts-3 do
		users[#users+1] = i
	end
	local users_left = #users
	local final_votes = {0,0,0,0,0}
	
	for k = 1,#users do
		local vote = math.random(1,#self.voting_poll.choices)
		local r = math.random(1,#users)
		local voter = users[r]
		local highest = math.max(unpack(final_votes))
		
		if vote == 2 then -- Gravity always wins
			votes_gravity = votes_gravity + 1
		else
			if highest - votes_gravity + 1 >= users_left-2 then
				vote = 2
				votes_gravity = votes_gravity + 1
			end
		end
		users_left = users_left - 1
		self.scripts.voting:addMessage(voter,"!vote "..vote,({1,math.random(200,450)})[math.random(1,2)],func)
		final_votes[vote] = final_votes[vote] + 1
		table.remove(users,r)
	end
	self.scripts.voting:setActive(true)
end
function Discord:initScripts()
	self.scripts.welcome = CreateScript()
	local func = function(id,msg,delay) self:SendToChannel(id,"#welcome",msg) end
	local func2 = function(id,msg,delay) self:SendToChannel(id,"#announcements",msg) end
	local func4 = function(id,msg,delay) self:SendToChannel(id,"#theme",msg) end
	local func5 = function(id,msg,delay) self:SendToChannel(id,"#fun",msg) end
	local func3 = function(id,msg,delay) self:SendToChannel(id,"#announcements",msg) end
	local func6 = function(id,msg,delay)
			self.voting_poll:setTime(45000)
			self.voting_poll:setActive(true)
			self.voting_rampage = true
			self:createVotingScript()
	end
	
	local ad1 = self:getSpecialUser("LexLoco")
	local ad2 = self:getSpecialUser("theDrDevin")
	
	self.scripts.welcome:setCallbackFunction(func)
	self.scripts.welcome:addMessage(ad1,"Welcome @"..self.accounts[1].name.." !",2500,func)
	self.scripts.welcome:addMessage(ad2,"Welcome @"..self.accounts[1].name.." !",1500,func)
	self.scripts.welcome:addMessage(ad1,"Welcome to the Untitled Game Jam #18",3000,func)
	self.scripts.welcome:addMessage(ad1,"this is the @welcome channel where general talk is",4500,func)
	self.scripts.welcome:addMessage(ad1,"and this is the @fun channel where you can spen your time goofing with the squad @everyone",5000,func5)
	
	self.scripts.welcome:addMessage(ad1,"The theme will be announced based on some voting",8000,func)
	self.scripts.welcome:addMessage(ad1,"You can go ahead and vote in Channel @theme",3000,func)
	
	self.scripts.welcome:addMessage(ad1,"@"..self.accounts[1].name.." Here youll see all announcements, be sure to check it every now and then",3000,func2)
	self.scripts.welcome:addMessage(ad1,"the voting will start shortly",3500,func2)
	self.scripts.welcome:addMessage(ad2,"the suggested themes are : Illusions, Gravity, One Chance, Escape, Meme.",12000,func2)
	self.scripts.welcome:addMessage(ad2,"To vote simply write \"!vote number\" in the channel @theme ,change the number by the choice you want!",4000,func2)
	self.scripts.welcome:addMessage(ad2,"Voting ends in 45 Seconds. Good Luck",4000,func2)
	self.scripts.welcome:addMessage(ad2,"Votes start in 5!",3000,func2)
	self.scripts.welcome:addMessage(ad2,"4!",1000,func2)
	self.scripts.welcome:addMessage(ad2,"3!",1000,func2)
	self.scripts.welcome:addMessage(ad2,"2!",1000,func2)
	self.scripts.welcome:addMessage(ad2,"1!",1000,func2)
	self.scripts.welcome:addMessage(ad2,"Vote!",1000,func3)
	self.scripts.welcome:addMessage(ad2,"",1750,func6)
	self.scripts.welcome:setActive(true)
	-------------------------------------
end
function Discord:getSpecialUserAccount(name)
	return self.accounts[self.specialUsers[name]]
end
function Discord:getSpecialUser(name)
	return self.specialUsers[name]
end
function Discord:addSpecialUser(name,id)
	self.specialUsers[name] = id
end
function Discord:addIcon(path)
	system:addIcon(path)
	self.icons, self.accounts, self.memes, self.memes2 = system:getAssets()
end
function Discord:addAccount(name,avatar,color)
	system:addAccount(name,avatar,color)
	self.icons, self.accounts, self.memes, self.memes2 = system:getAssets()
end
function Discord:markRead(c)
	for i = 1,#self.channels_order do
		for k,v in pairs(self.channels[self.channels_order[i]]) do
			if k == c then
				self.channels[self.channels_order[i]][k].new = false
				break
			end
		end
	end
end
function Discord:keypressed(k)
	if k == "backspace" then
		local byteoffset = UTF8.offset(self.chat_text, -1)
		if byteoffset then
			self.chat_text = string.sub(self.chat_text, 1, byteoffset - 1)
		end
	elseif k == "return" then
		if self.chat_text ~= "" then
			self:SendToChannel(1,self.selected_channel,self.chat_text)
			self.chat_text = ""
		end
	end
end
function Discord:textinput(t)
	if #self.chat_text < self.max_text_size then
		self.chat_text = self.chat_text .. t
	end
end
function Discord:mousepressed(x,y)
	if self.hovered_channel ~= "" then
		self.selected_channel = self.hovered_channel
		for i = 1,#self.channels_order do
			for k,v in pairs(self.channels[self.channels_order[i]]) do
				if k == self.selected_channel then
					self.selected_group = self.channels_order[i]
					break
				end
			end
		end
		self:markRead(self.selected_channel)
	end
end
function Discord:update_(dt)
	if self.blinker_timer > 0 then
		self.blinker_timer = self.blinker_timer - 1000*dt
	else
		self.blinker_timer = self.blinker_timer_const
		self.blinker_value = (self.blinker_value + 1)%2 -- 0 for empty 1 for |
	end
	for k,v in pairs(self.scripts) do
		if v then
			v:update(dt)
		end
	end
	self.voting_poll:update(dt)
end
function Discord:onOpen()
	if not self.isOpennedOnce then
		self.icons, self.accounts, self.memes, self.memes2 = system:getAssets()
		self.isOpennedOnce = true
		self:afterInit()
		self:initScripts()
	end
end
function Discord:setStats(pos,size,open)
	self:update_stats(pos,size,open)
	
	self.chat_box.position.x = self.position.x + 175
	self.chat_box.position.y = self.position.y + 5
end
function Discord:addColorsToText(txt) -- add colors like @WexDex and taytay
	local result = {}
	
	local index = 1
	local m1,m2 = txt:find("@",index)
	if not (m1 and m2) then
		result = {{1,1,1},txt}
		index = #txt
	end
	while (m1 and m2) do
		result[#result+1] = {1,1,1}
		result[#result+1] = txt:sub(index,m1-1)
		result[#result+1] = {self.colors[4][1],self.colors[4][2],self.colors[4][3]}
		local next_space = txt:find(" ",m1)
		if next_space then
			result[#result+1] = txt:sub(m1,next_space)
			m1,m2 = txt:find("@",next_space+1)
			index = next_space
		else
			result[#result+1] = txt:sub(m1,#txt)
			index = #txt+1
			m1,m2 = nil,nil
		end
	end
	result[#result+1] = {1,1,1}
	result[#result+1] = txt:sub(index+1)
	return result
end
function Discord:onMessageSend(id,channel,message)
	if self.voting_rampage then -- a voting poll is running
		if type(message) == "string" then
			if message:sub(1,5) == "!vote" then
				if channel == self.voting_channel then
					local vote = tonumber(message:sub(6))
					if type(vote) == "number" then
						self.voting_poll:Vote(id,vote)
					else
						-- Syntax error
					end
				else
					if id == 1 then -- watn the player
						local admin = ({self:getSpecialUser("LexLoco"),self:getSpecialUser("theDrDevin")})[math.random(1,2)]
						local func = function(id,msg,delay) self:SendToChannel(id,channel,msg) end
						-- self:SendToChannel(admin,channel,"@"self.accounts[1].name)
						self.scripts.welcome:addMessage(admin,"@"..self.accounts[1].name.." you need to vote on the channel @theme by writing \"!vote n\"",1700,func,true)
						self.scripts.welcome:setActive(true)
					end
				end
			end
		end
	end
end
function Discord:SendToChannel(id,channel,message) -- id of the sender, message = string or Image
	for i = 1,#self.channels_order do
		for k,v in pairs(self.channels[self.channels_order[i]]) do
			if k == channel then
				self.channels[self.channels_order[i]][k].text[#self.channels[self.channels_order[i]][k].text+1] = {id=id,msg=message}
				self:onMessageSend(id,channel,message)
				if k ~= self.selected_channel then
					self.channels[self.channels_order[i]][k].new = true
				end
					if id ~= 1 then
						self.notif_sound:play()
						if not self.open then
							self.notifier:Notify(self.accounts[id].avatar,self.accounts[id].name.." ("..channel..")",message,self.app_name,self.app_icon,3500)
						else
							if channel ~= self.selected_channel then
								self.notifier:Notify(self.accounts[id].avatar,self.accounts[id].name.." ("..channel..")",message,self.app_name,self.app_icon,3500)								
							end
						end
					end
				break
			end
		end
	end
end
function Discord:wheelmoved(x,y)
	if y > 0 then -- wheel up
		self.chat_box.offset = self.chat_box.offset + self.chat_box.scroll_speed
	elseif y < 0 then
		self.chat_box.offset = self.chat_box.offset - self.chat_box.scroll_speed
	end
	local off = self.channels[self.selected_group][self.selected_channel].offset or 0
	self.chat_box.offset = math.clamp(self.chat_box.offset,0,-off)
end
function Discord:draw_chat()
	love.graphics.setColor(1,1,1,1)
	local height = 5
	local offset = self.channels[self.selected_group][self.selected_channel].offset or 0
	offset = offset + self.chat_box.offset
	love.graphics.setScissor(self.chat_box.position.x,self.chat_box.position.y,self.chat_box.size.x,self.chat_box.size.y)
	for i=1,#self.channels[self.selected_group][self.selected_channel].text do
		local x = self.chat_box.position.x + 50
		local y = self.chat_box.position.y + height + offset
		local name = self.accounts[self.channels[self.selected_group][self.selected_channel].text[i].id].name
		local wa = self.accounts[self.channels[self.selected_group][self.selected_channel].text[i].id].avatar:getWidth()
		local ha = self.accounts[self.channels[self.selected_group][self.selected_channel].text[i].id].avatar:getHeight()
		
		local stencil_func = function()
			love.graphics.circle("fill",x-25,y+20,20)
		end
		love.graphics.stencil(stencil_func)
		love.graphics.setStencilTest("greater",0)
		
		love.graphics.draw(self.accounts[self.channels[self.selected_group][self.selected_channel].text[i].id].avatar,x-45,y,0,40/wa,40/ha)
		love.graphics.setStencilTest()
		
		if name == "" then name = user.name end
		love.graphics.setFont(Font2)
		local ct = self.accounts[self.channels[self.selected_group][self.selected_channel].text[i].id].color
		local c = {ct[1]/255,ct[2]/255,ct[3]/255,1}
		love.graphics.setColor(c)
		love.graphics.printf(name,x,y,self.chat_box.size.x-55)
		love.graphics.setColor(1,1,1,1)
		love.graphics.setFont(Font1)
		height = height + 15
		
		y = self.chat_box.position.y + height + offset
		if type(self.channels[self.selected_group][self.selected_channel].text[i].msg) == "string" then
			local s,w = love.graphics.getFont():getWrap(self.channels[self.selected_group][self.selected_channel].text[i].msg,self.chat_box.size.x-55)
			local message_result = self:addColorsToText(self.channels[self.selected_group][self.selected_channel].text[i].msg)
			
			love.graphics.printf(message_result,x,y,self.chat_box.size.x-55)
			height = height + math.max(#w*20, 40)
		else
			if self.channels[self.selected_group][self.selected_channel].text[i].msg:typeOf("Image") then
				local sz = self.size.x - 430
				local img_s = self.channels[self.selected_group][self.selected_channel].text[i].msg
				local aw = img_s:getWidth()
				local ah = img_s:getHeight()
				local ascale = math.min(sz/aw,sz/ah)
				if aw <= sz then ascale = 1 end
				love.graphics.setColor(1,1,1,1)
				love.graphics.draw(img_s,x,y+10,0,ascale,ascale)
				height = height + math.max(ah*ascale+25, 40)
			end
		end
	end
	if height > self.chat_box.size.y then
		self.channels[self.selected_group][self.selected_channel].offset = self.chat_box.size.y - height
	end
	love.graphics.setScissor()
end
function Discord:draw_()
	love.graphics.setColor(self.colors[2])
	love.graphics.rectangle("fill",self.position.x,self.position.y,self.size.x,self.size.y)
	
	love.graphics.setColor(self.colors[1])
	love.graphics.rectangle("fill",self.position.x,self.position.y,170,self.size.y)
	love.graphics.rectangle("fill",self.position.x + self.size.x-170,self.position.y,170,self.size.y)
	
	self.voting_poll:draw(self.position.x + self.size.x-170,self.position.y)
	
	---- Channels
	love.graphics.setColor(1,1,1,1)
	love.graphics.setFont(Font2)
	love.graphics.print(self.server_name,self.position.x + 10,self.position.y + 15)
	local height = 0
	local mx, my = user:getMousePos()
	local found = false
	for i = 1,#self.channels_order do
		love.graphics.setColor(133/255,144/255,151/255,1)
		love.graphics.setFont(Font3)
		love.graphics.print("-"..self.channels_order[i],self.position.x + 5,self.position.y + 50 + height)
		height = height + 35
		love.graphics.setFont(Font1)
		for k,v in pairs(self.channels[self.channels_order[i]]) do
			local x = self.position.x + 15
			local y = self.position.y + 50 + height
			if mx + 6 >= x and mx + 6 <= x+160 and my + 10 >= y and my + 10 <= y+30 then
				found = true
				love.graphics.setColor(90/255,100/255,107/255,1)
				if v.new then
					love.graphics.setColor(130/255,140/255,147/255,1)
				end
				self.hovered_channel = k
			else
				if not found then
					self.hovered_channel = ""
				end
				love.graphics.setColor(57/255,60/255,67/255,1)
				if v.new then
					love.graphics.setColor(97/255,100/255,107/255,1)
				end
			end
			if self.selected_channel == k then
				love.graphics.setColor(130/255,140/255,147/255,1)
			end
			love.graphics.rectangle("fill",x - 10,y - 7,160,30,5)
			
			if v.new then
				love.graphics.setColor(1,1,1,1)
				self:draw_newMessageCircle(x-10,y+8)
			end
			if self.selected_channel == k then
				love.graphics.setColor(1,1,1,1)
				love.graphics.setFont(Font4)
			else
				love.graphics.setColor(133/255,144/255,151/255,1)
				love.graphics.setFont(Font3)
			end
			love.graphics.print(k,x,y)
			love.graphics.setFont(Font1)
			height = height + 35
		end
	end
	------- Chat Section
	love.graphics.setColor(self.colors[3])
	local x,y = self.position.x+175,self.position.y + self.size.y - 30
	love.graphics.rectangle("fill",x,y,self.size.x - 350,20)
	
	love.graphics.rectangle("fill",self.chat_box.position.x,self.chat_box.position.y,self.chat_box.size.x,self.chat_box.size.y)
	love.graphics.setScissor(x,y,self.size.x - 350,20)
	local blinker = ""
	if self.blinker_value == 1 then
		blinker = "|"
	end
	if self.chat_text ~= "" then
		love.graphics.setColor(1,1,1,1)
		love.graphics.print(self.chat_text..blinker,x+5,y+2)
	else
		love.graphics.setColor(1,1,1,1)
		love.graphics.print(blinker,x+5,y+2)
		love.graphics.setColor(0.6,0.6,0.6,0.6)
		love.graphics.print("Message "..self.selected_channel,x+5,y+2)
	end
	love.graphics.setScissor()
	self:draw_chat()
end
function Discord:draw_newMessageCircle(x,y)
	love.graphics.arc("fill",x,y,5,-math.pi/2,math.pi/2)
end

function CreateDiscord(x,y,w,h)
	local obj = Discord:new()
	obj:init(x,y,w,h)
	return obj
end