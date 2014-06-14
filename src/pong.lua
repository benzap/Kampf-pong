require "engine/utils"
local func = require "engine/func"
local sprite = require "engine/sprite"
local events = require "engine/events"
local text = require "engine/text"

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
		width = 20,
		height = 20,
	},
}

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

-- EVENTS






kf.runMainLoop()
