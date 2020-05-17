math.randomseed(os.time())
WIDTH,HEIGHT = love.graphics.getWidth(),love.graphics.getHeight()

GAMESTATE = "MENU"

require "libs.goodies"
require "libs.intersection"
require "libs.enums"

Vector = require "libs.brinevector"
Gamera = require "libs.gamera"
Flux = require "libs.flux"
Timer = require 'libs.knife.timer'


require "core.Menu"
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
	
	FOLDER_NAME = "The Cake isnt a Lie"
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
	if GAMESTATE == "MENU" then
		GameMenu:update(dt)
	elseif GAMESTATE == "PLAYING" then
		MapHandler:update(dt)
	end
end
function love.draw()
	camera:draw(function(l,t,w,h)
		if GAMESTATE == "MENU" then
			GameMenu:draw()
		elseif GAMESTATE == "PLAYING" then
			MapHandler:draw()
		end
	end)
	
	love.graphics.setColor(1,1,1,1)
	love.graphics.print("FPS : "..love.timer.getFPS(),0,0)
end

function love.mousepressed(x,y,b)
	if GAMESTATE == "MENU" then
		GameMenu:mousepressed(x,y,b)
	elseif GAMESTATE == "PLAYING" then
		MapHandler:keypressed(x,y,b)
	end
end
function love.keypressed(key)
	if GAMESTATE == "MENU" then
		GameMenu:keypressed(key)
	elseif GAMESTATE == "PLAYING" then
		MapHandler:keypressed(key)
	end
	if key == "f5" then
		local screenshot = love.graphics.captureScreenshot("ScreenShot_"..os.time() .. '.png');
		print("Screen Successfully taken at : "..love.filesystem.getSaveDirectory().."/"..FOLDER_NAME)
	end
end

function FirstInits()
	camera = Gamera.new(0,0,WIDTH,HEIGHT)
	camera:setWindow(0,0,WIDTH,HEIGHT)
	
	GameMenu = Menu:new()
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
	table.sort(files)
	for k,v in pairs(files) do
		if string.lower(v:sub(#v-3)) == ".lua" then
			MapHandler:addLevelFromLevel("maps.Lua Levels."..v:sub(1,#v-4))
		end
	end
end