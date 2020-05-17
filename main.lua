math.randomseed(os.time())
WIDTH,HEIGHT = love.graphics.getWidth(),love.graphics.getHeight()

require "libs.goodies"
require "libs.intersection"
require "libs.enums"

Vector = require "libs.brinevector"
Gamera = require "libs.gamera"
Flux = require "libs.flux"
Timer = require 'libs.knife.timer'


require "core.Map"
require "core.Tile"

require "core.Entity"
require "core.Wall"
require "core.Player"
require "core.Enemy"
require "core.Charger"
require "core.Spike"
require "core.Cake"
require "core.Portal"

require "core.Box"

require "core.Key"
require "core.Door"

-- ENTITIES = {}


-- local newOutliner = require 'core.outliner'

function love.load()
	love.graphics.setBackgroundColor(48/255,10/255,36/255)
	-- love.graphics.setBackgroundColor(6/255,109/255,152/255)
	love.graphics.setDefaultFilter("nearest","nearest")
	
	------------------------- CONSTANTS
	mainFont = love.graphics.newImageFont("fonts/font.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\"|$_°_")
	love.graphics.setFont(mainFont)
	
	FOLDER_NAME = "Platformer Simulator"
	love.filesystem.setIdentity(FOLDER_NAME);
	
	-- outlinerOnly = newOutliner(true)
	-- outliner = newOutliner(false)
	
	FirstInits()
	
end
function love.update(dt)
	if dt > 0.1 then return print("didn't skip frame, dt is too big "..dt) end
	Timer.update(dt)
	Flux.update(dt)
	
	camera:update(dt)
	
	MapHandler:update(dt)
end
function love.draw()
	camera:draw(function(l,t,w,h)
		MapHandler:draw()
	end)
	
	love.graphics.setColor(1,1,1,1)
	love.graphics.print("FPS : "..love.timer.getFPS(),0,0)
end

function love.keypressed(key)
	MapHandler:keypressed(key)
	-- local s = camera:getScale()
	-- print(s)
	-- if key == "a" then
		-- camera:setScale(s-0.1)
	-- elseif key == "e" then
		-- camera:setScale(s+0.1)
	-- end
end

function FirstInits()
	camera = Gamera.new(0,0,1280,640)
	camera:setWindow(0,0,WIDTH,HEIGHT)
	
	MapHandler = Map:new()
	-- table.insert(ENTITIES, Spike:new(4,4))
	-- table.insert(ENTITIES, Enemy:new(2,8))
	-- table.insert(ENTITIES, Enemy:new(2,2))
	-- table.insert(ENTITIES, Player:new(5,4))
	
	
	-- MapHandler:addLevelFromLevel("maps.first_tutorial")
	-- MapHandler:addLevelFromLevel("maps.first_tutorial2")
	-- MapHandler:addLevelFromLevel("maps.troll")
	-- MapHandler:addLevelFromLevel("maps.tutorial")
	-- MapHandler:addLevelFromLevel("maps.level1")
	-- MapHandler:addLevelFromLevel("maps.trapped")
	-- MapHandler:addLevelFromLevel("maps.sandbox")
	
	local files = love.filesystem.getDirectoryItems("maps/Lua Levels")
	for k,v in pairs(files) do
		MapHandler:addLevelFromLevel("maps.Lua Levels."..v:sub(1,#v-4))
	end
	MapHandler:SelectLevel(1)
end