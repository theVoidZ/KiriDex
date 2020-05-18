math.randomseed(os.time())
WIDTH,HEIGHT = love.graphics.getWidth(),love.graphics.getHeight()

require "libs.goodies"
require "libs.intersection"

Vector = require "libs.brinevector"
GameLoop = (require "libs.gameloop"):new()
Renderer = (require "libs.renderer"):new()

-----
require "core.shaders"
require "core.Player"
require "core.Stand"
require "core.Level"
require "core.Enemy"
require "core.Menu"
require "core.Boss_Effect"
require "core.Circle_graph"
require "core.Animation"
require "core.Glow"

require "core.Stands.Projectile"

require "core.Stands.None"
require "core.Stands.Star_Platinum"
require "core.Stands.The_World"
require "core.Stands.Six_Pistols"

require "core.Stands.Normal"
require "core.Stands.Star_Platinum_punch"
require "core.Stands.The_World_punch"
require "core.Stands.Six_Pistols_punch"

require "core.Enemies.Standard_Enemy"


GAMESTATE = "MAIN"

---------------------------
function love.load()
	love.graphics.setBackgroundColor(48/255,10/255,36/255)
	------------------------- CONSTANTS
	font1 = love.graphics.newImageFont("fonts/font.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\"|$_°_")
	love.graphics.setFont(font1)
	
	font_fedora = love.graphics.newFont("fonts/SF Fedora.ttf",80)
	font_fedora_shadow = love.graphics.newFont("fonts/SF Fedora Shadow.ttf")
	
	PLAY_IMAGE = love.graphics.newImage("gfx/Play.png")
	
	MASTER_VOLUME = 0.6
	
	FOLDER_NAME = "JoJo Bizarre Shooting"
	love.filesystem.setIdentity(FOLDER_NAME);
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
			love.graphics.setBackgroundColor(0,0.75,0)
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
		for k,v in pairs(PROJECTILES) do
			if v then
				v:update(dt)
			end
		end
		for k,v in pairs(ENEMIES) do
			if v then
				v:update(dt)
			end
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
		for k,v in pairs(PROJECTILES) do
			if v then
				v:draw()
			end
		end
		for k,v in pairs(ENEMIES) do
			if v then
				v:draw()
			end
		end
	elseif GAMESTATE == "MAIN" then
		love.graphics.setColor(1,1,1,1)
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
	Effect_Handler = CreateBoss_Effect()
	Animation_Handler = CreateAnimation()
	
	-- local e = CreateStandard_Enemy(50,50,200)
	-- e.stand = CreateStar_Platinum(e.index,true)
	-- e.stand:setActive(true)
	-- CreateStandard_Enemy(50,250,1)
	-- CreateStandard_Enemy(-550,550,1)
	CreatePlayer()
	
	Player_Menu = CreateMenu()
end
