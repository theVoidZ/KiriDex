math.randomseed(os.time())
WIDTH,HEIGHT = love.graphics.getWidth(),love.graphics.getHeight()

require "libs.goodies"
require "libs.intersection"
require "libs.enums"

Vector = require "libs.brinevector"
gamera = require "libs.gamera"
GameLoop = (require "libs.gameloop"):new()
Renderer = (require "libs.renderer"):new()
UTF8 = require("utf8")
local newOutliner = require 'core.outliner'

-----
require "core.Colors"
require "core.Glow"

require "core.EventSystem"
require "core.Level"

require "core.Actor"
require "core.Solid"

require "core.Player"
require "core.Enemy"

require "core.Obstacle"
require "core.MovingPlatform"

require "core.Collectable"
require "core.Trampoline"

require "core.Companion"

require "core.DeathAnimator"


-- local Light = require "lightlib" 

function RectToPoly(x, y, w, h)
	return {x, y, x+w, y, x+w, y+h, x, y+h}
end

GAMESTATE = "MAIN"

---------------------------
function love.load()
	love.graphics.setBackgroundColor(48/255,10/255,36/255)
	------------------------- CONSTANTS
	mainFont = love.graphics.newImageFont("fonts/font.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\"|$_°_")
	love.graphics.setFont(mainFont)
	
	PLAY_IMAGE = love.graphics.newImage("gfx/Play.png")
	
	DEBUG = false
	
	FOLDER_NAME = "Platformer Simulator"
	love.filesystem.setIdentity(FOLDER_NAME);
	
	outlinerOnly = newOutliner(true)
	outliner = newOutliner(false)
	
	Event = CreateEventSystem()
	
	-- LIGHTING = false
end
function love.mousereleased(x,y,b)
	if Event:getGameState() == "PLAYING" then
		-- ACTORS[1]:onDeath()
	end
end
function love.keypressed(key)
	-- if key == "space" then
		-- Event:SelectLevel("Tutorial")
	-- elseif key == "l" then
		-- Event:SelectLevel("Level1")
	-- end
	if Event:getGameState() == "PLAYING" then
		for k,v in pairs(ACTORS) do
			if v then
				v:keypressed(key)
			end
		end
	elseif Event:getGameState() == "MENU" then
	end
	if key == "f5" then
		local screenshot = love.graphics.captureScreenshot("ScreenShot_"..os.time() .. '.png');
		print("Screen Successfully taken at : "..love.filesystem.getSaveDirectory().."/"..FOLDER_NAME)
	end
end
function love.mousepressed(x,y,b)
	if Event:getGameState() == "PLAYING" then
	elseif Event:getGameState() == "MENU" then
	elseif Event:getGameState() == "MAIN" then
		if x >= WIDTH/2-200 and x <= WIDTH/2+200 and y >= HEIGHT/2-50 and y <= HEIGHT/2+50 then
			Event:setGameState("PLAYING")
			love.graphics.setBackgroundColor(0,0,0)
			FirstInits()
		end
	end
end
function love.update(dt)
	if dt > 0.1 then return print("didn't skip frame, dt is too big "..dt) end
	if Event:getGameState() == "PLAYING" then
		-- if love.keyboard.isDown("space") then
			GameLoop:update(dt)
			for k,v in pairs(ACTORS) do
				if v then
					v:update(dt)
				end
			end
			for k,v in pairs(SOLIDS) do
				if v then
					v:update(dt)
				end
			end
			local x, y = Event:getCamera():getPosition()
			local scale = Event:getCamera():getScale()
			-- LightWorld:update(dt)
			-- LightWorld:setTranslation(-x+WIDTH/2, -y+HEIGHT/2, scale)
		-- end
	elseif Event:getGameState() == "MENU" then
	end
end
function love.draw()
	if Event:getGameState() == "PLAYING" then
		Renderer:draw()
	end
	Event:draw()
	love.graphics.setColor(1,1,1,1)
	love.graphics.print("FPS : "..love.timer.getFPS(),0,0)
	-- love.graphics.print("Game State : "..Event:getGameState(),0,15)
	-- love.graphics.print("Game Event : "..Event.game_event.name,0,30)
end

function FirstInits()
	Event:FirstInits()
	-- LightWorld = Light({
		-- ambient = {55/255,55/255,55/255},         --How dark
		-- refractionStrength = 32.0,
		-- reflectionVisibility = 0.75,
	-- })
	-- CreateEnemy(x,y,{r=1,g=0,b=0},7,25)
	
	
	-- local enemy = CreateEnemy()
	-- enemy.color = {r=1,g=0,b=0}
	
	-- CreateObstacle(0,0,WIDTH,32)
	-- CreateObstacle(0,HEIGHT-32,WIDTH,32)
	-- CreateObstacle(0,32,32,HEIGHT-64)
	-- CreateObstacle(WIDTH-32,32,32,HEIGHT-64)
	
	-- CreateObstacle(WIDTH/2+200,HEIGHT/2+32,200,32)
	-- CreateObstacle(WIDTH/2-100,HEIGHT/2+240,200,32)
	-- CreateObstacle(100,225,200,32)
	-- Player_Menu = CreateMenu()
end
