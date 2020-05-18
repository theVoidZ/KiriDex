math.randomseed(os.time())
require "libs.goodies"
require "libs.intersection"

Vector = require "libs.brinevector"
GameLoop = (require "libs.gameloop"):new()
Renderer = (require "libs.renderer"):new()
UTF8 = require("utf8")


require "core.Level"
require "core.Player"
require "core.Enemy"
require "core.Bullet"
require "core.Menu"
require "core.Glow"

GAMESTATE = "MAIN"

---------------------------
function love.load()
	love.graphics.setBackgroundColor(48/255,10/255,36/255)
	------------------------- CONSTANTS
	WIDTH,HEIGHT = love.graphics.getWidth(),love.graphics.getHeight()
	mainFont = love.graphics.newImageFont("fonts/font.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\"|$_°_")
	love.graphics.setFont(mainFont)
	
	Font0 = love.graphics.newFont("fonts/ARCADE_N.ttf",120)
	Font1 = love.graphics.newFont("fonts/Vera.ttf")
	Font2 = love.graphics.newFont("fonts/VeraBd.ttf")
	Font3 = love.graphics.newFont("fonts/Vera.ttf",15)
	Font4 = love.graphics.newFont("fonts/VeraBd.ttf",15)
	Font5 = love.graphics.newFont("fonts/VeraBd.ttf",19)
	
	PLAY_IMAGE = love.graphics.newImage("gfx/Play.png")
	BACK_IMAGE = love.graphics.newImage("gfx/Home.png")
	
	FOLDER_NAME = "Space Cells"
	love.filesystem.setIdentity(FOLDER_NAME);
	
	time_played = 0
end
function love.mousereleased(x,y,b)
	if GAMESTATE == "PLAYING" then
	end
end
function love.keypressed(key)
	if GAMESTATE == "PLAYING" then
		for k,v in pairs(PLAYERS) do
			if v then
				v:keypressed(key)
			end
		end
		Level_Handler:keypressed(key)
	elseif GAMESTATE == "MENU" then
	end
	if key == "f5" then
		local screenshot = love.graphics.captureScreenshot("ScreenShot_"..os.time() .. '.png');
		print("Screen Successfully taken at : "..love.filesystem.getSaveDirectory().."/"..FOLDER_NAME)
	end
end
function love.mousepressed(x,y,b)
	if GAMESTATE == "PLAYING" then
	elseif GAMESTATE == "MENU" then
		Player_Menu:mousepressed(x,y,b)
	elseif GAMESTATE == "MAIN" then
		if x >= WIDTH/2-200 and x <= WIDTH/2+200 and y >= HEIGHT/2-50 and y <= HEIGHT/2+50 then
			GAMESTATE = "MENU"
			love.graphics.setBackgroundColor(0,0,0)
			FirstInits()
		end
	end
end
function love.update(dt)
	if dt > 0.1 then return print("didn't skip frame, dt is too big "..dt) end
	if GAMESTATE == "PLAYING" then
		GameLoop:update(dt)
		for k,v in pairs(PLAYERS) do
			if v then
				v:update(dt)
			end
		end
		for k,v in pairs(ENEMIES) do
			if v then
				v:update(dt)
			end
		end
		for k,v in pairs(BULLETS) do
			if v then
				v:update(dt)
			end
		end
		if PLAYERS[1].isAlive then
			time_played = time_played + 1000*dt
		end
	elseif GAMESTATE == "MENU" then
		Player_Menu:update(dt)
	end
end

function love.draw()
	if GAMESTATE == "PLAYING" then
		love.graphics.setColor(1,1,1,1)
		Renderer:draw()
		for k,v in pairs(PLAYERS) do
			if v then
				v:draw()
			end
		end
		for k,v in pairs(ENEMIES) do
			if v then
				v:draw()
			end
		end
		for k,v in pairs(BULLETS) do
			if v then
				v:draw()
			end
		end
	elseif GAMESTATE == "MAIN" then
		love.graphics.setColor(1,1,1,1)
		love.graphics.draw(BACK_IMAGE,0,0)
		love.graphics.draw(PLAY_IMAGE,WIDTH/2-200,HEIGHT/2-50)
	elseif GAMESTATE == "MENU" then
		Player_Menu:draw()
	end
	love.graphics.setColor(1,1,1,1)
	love.graphics.print("FPS : "..love.timer.getFPS(),0,0)
	-- love.graphics.print("Game State : "..GAMESTATE,0,15)
end

function FirstInits()
	Level_Handler = CreateLevel()
	-- CreateEnemy(x,y,{r=1,g=0,b=0},7,25)
	CreatePlayer()
	PLAYERS[1].rateOfFire = 200
	Player_Menu = CreateMenu()
end
