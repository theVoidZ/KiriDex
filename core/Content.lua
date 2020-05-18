--------------------- Content --------------------
Content = {}
Content.__index = Content

function Content:new()
	local t = {}
	setmetatable(t,Content)
	return t
end
function Content:init(x,y,w,h)
end
function Content:draw_physics()
end
function Content:draw()
	self:draw_()
	
end
function Content:update(dt) -- DONT OVERRIDE THIS
	self:update_(dt)
	if self.notifier then
		self.notifier:update(dt)
	end
end
function Content:CreateLetter(t)
end
function Content:setGravityScale(h)
end
function Content:wheelmoved(x,y)
end
function Content:setGravity(x,y)
end
function Content:textinput(t)
end
function Content:mousepressed(x,y)
end
function Content:update_icon(name,icon)
	self.app_icon = icon
	self.app_name = name
end
function Content:onOpen()
end
function Content:keypressed(k)
end
function Content:setStats(pos,size,open)
end
function Content:update_stats(pos,size,open)
	self.position = pos
	self.size = size
	self.open = open
end

function CreateContent()
	local obj = Content:new()
	obj:init()
	return obj
end