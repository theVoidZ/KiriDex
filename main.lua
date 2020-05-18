math.randomseed(os.time())
require "libs.goodies"
require "libs.intersection"

GameLoop = (require "libs.gameloop"):new()
Renderer = (require "libs.renderer"):new()
Camera = require "libs.Camera"

require "core.Player"
require "core.Level"
require "core.Bullet"
require "core.Enemy"
require "core.Time"

GAMESTATE = "MAIN"

---------------------------
function love.load()
	love.graphics.setBackgroundColor(48/255,10/255,36/255)
	------------------------- CONSTANTS
	WIDTH,HEIGHT = love.graphics.getWidth(),love.graphics.getHeight()
	mainFont = love.graphics.newImageFont("fonts/font.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\"|$_°_")
	love.graphics.setFont(mainFont)
	camera = Camera:new()
	camera:init(WIDTH/2,HEIGHT/2,WIDTH,HEIGHT)
	PLAY_IMAGE = love.graphics.newImage("gfx/Play.png")
	TITLE_IMAGE = love.graphics.newImage("gfx/logo.png")
	
	FOLDER_NAME = "Top Down Shooter"
	love.filesystem.setIdentity(FOLDER_NAME);
	
	---------------------------------------------------

	Level_Handler = CreateALevel()
	player=CreateAPlayer()
	CreateATime(500,300)
end
function love.mousepressed(x,y,b)
	if GAMESTATE == "PLAYING" then
		player:mousepressed(x,y,b)
	elseif GAMESTATE == "MAIN" then
		if x >= WIDTH/2-200 and x <= WIDTH/2+200 and y >= HEIGHT/2-50 and y <= HEIGHT/2+50 then
			GAMESTATE = "PLAYING"
		end
	end
end
function love.update(dt)
	if dt > 0.1 then return print("didn't skip frame, dt is too big "..dt) end
	if GAMESTATE == "PLAYING" then
		GameLoop:update(dt)
		for k,v in pairs(ENEMIES) do
			if v then
				-- if v.exists then
					v:update(dt)
				-- end
			end
		end
		for k,v in pairs(BULLETS) do
			if v then
				if v.exists then
					v:update(dt)
				end
			end
		end
		for k,v in pairs(TIMERS) do
			if v then
				if v.exists then
					v:update(dt)
				end
			end
		end
	end
end

function love.draw()
	if GAMESTATE == "PLAYING" then
		love.graphics.setColor(1,1,1,1)
		Renderer:draw()
		for k,v in pairs(ENEMIES) do
			if v then
				-- if v.exists then
					v:draw()
				-- end
			end
		end
		for k,v in pairs(BULLETS) do
			if v then
				if v.exists then
					v:draw()
				end
			end
		end
		for k,v in pairs(TIMERS) do
			if v then
				if v.exists then
					v:draw()
				end
			end
		end
		if not player.isDead then
			love.graphics.setColor(1,1,1,1)
			local s,w = love.graphics.getFont():getWidth("Kills : "..player.kills,800)
			love.graphics.print("Kills : "..player.kills,math.floor(WIDTH/2-s/2),15)
		else
			love.graphics.setColor(1,1,1,1)
			local s,w = love.graphics.getFont():getWidth("Kills : "..player.kills,800)
			love.graphics.print("Kills : "..player.kills,math.floor(WIDTH/2-5*s/2),HEIGHT/2-35,0,5,5)
		end
	elseif GAMESTATE == "MAIN" then
		-- love.graphics.setColor(0,0.5,0,1)
		-- love.graphics.rectangle("fill",WIDTH/2-200,HEIGHT/2-50,400,100)
		love.graphics.setColor(1,1,1,1)
		love.graphics.draw(TITLE_IMAGE,0,0)
		love.graphics.draw(PLAY_IMAGE,WIDTH/2-200,HEIGHT/2-50)
		-- local s,w = love.graphics.getFont():getWidth("PLAY",800)
		-- love.graphics.print("PLAY",math.floor(WIDTH/2-s/2*5),HEIGHT/2-8*5,0,5,5)
		love.graphics.setColor(1,1,1,1)
		love.graphics.print("RED ZONES ARE FAST MOTION",5,HEIGHT/2+100,0,2,2)
		love.graphics.print("BLUE ZONES ARE SLOW MOTION",5,HEIGHT/2+130,0,2,2)
		love.graphics.print("THE DARKER THE ZONE THE SLOWER IT IS",5,HEIGHT/2+160,0,2,2)
		love.graphics.print("YOU ARE A GUY WHO SHOOTS ANGRY CARS THAT WANT TO RUN YOU OVER!!",5,HEIGHT/2+190,0,2,2)
		love.graphics.print("USE TIME FOR YOUR SIDE, ALSO THERE ARE TIME POWERUPS",5,HEIGHT/2+220,0,2,2)
	end
	love.graphics.setColor(1,1,1,1)
	love.graphics.print("FPS : "..love.timer.getFPS(),0,0)
end

