require "engine/utils"
local func = require "engine/func"
local sprite = require "engine/sprite"
local events = require "engine/events"
local text = require "engine/text"
local timers = require "engine/timers"

-- CONFIGURATION SETTINGS
controls = {
	player_one = {
		padel_up = "w",
		padel_down = "s",
	},
	player_two = {
		padel_up = "up",
		padel_down = "down",
	},
	reset = "r",
	easteregg = "insert",
}

config = {
	padelVelocity = 200,
	ballSpeed = {200, 100},
	ballSpeedIncrement = {10, 3},
	resetDelay = 2000,
}

--this increases by the ballSpeedIncrement each bounce
local ballSpeed = {config.ballSpeed[1],
				   config.ballSpeed[2]}

-- WINDOW SETTINGS
local renderWindow = kf.getRenderWindow()
renderWindow:setWindowTitle("Pong")
renderWindow:setWindowIcon("../assets/logo.png")
renderWindow:setWindowSize(800, 600)
renderWindow:setResolution(800, 600)
renderWindow:setViewport{x = 0, y = 0, w = 800, h = 600}
renderWindow:setClearColor(240, 240, 240)

-- ASSETS
local assetManager = kf.SDLAssetManager()
assetManager:addImage("left-padel", "../assets/padel-left.png")
assetManager:addImage("right-padel", "../assets/padel-right.png")
assetManager:addImage("pong-ball", "../assets/pong-ball.png")
assetManager:addImage("background", "../assets/background.png")

-- FONTS
local fontManager = kf.SDLFontManager()
local font = fontManager:addFont("font-scoreboard", "../fonts/ComicNeue-Bold.ttf", 30)
font:setRenderType("BLENDED")
font:setFontColor(17, 17, 17)
font:setStyle{ bold = true }

-- SPRITE INSTANTIATION
local background = sprite:new{
	graphics = {
		key = "background",
		index = -100
	},
}

local gameBounds = {
	top = 100,
	right = 800,
	bottom = 600,
	left = 0,
}

local padelBounds = {
	top = 0,
	right = 20,
	bottom = 80,
	left = 0,
}

local leftPadel = sprite:new{
	name = "leftPadel",
	physics = {
		position = {0,
					gameBounds.top + (gameBounds.bottom - gameBounds.top) / 2 - 
						padelBounds.bottom / 2},
	},
	graphics = {
		key = "left-padel",
		index = 2,
	},
	collision = {
		type = "AABB",
		width = padelBounds.right,
		height = padelBounds.bottom,
	},
}

local rightPadel = sprite:new{
	name = "rightPadel",
	physics = {
		position = {
			gameBounds.right - padelBounds.right,
			gameBounds.top + (gameBounds.bottom - gameBounds.top) / 2 - 
				padelBounds.bottom / 2},
	},
	graphics = {
		key = "right-padel",
		index = 2,
	},
	collision = {
		type = "AABB",
		width = padelBounds.right,
		height = padelBounds.bottom,
	},
}

local ballBounds = {
	top = 0,
	right = 20,
	bottom = 20,
	left = 0,
}

local ball = sprite:new{
	name = "ball",
	physics = {
		position = {
			gameBounds.right / 2 - ballBounds.right / 2 ,
			gameBounds.top  + 
				(gameBounds.bottom - gameBounds.top) / 2 - 
				ballBounds.bottom / 2
		},
	},
	graphics = {
		key = "pong-ball"
	},
	collision = {
		type = "AABB",
		width = ballBounds.right,
		height = ballBounds.bottom,
	},
}

function ball:reset(delay, bLeft)
	delay = delay or 0
	ballSpeed = {config.ballSpeed[1],
				 config.ballSpeed[2]}
	self:setPosition{
		gameBounds.right / 2 - ballBounds.right / 2 ,
		gameBounds.top  + 
			(gameBounds.bottom - gameBounds.top) / 2 - 
			ballBounds.bottom / 2
	}

	ball:setVelocity(0,0)

	timerCallback = function()
		if bLeft then
			self:bounceLeft()
			self:bounceUp()
		else
			self:bounceRight()
			self:bounceDown()
		end
	end

	if delay > 0 then
		timers.createEventTimer(delay, timerCallback)
	else
		timerCallback()
	end
end

function ball:bounceLeft()
	local velocity = ball:getVelocity()
	velocity[1] = -ballSpeed[1]
	ball:setVelocity(velocity)
	ballSpeed[1] = ballSpeed[1] + config.ballSpeedIncrement[1]
end

function ball:bounceRight()
	local velocity = ball:getVelocity()
	velocity[1] = ballSpeed[1]
	ball:setVelocity(velocity)
	ballSpeed[1] = ballSpeed[1] + config.ballSpeedIncrement[1]
end

function ball:bounceUp()
	local velocity = ball:getVelocity()
	velocity[2] = -ballSpeed[2]
	ball:setVelocity(velocity)
	ballSpeed[2] = ballSpeed[2] + config.ballSpeedIncrement[2]
end

function ball:bounceDown()
	local velocity = ball:getVelocity()
	velocity[2] = ballSpeed[2]
	ball:setVelocity(velocity)
	ballSpeed[2] = ballSpeed[2] + config.ballSpeedIncrement[2]
end


local text_left = text:new{
	name = "text-scoreboard-left",
	font = "font-scoreboard",
	text = "0",
	physics = {
		position = {200, 20},
	},
}

local text_right = text:new{
	name = "text-scoreboard-right",
	font = "font-scoreboard",
	text = "0",
	physics = {
		position = {600, 20},
	},
}

--scoreboard functions
local playerOneScore = 0
function text_left:inc()
	playerOneScore = playerOneScore + 1
	text_left:setText(tostring(playerOneScore))
end

local playerTwoScore = 0
function text_right:inc()
	playerTwoScore = playerTwoScore + 1
	text_right:setText(tostring(playerTwoScore))
end

function resetScore()
	playerOneScore = 0
	text_left:setText("0")
	playerTwoScore = 0
	text_right:setText("0")
end

-- EVENTS
events.createKeyListener(
	function(key, bKeyDown) 

		--Player One
		if key == controls.player_one.padel_up then
			if bKeyDown then
				leftPadel:setVelocity(0, -config.padelVelocity)
			else
				leftPadel:setVelocity(0, 0)
			end
		elseif key == controls.player_one.padel_down then
			if bKeyDown then
				leftPadel:setVelocity(0, config.padelVelocity)
			else
				leftPadel:setVelocity(0, 0)
			end
		end

		--Player Two
		if key == controls.player_two.padel_up then
			if bKeyDown then
				rightPadel:setVelocity(0, -config.padelVelocity)
			else
				rightPadel:setVelocity(0, 0)
			end
		elseif key == controls.player_two.padel_down then
			if bKeyDown then
				rightPadel:setVelocity(0, config.padelVelocity)
			else
				rightPadel:setVelocity(0, 0)
			end
		end

		if key == controls.reset and bKeyDown then
			resetGame()
		end

		if key == controls.easteregg and bKeyDown then
			print("Haha, there is no easter egg")
		end

end)

function startGame()
	ball:bounceUp()
	ball:bounceLeft()
end

function pauseGame()
	
end

function resetGame()
	resetScore()
	ball:reset(config.resetDelay, true)
end

--new system for ball bounds
kf.addSystem(
	"ball-bounds",
	function() end,
	function() 
		local position = ball:getPosition()
		if position[1] <= gameBounds.left then
			ball:reset(config.resetDelay, false)
			text_left:inc()
		elseif position[1] + ballBounds.right > gameBounds.right then
			ball:reset(config.resetDelay, true)
			text_right:inc()
		end

		if position[2] <= gameBounds.top then
			ball:bounceDown()
		elseif position[2] + ballBounds.bottom > gameBounds.bottom then
			ball:bounceUp()
		end


end)

--new system for padel bounds
kf.addSystem(
	"padel-bounds",
	function() end,
	function()
		local bounds = function(padel)
			local position = padel:getPosition()

			if position[2] <= gameBounds.top then
				position[2] = gameBounds.top
			elseif position[2] + padelBounds.bottom > gameBounds.bottom then
				position[2] = gameBounds.bottom - padelBounds.bottom
			end

			padel:setPosition(position)
		end
		
		bounds(leftPadel)
		bounds(rightPadel)
end)


--collision listener for the ball
events.createCollisionListener(
	ball:getName(),
	--in
	function() 
	
	end,
	--out
	function() 
		
end)

--collision listener for the left padel
events.createCollisionListener(
	leftPadel:getName(),
	function(first, second, args)
		local padel = sprite:get(first)
		if second:getName() ~= ball:getName() then return end
		ball:bounceRight()
	end,
	function() 
end)

--collision listener for the left padel
events.createCollisionListener(
	rightPadel:getName(),
	function(first, second, args)
		local padel = sprite:get(first)
		if second:getName() ~= ball:getName() then return end
		ball:bounceLeft()
	end,
	function() 
end)


startGame()
kf.runMainLoop()
