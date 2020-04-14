--------------------- DeathAnimator --------------------
DeathAnimator = {}
DeathAnimator.__index = DeathAnimator

function DeathAnimator:new()
	local t = {}
	setmetatable(t,DeathAnimator)
	return t
end
function DeathAnimator:init()
	self.anims = {}
	self.range_const = 80
	self.delay_const = 1000
	self.speed = 700
	self.rotation_speed = 1
	self.start_const = 620
end

function DeathAnimator:playAt(x,y,color,color2,skip_intro_effect,id) -- Actor id / intro_effect : if the first explosion is included
	table.insert(self.anims,{rot=0,sx=x,sy=y,x=x,y=y,color=color,color2=color2,delay=self.delay_const,range=self.range_const,phase=1,time_to_start=self.start_const}) -- phase 1 : explosion, phase 2 : circles arounds slowly
	self.anims[#self.anims].direction = Vector(2*math.random()-1,-math.random())
	self.anims[#self.anims].id = id or 0
	if skip_intro_effect then
		-- self.anims[#self.anims].phase = 2
		self.anims[#self.anims].time_to_start = 0
	end
end	

function DeathAnimator:update(dt)
	for i = #self.anims,1,-1 do
		if self.anims[i] then
			if self.anims[i].time_to_start > 0 then
				self.anims[i].time_to_start = self.anims[i].time_to_start - 1000*dt
				local r = math.random(400,1000)
				local x = self.anims[i].sx + math.cos(self.anims[i].direction.angle)*(r*dt)*self.anims[i].time_to_start/self.start_const
				local y = self.anims[i].sy + math.sin(self.anims[i].direction.angle)*(r*dt)*self.anims[i].time_to_start/self.start_const
				self.anims[i].sx = x
				self.anims[i].sy = y
				self.anims[i].x = x
				self.anims[i].y = y
			else
				self.anims[i].time_to_start = 0
				if self.anims[i].phase == 1 then
					if self.anims[i].range > 0 then
						self.anims[i].range = math.max(self.anims[i].range - self.speed*dt,0)
					else
						self.anims[i].phase = 2
					end
				elseif self.anims[i].phase == 2 then
					self.anims[i].rot = self.anims[i].rot + dt*self.rotation_speed
					if self.anims[i].delay > 0 then
						self.anims[i].delay = self.anims[i].delay - 1000*dt
					else
						self.anims[i].delay = 0
						if self.anims[i].id ~= 0 then
							if ACTORS[self.anims[i].id] then
								ACTORS[self.anims[i].id]:onDeathEnd(self.anims[i].sx,self.anims[i].sy)
							end
						end
						table.remove(self.anims,i)
					end
				end
				if self.anims[i] then
					local x = self.anims[i].sx + math.cos(self.anims[i].rot)*(self.range_const-self.anims[i].range)
					local y = self.anims[i].sy + math.sin(self.anims[i].rot)*(self.range_const-self.anims[i].range)
					self.anims[i].x = x
					self.anims[i].y = y
				end
			end
		end
	end
end
function DeathAnimator:draw()
	for i = #self.anims,1,-1 do
		if self.anims[i] then
			if self.anims[i].time_to_start > 0 then
				love.graphics.setColor(self.anims[i].color.r,self.anims[i].color.g,self.anims[i].color.b,1)
				local x = self.anims[i].sx
				local y = self.anims[i].sy
				
				local ratio = self.anims[i].time_to_start/self.start_const
				
				love.graphics.circle("fill", x, y, 10 + (1-ratio)*10)
				love.graphics.setColor(0,0,0,1)
				love.graphics.circle("line", x, y, 10 + (1-ratio)*10)
			else
				for a = 1,8 do
					if self.anims[i].phase == 1 then
						love.graphics.setColor(self.anims[i].color.r,self.anims[i].color.g,self.anims[i].color.b,1)
					else
						love.graphics.setColor(self.anims[i].color2.r,self.anims[i].color2.g,self.anims[i].color2.b,1)
					end
					local ang = math.pi/4*a + self.anims[i].rot
					local x = self.anims[i].sx + math.cos(ang)*(self.range_const-self.anims[i].range)
					local y = self.anims[i].sy + math.sin(ang)*(self.range_const-self.anims[i].range)
					
					love.graphics.circle("fill", x, y, 12)
					love.graphics.setColor(0,0,0,1)
					love.graphics.circle("line", x, y, 12)
				end
				if self.anims[i].phase == 2 then
					love.graphics.setColor(self.anims[i].color2.r,self.anims[i].color2.g,self.anims[i].color2.b,(self.anims[i].delay)/self.delay_const/4)
					local x = self.anims[i].sx
					local y = self.anims[i].sy
					
					-- love.graphics.setColor(0,0,0,1)
					love.graphics.circle("line", x, y, 12 + (self.range_const - self.anims[i].range))
				end
			end
		end
	end
end


function CreateDeathAnimator()
	local obj = DeathAnimator:new()
	obj:init()
	GameLoop:addObject(obj)
	return obj
end