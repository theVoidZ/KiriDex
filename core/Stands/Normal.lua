--------------------- Normal --------------------
Normal = Projectile:new()
Normal.__index = Normal

function Normal:new()
	local t = {}
	setmetatable(t,Normal)
	return t
end
function Normal:init(x,y,r,img,ai)
	self.isAlive = true
	self.position = Vector(x,y)
	self.rotation = r
	
	self.image = img
	
	
	self.img_w = self.image:getWidth()
	self.img_h = self.image:getHeight()
	self.scale = 1
	
	self.isAI = ai
	
	self.speed = 700
	self.range = 50
	self.damage = 35
	
	self:updateHitbox()
end
function Normal:update_(dt)
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
				self.position.x = self.position.x - math.cos(self.rotation+math.pi/2)*self.speed*dt
				self.position.y = self.position.y - math.sin(self.rotation+math.pi/2)*self.speed*dt
				
				self.range = self.range - self.speed*dt
				if self:isOutOfBounds() then
					self.isAlive = false
					PROJECTILES[self.index] = nil
				end
			else
				self.isAlive = false
				PROJECTILES[self.index] = nil
			end
		end
	end
end
function Normal:draw_()
	if self.isAlive then
		love.graphics.setColor(1,1,1,1)
		local w = self.image:getWidth()
		local h = self.image:getHeight()
		love.graphics.draw(self.image,self.position.x,self.position.y,self.rotation,1,1,w/2,h/2)
	end
end

function CreateNormal(x,y,r,img,ai)
	local obj = Normal:new()
	obj:init(x,y,r,img,ai)
	obj.index = #PROJECTILES+1
	PROJECTILES[#PROJECTILES+1] = obj
	return obj
end