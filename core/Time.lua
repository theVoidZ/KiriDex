--------------------- Time --------------------
Time = {}
Time.__index = Time

TIMERS = {}

function Time:new()
	local t = {}
	setmetatable(t,Time)
	return t
end
function Time:init(x,y)
	self.exists = true
	self.x = math.floor(x) or 0
	self.y = math.floor(y) or 0
	self.img = love.graphics.newImage("gfx/Time.png")
	self.isPicked = false
	self.range = 0
	self.speed = 2000
	
	self.player_pickup_sounds = {}
	
	for i = 1,5 do
		self.player_pickup_sounds[i] = love.audio.newSource("sfx/time stop.wav","stream")
	end
end
function Time:update(dt)
	local dist = Distance(self.x,self.y,player.x,player.y)
	if dist <= 50 and not self.isPicked then
		self.isPicked = true
		local snd = math.random(1,#self.player_pickup_sounds)
		self.player_pickup_sounds[snd]:play()
		Level_Handler:StopTime(4000)
	end
	if self.isPicked then
		self.range = self.range + dt*self.speed
		if self.range > 2*math.max(WIDTH,HEIGHT) then
			self.exists = false
			TIMERS[self.index] = nil
			Level_Handler:setStencilFunction(nil)
		end
	end
end
function Time:draw()
	if not self.isPicked then
		love.graphics.setColor(1,1,1,1)
		love.graphics.draw(self.img,self.x,self.y)
	else
		local func = function()
			love.graphics.circle("fill",self.x,self.y,self.range)
		end
		Level_Handler:setStencilFunction(func)
	end
end

function CreateATime(x,y)
	local obj = Time:new()
	obj:init(x,y)
	obj.index = #TIMERS+1
	TIMERS[#TIMERS+1] = obj
	return obj
end