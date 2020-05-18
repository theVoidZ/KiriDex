--------------------- Animation --------------------
Animation = {}
Animation.__index = Animation

function Animation:new()
	local t = {}
	setmetatable(t,Animation)
	return t
end
function Animation:init()
	self.animations = {}
	self.texts = {}
	self.images = {}
	self.images[1] = love.graphics.newImage("gfx/animations/hit1/hit1.png")
	self.images[2] = love.graphics.newImage("gfx/animations/hit1/hit2.png")
	self.images[3] = love.graphics.newImage("gfx/animations/hit1/hit3.png")
end
function Animation:play_text(text,x,y,duration)
	self.texts[#self.texts+1] = {delay = duration,text=text,x=x,y=y,isAlive=true}
end
function Animation:play(x,y) -- count number of frames
	self.animations[#self.animations+1] = {frame = 1,delay = 100,isAlive = true,x=x,y=y}
end
function Animation:update(dt)
	for k,v in pairs(self.animations) do
		if v then
			if v.isAlive then
				if v.delay > 0 then
					self.animations[k].delay = self.animations[k].delay - 1000*dt
				else
					self.animations[k].delay = 100
					self.animations[k].frame = self.animations[k].frame + 1
					if self.animations[k].frame > 3 then
						self.animations[k].isAlive = false
						self.animations[k] = nil
					end
				end
			end
		end
	end
	for k,v in pairs(self.texts) do
		if v then
			if v.isAlive then
				if v.delay > 0 then
					self.texts[k].delay = self.texts[k].delay - 1000*dt
				else
					self.texts[k].isAlive = false
					self.texts[k] = nil
				end
			end
		end
	end
end
function Animation:draw()
	for k,v in pairs(self.animations) do
		if v then
			if v.isAlive then
				love.graphics.setColor(1,1,1,1)
				love.graphics.draw(self.images[v.frame],v.x,v.y)
			end
		end
	end
	for k,v in pairs(self.texts) do
		if v then
			if v.isAlive then
				love.graphics.setColor(1,1,1,1)
				love.graphics.setFont(font_fedora)
				local s,w = love.graphics.getFont():getWrap(v.text,1000)
				love.graphics.print(v.text,math.floor(v.x-s/2),v.y)
				love.graphics.setFont(font1)
			end
		end
	end
end
function CreateAnimation()
	local obj = Animation:new()
	obj:init()
	GameLoop:addObject(obj)
	Renderer:addToLayer("HUD",obj)
	return obj
end