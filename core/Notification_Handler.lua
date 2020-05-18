--------------------- Notification_Handler --------------------
Notification_Handler = {}
Notification_Handler.__index = Notification_Handler

function Notification_Handler:new()
	local t = {}
	setmetatable(t,Notification_Handler)
	return t
end
function Notification_Handler:init()
	self.notifications = {}
	self.size = Vector(math.ceil(WIDTH/2.7),96)
	self.position = Vector(WIDTH - self.size.x - 10,10)
	self.removed = 0
end
function Notification_Handler:Notify(main_icon,title,subtext,app_name,app_icon,long) -- add notifications
	self.notifications[#self.notifications+1] = {main_icon=main_icon,title=title or "",subtext=subtext,app_name=app_name or "",app_icon=app_icon,long=long or 1000,long_const=long or 1000}
end
function Notification_Handler:update(dt)
	for i = 1,#self.notifications do
		if self.notifications[i] then
			if self.notifications[i].long > 0 then
				self.notifications[i].long = self.notifications[i].long - 1000*dt
			else
				self.notifications[i].willRemove = true
				self.removed = self.removed + 1
			end
		end
	end
	local count = #self.notifications
	for k,v in pairs(self.notifications) do
		if v.willRemove then
			count = count - 1
		end
	end
	if count == 0 then
		self.notifications = {}
		self.removed = 0
	end
end
function Notification_Handler:draw()
	local height = 0
	for i = 1,#self.notifications do
		if self.notifications[i] then
			if not self.notifications[i].willRemove then
				local v = self.notifications[i]
				local x = self.position.x
				local y = self.position.y + height
				local a = 1
				if self.notifications[i].long <= self.notifications[i].long_const / 4 then -- start to fade when 25% 
					a = self.notifications[i].long / (self.notifications[i].long_const/4)
				end
				love.graphics.setColor(1,1,1,a)
				love.graphics.rectangle("fill",x,y,self.size.x,self.size.y)
				local img = self.notifications[i].main_icon
				if img then
					local w = img:getWidth()
					local h = img:getHeight()
					love.graphics.draw(img,x,y,0,math.min(self.size.y/w),math.min(self.size.y/h))
				end
				love.graphics.setScissor(x,y,self.size.x,self.size.y)
				
				love.graphics.setColor(140/255,159/255,225/255,a)
				love.graphics.setFont(Font4)
				love.graphics.print(v.title,x+self.size.y+10,y+10)
				love.graphics.setFont(Font1)
				love.graphics.setColor(0.6,0.6,0.6,a)
				if type(v.subtext) == "string" then
					love.graphics.printf(v.subtext,x+self.size.y+10,y+30,self.size.x-self.size.y-20)
				else
					love.graphics.printf("Sent an image.",x+self.size.y+10,y+30,self.size.x-self.size.y-20)
				end
				
				local img2 = v.app_icon
				if img2 then
					local w2 = img2:getWidth()
					local h2 = img2:getHeight()
					local scale2 = math.min(24/w2,24/h2)
					love.graphics.setColor(1,1,1,a)
					love.graphics.draw(img2,x+self.size.x-30,y+self.size.y-30,0,scale2,scale2)
				end
				love.graphics.setColor(0.6,0.6,0.6,a)
				love.graphics.setFont(Font2)
				local s,w = love.graphics.getFont():getWrap(v.app_name,500)
				love.graphics.print(v.app_name,math.floor(x+self.size.x-40-s),y+self.size.y-30)
				love.graphics.setFont(Font1)
				
				love.graphics.setScissor()
				-------------------------
				height = height + self.size.y + 10
			end
		end
	end
end
function CreateNotification_Handler()
	local obj = Notification_Handler:new()
	obj:init()
	return obj
end