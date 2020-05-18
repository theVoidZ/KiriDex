--------------------- Stand --------------------
Stand = {}
Stand.__index = Stand

function Stand:new()
	local t = {}
	setmetatable(t,Stand)
	return t
end
function Stand:init()
	
end
function Stand:UltimateAttack()
end
function Stand:SpecialAttack()
end
function Stand:Attack()
end

function CreateStand(name,player,ai)
	return STANDS[name](player,ai)
end

STANDS_NAMES = {"None","Star_Platinum","The_World","Six_Pistols"}

STANDS = {
			["None"] = function(player,ai) return CreateNone(player,ai) end,
			["Star_Platinum"] = function(player,ai) return CreateStar_Platinum(player,ai) end,
			["The_World"] = function(player,ai) return CreateThe_World(player,ai) end,
			["Six_Pistols"] = function(player,ai) return CreateSix_Pistols(player,ai) end
}