--------------------- VotePoll --------------------
VotePoll = {}
VotePoll.__index = VotePoll

function VotePoll:new()
	local t = {}
	setmetatable(t,VotePoll)
	return t
end
function VotePoll:init()
	self.voting_allowed = false
	self.active = false
	self.choices = {}
	self.poll_time = 0
	self.total_votes = 0
	self.max_votes = 0 -- 0 for unlimited
	self.already_voted = {}
	self.onPollEnd = function(winner) return winner end
end
function VotePoll:setMaxVotes(v)
	self.max_votes = v or 0
end
function VotePoll:setTime(t)
	self.poll_time = t
end
function VotePoll:Vote(id,choice)
	if self.voting_allowed and not contains(self.already_voted,id) then
		if choice > 0 and choice <= #self.choices then
			self.choices[choice].votes = self.choices[choice].votes + 1
			self.total_votes = self.total_votes + 1
			self.already_voted[#self.already_voted+1] = id
		end
	end
	if (self.total_votes == self.max_votes and self.max_votes ~= 0) then
		self.poll_time = 0
		self.voting_allowed = false
		local hid,high = self:getHighestVote()
		self.onPollEnd(hid)
	end
end
function VotePoll:reset()
	self.choices = {}
	self.already_voted = {}
	self.total_votes = 0
	self.poll_time = 0
	self.max_votes = 0 -- 0 for unlimited
	self.active = false
	self.voting_allowed = false
end
function VotePoll:getHighestVote()
	high = 0
	local result = -1
	for i = 1,#self.choices do
		if self.choices[i] then
			if self.choices[i].votes > high then
				high = self.choices[i].votes
				result = i
			end
		end
	end
	return result,high
end
function VotePoll:addChoice(name,icon)
	self.choices[#self.choices+1] = {name=name,votes=0,icon=icon}
end
function VotePoll:setVoting(voting)
	self.voting_allowed = voting
end
function VotePoll:setActive(active)
	self.active = active
	self:setVoting(active)
end
function VotePoll:setEndFunction(func)
	self.onPollEnd = func
end
function VotePoll:update(dt)
	if self.active then
		if self.poll_time > 0 then
			self.poll_time = self.poll_time - 1000*dt
		else
			if self.poll_time ~= 0 then
				self.onPollEnd(hid)
			end
			self.poll_time = 0
			self.voting_allowed = false
			local hid,high = self:getHighestVote()
		end
	end
end
function VotePoll:draw(x,y)
	if self.active then
		love.graphics.setColor(1,1,1,1)
		love.graphics.setFont(Font2)
		love.graphics.print("VOTE POLL ("..math.ceil(self.poll_time/100)/10 .."s)",x+10,y+10)
		if self.max_votes ~= 0 then
			love.graphics.print("Voted "..self.total_votes.."/"..self.max_votes,x+10,y+30)
		end
		love.graphics.setFont(Font1)
		local height = 40
		for i = 1,#self.choices do
			if self.choices[i] then
				local x1 = x+10
				local y1 = y+10+height
				local img = self.choices[i].icon
				love.graphics.setColor(1,1,1,1)
				love.graphics.draw(img,x1,y1,0,math.min(35/img:getWidth(),35/img:getHeight()),math.min(35/img:getWidth(),35/img:getHeight()))
				local ratio = self.choices[i].votes/self.total_votes
				local percent = math.ceil(ratio*1000)/10
				if self.total_votes == 0 then ratio = 0;percent=0 end
				love.graphics.print(self.choices[i].name,x1+40,y1)
				love.graphics.print(percent.."% ("..self.choices[i].votes..")",x1+40,y1+17)
				
				love.graphics.setColor(67/255,69/255,74/255,1)
				love.graphics.rectangle("fill",x1,y1+40,150,10,5)
				love.graphics.setColor(96/255,137/255,218/255,1)
				local hid,high = self:getHighestVote()
				if self.poll_time == 0 and i == hid then
					love.graphics.setColor(90/255,230/255,83/255,1)
				end
				if ratio ~= 0 then
					love.graphics.rectangle("fill",x1,y1+40,150*ratio,10,5)
				end
				height = height + 70
			end
		end
	end
end
function CreateVotePoll(t)
	local obj = VotePoll:new()
	obj:init(t)
	return obj
end