local class = require 'libs.middleclass'

Menu = class('Menu')

function Menu:initialize()
	self.play_img = love.graphics.newImage("gfx/Play.png")
	self.play_img:setFilter("nearest")
	self.isHovered = false
	self.img_w = self.play_img:getWidth()
	self.img_h = self.play_img:getHeight()
	self.scale = 1
end

function Menu:mousepressed(x,y,b)
	if b == 1 then
		GAMESTATE = "PLAYING"
		MapHandler:SelectLevel(1)
	end
end
function Menu:keypressed(key)
	
end
function Menu:update(dt)
	local mx,my = love.mouse.getPosition()
	local old = self.isHovered
	self.isHovered = pointInsideRect(mx,my,WIDTH/2-self.img_w/2,HEIGHT/2-self.img_h/2,self.img_w,self.img_h)
	if old ~= self.isHovered then
		if old then -- mean mouse out
			Flux.to(self,0.5,{scale = 1}):ease("backinout")
		else
			Flux.to(self,0.5,{scale = 1.3}):ease("backinout")
		end
	end
end

function Menu:draw()
	love.graphics.setColor(1,1,1,1)
	local s = self.scale
	love.graphics.draw(self.play_img,WIDTH/2,HEIGHT/2,0,s,s,self.img_w/2,self.img_h/2)
end