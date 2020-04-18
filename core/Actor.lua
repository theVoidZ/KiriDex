--------------------- Actor --------------------
Actor = {}
Actor.__index = Actor

function Actor:new()
	local t = {}
	setmetatable(t,Actor)
	t:pre_init()
	return t
end
function Actor:init()
end
function Actor:pre_init()
	self.position = Vector(WIDTH/2,HEIGHT/2+20)
	self.xRemainder = 0
	self.yRemainder = 0
end
function Actor:MoveX(amount,action) -- action : function(side) -- side : -1 : Left, 1 : Right
	self.xRemainder = self.xRemainder + amount
	local move = math.round(self.xRemainder)
	
	if move ~= 0 then
		self.xRemainder = self.xRemainder - move
		local m_sign = sign(move)
		
		while move ~= 0 do
			if (not self:collideAt(SOLIDS, self.position + Vector(m_sign,0))) then
				self.position.x = self.position.x + m_sign
				move = move - m_sign
			else
				if action then
					action(m_sign)
				end
				break
			end
		end
	end
end
function Actor:MoveY(amount,action) -- action : function(side) -- side : -1 : Up, 1 : Down
	self.yRemainder = self.yRemainder + amount
	local move = math.round(self.yRemainder)
	if move ~= 0 then
		self.yRemainder = self.yRemainder - move
		local m_sign = sign(move)
		
		while move ~= 0 do
			if (not self:collideAt(SOLIDS, self.position + Vector(0,m_sign))) then
				self.position.y = self.position.y + m_sign
				move = move - m_sign
			else
				if action then
					action(m_sign)
				end
				break
			end
		end
	end
end


function Actor:Refresh()
	for k,v in pairs(SOLIDS) do
		if v then
			if v.isActive then
				if v.Collidable then
					if not self:collideWith(v,self.position + Vector(0,1)) then
						self.isGrounded = false
						break
					end
				end
			end
		end
	end
end

function Actor:collideWith(solid,pos)
	if solid then
		if solid.Collidable then
			if doOverlap(pos.x,pos.y,pos.x+self.size.x,pos.y+self.size.y,solid.position.x,solid.position.y,solid.position.x+solid.size.x,solid.position.y+solid.size.y,true) then
				return true
			end
		end
	end
	return false
end
function Actor:collideAt(tab,pos)
	for k,v in pairs(tab) do
		if v then
			if v.isActive and v.Collidable then
				if doOverlap(pos.x,pos.y,pos.x+self.size.x,pos.y+self.size.y,v.position.x,v.position.y,v.position.x+v.size.x,v.position.y+v.size.y,true) then
					if v.isDeadly then
						self:onDeadlyCollision()
					elseif v.isFragile then
						v:onCollide(self.index)
					end
					return true
				end
			end
		end
	end
	return false
end

function Actor:isRiding(solid)
	return self:collideWith(solid, self.position + Vector(0,1))
end

function Actor:Squish() -- on Squish
	self:onDeath()
end

function CreateActor()
	local obj = Actor:new()
	obj:init()
	return obj
end