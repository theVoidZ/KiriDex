--------------------- Menu --------------------
Menu = {}
Menu.__index = Menu

function Menu:new()
	local t = {}
	setmetatable(t,Menu)
	return t
end
function Menu:init()
	self.size = Vector(WIDTH/1.25, HEIGHT/1.25)
	self.position = Vector(WIDTH/2 - self.size.x/2,HEIGHT/2 - self.size.y/2)
	
	self.upgrades = {}
	
	self.icons = {}
	
	self.hovered = -1
	
	self.skillPoints = 1
	
	self.icons[#self.icons+1] = love.graphics.newImage("gfx/upgrades/Piercing.png")
	self.icons[#self.icons+1] = love.graphics.newImage("gfx/upgrades/Multishot.png")
	self.icons[#self.icons+1] = love.graphics.newImage("gfx/upgrades/FireRate.png")
	-- self.icons[#self.icons+1] = love.graphics.newImage("gfx/upgrades/Splitting.png")
	self.icons[#self.icons+1] = love.graphics.newImage("gfx/upgrades/Beam.png")
	self.icons[#self.icons+1] = love.graphics.newImage("gfx/upgrades/Shockwave.png")
	
	local pierce_func = function(lvl)
							for k,v in pairs(PLAYERS) do
								if v then
									v.bullets_pierce = true
								end
							end
						end
	
	local multishot_func = function(lvl)
								for k,v in pairs(PLAYERS) do
									if v then
										v.spread = lvl
									end
								end
							end
	
	local rate_func = function(lvl)
								for k,v in pairs(PLAYERS) do
									if v then
										v.rateOfFire_const = -50*lvl + 400
									end
								end
							end
	
	-- local splitting_func = function(lvl)
								-- for k,v in pairs(PLAYERS) do
									-- if v then
										-- v.splits = v.splits + 1
									-- end
								-- end
							-- end
	
	local beam_func = function(lvl)
								for k,v in pairs(PLAYERS) do
									if v then
										v.beam = true
									end
								end
							end
	
	local shock_func = function(lvl)
								for k,v in pairs(PLAYERS) do
									if v then
										v.shock = true
									end
								end
							end
							
	self:addUpgrade(self.icons[1],"Piercing",1,pierce_func)
	self:addUpgrade(self.icons[2],"Multishot",4,multishot_func)
	self:addUpgrade(self.icons[3],"FireRate",6,rate_func)
	-- self:addUpgrade(self.icons[4],"Splitting (Press : 1)",2,splitting_func)
	self:addUpgrade(self.icons[4],"Beam (Press : 2)",1,beam_func)
	self:addUpgrade(self.icons[5],"Shockwave (Press : 3)",1,shock_func)
end
function Menu:addUpgrade(icon,name,level_max,func)
	self.upgrades[#self.upgrades+1] = {icon=icon,name=name,level=0,level_max=level_max,func=func or function(lvl) end}
end

function Menu:mousepressed(x,y,b)
	if b == 1 then
		if self.hovered == -1 then
		elseif self.hovered == 0 then -- NEXT WAVE
			Level_Handler:nextLevel()
			GAMESTATE = "PLAYING"
		else -- UPGRADING
			local lvl = self.upgrades[self.hovered].level
			if lvl < self.upgrades[self.hovered].level_max and self.skillPoints > 0 then
				self.upgrades[self.hovered].level =  self.upgrades[self.hovered].level + 1
				self.upgrades[self.hovered].func(lvl+1)
				self.skillPoints = self.skillPoints - 1
			end
		end
	end
end
function Menu:update(dt)
end

function Menu:draw()
	love.graphics.setColor(0.2,0.2,0.2,1)
	love.graphics.rectangle("fill",self.position.x,self.position.y,self.size.x,self.size.y)
	glowShape(0.3,0.3,0.3, "rectangle", 8, self.position.x,self.position.y,self.size.x,self.size.y)
	
	local mx,my = love.mouse.getPosition()
	local found = false
	
	for i = 1,#self.upgrades do
		local v = self.upgrades[i]
		local x = self.position.x + 100
		local y = self.position.y + 20 + (i-1)*70
		love.graphics.setColor(1,1,1,1)
		love.graphics.draw(self.icons[i],x,y,0,40/32,40/32)
		glowShape(1, 1, 1, "rectangle", 8, x ,y, 40, 40)
		
		love.graphics.setColor(1,1,1,1)
		love.graphics.print(v.name,x+50,y)
		
		local ratio = v.level/v.level_max
		love.graphics.setColor(0.4,0.4,0.4,0.6)
		love.graphics.rectangle("fill",x+50,y+20,500,20)
		
		love.graphics.setColor(0,0.4,0,0.6)
		love.graphics.rectangle("fill",x+50,y+20,500*ratio,20)
		
		love.graphics.setColor(1,1,1,1)
		local s,w = love.graphics.getFont():getWrap(v.level.."/"..v.level_max,1000)
		love.graphics.print(v.level.."/"..v.level_max,math.floor(x+300-s/2),y+22)
		
		glowShape(0.6, 0.6, 0.6, "rectangle", 8, x+50 ,y+20, 500, 20)
		
		if pointInsideRect(mx,my,x+570,y+20,20,20) and v.level < v.level_max then
			love.graphics.setColor(0.6,0.6,0.6,0.6)
			found = true
			self.hovered = i
		else
			love.graphics.setColor(0.4,0.4,0.4,0.6)
			if not found then
				self.hovered = -1
			end
		end
		love.graphics.rectangle("fill",x+570,y+20,20,20)
		glowShape(0.6, 0.6, 0.6, "rectangle", 8, x+570 ,y+20, 20, 20)
		
		love.graphics.setColor(1,1,1,1)
		love.graphics.print("+",x+576,y+22)
	end
	
	local s2,w2 = love.graphics.getFont():getWrap("NEXT WAVE",1000)
	if not found then
		if pointInsideRect(mx,my,self.position.x+self.size.x/2-100 , self.position.y+self.size.y-60,200,40) then
			love.graphics.setColor(0.75,0.75,0.75,0.6)
			self.hovered = 0
			found = true
		else
			love.graphics.setColor(0.6,0.6,0.6,0.6)
			if not found then
				self.hovered = -1
			end
		end
	else
		love.graphics.setColor(0.6,0.6,0.6,0.6)
	end
	love.graphics.rectangle("fill",self.position.x+self.size.x/2-100 , self.position.y+self.size.y-60,200,40)
	love.graphics.setColor(1,1,1,1)
	love.graphics.print("NEXT WAVE",math.floor(self.position.x+self.size.x/2-s2/2),self.position.y+self.size.y-50)
	glowShape(1, 1, 1, "rectangle", 8, self.position.x+self.size.x/2-100 , self.position.y+self.size.y-60,200,40)
	love.graphics.setColor(1,1,1,1)
	
	local s3,w3 = love.graphics.getFont():getWrap("Skill Points : "..self.skillPoints,1000) 
	love.graphics.print("Skill Points : "..self.skillPoints,math.floor(self.position.x+self.size.x/2-s3/2),self.position.y+self.size.y-90)
	
end

function CreateMenu()
	local obj = Menu:new()
	obj:init()
	return obj
end