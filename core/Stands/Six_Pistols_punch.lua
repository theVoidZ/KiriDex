--------------------- Six_Pistols_punch --------------------
Six_Pistols_punch = Projectile:new()
Six_Pistols_punch.__index = Six_Pistols_punch

function Six_Pistols_punch:new()
	local t = {}
	setmetatable(t,Six_Pistols_punch)
	return t
end
function Six_Pistols_punch:init(x,y,r,img,ai)
	self.isAlive = true
	self.position = Vector(x,y)
	self.rotation = r
	
	self.image = img
	
	self.damage = 25
	
	self.will_pierce = true
	self.last_hit = 0
	
	self.img_w = self.image:getWidth()
	self.img_h = self.image:getHeight()
	self.scale = 1
	
	self.will_bounce = true
	
	self.speed = 1500
	self.range = 300
	self.isAI = ai
	
	self:updateHitbox()
end
function Six_Pistols_punch:update_(dt)
	if self.isAlive then
		if self.isTimeChanged then
			if self.time_change_duration > 0 then
				self.time_change_duration = self.time_change_duration - 1000*dt
			else
				self.time_change_duration = 0
				self.time_factor = 1
				self.isTimeChanged = false
			end
		else
			if self.range > 0 then
				self:updateHitbox()
				self:updateCollision()
				self.position.x = self.position.x - math.cos(self.rotation+math.pi/2)*self.speed*dt * self.time_factor
				self.position.y = self.position.y - math.sin(self.rotation+math.pi/2)*self.speed*dt * self.time_factor
				
				self.range = self.range - self.speed*dt * self.time_factor
				if self:isOutOfBounds() then
					self.isAlive = false
					PROJECTILES[self.index] = nil
				end
			else
				if self.will_bounce then
					local rot = self.rotation+math.pi
					if not self.isAI then
						local min_dist = math.huge
						local min_target = 0
						for k,v in pairs(ENEMIES) do
							if v then
								if v.isAlive then
									local dist = Distance(self.position.x,self.position.y,v.position.x,v.position.y)
									if dist < min_dist then
										min_dist = dist
										min_target = v.index
									end
								end
							end
						end
						if min_target ~= 0 then
							rot = Angle(self.position.x,self.position.y,ENEMIES[min_target].position.x,ENEMIES[min_target].position.y)+math.pi/2
						end
					else
						rot = Angle(self.position.x,self.position.y,PLAYERS[1].position.x,PLAYERS[1].position.y)+math.pi/2
					end
					local nb = CreateSix_Pistols_punch(self.position.x,self.position.y,rot,self.image,self.isAI)
					nb.will_bounce = false
				end
				self.isAlive = false
				PROJECTILES[self.index] = nil
			end
		end
	end
end
function Six_Pistols_punch:draw_()
	if self.isAlive then
		love.graphics.setColor(1,1,1,1)
		local w = self.image:getWidth()
		local h = self.image:getHeight()
		love.graphics.draw(self.image,self.position.x,self.position.y,self.rotation,1,1,w/2,h/2)
	end
end

function CreateSix_Pistols_punch(x,y,r,img,ai)
	local obj = Six_Pistols_punch:new()
	obj:init(x,y,r,img,ai)
	obj.index = #PROJECTILES+1
	PROJECTILES[#PROJECTILES+1] = obj
	return obj
end