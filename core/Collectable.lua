--------------------- Collectable --------------------
Collectable = {}
Collectable.__index = Collectable

function Collectable:new()
	local t = {}
	setmetatable(t,Collectable)
	return t
end
function Collectable:init(img)
	self.isActive = true
	self.position = Vector(0,0)
	
	self.isCollected = false
	
	self.isRespawnable = false
	self.respawn_time_const = 5000
	self.respawn_time = 0
	
	self.image = img
	
	self.collect_target = "Human" -- Human / All / Enemies
	
	self.pick_range = 50
	self.hover_offset = 0
	self.onPickUp = function(id)
	end
end

function Collectable:onCollect(id)
	self.isCollected = true	
	if self.isRespawnable then
		self.respawn_time = self.respawn_time_const
	else
		self.isActive = false
	end
end

function Collectable:setPickFunction(func)
	self.onPickUp = func
end


function Collectable:update(dt)
	if self.isActive then
		self.hover_offset = math.cos(os.clock()*2.5)*5
		if not self.isCollected then
			for k,v in pairs(ACTORS) do
				if v then
					if v.isActive then
						-- if v.isHuman then
							local w = self.image:getWidth()
							local h = self.image:getHeight()
							local dist = Distance(self.position.x, self.position.y, v.position.x + v.size.x/2, v.position.y + v.size.y/2)
							if dist < self.pick_range then
								self.onPickUp(k)
								self:onCollect(k)
								break
							end
						-- end
					end
				end
			end
		else
			if self.isRespawnable then
				if self.respawn_time > 0 then
					self.respawn_time = self.respawn_time - 1000*dt
				else
					self.respawn_time = 0
					self.isCollected = false
				end
			end
		end
	end
end

function Collectable:draw()
	if self.isActive then
		local w = self.image:getWidth()
		local h = self.image:getHeight()
		if not self.isCollected then
			love.graphics.setColor(1,1,1,1)
			love.graphics.draw(self.image,self.position.x - w/2, self.position.y + self.hover_offset - h/2)
		else
			love.graphics.setColor(1,1,1,1)
			-- love.graphics.draw(self.image_alt,self.position.x - w/2, self.position.y + self.hover_offset - h/2)
			outlinerOnly:outline(0.6, 0.6, 0.6)
			outlinerOnly:draw(3, self.image, self.position.x - w/2, self.position.y + self.hover_offset - h/2)
			
			local ratio = self.respawn_time/self.respawn_time_const
			local stencil_func = function()
				love.graphics.rectangle("fill",self.position.x - w/2,self.position.y + h/2 + self.hover_offset,w,h*ratio-h)
			end
			love.graphics.stencil(stencil_func)
			love.graphics.setStencilTest("greater",0)
			
			love.graphics.draw(self.image,self.position.x - w/2, self.position.y + self.hover_offset - h/2)
			love.graphics.setStencilTest()
		end
	end
end

function CreateCollectable(img)
	local obj = Collectable:new()
	obj:init(img)
	return obj
end