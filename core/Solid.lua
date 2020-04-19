--------------------- Solid --------------------
Solid = {}
Solid.__index = Solid

SOLIDS = {}

function Solid:new()
	local t = {}
	setmetatable(t,Solid)
	t:pre_init()
	return t
end
function Solid:pre_init()
	self.xRemainder = 0
	self.yRemainder = 0
end
function Solid:post_init()
	
end

function Solid:init()
	
end

function Solid:Move(x, y)
	if not self.isActive then return false end
	self.xRemainder = self.xRemainder + x
	self.yRemainder = self.yRemainder + y
	
	local moveX = math.round(self.xRemainder)
	local moveY = math.round(self.yRemainder)
	
	if moveX ~= 0 or moveY ~= 0 then
		local ridingIDs = self:GetAllRidingActors()
		
		self.Collidable = false
		if moveX ~= 0 then
			self.xRemainder = self.xRemainder - moveX
			self.position.x = self.position.x + moveX
			if moveX > 0 then
				for k,v in pairs(ACTORS) do
					if v then
						if v.isActive and not v.isDead then
							if doOverlap(self.position.x,self.position.y,self.position.x+self.size.x,self.position.y+self.size.y,v.position.x,v.position.y,v.position.x+v.size.x,v.position.y+v.size.y,true) then
								-- Push Right (Actor is on the Right Side)
								v:MoveX(self.position.x+self.size.x - v.position.x, function() v:Squish() end)
							elseif contains(ridingIDs,v.index) then
								-- Carry Right
								v:MoveX(moveX,function() end)
							-- else
								-- v:Refresh()
							end
						end
					end
				end
			elseif moveX < 0 then
				for k,v in pairs(ACTORS) do
					if v then
						if v.isActive and not v.isDead then
							if doOverlap(self.position.x,self.position.y,self.position.x+self.size.x,self.position.y+self.size.y,v.position.x,v.position.y,v.position.x+v.size.x,v.position.y+v.size.y,true) then
								-- Push Left (Actor is on the Left Side)
								v:MoveX(self.position.x - (v.position.x+v.size.x), function() v:Squish() end)
							elseif contains(ridingIDs,v.index) then
								-- Carry Left
								v:MoveX(moveX,function() end)
							-- else
								-- v:Refresh()
							end
						end
					end
				end
			end
		end
		---- Y
		if moveY ~= 0 then
			self.yRemainder = self.yRemainder - moveY
			self.position.y = self.position.y + moveY
			if moveY > 0 then
				for k,v in pairs(ACTORS) do
					if v then
						if v.isActive and not v.isDead then
							if doOverlap(self.position.x,self.position.y,self.position.x+self.size.x,self.position.y+self.size.y,v.position.x,v.position.y,v.position.x+v.size.x,v.position.y+v.size.y,true) then
								-- Push Right (Actor is on the Right Side)
								v:MoveY(self.position.y+self.size.y - v.position.y, function() v:Squish() end)
							elseif contains(ridingIDs,v.index) then
								-- Carry Right
								v:MoveY(moveY,function() end)
							-- else
								-- v:Refresh()
							end
						end
					end
				end
			elseif moveY < 0 then
				for k,v in pairs(ACTORS) do
					if v then
						if v.isActive and not v.isDead then
							if doOverlap(self.position.x,self.position.y,self.position.x+self.size.x,self.position.y+self.size.y,v.position.x,v.position.y,v.position.x+v.size.x,v.position.y+v.size.y,true) then
								-- Push Left (Actor is on the Left Side)
								v:MoveY(self.position.y - (v.position.y+v.size.y), function() v:Squish() end)
							elseif contains(ridingIDs,v.index) then
								-- Carry Left
								v:MoveY(moveY,function() end)
							-- else
								-- v:Refresh()
							end
						end
					end
				end
			end
		end
	end
	self.Collidable = true
end

function Solid:GetAllRidingActors() -- ID
	local list = {}
	for k,v in pairs(ACTORS) do
		if v then
			if v.isActive and not v.isDead then
				if v:isRiding(self) then
					table.insert(list,v.index)
				end
			end
		end
	end
	return list
end

function CreateSolid()
	local obj = Solid:new()
	obj:init()
	return obj
end