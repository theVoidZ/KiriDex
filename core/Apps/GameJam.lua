--------------------- GameJam --------------------
GameJam = Content:new()
GameJam.__index = GameJam

function GameJam:new()
	local t = {}
	setmetatable(t,GameJam)
	return t
end
function GameJam:init(x,y,w,h)
	self.active = true
	self.position = Vector(x,y)
	self.size = Vector(w,h)
	
	self.phase = "register"
	
	self.memes = {}
	self.memes2 = {}
	
	self.images = {}
	self.images.logo = love.graphics.newImage("gfx/untitledGJ.png")
	
	self.entries = 0 -- maybe make it a table? no ?
	self.submissions = 0
	
	self.isOpennedOnce = false
	self.open = false
	self.scripts = {}
	self.canvas = love.graphics.newCanvas(w,h)
	
	self.game_name_text = ""
	
	self.blinker_timer_const = 700
	self.blinker_timer = 0
	self.blinker_value = 1
	
	self.gravity_applied = false
	self.isSubmitting = false
	
	self.files_to_submit = love.filesystem.getDirectoryItems("")
	self.files_to_submit[#self.files_to_submit+1] = "Gravity"
	self.submit_index = 1
	self.submit_delay_const = #self.files_to_submit * 2000
	self.submit_delay = self.submit_delay_const / #self.files_to_submit
	self.submit_will_fail = false
	self.submit_progess = 0
	self.gravity_triggered = false
	
end
function GameJam:initScripts()
	self.icons, self.accounts, self.memes,self.memes2 = system:getAssets()
	self.scripts.joining = CreateScript()
	local func = function (id,delay,msg)
		self:Join()
		if math.random(1,2) == 1 then
			self:Submit()
		end
	end
	self.scripts.joining:addMessage(2,"",3000,func)
	for k = 3,#self.accounts-3 do
		self.scripts.joining:addMessage(k,"",math.random(0,300),func)
	end
	self.scripts.joining:setActive(true)
	
end
function GameJam:setActive(active)
	self.active = active
end
function GameJam:Submit()
	self.submissions = self.submissions + 1
end
function GameJam:Join()
	self.entries = self.entries + 1
end
function GameJam:onOpen()
	if not self.isOpennedOnce then
		self.icons, self.accounts, self.memes,self.memes2 = system:getAssets()
		self.isOpennedOnce = true
		-- self.phase = "register"
	end
end
function GameJam:setStats(pos,size,open)
	self:update_stats(pos,size,open)
end
function GameJam:mousepressed(x,y)
	if self.phase == "register" then
		if x >= self.position.x+self.size.x-250 and x <= self.position.x+self.size.x-50 and 
			y >= self.position.y+self.size.y/2-25 and y <= self.position.y+self.size.y/2+25 then
			self:Join()
			self.phase = "submission"
		end
	elseif self.phase == "submission" and not self.isSubmitting then
		if self.game_name_text ~= "" then
			if x >= self.position.x+self.size.x-200 and x <= self.position.x+self.size.x-100 and 
				y >= self.position.y+self.size.y-75 and y <= self.position.y+self.size.y-25 then
				if not self.gravity_triggered then
					self.isSubmitting = true
					self.gravity_triggered = true
				end
			end
		end
	end
end
function GameJam:onSubmitAttempt() -- on the Actual submit
	self.icons, self.accounts, self.memes,self.memes2 = system:getAssets()
	self.scripts.gravity_first_appear = CreateScript()
	
	local dx,dy = Main_Desktop:getAppFromName("Discord")
	local discord = Main_Desktop:getAppAt(dx,dy)
	local gr = #self.accounts
	local func = function(id,msg,delay)
		local dx,dy = Main_Desktop:getAppFromName("Discord")
		local discord = Main_Desktop:getAppAt(dx,dy)
		if discord then
			if discord.window then
				if discord.window.content then
					discord.window.content:SendToChannel(id,"#gravity",msg)
				end
			end
		end
	end
	local func2 = function(id,msg,delay)
		func(id,msg,delay)
		Main_Desktop:addApp("Notepad++",".exe","gfx/icons/Notepad++.png",2,2,"Notepad")
		local jx,jy = Main_Desktop:getAppFromName("Notepad++")
		local note = Main_Desktop:getAppAt(jx,jy)
		local dx,dy = Main_Desktop:getAppFromName("Discord")
		local discord = Main_Desktop:getAppAt(dx,dy)
		if discord then
			if discord.window then
				if discord.window.content then
					if note then
						discord.window.content.notifier:Notify(note.icon,"New App added","Notepad++.exe was Added to your desktop!",nil,nil,4000)
						note.window.content:setGravity()
						if not note.window.content.isFinished then
							note.window.content.minigame = true
						end
					end
				end
			end
		end
	end
	if discord then
		if discord.window then
			if discord.window.content then
				discord.window.content:addChannel("GAME JAM","#gravity")
				self.scripts.gravity_first_appear:addMessage(gr,"Hello @"..self.accounts[1].name,2500,func)
				self.scripts.gravity_first_appear:addMessage(gr,"Having troubles subbmitting your game?",4000,func)
				self.scripts.gravity_first_appear:addMessage(gr,"Well, of course",3500,func)
				self.scripts.gravity_first_appear:addMessage(gr,"you've been playing for couple minutes, and guess what",3500,func)
				self.scripts.gravity_first_appear:addMessage(gr,"THERE",5000,func)
				self.scripts.gravity_first_appear:addMessage(gr,"IS",750,func)
				self.scripts.gravity_first_appear:addMessage(gr,"NO",750,func)
				self.scripts.gravity_first_appear:addMessage(gr,"GRAVITY",1000,func)
				self.scripts.gravity_first_appear:addMessage(gr,"RELATED",1000,func)
				self.scripts.gravity_first_appear:addMessage(gr,"GAMEPLAY",1000,func)
				self.scripts.gravity_first_appear:addMessage(gr,"So i thought i'd give you a hand in achieving that",4500,func)
				self.scripts.gravity_first_appear:addMessage(gr,self.memes[self.memes2["no need to thank me.jpg"]],3500,func)
				self.scripts.gravity_first_appear:addMessage(gr,"Anyways let's get into it.",4500,func)
				self.scripts.gravity_first_appear:addMessage(gr,"i've Added Notepad++ as a simple one",2500,func2)
				self.scripts.gravity_first_appear:addMessage(gr,"it's Notepad alright but,i gave it a little twist",3000,func)
				self.scripts.gravity_first_appear:addMessage(gr,"try to write the name of the incoming enemies to kill them",2000,func)
				self.scripts.gravity_first_appear:addMessage(gr,"good luck",2000,func)
				self.scripts.gravity_first_appear:addMessage(gr,"i guess",500,func)
				
				self.scripts.gravity_first_appear:setActive(true)
			end
		end
	end
end
function GameJam:onEndGame(name)
	if name == "Notepad++" then
		self.scripts.second_game = CreateScript()
		local dx,dy = Main_Desktop:getAppFromName("Discord")
		local discord = Main_Desktop:getAppAt(dx,dy)
		local gr = #self.accounts
		local func = function(id,msg,delay)
			local dx,dy = Main_Desktop:getAppFromName("Discord")
			local discord = Main_Desktop:getAppAt(dx,dy)
			if discord then
				if discord.window then
					if discord.window.content then
						discord.window.content:SendToChannel(id,"#gravity",msg)
					end
				end
			end
		end
		local func2 = function(id,msg,delay)
			Main_Desktop:addApp("FallIt",".exe","gfx/icons/Fall the ball.png",2,5,"FallIt")
			local jx,jy = Main_Desktop:getAppFromName("FallIt")
			local fall = Main_Desktop:getAppAt(jx,jy)
			local dx,dy = Main_Desktop:getAppFromName("Discord")
			local discord = Main_Desktop:getAppAt(dx,dy)
			if discord then
				if discord.window then
					if discord.window.content then
						discord.window.content:SendToChannel(id,"#gravity",msg)
						discord.window.content.notifier:Notify(fall.icon,"New App added","Fall it.exe was Added to your desktop!",nil,nil,4000)
					end
				end
			end
		end
		
		self.scripts.second_game:addMessage(gr,"Well, well, well.",6000,func)
		self.scripts.second_game:addMessage(gr,"That was impressive!",3500,func)
		self.scripts.second_game:addMessage(gr,"and gravity related!",2500,func)
		self.scripts.second_game:addMessage(gr,"what?",3500,func)
		self.scripts.second_game:addMessage(gr,"you didn't see the falling letters????",3000,func)
		self.scripts.second_game:addMessage(gr,"that's was like the best part",3000,func)
		self.scripts.second_game:addMessage(gr,"Dude go back, write some thing",3000,func)
		self.scripts.second_game:addMessage(gr,"and move mouse over it",1500,func)
		self.scripts.second_game:addMessage(gr,"you miseed the fun",1500,func)
		self.scripts.second_game:addMessage(gr,"...",1000,func)
		
		---- onto next game
		self.scripts.second_game:addMessage(gr,"okay lets get to the next one",8000,func)
		self.scripts.second_game:addMessage(gr,"this one is gravity related 101%",3000,func)
		self.scripts.second_game:addMessage(gr,"there you go, go try this now",3000,func2)
		self.scripts.second_game:addMessage(gr,"use arrows left/right to move and get to the bottom",3000,func)
		
		self.scripts.second_game:setActive(true)
	end
end
function GameJam:update_(dt)
	for k,v in pairs(self.scripts) do
		if v then
			v:update(dt)
		end
	end
	if self.blinker_timer > 0 then
		self.blinker_timer = self.blinker_timer - 1000*dt
	else
		self.blinker_timer = self.blinker_timer_const
		self.blinker_value = (self.blinker_value + 1)%2 -- 0 for empty 1 for |
	end
	if self.isSubmitting then
		if self.submit_delay > 0 and not self.submit_will_fail then
			self.submit_delay = self.submit_delay - 1000*dt
			self.submit_progess = math.clamp(self.submit_progess + 0.5/#self.files_to_submit*dt,0,0.98)
		else
			if self.submit_index < #self.files_to_submit and not self.submit_will_fail then
				self.submit_index = self.submit_index + 1
				self.submit_delay = self.submit_delay_const / #self.files_to_submit
			elseif self.submit_index == #self.files_to_submit then
				self.submit_will_fail = true
			end
		end
		if self.submit_will_fail then
			self.submit_delay = 1
			self.submit_progess = math.clamp(self.submit_progess - 8/#self.files_to_submit*dt,0,0.98)
			if self.submit_progess == 0 then
				self.isSubmitting = false
				self:onSubmitAttempt()
			end
		end
	end
end
function GameJam:keypressed(k)
	if k == "backspace" then
		local byteoffset = UTF8.offset(self.game_name_text, -1)
		if byteoffset then
			self.game_name_text = string.sub(self.game_name_text, 1, byteoffset - 1)
		end
	end
end
function GameJam:textinput(t)
	if self.phase == "submission" and not self.gravity_applied then
		self.game_name_text = self.game_name_text .. t
	end
end
function GameJam:draw_canvas()
	love.graphics.setCanvas(self.canvas)
		love.graphics.clear()
		love.graphics.setColor(1,1,1,1)
		local x = 0
		local y = 0
		local w = self.images.logo:getWidth()
		local h = self.images.logo:getHeight()
		love.graphics.draw(self.images.logo,x,y,0,1,1)
		if self.phase == "register" then
			love.graphics.setColor(1,36/255,73/255,1)
			local mx, my = user:getMousePos()
			if mx >= x+self.position.x+self.size.x-250 and mx <= x+self.position.x+self.size.x-50 and 
			my >= y+self.position.y+self.size.y/2-25 and my <= y+self.position.y+self.size.y/2+25 then
				love.graphics.setColor(1,76/255,113/255,1)
			end
			
			love.graphics.rectangle("fill",x+self.size.x-250,y+self.size.y/2-25,200,50,5)
			love.graphics.setColor(1,1,1,1)
			love.graphics.setFont(Font4)
			local s,w = love.graphics.getFont():getWrap("Join Jam",500)
			love.graphics.print("Join Jam",math.floor(x+self.size.x-150 - s/2),y+self.size.y/2-9)
		else
			love.graphics.setColor(1,36/255,73/255,1)
			local mx, my = user:getMousePos()
			if mx >= x+self.position.x+self.size.x-200 and mx <= x+self.position.x+self.size.x-50 and 
			my >= y+self.position.y+self.size.y-75 and my <= y+self.position.y+self.size.y-25 then
				love.graphics.setColor(1,76/255,113/255,1)
			end
			
			love.graphics.rectangle("fill",x+self.size.x-200,y+self.size.y-75,150,50,5)
			love.graphics.setColor(1,1,1,1)
			love.graphics.setFont(Font4)
			local s,w = love.graphics.getFont():getWrap("Submit Game",500)
			love.graphics.print("Submit Game",math.floor(x+self.size.x-125 - s/2),y+self.size.y-59)
			
			local blinker = ""
			if self.blinker_value == 1 then
				blinker = "|"
			end
			local s2,w2 = love.graphics.getFont():getWrap(user.name,1000)
			local s3,w3 = love.graphics.getFont():getWrap(self.game_name_text,1000)
			local s4,w4 = love.graphics.getFont():getWrap("Username :",1000)
			local s5,w5 = love.graphics.getFont():getWrap("Game Title :",1000)
			
			local rect2_width = math.max(100,s2+20)
			local rect3_width = math.max(100,s3+20)
			
			
			love.graphics.rectangle("fill",x+self.size.x/2-rect2_width/2,y+self.size.y/2+35,rect2_width,25)
			love.graphics.rectangle("fill",x+self.size.x/2-rect3_width/2,y+self.size.y/2+70,rect3_width,25)
			
			love.graphics.setColor(0,0,0,1)
			love.graphics.print(user.name,math.floor(x+self.size.x/2 - s2/2),y+self.size.y/2+40)
			if self.game_name_text ~= "" then
				love.graphics.print(self.game_name_text..blinker,math.floor(x+self.size.x/2 - s3/2),y+self.size.y/2+75)
			else
				love.graphics.setColor(0.6,0.6,0.6,0.6)
				local s420,w420 = love.graphics.getFont():getWrap("WRITE",1000)
				love.graphics.print("WRITE",math.floor(x+self.size.x/2 - s420/2),y+self.size.y/2+75)
				love.graphics.setColor(0,0,0,1)
				love.graphics.print(blinker,math.floor(x+self.size.x/2 - s420/2),y+self.size.y/2+75)
			end
			love.graphics.setColor(1,1,1,1)
			love.graphics.print("User Name :",math.floor(x+self.size.x/2-rect2_width/2 - s4 - 10),y+self.size.y/2+40)
			love.graphics.print("Game Title :",math.floor(self.size.x/2-rect3_width/2 - s5 - 10),y+self.size.y/2+75)
			----------------------------
			if self.isSubmitting then
				love.graphics.setColor(90/255,230/255,83/255,1)
				local h = self.submit_progess
				love.graphics.rectangle("fill",x+self.size.x-150,y-75+self.size.y-h*(self.size.y-150),50,h*(self.size.y-150))
				love.graphics.setColor(0,0,0,1)
				love.graphics.print("Uploading ...",x+self.size.x-150,y+25)
				love.graphics.print(self.files_to_submit[self.submit_index],x+self.size.x-150,y+50)
				love.graphics.rectangle("line",x+self.size.x-150,y+75,50,self.size.y-150)
			end
			
		end
		love.graphics.setFont(Font5)
		love.graphics.setColor(0,0,0,1)
		love.graphics.print("Entries : "..self.entries,x+20,y+self.size.y/3)
		love.graphics.print("Submissions : "..self.submissions,x+20,y+self.size.y/3+25)
		love.graphics.print("Theme : GRAVITY",x+20,y+self.size.y/3+50)
		love.graphics.setFont(Font1)
	love.graphics.setCanvas()
end
function GameJam:draw_()
	self:draw_canvas()
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(self.canvas,self.position.x,self.position.y)
end

function CreateGameJam(x,y,w,h)
	local obj = GameJam:new()
	obj:init(x,y,w,h)
	return obj
end