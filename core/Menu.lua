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
	self.cell_size = Vector(150,220)
	
	self.graph = CreateCircle_graph()
end
function Menu:update(dt)

end
function Menu:mousepressed(x,y,b)
	if self.hovered > 0 then
		PLAYERS[1].stands[PLAYERS[1].current_stand]:setActive(false)
		PLAYERS[1].current_stand = self.hovered
		PLAYERS[1].stands[PLAYERS[1].current_stand]:setActive(true)
		Level_Handler:nextLevel()
		GAMESTATE = "PLAYING"
	end
end
function Menu:draw()
	love.graphics.setColor(0.2,0.2,0.2,1)
	love.graphics.rectangle("fill",self.position.x,self.position.y,self.size.x,self.size.y)
	glowShape(0.3,0.3,0.3, "rectangle", 8, self.position.x,self.position.y,self.size.x,self.size.y)
	
	local width = 0
	local height = 0
	local found = false
	local mx,my = love.mouse.getPosition()
	for i = 1 ,#PLAYERS[1].stands do
		if width > self.size.x - 20 then
			height = height + self.cell_size.y + 10
			width = 0
		end
		local x = self.position.x + 10 + width
		local y = self.position.y + 10 + height
		local v = PLAYERS[1].stands[i]
		
		if pointInsideRect(mx,my,x,y,self.cell_size.x,self.cell_size.y) then
			love.graphics.setColor(0.2,0.2,0.2,1)
			found = true
			self.hovered = i
			self.graph:setStats(v.stats[1],v.stats[2],v.stats[3],v.stats[4],v.stats[5],v.stats[6])
			love.graphics.rectangle("fill",10,HEIGHT-200,200,200)
			self.graph:draw(10,HEIGHT-200)
			glowShape(0.4,0.4,0.4, "rectangle", 8, 10,HEIGHT-200,200,200)
			love.graphics.setColor(0.4,0.4,0.4,1)
		else
			love.graphics.setColor(0.2,0.2,0.2,0.6)
			if not found then
				self.hovered = -1
			end
		end
		love.graphics.rectangle("fill",x,y,self.cell_size.x,self.cell_size.y)
		glowShape(0.7,0.7,0.7, "rectangle", 8, x,y,self.cell_size.x,self.cell_size.y)
		love.graphics.setColor(1,1,1,1)
		
		love.graphics.draw(PLAYERS[1].player_image,x+50+12,y+20+12)
		love.graphics.draw(v.stand_image,x+50,y+20)
		
		love.graphics.setColor(1,0,0,1)
		love.graphics.printf(v.name,x+5,y+75,self.cell_size.x)
		
		love.graphics.setColor(1,1,1,1)
		love.graphics.print("Right Click :",x+5,y+120)
		love.graphics.setColor(0,1,0,1)
		love.graphics.print(v.special_desc,x+5,y+135)
		
		love.graphics.setColor(1,1,1,1)
		love.graphics.print("Space :",x+5,y+155)
		love.graphics.setColor(0,1,0,1)
		love.graphics.print(v.ultimate_desc,x+5,y+170)
		
		width = width + self.cell_size.x + 10
	end
end
function CreateMenu()
	local obj = Menu:new()
	obj:init()
	return obj
end