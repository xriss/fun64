
local bit=require("bit")
local wstr=require("wetgenes.string")
local wgrd=require("wetgenes.grd")
local tardis=require("wetgenes.tardis")	-- matrix/vector math

local bitdown=require("wetgenes.gamecake.fun.bitdown")
local bitdown_font_4x8=require("wetgenes.gamecake.fun.bitdown_font_4x8")

local chipmunk=require("wetgenes.chipmunk")

local ls=function(...) print(wstr.dump(...)) end

local fatpix=not(args and args.pixel or false) -- pass --pixel on command line to turn off fat pixel filters

--request this hardware setup !The components will not exist until after main has been called!
cmap=bitdown.cmap -- use default swanky32 colors
screen={hx=368,hy=128,ss=4,fps=60}
hardware={
	{
		component="screen",
		size={screen.hx,screen.hy},
		bloom=fatpix and 0.75 or 0,
		filter=fatpix and "scanline" or nil,
		shadow=fatpix and "drop" or nil,
		scale=screen.ss,
		fps=screen.fps,
		layers={
			{ }, -- background
			{ clip={8  ,8,112,112}, scroll={  -8,-8}, size={112,112}, }, -- panel 1 background
			{ clip={8  ,8,112,112}, scroll={  -8,-8}, size={112,112}, }, -- panel 1 foreground
			{ clip={128,8,112,112}, scroll={-128,-8}, size={112,112}, }, -- panel 2 background
			{ clip={128,8,112,112}, scroll={-128,-8}, size={112,112}, }, -- panel 2 foreground
			{ clip={248,8,112,112}, scroll={-248,-8}, size={112,112}, }, -- panel 3 background
			{ clip={248,8,112,112}, scroll={-248,-8}, size={112,112}, }, -- panel 3 foreground
			{ }, -- text
		},
	},
	{
		component="colors",
		cmap=cmap, -- swanky32 palette
	},
	{
		component="tiles",
		name="tiles",
		tile_size={8,8},
		bitmap_size={64,64},
	},
--[[
	{
		component="tilemap",
		name="map",
		tiles="tiles",
		tilemap_size={math.ceil(screen.hx/8),math.ceil(screen.hy/8)},
		layer=1,
	},
]]
	{
		component="tilemap",
		name="text_back",
		tiles="tiles",
		tile_size={4,8}, -- use half width tiles for font
		tilemap_size={math.ceil(screen.hx/4),math.ceil(screen.hy/8)},
		layer=1,
	},
	{
		component="copper",
		name="copper1",
		layer=2,
	},
	{
		component="sprites",
		name="sprites1",
		tiles="tiles",
		layer=3,
	},
	{
		component="copper",
		name="copper2",
		layer=4,
	},
	{
		component="sprites",
		name="sprites2",
		tiles="tiles",
		layer=5,
	},
	{
		component="copper",
		name="copper3",
		layer=6,
	},
	{
		component="sprites",
		name="sprites3",
		tiles="tiles",
		layer=7,
	},
	{
		component="tilemap",
		name="text",
		tiles="tiles",
		tile_size={4,8}, -- use half width tiles for font
		tilemap_size={math.ceil(screen.hx/4),math.ceil(screen.hy/8)},
		layer=8,
		scroll={0,-4},
	},
}


-- define all graphics in this global, we will convert and upload to tiles at setup
-- although you can change tiles during a game, we try and only upload graphics
-- during initial setup so we have a nice looking sprite sheet to be edited by artists

graphics={
{0x0100,"char_empty",[[
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
]]},
{0x0101,"char_black",[[
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
]]},
{0x0102,"char_darkgrey",[[
2 2 2 2 2 2 2 2 
2 2 2 2 2 2 2 2 
2 2 2 2 2 2 2 2 
2 2 2 2 2 2 2 2 
2 2 2 2 2 2 2 2 
2 2 2 2 2 2 2 2 
2 2 2 2 2 2 2 2 
2 2 2 2 2 2 2 2 
]]},
{0x0103,"char_grey",[[
4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 
]]},
{0x0104,"char_white",[[
7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 
]]},
{0x0105,"char_dot",[[
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . 7 7 . . . 
. . . 7 7 . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
]]},


{0x0200,"poly",[[
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 0 0 0 3 3 3 3 0 0 0 3 3 3 
3 3 3 0 0 0 3 3 3 3 0 0 0 3 3 3 
3 3 3 0 0 0 3 3 3 3 0 0 0 3 3 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
]]},

{0x0202,"poly_open",[[
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 0 0 0 3 3 3 3 0 0 0 3 3 3 
3 3 3 0 0 0 3 3 3 3 0 0 0 3 3 3 
3 3 3 0 0 0 3 3 3 3 0 0 0 3 3 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
]]},

{0x0204,"poly_look",[[
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 3 3 0 0 0 3 3 3 3 0 0 0 3 
3 3 3 3 3 0 0 0 3 3 3 3 0 0 0 3 
3 3 3 3 3 0 0 0 3 3 3 3 0 0 0 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
]]},

{0x0500,"morf",[[
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . g g . . . . . . g g . . . . . . g g . . . 
. . . g g . . . . . . g g . . . . . . g g . . . 
. . . g g . . . . . . g g . . . . . . g g . . . 
. . . g g . . . . . . g g . . . . . . g g . . . 
. . g g g g . . . . g g g g . . . . g g g g . . 
. . g g g g . . . . g g g g . . . . g g g g . . 
. . g g g g . . . . g g g g . . . . g g g g . . 
. . g g g g . . . . g g g g . . . . g g g g . . 
. g g g g g g . . g g g g g g . . g g g g g g . 
. g g g g g g . . g g g g g g . . g g g g g g . 
. g g g g g g . . g g g g g g . . g g g g g g . 
. g g g g g g . . g g g g g g . . g g g g g g . 
g g g g g g g g g g g g g g g g g g g g g g g g 
g g g g g g g g g g g g g g g g g g g g g g g g 
g g g g g g g g g g g g g g g g g g g g g g g g 
g g g g g g g g g g g g g g g g g g g g g g g g 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 3 3 3 0 0 0 0 0 0 0 0 3 3 3 0 0 0 0 0 
0 0 0 0 0 3 3 3 0 0 0 0 0 0 0 0 3 3 3 0 0 0 0 0 
0 0 0 0 0 3 3 3 0 0 0 0 0 0 0 0 3 3 3 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
]]},

{0x0503,"morf_open",[[
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . g g . . . . . . g g . . . . . . g g . . . 
. . . g g . . . . . . g g . . . . . . g g . . . 
. . . g g . . . . . . g g . . . . . . g g . . . 
. . . g g . . . . . . g g . . . . . . g g . . . 
. . g g g g . . . . g g g g . . . . g g g g . . 
. . g g g g . . . . g g g g . . . . g g g g . . 
. . g g g g . . . . g g g g . . . . g g g g . . 
. . g g g g . . . . g g g g . . . . g g g g . . 
. g g g g g g . . g g g g g g . . g g g g g g . 
. g g g g g g . . g g g g g g . . g g g g g g . 
. g g g g g g . . g g g g g g . . g g g g g g . 
. g g g g g g . . g g g g g g . . g g g g g g . 
g g g g g g g g g g g g g g g g g g g g g g g g 
g g g g g g g g g g g g g g g g g g g g g g g g 
g g g g g g g g g g g g g g g g g g g g g g g g 
g g g g g g g g g g g g g g g g g g g g g g g g 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 3 3 3 0 0 0 0 0 0 0 0 3 3 3 0 0 0 0 0 
0 0 0 0 0 3 3 3 0 0 0 0 0 0 0 0 3 3 3 0 0 0 0 0 
0 0 0 0 0 3 3 3 0 0 0 0 0 0 0 0 3 3 3 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
]]},

{0x0506,"morf_look",[[
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . g g . . . . . . g g . . . . . . g g . . . 
. . . g g . . . . . . g g . . . . . . g g . . . 
. . . g g . . . . . . g g . . . . . . g g . . . 
. . . g g . . . . . . g g . . . . . . g g . . . 
. . g g g g . . . . g g g g . . . . g g g g . . 
. . g g g g . . . . g g g g . . . . g g g g . . 
. . g g g g . . . . g g g g . . . . g g g g . . 
. . g g g g . . . . g g g g . . . . g g g g . . 
. g g g g g g . . g g g g g g . . g g g g g g . 
. g g g g g g . . g g g g g g . . g g g g g g . 
. g g g g g g . . g g g g g g . . g g g g g g . 
. g g g g g g . . g g g g g g . . g g g g g g . 
g g g g g g g g g g g g g g g g g g g g g g g g 
g g g g g g g g g g g g g g g g g g g g g g g g 
g g g g g g g g g g g g g g g g g g g g g g g g 
g g g g g g g g g g g g g g g g g g g g g g g g 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 3 3 3 0 0 0 0 0 0 0 0 3 3 3 0 0 0 0 0 0 0 
0 0 0 3 3 3 0 0 0 0 0 0 0 0 3 3 3 0 0 0 0 0 0 0 
0 0 0 3 3 3 0 0 0 0 0 0 0 0 3 3 3 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
]]},

{0x0b00,"laptop_poly",[[
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. 0 0 0 0 0 0 0 0 0 0 0 0 0 0 . 
. 0 0 0 0 0 0 0 0 0 0 0 0 0 0 . 
. 0 0 0 0 0 0 0 0 0 0 0 0 0 0 . 
. 0 0 0 0 0 0 7 7 0 0 0 0 0 0 . 
. 0 0 0 0 0 7 7 0 0 0 0 0 0 0 . 
. 0 0 0 0 0 0 7 7 0 0 0 0 0 0 . 
. 0 0 0 0 0 0 0 0 0 0 0 0 0 0 . 
. 0 0 0 0 0 0 0 0 0 0 0 0 C 0 . 
. 0 0 0 0 0 0 0 0 0 0 0 0 R 0 . 
. 0 0 0 0 0 0 0 0 0 0 0 0 0 0 . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
]]},

{0x0b02,"laptop_morf",[[
. . . 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 . . . 
. . . 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 . . . 
. . . 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 . . . 
. . . 1 1 1 1 1 1 1 7 7 1 1 1 1 1 1 1 1 1 . . . 
. . . 1 1 1 1 1 1 7 1 1 1 7 7 1 1 1 1 1 1 . . . 
. . . 1 1 1 1 1 1 7 1 1 7 7 1 1 1 1 1 1 1 . . . 
. . . 1 1 1 1 1 1 7 1 1 1 7 7 1 1 1 1 1 1 . . . 
. . . 1 1 1 1 1 1 1 7 7 1 1 1 1 1 1 1 1 1 . . . 
. . . 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 . . . 
. . . 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 C 1 . . . 
. . . 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 R 1 . . . 
. . . 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
]]},

}


local combine_legends=function(...)
	local legend={}
	for _,t in ipairs{...} do -- merge all
		for n,v in pairs(t) do -- shallow copy, right side values overwrite left
			legend[n]=v
		end
	end
	return legend
end

local default_legend={
	[0]={ name="char_empty",	},

	[". "]={ name="char_darkgrey",				cell={0,0,0,0}, },
	["0 "]={ name="char_black",				solid=1, dense=1, cell={0,0,0,1}, },		-- empty border
	["4 "]={ name="char_grey",				solid=1, dense=1, cell={0,0,0,1}, },		-- empty border
	["7 "]={ name="char_white",				solid=1, dense=1, cell={0,0,0,1}, },		-- empty border

}
	
levels={}
levels[0]={
legend=combine_legends(default_legend,{
}),
title="This is a test",
map=[[
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
]],
}


-- handle tables of entities that need to be updated and drawn.

local entities -- a place to store everything that needs to be updated
local entities_info -- a place to store options or values
local entities_reset=function()
	entities={}
	entities_info={}
end
-- get items for the given caste
local entities_items=function(caste)
	caste=caste or "generic"
	if not entities[caste] then entities[caste]={} end -- create on use
	return entities[caste]
end
-- add an item to this caste
local entities_add=function(it,caste)
	caste=caste or it.caste -- probably from item
	caste=caste or "generic"
	local items=entities_items(caste)
	items[ #items+1 ]=it -- add to end of array
	return it
end
-- call this functions on all items in every caste
local entities_call=function(fname,...)
	local count=0
	for caste,items in pairs(entities) do
		for idx=#items,1,-1 do -- call backwards so item can remove self
			local it=items[idx]
			if it[fname] then
				it[fname](it,...)
				count=count+1
			end
		end			
	end
	return count -- number of items called
end
-- get/set info associated with this entities
local entities_get=function(name)       return entities_info[name]							end
local entities_set=function(name,value)        entities_info[name]=value	return value	end
local entities_manifest=function(name)
	if not entities_info[name] then entities_info[name]={} end -- create empty
	return entities_info[name]
end
-- reset the entities
entities_reset()


-- call coroutine with traceback on error
local coroutine_resume_and_report_errors=function(co,...)
	local a,b=coroutine.resume(co,...)
	if a then return a,b end -- no error
	error( b.."\nin coroutine\n"..debug.traceback(co) , 2 ) -- error
end


-- create space and handlers
function setup_space()

	local space=entities_set("space", chipmunk.space() )
	
	space:gravity(0,700)
	space:damping(0.5)
	space:sleep_time_threshold(1)
	space:idle_speed_threshold(10)

	return space
end


function setup_level(idx)

	local level=entities_set("level",entities_add{})

	local names=system.components.tiles.names

	level.updates={} -- tiles to update (animate)
	level.update=function()
		for v,b in pairs(level.updates) do -- update these things
			if v.update then v:update() end
		end
	end

-- init map and space

	local space=setup_space()

	for n,v in pairs( levels[idx].legend ) do -- fixup missing values (this will slightly change your legend data)
		if v.name then -- convert name to tile idx
			v.idx=names[v.name].idx
		end
		if v.idx then -- convert idx to r,g,b,a
			v[1]=(          (v.idx    )%256)
			v[2]=(math.floor(v.idx/256)%256)
			v[3]=31
			v[4]=0
		end
	end

	local map=entities_set("map", bitdown.pix_tiles(  levels[idx].map,  levels[idx].legend ) )
	
	level.title=levels[idx].title

--	bitdown.pix_grd(    levels[idx].map,  levels[idx].legend,      system.components.map.tilemap_grd  ) -- draw into the screen (tiles)

	bitdown.map_build_collision_strips(map,function(tile)
		if tile.coll then -- can break the collision types up some more by appending a code to this setting
			if tile.collapse then -- make unique
				tile.coll=tile.coll..tile.idx
			end
		end
	end)

	for y,line in pairs(map) do
		for x,tile in pairs(line) do
			local shape
			if tile.solid and (not tile.parent) then -- if we have no parent then we are the master tile
			
				local l=1
				local t=tile
				while t.child do t=t.child l=l+1 end -- count length of strip

				if     tile.link==1 then -- x strip
					shape=space.static:shape("box",x*8,y*8,(x+l)*8,(y+1)*8,0)
				elseif tile.link==-1 then  -- y strip
					shape=space.static:shape("box",x*8,y*8,(x+1)*8,(y+l)*8,0)
				else -- single box
					shape=space.static:shape("box",x*8,y*8,(x+1)*8,(y+1)*8,0)
				end

				shape:friction(tile.solid)
				shape:elasticity(tile.solid)
				shape.cx=x
				shape.cy=y
				shape.coll=tile.coll
			end

			tile.map=map -- remember map
			tile.level=level -- remember level
			if shape then -- link shape and tile
				shape.tile=tile
				tile.shape=shape
			end
		end
	end


	for y,line in pairs(map) do
		for x,tile in pairs(line) do
		end
	end

	
end

-- create a fat controller coroutine that handles state changes, fills in entities etc etc etc

local fat_controller=coroutine.create(function()

-- set copper shaders
	system.components.copper1.shader_name="fun_copper_back_comic"
	system.components.copper2.shader_name="fun_copper_back_comic"
	system.components.copper3.shader_name="fun_copper_back_comic"


-- copy font data tiles into top line
	system.components.tiles.bitmap_grd:pixels(0,0,128*4,8, bitdown_font_4x8.grd_mask:pixels(0,0,128*4,8,"") )

-- upload graphics
	system.components.tiles.upload_tiles( graphics )

-- setup background


-- setup game
	entities_reset()

	setup_level(0) -- load map


-- update loop

	local ticks=0

	while true do coroutine.yield()
	
		ticks=ticks+1
	
		entities_call("update")
		entities_get("space"):step(1/screen.fps)

		-- run all the callbacks created by collisions 
		for _,f in pairs(entities_manifest("callbacks")) do f() end
		entities_set("callbacks",{}) -- and reset the list
		
		local letters=math.floor(ticks/4)
		
		local panel
		local talking

		local tprint=system.components.text.text_print

		local speach=function(tab,x,y,w)
			for idx,it in ipairs(tab) do
				if letters<=0 then return end -- no more to draw
				local ls=wstr.smart_wrap(it,w or 25)
				for i=1,#ls do local s=ls[i]
					if letters<=0 then return end -- no more to draw
					if #s > letters then
						s=s:sub(1,letters)
					end
					if idx%2==1 then
						tprint(s,x,y,31,0)
					else
						tprint(s,x+26-#ls[i],y,31-2,0)
					end
					y=y+1
					if #s==0 then -- pause on white space
						letters=letters-8
						talking=nil
					else
						letters=letters-#s
						talking=idx%2
					end
				end
			end
			panel=nil
		end


		if letters>0 then panel=1 end
		speach({[[
I think we may have just released another one of them game things.

]],[[
Well, you know what they say...

]],},2+1,1)

		if letters>0 then panel=2 end
		speach({[[
Uhm, "What doesn't kill you slowly chips away at your soul until you finally seek the sweet release of death."?

]],[[
]],},32+1,1)


		if letters>0 then panel=3 end
		speach({"",[[
NO!

Not those voices...

]],[[
What do you mean? What other voices are there?

]]},62+1,1)

		local bprint=system.components.text_back.text_print
		bprint("Post naval depression.",2,0,25,0)
		bprint("4lfa.com",82,15,25,0)

		system.components.text_back.dirty(true)
		system.components.text.dirty(true)

		system.components.sprites1.list_reset() -- remove old sprites here
		system.components.sprites2.list_reset() -- remove old sprites here
		system.components.sprites3.list_reset() -- remove old sprites here

		local names=system.components.tiles.names

		for i=1,3 do
			local pt,mt=0,0
			if panel==i then
				if talking==1 then pt=math.floor(ticks/8)%2 mt=2 end
				if talking==0 then mt=math.floor(ticks/8)%2 pt=2 end
			end

			system.components["sprites"..i].list_add({t=names.laptop_poly.idx,ox=0,oy=0,hx=2*8,hy=3*8,px= 2*8,py=12*8})
			system.components["sprites"..i].list_add({t=names.laptop_morf.idx,ox=0,oy=0,hx=3*8,hy=3*8,px= 9*8,py=12*8})

			system.components["sprites"..i].list_add({t=names.poly.idx+(pt*2),ox=0,oy=0,hx=2*8,hy=3*8,px= 2*8,py=10*8})
			system.components["sprites"..i].list_add({t=names.morf.idx+(mt*3),ox=0,oy=0,hx=3*8,hy=6*8,px= 9*8,py= 7*8})

		end

	end


end)


-- this is the main function, code below called repeatedly to update and draw or handle other messages (eg mouse)

function main(need)

	if not need.setup then need=coroutine.yield() end -- wait for setup request (should always be first call)

	coroutine_resume_and_report_errors( fat_controller ) -- setup

-- after setup we should yield and then perform updates only if requested from a yield
	local done=false while not done do
		need=coroutine.yield()
		if need.update then
			coroutine_resume_and_report_errors( fat_controller ) -- update
		end
		if need.draw then
			entities_call("draw") -- because we are going to add them all in again here
		end
		if need.clean then done=true end -- cleanup requested
	end

-- perform cleanup here

end


-- Include GLSL code inside a comment
-- The GLSL handler will pickup the #shader directive and use all the code following it until the next #shader directive.
--[=[
#shader "fun_copper_back_comic"

#ifdef VERTEX_SHADER

uniform mat4 modelview;
uniform mat4 projection;
uniform vec4 color;

attribute vec3 a_vertex;
attribute vec2 a_texcoord;

varying vec2  v_texcoord;
varying vec4  v_color;
 
void main()
{
    gl_Position = projection * vec4(a_vertex, 1.0);
	v_texcoord=a_texcoord;
	v_color=color;
}


#endif
#ifdef FRAGMENT_SHADER

#if defined(GL_FRAGMENT_PRECISION_HIGH)
precision highp float; /* really need better numbers if possible */
#endif


varying vec2  v_texcoord;
varying vec4  v_color;


uniform vec3      iResolution;           // viewport resolution (in pixels)
uniform float     iGlobalTime;           // shader playback time (in seconds)

void mainImage( out vec4 fragColor, in vec2 fragCoord );

void main(void)
{
    vec2 uv=v_texcoord;
    uv.y=iResolution.y-uv.y;
    mainImage(gl_FragColor,uv);
}



// Cellular noise ("Worley noise") in 3D in GLSL.
// Copyright (c) Stefan Gustavson 2011-04-19. All rights reserved.
// This code is released under the conditions of the MIT license.
// See LICENSE file for details.
// https://github.com/stegu/webgl-noise

// Modulo 289 without a division (only multiplications)
vec3 mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

// Modulo 7 without a division
vec3 mod7(vec3 x) {
  return x - floor(x * (1.0 / 7.0)) * 7.0;
}

// Permutation polynomial: (34x^2 + x) mod 289
vec3 permute(vec3 x) {
  return mod289((34.0 * x + 1.0) * x);
}

// Cellular noise, returning F1 and F2 in a vec2.
// 3x3x3 search region for good F2 everywhere, but a lot
// slower than the 2x2x2 version.
// The code below is a bit scary even to its author,
// but it has at least half decent performance on a
// modern GPU. In any case, it beats any software
// implementation of Worley noise hands down.

vec2 cellular(vec3 P) {
#define K 0.142857142857 // 1/7
#define Ko 0.428571428571 // 1/2-K/2
#define K2 0.020408163265306 // 1/(7*7)
#define Kz 0.166666666667 // 1/6
#define Kzo 0.416666666667 // 1/2-1/6*2
#define jitter 1.0 // smaller jitter gives more regular pattern

	vec3 Pi = mod289(floor(P));
 	vec3 Pf = fract(P) - 0.5;

	vec3 Pfx = Pf.x + vec3(1.0, 0.0, -1.0);
	vec3 Pfy = Pf.y + vec3(1.0, 0.0, -1.0);
	vec3 Pfz = Pf.z + vec3(1.0, 0.0, -1.0);

	vec3 p = permute(Pi.x + vec3(-1.0, 0.0, 1.0));
	vec3 p1 = permute(p + Pi.y - 1.0);
	vec3 p2 = permute(p + Pi.y);
	vec3 p3 = permute(p + Pi.y + 1.0);

	vec3 p11 = permute(p1 + Pi.z - 1.0);
	vec3 p12 = permute(p1 + Pi.z);
	vec3 p13 = permute(p1 + Pi.z + 1.0);

	vec3 p21 = permute(p2 + Pi.z - 1.0);
	vec3 p22 = permute(p2 + Pi.z);
	vec3 p23 = permute(p2 + Pi.z + 1.0);

	vec3 p31 = permute(p3 + Pi.z - 1.0);
	vec3 p32 = permute(p3 + Pi.z);
	vec3 p33 = permute(p3 + Pi.z + 1.0);

	vec3 ox11 = fract(p11*K) - Ko;
	vec3 oy11 = mod7(floor(p11*K))*K - Ko;
	vec3 oz11 = floor(p11*K2)*Kz - Kzo; // p11 < 289 guaranteed

	vec3 ox12 = fract(p12*K) - Ko;
	vec3 oy12 = mod7(floor(p12*K))*K - Ko;
	vec3 oz12 = floor(p12*K2)*Kz - Kzo;

	vec3 ox13 = fract(p13*K) - Ko;
	vec3 oy13 = mod7(floor(p13*K))*K - Ko;
	vec3 oz13 = floor(p13*K2)*Kz - Kzo;

	vec3 ox21 = fract(p21*K) - Ko;
	vec3 oy21 = mod7(floor(p21*K))*K - Ko;
	vec3 oz21 = floor(p21*K2)*Kz - Kzo;

	vec3 ox22 = fract(p22*K) - Ko;
	vec3 oy22 = mod7(floor(p22*K))*K - Ko;
	vec3 oz22 = floor(p22*K2)*Kz - Kzo;

	vec3 ox23 = fract(p23*K) - Ko;
	vec3 oy23 = mod7(floor(p23*K))*K - Ko;
	vec3 oz23 = floor(p23*K2)*Kz - Kzo;

	vec3 ox31 = fract(p31*K) - Ko;
	vec3 oy31 = mod7(floor(p31*K))*K - Ko;
	vec3 oz31 = floor(p31*K2)*Kz - Kzo;

	vec3 ox32 = fract(p32*K) - Ko;
	vec3 oy32 = mod7(floor(p32*K))*K - Ko;
	vec3 oz32 = floor(p32*K2)*Kz - Kzo;

	vec3 ox33 = fract(p33*K) - Ko;
	vec3 oy33 = mod7(floor(p33*K))*K - Ko;
	vec3 oz33 = floor(p33*K2)*Kz - Kzo;

	vec3 dx11 = Pfx + jitter*ox11;
	vec3 dy11 = Pfy.x + jitter*oy11;
	vec3 dz11 = Pfz.x + jitter*oz11;

	vec3 dx12 = Pfx + jitter*ox12;
	vec3 dy12 = Pfy.x + jitter*oy12;
	vec3 dz12 = Pfz.y + jitter*oz12;

	vec3 dx13 = Pfx + jitter*ox13;
	vec3 dy13 = Pfy.x + jitter*oy13;
	vec3 dz13 = Pfz.z + jitter*oz13;

	vec3 dx21 = Pfx + jitter*ox21;
	vec3 dy21 = Pfy.y + jitter*oy21;
	vec3 dz21 = Pfz.x + jitter*oz21;

	vec3 dx22 = Pfx + jitter*ox22;
	vec3 dy22 = Pfy.y + jitter*oy22;
	vec3 dz22 = Pfz.y + jitter*oz22;

	vec3 dx23 = Pfx + jitter*ox23;
	vec3 dy23 = Pfy.y + jitter*oy23;
	vec3 dz23 = Pfz.z + jitter*oz23;

	vec3 dx31 = Pfx + jitter*ox31;
	vec3 dy31 = Pfy.z + jitter*oy31;
	vec3 dz31 = Pfz.x + jitter*oz31;

	vec3 dx32 = Pfx + jitter*ox32;
	vec3 dy32 = Pfy.z + jitter*oy32;
	vec3 dz32 = Pfz.y + jitter*oz32;

	vec3 dx33 = Pfx + jitter*ox33;
	vec3 dy33 = Pfy.z + jitter*oy33;
	vec3 dz33 = Pfz.z + jitter*oz33;

	vec3 d11 = dx11 * dx11 + dy11 * dy11 + dz11 * dz11;
	vec3 d12 = dx12 * dx12 + dy12 * dy12 + dz12 * dz12;
	vec3 d13 = dx13 * dx13 + dy13 * dy13 + dz13 * dz13;
	vec3 d21 = dx21 * dx21 + dy21 * dy21 + dz21 * dz21;
	vec3 d22 = dx22 * dx22 + dy22 * dy22 + dz22 * dz22;
	vec3 d23 = dx23 * dx23 + dy23 * dy23 + dz23 * dz23;
	vec3 d31 = dx31 * dx31 + dy31 * dy31 + dz31 * dz31;
	vec3 d32 = dx32 * dx32 + dy32 * dy32 + dz32 * dz32;
	vec3 d33 = dx33 * dx33 + dy33 * dy33 + dz33 * dz33;

	// Sort out the two smallest distances (F1, F2)
#if 1
	// Cheat and sort out only F1
	vec3 d1 = min(min(d11,d12), d13);
	vec3 d2 = min(min(d21,d22), d23);
	vec3 d3 = min(min(d31,d32), d33);
	vec3 d = min(min(d1,d2), d3);
	d.x = min(min(d.x,d.y),d.z);
	return vec2(sqrt(d.x)); // F1 duplicated, no F2 computed
#else
	// Do it right and sort out both F1 and F2
	vec3 d1a = min(d11, d12);
	d12 = max(d11, d12);
	d11 = min(d1a, d13); // Smallest now not in d12 or d13
	d13 = max(d1a, d13);
	d12 = min(d12, d13); // 2nd smallest now not in d13
	vec3 d2a = min(d21, d22);
	d22 = max(d21, d22);
	d21 = min(d2a, d23); // Smallest now not in d22 or d23
	d23 = max(d2a, d23);
	d22 = min(d22, d23); // 2nd smallest now not in d23
	vec3 d3a = min(d31, d32);
	d32 = max(d31, d32);
	d31 = min(d3a, d33); // Smallest now not in d32 or d33
	d33 = max(d3a, d33);
	d32 = min(d32, d33); // 2nd smallest now not in d33
	vec3 da = min(d11, d21);
	d21 = max(d11, d21);
	d11 = min(da, d31); // Smallest now in d11
	d31 = max(da, d31); // 2nd smallest now not in d31
	d11.xy = (d11.x < d11.y) ? d11.xy : d11.yx;
	d11.xz = (d11.x < d11.z) ? d11.xz : d11.zx; // d11.x now smallest
	d12 = min(d12, d21); // 2nd smallest now not in d21
	d12 = min(d12, d22); // nor in d22
	d12 = min(d12, d31); // nor in d31
	d12 = min(d12, d32); // nor in d32
	d11.yz = min(d11.yz,d12.xy); // nor in d12.yz
	d11.y = min(d11.y,d12.z); // Only two more to go
	d11.y = min(d11.y,d11.z); // Done! (Phew!)
	return sqrt(d11.xy); // F1, F2
#endif
}

// main
void mainImage( out vec4 fragColor, in vec2 fragCoord ) {

	float fa=cellular( vec3(fragCoord,iGlobalTime*3.0)/8.0 ).x;
	float fb=cellular( vec3(fragCoord,127.0+iGlobalTime*7.0)/8.0 ).x;
	float f=fa*fb;	
//	f=f*f;

	vec3 color=vec3(
		(3.0+ f*f*2.0)/16.0 ,
		(3.0+ f*f*2.0)/16.0 ,
		(3.0+ f  *1.0)/16.0 );
	
	float p= ((fragCoord.y-16.0)/24.0) ;
	
	if(p>=0.0)
	{
		p=clamp( abs(p) , 0.0 , 1.0 );
		fragColor = vec4( mix( vec3(5.0/16.0) , color , vec3(p) ) , 1.0 );
	}
	else
	{
		p=clamp( abs(p) , 0.0 , 1.0 );
		fragColor = vec4( mix( vec3(3.0/16.0) , vec3(10.0/16.0) , vec3(p) ) , 1.0 );
	}

}



#endif

#shader
//]=]
