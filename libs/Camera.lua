--------------------- Camera --------------------
local Camera = {}
Camera.__index = Camera

function Camera:new()
	local t = {}
	setmetatable(t,Camera)
	return t
end

function Camera:init(x,y,w,h,scale,rotation)
	
	self.w = w or love.graphics.getWidth()
	self.h = h or love.graphics.getHeight()
	self.x = x or self.w/2
	self.y = y or self.h/2
	self.scale = scale or 1
	self.rotation = rotation or 0
	self.screen_x = x or self.w/2
	self.screen_y = y or self.h/2
	
	self.target_x, self.target_y = 0, 0
	self.draw_deadzone = true
	
	
	self.onRoomEnter = function(dx,dy) -- Callback Function, you need to Redefine this
		print("Default")
	end
end
function Camera:getX()
	return camera.x-camera.w/2
end
function Camera:getY()
	return camera.y-camera.h/2
end
function Camera:setOnRoomEnter(func)
	if type(func) == "function" then
		self.onRoomEnter = func
	end
end
function Camera:attach()
    love.graphics.push()
    love.graphics.translate(self.w/2, self.h/2)
    love.graphics.scale(self.scale)
    love.graphics.rotate(self.rotation)
    love.graphics.translate(-self.x, -self.y)
end

function Camera:detach()
    love.graphics.pop()
end

function Camera:move(dx, dy)
    self.x, self.y = self.x + dx, self.y + dy
end

function Camera:toWorldCoords(x, y)
    local c, s = math.cos(self.rotation), math.sin(self.rotation)
    x, y = (x - self.w/2)/self.scale, (y - self.h/2)/self.scale
    x, y = c*x - s*y, s*x + c*y
    return x + self.x, y + self.y
end

function Camera:toCameraCoords(x, y)
    local c, s = math.cos(self.rotation), math.sin(self.rotation)
    x, y = x - self.x, y - self.y
    x, y = c*x - s*y, s*x + c*y
    return x*self.scale + self.w/2, y*self.scale + self.h/2
end

function Camera:getMousePosition()
    return self:toWorldCoords(love.mouse.getPosition())
end

function Camera:update(dt)
	self.mx, self.my = self:getMousePosition()
	
	if not self.target_x and not self.target_y then return end
	if self.follow_style == 'LOCKON' then
		local w, h = self.w/16, self.w/16
		self:setDeadzone((self.w - w)/2, (self.h - h)/2, w, h)
	elseif self.follow_style == 'ROOM_BY_ROOM' then
		local w, h = self.w/16, self.w/16
		self:setDeadzone((self.w - w)/2, (self.h - h)/2, w, h)
	elseif self.follow_style == 'SCREEN_BY_SCREEN' then
		self:setDeadzone(0, 0, 0, 0)
	elseif self.follow_style == 'NO_DEADZONE' then
		self.deadzone = nil
	end
	
	------------ no Deadzone
	if not self.deadzone then 
        self.x, self.y = self.target_x, self.target_y 
        if self.bound then
            self.x = math.min(math.max(self.x, self.bounds_min_x + self.w/2), self.bounds_max_x - self.w/2)
            self.y = math.min(math.max(self.y, self.bounds_min_y + self.h/2), self.bounds_max_y - self.h/2)
        end
        return
    end
	------------ Deadzone
	local dx1, dy1, dx2, dy2 = self.deadzone_x, self.deadzone_y, self.deadzone_x + self.deadzone_w, self.deadzone_y + self.deadzone_h
    local scroll_x, scroll_y = 0, 0
    local target_x, target_y = self:toCameraCoords(self.target_x, self.target_y)
    local x, y = self:toCameraCoords(self.x, self.y)
	-- print(self.bounds_min_x,self.bounds_min_y,self.bounds_max_x,self.bounds_max_y)
	if self.follow_style == "ROOM_BY_ROOM" then
		if target_x < x then
            local d = target_x - dx1
            if d < 0 then scroll_x = d end
        end
        if target_x > x then
            local d = target_x - dx2
            if d > 0 then scroll_x = d end
        end
        if target_y < y then
            local d = target_y - dy1
            if d < 0 then scroll_y = d end
        end
        if target_y > y then
            local d = target_y - dy2
            if d > 0 then scroll_y = d end
        end

        -- Scroll towards target with lerp
        -- self.x = lerp(self.x, scroll_x, self.follow_lerp_x)
        -- self.y = lerp(self.y, scroll_y, self.follow_lerp_y)
		if self.bound then
			-- if self.x >= self.bounds_min_x + self.w/2 and target_x < 0 then
				-- self.onRoomEnter(-1,0)
			-- end
			-- if self.x <= self.bounds_max_x - self.w/2 and target_x >= self.w then
				-- self.onRoomEnter(1,0)
			-- end
			-- if self.y >= self.bounds_min_y + self.h/2 and target_y < 0 then
				-- self.onRoomEnter(0,-1)
			-- end
			-- if self.y <= self.bounds_max_y - self.h/2 and target_y >= self.h then
				-- self.onRoomEnter(0,1)
			-- end
			if self.x >= self.bounds_min_x + self.w/2 and target_x < 0 then
				self.onRoomEnter(-1,0)
			end
			if self.x <= self.bounds_max_x - self.w/2 and target_x >= self.w then
				self.onRoomEnter(1,0)
			end
			if self.y >= self.bounds_min_y + self.h/2 and target_y < 0 then
				self.onRoomEnter(0,-1)
			end
			if self.y <= self.bounds_max_y - self.h/2 and target_y >= self.h then
				self.onRoomEnter(0,1)
			end
		end

        -- Scroll towards target with lerp
        -- self.x = csnap(self.x+scroll_x,math.abs(ssx))
        -- self.y = csnap(self.y+scroll_y,math.abs(ssy))
		
        self.x = lerp(self.x, self.x + scroll_x, self.follow_lerp_x)
        self.y = lerp(self.y, self.y + scroll_y, self.follow_lerp_y)
		
        -- Apply bounds
        if self.bound then
            self.x = math.min(math.max(self.x, self.bounds_min_x + self.w/2), self.bounds_max_x - self.w/2)
            self.y = math.min(math.max(self.y, self.bounds_min_y + self.h/2), self.bounds_max_y - self.h/2)
        end
	else
	-- Figure out how much the camera needs to scroll
        if target_x < x then
            local d = target_x - dx1
            if d < 0 then scroll_x = d end
        end
        if target_x > x then
            local d = target_x - dx2
            if d > 0 then scroll_x = d end
        end
        if target_y < y then
            local d = target_y - dy1
            if d < 0 then scroll_y = d end
        end
        if target_y > y then
            local d = target_y - dy2
            if d > 0 then scroll_y = d end
        end

        -- Scroll towards target with lerp
        self.x = lerp(self.x, self.x + scroll_x, self.follow_lerp_x)
        self.y = lerp(self.y, self.y + scroll_y, self.follow_lerp_y)

        -- Apply bounds
        if self.bound then
            self.x = math.min(math.max(self.x, self.bounds_min_x + self.w/2), self.bounds_max_x - self.w/2)
            self.y = math.min(math.max(self.y, self.bounds_min_y + self.h/2), self.bounds_max_y - self.h/2)
        end
	end
end

function Camera:draw()
	if self.draw_deadzone and self.deadzone then
		love.graphics.setColor(255,255,255,255)
		local n = love.graphics.getLineWidth()
		love.graphics.setLineWidth(2)
		love.graphics.line(self.deadzone_x - 1, self.deadzone_y, self.deadzone_x + 6, self.deadzone_y)
		love.graphics.line(self.deadzone_x, self.deadzone_y, self.deadzone_x, self.deadzone_y + 6)
		love.graphics.line(self.deadzone_x - 1, self.deadzone_y + self.deadzone_h, self.deadzone_x + 6, self.deadzone_y + self.deadzone_h)
		love.graphics.line(self.deadzone_x, self.deadzone_y + self.deadzone_h, self.deadzone_x, self.deadzone_y + self.deadzone_h - 6)
		love.graphics.line(self.deadzone_x + self.deadzone_w + 1, self.deadzone_y + self.deadzone_h, self.deadzone_x + self.deadzone_w - 6, self.deadzone_y + self.deadzone_h)
		love.graphics.line(self.deadzone_x + self.deadzone_w, self.deadzone_y + self.deadzone_h, self.deadzone_x + self.deadzone_w, self.deadzone_y + self.deadzone_h - 6)
		love.graphics.line(self.deadzone_x + self.deadzone_w + 1, self.deadzone_y, self.deadzone_x + self.deadzone_w - 6, self.deadzone_y)
		love.graphics.line(self.deadzone_x + self.deadzone_w, self.deadzone_y, self.deadzone_x + self.deadzone_w, self.deadzone_y + 6)
		love.graphics.setLineWidth(n)
	end
end

function Camera:follow(x, y)
    self.target_x, self.target_y = x, y
end

function Camera:setDeadzone(x, y, w, h)
    self.deadzone = true
    self.deadzone_x = x
    self.deadzone_y = y
    self.deadzone_w = w
    self.deadzone_h = h
end

function Camera:setFollowLerp(x, y)
    self.follow_lerp_x = x
    self.follow_lerp_y = y or x
end

function Camera:setBounds(x, y, w, h)
    self.bound = true
    self.bounds_min_x = x
    self.bounds_min_y = y
    self.bounds_max_x = x + w
    self.bounds_max_y = y + h
end

function Camera:setFollowStyle(follow_style)
    self.follow_style = follow_style
end

return Camera