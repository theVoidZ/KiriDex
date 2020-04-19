--------------------- Obstacle --------------------
Obstacle = Solid:new()
Obstacle.__index = Obstacle

function Obstacle:new()
	local t = {}
	setmetatable(t,Obstacle)
	return t
end
function Obstacle:init(x,y,w,h,deadly,isFragile)
	self.isActive = true
	self.Collidable = true
	self.position = Vector(x,y)
	self.size = Vector(w,h)
	
	self.isFragile = isFragile
	
	self.respawn_time_const = 2000
	self.respawn_time = 0
	
	self.destroy_time_const = 1000
	self.destroy_time = 0
	
	self.willDie = false
	self.willRespawn = false
	
	self.isDeadly = deadly
	
	-- self.light_body = LightWorld:newPolygon(unpack(RectToPoly(self.position.x, self.position.y, self.size.x, self.size.y)))
end


function Obstacle:onCollide(id)
	if self.isFragile and not self.willDie then
		self.willDie = true
		self.destroy_time = self.destroy_time_const
	end
end

function Obstacle:update(dt)
	if self.willDie then
		if self.destroy_time > 0 then
			self.destroy_time = self.destroy_time - 1000*dt
		else
			self.destroy_time = 0
			self.Collidable = false
			self.willDie = false
			self.willRespawn = true
			self.respawn_time = self.respawn_time_const
		end
	elseif self.willRespawn then
		if self.respawn_time > 0 then
			self.respawn_time = self.respawn_time - 1000*dt
		else
			self.respawn_time = 0
			local canSpawn = true
			for k,v in pairs(ACTORS) do
				if v then
					if v.isActive then
						if doOverlap(self.position.x,self.position.y,self.position.x+self.size.x,self.position.y+self.size.y,v.position.x,v.position.y,v.position.x+v.size.x,v.position.y+v.size.y,true) then
							canSpawn = false
							break
						end
					end
				end
			end
			if canSpawn then
				self.Collidable = true
				self.willDie = false
				self.willRespawn = false
			else
				self.respawn_time = self.respawn_time_const*0.5
			end
		end
	end
end
function Obstacle:draw()
	if self.isActive then
		if self.isFragile then
			if self.Collidable then
				local a = self.destroy_time/self.destroy_time_const
				if not self.willDie then
					a = 1
				end
				love.graphics.setColor(0.6,0.6,0.6,a)
				love.graphics.rectangle("fill",self.position.x,self.position.y,self.size.x,self.size.y)
				love.graphics.setColor(0.85,0.85,0.9,a)
				love.graphics.rectangle("line",self.position.x,self.position.y,self.size.x,self.size.y)
				
			end
		end
		-- love.graphics.setColor(0.85,0.85,0.9,1)
		-- love.graphics.print(tostring(self.respawn_time),self.position.x,self.position.y)
	end
end

function CreateObstacle(x,y,w,h,deadly,isFragile)
	local obj = Obstacle:new()
	obj:init(x,y,w,h,deadly,isFragile)
	obj.index = #SOLIDS+1
	SOLIDS[#SOLIDS+1] = obj
	return obj
end