math.randomseed(os.time())
require "libs.goodies"
require "libs.intersection"

Vector = require "libs.brinevector"
GameLoop = (require "libs.gameloop"):new()
Renderer = (require "libs.renderer"):new()
UTF8 = require("utf8")

require "core.System"
require "core.Desktop"
require "core.User"
require "core.Application"
require "core.Window"
require "core.Content"

require "core.Script"
require "core.Notification_Handler"
require "core.VotePoll"

require "core.Colors"

require "core.Apps.Notepad"
require "core.Apps.Discord"
require "core.Apps.GameJam"
require "core.Apps.FallIt"


GAMESTATE = "MAIN"

---------------------------
function love.load()
	love.graphics.setBackgroundColor(48/255,10/255,36/255)
	------------------------- CONSTANTS
	WIDTH,HEIGHT = love.graphics.getWidth(),love.graphics.getHeight()
	-- mainFont = love.graphics.newImageFont("fonts/font.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\"|$_°_")
	-- love.graphics.setFont(mainFont)
	Font1 = love.graphics.newFont("fonts/Vera.ttf")
	Font2 = love.graphics.newFont("fonts/VeraBd.ttf")
	Font3 = love.graphics.newFont("fonts/Vera.ttf",15)
	Font4 = love.graphics.newFont("fonts/VeraBd.ttf",15)
	Font5 = love.graphics.newFont("fonts/VeraBd.ttf",19)
	
	PLAY_IMAGE = love.graphics.newImage("gfx/Play.png")
	TITLE_IMAGE = love.graphics.newImage("gfx/logo.png")
	
	FOLDER_NAME = "Gravity has joined the game"
	love.filesystem.setIdentity(FOLDER_NAME);
	
	Main_Desktop = CreateDesktop()
	system = CreateSystem()
	
	user = CreateUser()
	
	blue_scrn = love.graphics.newImage("gfx/bluescreen.png")
	
	-- Main_Desktop:addApp("My Computer",".exe","gfx/icons/MyComputer.png",1,2)
	-- Main_Desktop:addApp("File Explorer",".exe","gfx/icons/FileExplorer.png",2,4)
	-- Main_Desktop:addApp("Notepad++",".exe","gfx/icons/Notepad++.png",2,4,"Notepad")
	-- Main_Desktop:addApp("Jam2020",".exe","gfx/icons/UntitledGameJam.png",5,4,"GameJam")
	-- Main_Desktop:addApp("Discord",".exe","gfx/icons/Discord.png",6,4,"Discord")
	-- Main_Desktop:addApp("FallIt",".exe","gfx/icons/Fall the ball.png",nil,nil,"FallIt")
	---- Testing boiz
	
	DRAW_PHYSICS = false
	---------------------------------------------------

	-- Level_Handler = CreateALevel(WIDTH*2, HEIGHT*2)
	-- player=CreateAPlayer()
end
function love.wheelmoved(x, y)
	if GAMESTATE == "PLAYING" then
		user:wheelmoved(x,y)
	elseif GAMESTATE == "STARTING" then
		system:wheelmoved(x,y)
	end
end
function love.textinput(t)
	if GAMESTATE == "PLAYING" then
		user:textinput(t)
	elseif GAMESTATE == "STARTING" then
		system:textinput(t)
	end
end
function love.mousereleased(x,y,b)
	if GAMESTATE == "PLAYING" then
		user:mousereleased(b)
	end
end
function love.keypressed(k)
	if GAMESTATE == "PLAYING" then
		user:keypressed(k)
	elseif GAMESTATE == "STARTING" then
		system:keypressed(k)
	end
end
function love.mousepressed(x,y,b)
	if GAMESTATE == "PLAYING" then
		user:mousepressed(b)
	elseif GAMESTATE == "MAIN" then
		if x >= WIDTH/2-200 and x <= WIDTH/2+200 and y >= HEIGHT/2-50 and y <= HEIGHT/2+50 then
			GAMESTATE = "STARTING"
			love.graphics.setBackgroundColor(0,0,0)
		end
	elseif GAMESTATE == "STARTING" then
		system:mousepressed(x,y,b)
	end
end
function love.update(dt)
	if dt > 0.1 then return print("didn't skip frame, dt is too big "..dt) end
	if GAMESTATE == "PLAYING" then
		GameLoop:update(dt)
	elseif GAMESTATE == "STARTING" then
		system:update(dt)
	end
end

function love.draw()
	if GAMESTATE == "PLAYING" then
		love.graphics.setColor(1,1,1,1)
		Renderer:draw()
	elseif GAMESTATE == "STARTING" then
		love.graphics.setColor(1,1,1,1)
		system:draw()
	elseif GAMESTATE == "MAIN" then
		-- love.graphics.setColor(0,0.5,0,1)
		-- love.graphics.rectangle("fill",WIDTH/2-200,HEIGHT/2-50,400,100)
		love.graphics.setColor(1,1,1,1)
		-- love.graphics.draw(TITLE_IMAGE,0,0)
		love.graphics.draw(PLAY_IMAGE,WIDTH/2-200,HEIGHT/2-50)
		
		love.graphics.setColor(1,1,1,1)
		-- love.graphics.print("RED ZONES ARE FAST MOTION",5,HEIGHT/2+100,0,2,2)
	elseif GAMESTATE == "END" then
		love.graphics.setColor(1,1,1,1)
		love.graphics.draw(blue_scrn,0,0)
		love.graphics.print("THANKS FOR PLAYING",WIDTH/2,20)
	end
	love.graphics.setColor(1,1,1,1)
	love.graphics.print("FPS : "..love.timer.getFPS(),0,0)
end
