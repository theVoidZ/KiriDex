--------------------- Bullet --------------------
Bullet = {}
Bullet.__index = Bullet

BULLETS = {}

function Bullet:new()
	local t = {}
	setmetatable(t,Bullet)
	return t
end
function Bullet:init(x,y,ang,color,player,willPierce) -- color : {r=r,g=g,b=b}
	self.exists = true
	self.color = color
	self.x = x
	self.y = y
	self.rotation = ang
	self.speed = 1000
	self.player = player -- boolean
	self.size = 15
	
	self.willPierce = willPierce
end
function Bullet:draw()
	if self.exists then
		local x = self.x + math.cos(self.rotation) * self.size
		local y = self.y + math.sin(self.rotation) * self.size
		glowShape(self.color.r, self.color.g, self.color.b, "line", 8, self.x, self.y, x, y)
	end
end
function Bullet:updateCollision()
	if self.player then -- the shooter is the player
		for k,v in pairs(ENEMIES) do
			if v then
				local dist = Distance2(self.x,self.y,v.x,v.y)
				if dist <= 10000 then
					if not v.isDying and not v.isSpawning then
						if pointInPolygon( v.hitbox, {x=self.x + math.cos(self.rotation) * self.size/2,y=self.y + math.sin(self.rotation) * self.size/2} ) then
							Level_Handler:Enemy_hit(v.index)
							if not self.willPierce then
								self.exists = false
								BULLETS[self.index] = nil
							end
						end
					end
				end
			end
		end
	end
end
function Bullet:update(dt)
	if self.exists then
		local x = self.x + math.cos(self.rotation) * self.speed*dt
		local y = self.y + math.sin(self.rotation) * self.speed*dt
		self:updateCollision()
		self.x = x
		self.y = y
		-- self:updateCollision()
		if self:isOutOfBounds() then
			self.exists = false
			BULLETS[self.index] = nil
		end
	end
end
function Bullet:isOutOfBounds()
	return not pointInPolygon( {{x=0,y=0},{x=WIDTH,y=0},{x=WIDTH,y=HEIGHT},{x=0,y=HEIGHT},{x=0,y=0}}, {x=self.x,y=self.y} )
end
function CreateABullet(x,y,ang,color,player,willPierce)
	local obj = Bullet:new()
	obj:init(x,y,ang,color,player,willPierce)
	obj.index = #BULLETS+1
	BULLETS[#BULLETS+1] = obj
	return obj
end