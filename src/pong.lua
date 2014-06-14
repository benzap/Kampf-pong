require "engine/utils"
local func = require "engine/func"
local sprite = require "engine/sprite"
local events = require "engine/events"

local assetManager = kf.SDLAssetManager()
assetManager:addImage("left-padel", "../assets/padel-left.png")
assetManager:addImage("right-padel", "../assets/padel-right.png")
assetManager:addImage("pong-ball", "../assets/pong-ball.png")

local leftPadel = sprite:new{
	name = "leftPadel",
	physics = {
		position = {0,0,0},
	},
	graphics = {
		key = "left-padel"
	},
	collision = {
		type = "AABB",
		width = 100,
		height = 400,
	},
}

local rightPadel = sprite:new{
	name = "rightPadel",
	physics = {
		position = {100, 100, 0},
	},
	graphics = {
		key = "right-padel"
	},
	collision = {
		type = "AABB",
		width = 100,
		height = 400,
	},
}

local ball = sprite:new{
	name = "ball",
	physics = {
		position = {200, 200, 0},
	},
	graphics = {
		key = "pong-ball"
	},
	collision = {
		type = "AABB",
		width = 50,
		height = 50,
	},
}


table.print(func.range(1,5))
print("hello world!")

kf.runMainLoop()
