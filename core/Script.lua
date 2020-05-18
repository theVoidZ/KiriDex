--------------------- Script --------------------
Script = {}
Script.__index = Script

function Script:new()
	local t = {}
	setmetatable(t,Script)
	return t
end
function Script:init()
	self.active = false
	self.delay = 0
	self.scene = {}
	self.index = 1
	self.onSendFunction = function(id,msg,delay) print("bro") end -- redefine this when creating this object
end
function Script:addMessage(id,msg,delay,func,reset_delay) -- callback function
	self.scene[#self.scene+1] = {sender = id,message = msg,delay = delay or 0,func = func or self.onSendFunction} -- delay from last message
	if #self.scene == 1 or reset_delay then
		self.delay = delay
	end
end
function Script:setActive(active)
	self.active = active
end
function Script:setPos(pos) -- set index
	self.index = pos
	self.delay = 100
end
function Script:setCallbackFunction(func)
	self.onSendFunction = func
end
function Script:update(dt)
	if self.active then
		if self.delay > 0 then
			self.delay = self.delay - 1000*dt
		else
			if self.index <= #self.scene then
				if self.scene[self.index] then
					self.scene[self.index].func(self.scene[self.index].sender,self.scene[self.index].message,self.scene[self.index].delay)
					self.index = self.index + 1
					if self.index <= #self.scene then
						self.delay = self.scene[self.index].delay
						-- print("SETTING DELAY FOR ",self.scene[self.index].message,self.delay)
					else
						self.delay = 0
					end
				end
			else
				self.active = false
			end
		end
	end
end

function CreateScript()
	local obj = Script:new()
	obj:init()
	return obj
end