
local bit=require("bit")
local wstr=require("wetgenes.string")
local wgrd=require("wetgenes.grd")
local tardis=require("wetgenes.tardis")	-- matrix/vector math

local bitdown=require("wetgenes.gamecake.fun.bitdown")
local bitdown_font_4x8=require("wetgenes.gamecake.fun.bitdown_font_4x8")

local chipmunk=require("wetgenes.chipmunk")


local hx,hy,ss=424,240,3
local fps=60

local cmap=bitdown.cmap -- use default swanky32 colors

--request this hardware setup before calling main
hardware={
	{
		component="screen",
		size={hx,hy},
		bloom=0.75,
		filter="scanline",
		scale=ss,
		fps=60,
		drawlist={ -- draw components with a 2 pix *merged* drop shadow
			{ color={0,0,0,0.5} , dx=1 , dy=1 },
			{ color={0,0,0,0.5} , dx=2 , dy=2 },
			{ color={1,1,1,1  } , dx=0 , dy=0 },
		}
	},
	{
		component="colors",
		cmap=cmap, -- swanky32 palette
	},
	{
		component="tiles",
		name="tiles",
		tile_size={8,8},
		bitmap_size={64,16},
	},
	{
		component="copper",
		name="copper",
		size={hx,hy},
		drawtype="first",
	},
	{
		component="tilemap",
		name="map",
		tiles="tiles",
		tilemap_size={math.ceil(hx/8),math.ceil(hy/8)},
		drawtype="merge",
	},
	{
		component="sprites",
		name="sprites",
		tiles="tiles",
		drawtype="merge",
	},
	{
		component="tilemap",
		name="text",
		tiles="tiles",
		tile_size={4,8}, -- use half width tiles for font
		tilemap_size={math.ceil(hx/4),math.ceil(hy/8)},
		drawtype="last",
		drawlist={ -- draw components with a 2 pix *merged* drop shadow
			{ color={0,0,0,0.5} , dx=1 , dy=1 },
			{ color={0,0,0,0.5} , dx=2 , dy=2 },
			{ color={1,1,1,1  } , dx=0 , dy=0 },
		}
	},
}


local tiles={}
local names={} -- a name -> tile number lookup
local maps={}

local set_tile_name=function(tile,name,data)
	names[name]=tile
	tiles[tile]=data
end

local tilemap={
	[0]={0,1,0,0},

	[". "]={  0,  1,  31,  0},
	["1 "]={  1,  1,  31,  0,	solid=1},
	["2 "]={  2,  1,  31,  0,	solid=1,dense=1},
	["3 "]={  3,  1,  31,  0,	solid=0},

	["X "]={  4,  1,  31,  0,	deadly=1},
	["5 "]={  5,  1,  31,  0,	solid=1},
	["6 "]={  6,  1,  31,  0,	solid=1},
	["7 "]={  7,  1,  31,  0,	solid=1},
	["8 "]={  8,  1,  31,  0,	solid=1},
	["9 "]={  9,  1,  31,  0,	solid=1},
	["A "]={ 10,  1,  31,  0,	solid=1},
	["B "]={ 11,  1,  31,  0,	solid=1},
	["C "]={ 12,  1,  31,  0,	solid=1},
	["D "]={ 13,  1,  31,  0,	solid=1},
	["E "]={ 14,  1,  31,  0,	solid=1},
	["F "]={ 15,  1,  31,  0,	solid=1},

-- items not tiles, so display tile 0 and we will add a sprite for display
	["$ "]={  0,  1,  31,  0,	loot=1},
	["? "]={  0,  1,  31,  0,	item=1},
	["S "]={  0,  1,  31,  0,	"start"},
}


set_tile_name(0x0100,"char_empty",[[
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
]])
set_tile_name(0x0101,"char_wall",[[
O O R R R R O O 
O O R R R R O O 
r r r r o o o o 
r r r r o o o o 
R R O O O O R R 
R R O O O O R R 
o o o o r r r r 
o o o o r r r r 
]])
set_tile_name(0x0102,"char_black",[[
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
]])
set_tile_name(0x0103,"char_box",[[
7 7 7 7 7 7 7 7 
7 0 0 0 0 0 0 7 
7 0 0 0 0 0 0 7 
7 0 0 0 0 0 0 7 
7 0 0 0 0 0 0 7 
7 0 0 0 0 0 0 7 
7 0 0 0 0 0 0 7 
7 7 7 7 7 7 7 7 
]])
set_tile_name(0x0104,"char_spike",[[
R R 7 7 7 7 R R 
R R 7 7 7 7 R R 
. R R 7 7 R R . 
. R R 7 7 R R . 
. . R R R R . . 
. . R R R R . . 
. . . R R . . . 
. . . R R . . . 
]])
set_tile_name(0x0105,"char_0100",[[
. . Y Y Y Y . . 
. Y Y Y Y Y Y . 
Y Y Y Y Y Y Y Y 
Y Y Y Y Y Y Y Y 
Y Y Y Y Y Y Y Y 
Y Y Y Y Y Y Y Y 
. Y Y Y Y Y Y . 
. . Y Y Y Y . . 
]])
set_tile_name(0x0106,"char_0101",[[
. . . . . . . . 
. . Y Y Y Y . . 
. Y Y 0 0 Y Y . 
. Y 0 Y Y 0 Y . 
. Y 0 Y Y 0 Y . 
. Y Y 0 0 Y Y . 
. . Y Y Y Y . . 
. . . . . . . . 
]])

set_tile_name(0x0200,"player_f1",[[
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . 4 4 4 4 . . . . . . . . . . 
. . . . . . . . . 4 2 7 7 1 4 . . . . . . . . . 
. . . . . . . . . 4 7 2 1 7 4 . . . . . . . . . 
. . . . . . . . 4 7 7 1 2 7 7 4 . . . . . . . . 
. . . . . . . 4 7 7 1 7 7 2 7 7 4 . . . . . . . 
. . . . . . . 4 4 4 4 4 4 4 4 4 4 . . . . . . . 
. . . . . . . . . . 7 7 0 7 . . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 7 . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 . . . . . . . . . . 
. . . . . . . . . . . 7 7 . . . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 . . . . . . . . . . 
. . . . . . . . . 7 7 7 7 7 7 . . . . . . . . . 
. . . . . . . . . 7 7 7 7 7 7 . . . . . . . . . 
. . . . . . . . 7 7 7 7 . 7 7 7 . . . . . . . . 
. . . . . . . . 7 7 7 7 7 . 7 7 . . . . . . . . 
. . . . . . . . . . 7 7 7 7 . . . . . . . . . . 
. . . . . . . . . 7 7 7 . 7 7 . . . . . . . . . 
. . . . . . . . . 7 7 . 7 7 7 . . . . . . . . . 
. . . . . . . . . 7 7 7 . 7 7 7 . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
]])
set_tile_name(0x0203,"player_f2",[[
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . 4 4 4 4 . . . . . . . . . . 
. . . . . . . . . 4 2 7 7 1 4 . . . . . . . . . 
. . . . . . . . . 4 7 2 1 7 4 . . . . . . . . . 
. . . . . . . . 4 7 7 1 2 7 7 4 . . . . . . . . 
. . . . . . . 4 7 7 1 7 7 2 7 7 4 . . . . . . . 
. . . . . . . 4 4 4 4 4 4 4 4 4 4 . . . . . . . 
. . . . . . . . . . 7 7 0 7 . . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 7 . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 . . . . . . . . . . 
. . . . . . . . . . . 7 7 . . . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 . . . . . . . . . . 
. . . . . . . . . 7 7 . 7 7 7 . . . . . . . . . 
. . . . . . . . . 7 7 . 7 7 7 . . . . . . . . . 
. . . . . . . . . 7 7 . 7 7 7 . . . . . . . . . 
. . . . . . . . . 7 7 7 . 7 7 . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 . . . . . . . . . . 
. . . . . . . . . . . 7 7 . . . . . . . . . . . 
. . . . . . . . . . . 7 7 . . . . . . . . . . . 
. . . . . . . . . . . 7 7 7 . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
]])
set_tile_name(0x0206,"player_f3",[[
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . 4 4 4 4 . . . . . . . . . . 
. . . . . . . . . 4 2 7 7 1 4 . . . . . . . . . 
. . . . . . . . . 4 7 2 1 7 4 . . . . . . . . . 
. . . . . . . . 4 7 7 1 2 7 7 4 . . . . . . . . 
. . . . . . . 4 7 7 1 7 7 2 7 7 4 . . . . . . . 
. . . . . . . 4 4 4 4 4 4 4 4 4 4 . . . . . . . 
. . . . . . . . . . 7 7 0 7 . . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 7 . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 . . . . . . . . . . 
. . . . . . . . . . . 7 7 . . . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 . . . . . . . . . . 
. . . . . . . . . 7 7 7 7 7 7 . . . . . . . . . 
. . . . . . . . 7 7 7 7 7 7 7 7 . . . . . . . . 
. . . . . . . 7 7 7 7 7 7 7 7 7 7 . . . . . . . 
. . . . . . . 7 7 . 7 7 7 7 . 7 7 . . . . . . . 
. . . . . . . . . . 7 7 7 7 7 . . . . . . . . . 
. . . . . . . . . 7 7 7 . 7 7 . 7 . . . . . . . 
. . . . . . . . 7 7 . . . . 7 7 7 . . . . . . . 
. . . . . . . . 7 7 7 . . . 7 7 . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
]])
set_tile_name(0x0209,"cannon_ball",[[
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . O O O O . . . . . . . . . . 
. . . . . . . R O O O O O O O O R . . . . . . . 
. . . . . . R R R O O O O O O R R R . . . . . . 
. . . . . R R R R O O O O O O R R R R . . . . . 
. . . . . 5 R R R R O O O O R R R R c . . . . . 
. . . . . 5 5 5 R R O O O O R R c c c . . . . . 
. . . . 5 5 5 5 5 5 R 0 0 R c c c c c c . . . . 
. . . . 5 5 5 5 5 5 0 0 0 0 c c c c c c . . . . 
. . . . 5 5 5 5 5 5 0 0 0 0 c c c c c c . . . . 
. . . . 5 5 5 5 5 5 R 0 0 R c c c c c c . . . . 
. . . . . 5 5 5 R R o o o o R R c c c . . . . . 
. . . . . 5 R R R R o o o o R R R R c . . . . . 
. . . . . R R R R o o o o o o R R R R . . . . . 
. . . . . . R R R o o o o o o R R R . . . . . . 
. . . . . . . R o o o o o o o o R . . . . . . . 
. . . . . . . . . . o o o o . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
]])
set_tile_name(0x020C,"bubble",[[
. . . . . . . . . 7 7 7 7 7 7 . . . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . 7 7 . . . . . . . . . . 7 7 . . . . . 
. . . . 7 . . . . . . . . . . . . . . 7 . . . . 
. . . 7 . . . 7 7 . . . . . . . . . . . 7 . . . 
. . 7 . . . 7 . . . . . . . . . . . . . . 7 . . 
. . 7 . . 7 . . . . . . . . . . . . . . . 7 . . 
. 7 . . . . . . . . . . . . . . . . . . . . 7 . 
. 7 . . . . . . . . . . . . . . . . . . . . 7 . 
7 . . . . . . . . . . . . . . . . . . . . . . 7 
7 . . . . . . . . . . . . . . . . . . . . . . 7 
7 . . . . . . . . . . . . . . . . . . . . . . 7 
7 . . . . . . . . . . . . . . . . . . . . . . 7 
7 . . . . . . . . . . . . . . . . . . . . . . 7 
7 . . . . . . . . . . . . . . . . . . . . . . 7 
. 7 . . . . . . . . . . . . . . . . . . . . 7 . 
. 7 . . . . . . . . . . . . . . . . . . . . 7 . 
. . 7 . . . . . . . . . . . . . . . 7 . . 7 . . 
. . 7 . . . . . . . . . . . . . . 7 . . . 7 . . 
. . . 7 . . . . . . . . . . . 7 7 . . . 7 . . . 
. . . . 7 . . . . . . . . . . . . . . 7 . . . . 
. . . . . 7 7 . . . . . . . . . . 7 7 . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . . . 7 7 7 7 7 7 . . . . . . . . . 
]])

set_tile_name(0x0500,"coin",[[
. . . . . . . . 
. . Y Y Y Y . . 
. Y Y 0 0 Y Y . 
Y Y 0 Y Y 0 Y Y 
Y Y Y 0 0 Y Y Y 
Y Y 0 Y Y 0 Y Y 
. Y Y 0 0 Y Y . 
. . Y Y Y Y . . 
]])

set_tile_name(0x0600,"body_p1",[[
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . 4 4 4 4 . . . . . . 
. . . . . 4 2 7 7 1 4 . . . . . 
. . . . . 4 7 2 1 7 4 . . . . . 
. . . . 4 7 7 1 2 7 7 4 . . . . 
. . . 4 7 7 1 7 7 2 7 7 4 . . . 
. . . 4 4 4 4 4 4 4 4 4 4 . . . 
. . . . . . 7 7 0 7 . . . . . . 
. . . . . . 7 7 7 7 7 . . . . . 
. . . . . . 7 7 7 7 . . . . . . 
. . . . . . . 7 7 . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
]])

set_tile_name(0x0602,"body_p2",[[
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . 7 7 . . . . . . . 
. . . . . . 7 7 7 7 . . . . . . 
. . . . . 7 7 7 7 7 7 . . . . . 
. . . . 7 7 7 7 7 7 7 7 . . . . 
. . . 7 7 7 7 7 7 7 7 7 7 . . . 
. . . 7 7 . 7 7 7 7 . 7 7 . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
]])

set_tile_name(0x0604,"body_p3",[[
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . 7 7 7 7 . . . . . . 
. . . . . . 7 7 7 7 7 . . . . . 
. . . . . 7 7 7 . 7 7 . 7 . . . 
. . . . 7 7 . . . . 7 7 7 . . . 
. . . . 7 7 7 . . . 7 7 . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
]])

maps[0]=[[
2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
1 . . . . . . . . . . . . . . . . $ . X . . . . X . . . . . . . . . . . . . . . . . . ? . ? . ? . ? . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . $ . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ? . . . . . . . 1 
1 . . . . $ . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . ? . . . . . . . . . . . . . . 1 1 1 1 1 1 1 1 1 1 . . . . . . . . . . . . . . . . . . . ? . ? . . . 1 
1 . . . ? . . . . . . . . . . . . . . . . . . . . . . . 1 . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 1 1 1 1 1 1 1 1 1 1 1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . 1 . . ? . . . . . . . . . . . . . . . 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
1 . . . . . . . . . . 1 . . . . . . . . . . . . . . . . . 1 . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . 1 1 1 1 1 1 . . . . . . . . ? . . . 1 . . . . $ . . . . . . $ . . . . . . $ . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . 1 1 1 . . . . . . . . . . . 1 . . . . . 1 . . . . . . 1 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ? . ? . . . 1 . . . . . 1 . . . . . . 1 1 
1 . . . . . . . . . . . . . . . . . . . . . $ $ . . . . . . . . . . . . . . 1 . . . . . 1 . . . . . . 1 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
1 . . . . . . . . . . $ . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . 1 . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . 1 . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . S . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . $ . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . 1 . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . 1 1 1 . . . . . ? . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . $ . . . . . 1 . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . 1 . . . . . 1 . . . . . . . . . 1 . . . . . . . . 1 1 1 . . . . $ . . . . . . . . . . . . . . 1 
1 . . . 1 1 . . . . . 1 . . . . . . . . . . . . . . . . . . 1 1 1 . . . . . . $ . . . . . . . . . . . . 1 
1 1 . . 1 1 . . . . 1 1 1 . . . . . 1 . . . . . . . . . . . 1 1 1 . . . . . . . . $ . . . . . . . . . . 1 
1 1 . . 1 1 . . . 1 1 1 1 1 . . . . 1 1 . . . . . . . . . . 1 1 1 . . . . . . . . . . . . . . . . . . . 1 
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
]]


function main(need)

	if not need.setup then need=coroutine.yield() end -- wait for setup request (should always be first call)

	local game_time=0
	local start_time -- set when we add a player
	local finish_time -- set when all loot is collected

-- cache components in locals for less typing
	local ctiles   = system.components.tiles
	local ccopper  = system.components.copper
	local cmap     = system.components.map
	local csprites = system.components.sprites
	local ctext    = system.components.text

	ctext.py=0
	
--	ccopper.shader_name="fun_copper_back_noise"


-- copy font data
	ctiles.bitmap_grd:pixels(0,0,128*4,8, bitdown_font_4x8.grd_mask:pixels(0,0,128*4,8,"") )

-- copy image data
	bitdown.pixtab_tiles( tiles,    bitdown.cmap, ctiles   )

-- screen
	bitdown.pix_grd(    maps[0],  tilemap,      cmap.tilemap_grd  )--,0,0,48,32)

-- map for collision etc
	local map=bitdown.pix_tiles(  maps[0],  tilemap )
	
		
	local space=chipmunk.space()
	space:gravity(0,700)
	space:damping(0.5)

-- mess around with low level setting that should not be messed with
--	space:collision_slop(0)
--	space:collision_bias(0)
--	space:iterations(10)

-- items, can be used for general detritus, IE just physics shapes no special actions
	local items={}
	local add_item=function(sprite,h,px,py,bm,bi,bf,be,...)
		local item={}
		items[#items+1]=item
		
		item.sprite=sprite
		item.h=h

		item.active=true
		item.body=space:body(bm,bi)
		item.body:position(px,py)

		item.shape=item.body:shape(...)
		item.shape:friction(bf)
		item.shape:elasticity(be)
		return item
	end


-- build collision strips for each tile with a solid or dense member
-- dense will be added for solid tiles that should be dense ( dense means can not jump up through)
	bitdown.map_build_collision_strips(map,function(tile)
		if tile.coll then -- can break the collision types up some more by appending a code to this
		end
	end)

	for y,line in pairs(map) do
		for x,tile in pairs(line) do
			if tile.deadly then -- a deadly tile

				shape=space.static:shape("box",x*8,y*8,(x+1)*8,(y+1)*8,0)
				shape:friction(1)
				shape:elasticity(1)
				shape.cx=x
				shape.cy=y
				shape:collision_type(0x1002) -- a tile that kills

			elseif tile.solid and (not tile.parent) then -- if we have no parent then we are the master tile
			
				local l=1
				local t=tile
				while t.child do t=t.child l=l+1 end -- count length of strip

				local shape
				
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
				if not tile.dense then 
					shape:collision_type(0x1001) -- a tile we can jump up through
				end
			end
		end
	end

	space:add_handler({
		presolve=function(it)

--print(wstr.dump(it))
			local points=it:points()

-- once we trigger headroom, we keep a table of headroom shapes and it is not reset until total separation
			if it.shape_b.in_body.headroom then
				local headroom=false
				for n,v in pairs(it.shape_b.in_body.headroom) do headroom=true break end -- still touching an old headroom shape?
				if ( (points.normal_y>0) or headroom) then -- can only headroom through non dense tiles
					it.shape_b.in_body.headroom[it.shape_a]=true
					return it:ignore()
				end
			end
			
			return true
		end,
		separate=function(it)
			if it.shape_b.in_body.headroom then it.shape_b.in_body.headroom[it.shape_a]=nil end
		end
	},0x1001) -- background tiles we can jump up through

	space:add_handler({
		presolve=function(it)
			if it.shape_b.player then -- trigger die
				it.shape_b.player.call="die"
			end
			return true
		end,
	},0x1002) -- deadly things

	space:add_handler({
		presolve=function(it)
			if it.shape_a.player and it.shape_b.player then
				local pa=it.shape_a.player
				local pb=it.shape_b.player
				if pa.active then
					if pb.bubble_active and pb.joined then -- burst
						pb.call="join"
					end
				end				
				if pb.active then
					if pa.bubble_active and pa.joined then -- burst
						pa.call="join"
					end
				end				
			end
			return true
		end,
		postsolve=function(it)
			local points=it:points()
			if points.normal_y>0.25 then -- on floor
				it.shape_a.in_body.floor_time=game_time
				it.shape_a.in_body.floor=it.shape_b
			end
			return true
		end,
	},0x2001) -- walking things (players)

	space:add_handler({
		presolve=function(it)
			if it.shape_a.loot and it.shape_b.player then -- trigger collect
				it.shape_a.loot.player=it.shape_b.player
			end
			return false
		end,
	},0x3001) -- loot things (pickups)
	
	local players_colors={30,14,18,7,3,22}
	local players={}
	local loots={}
	for y,line in pairs(map) do
		for x,tile in pairs(line) do

			if tile.loot then
				local loot={}
				loots[#loots+1]=loot

				local shape=space.static:shape("box",x*8,y*8,(x+1)*8,(y+1)*8,0)
				shape:collision_type(0x3001)
				shape.loot=loot
				loot.shape=shape
				loot.px=x*8+4
				loot.py=y*8+4
				loot.active=true
			end
			if tile.item then
				local item={}
				items[#items+1]=item
				
				item.sprite=names.cannon_ball
				item.h=24

				item.active=true
				item.body=space:body(2,2)
				item.body:position(x*8+4,y*8+4)

				item.shape=item.body:shape("circle",8,0,0)
				item.shape:friction(0.5)
				item.shape:elasticity(0.5)

			end
			if tile[5]=="start" then
			
				players.start={x*8+4,y*8+4} --  remember start point
			end
		end
	end

	
	for i=1,6 do
		local p={}
		players[i]=p
		p.idx=i
		p.score=0
		
		local t=bitdown.cmap[ players_colors[i] ]
		p.color={}
		p.color.r=t[1]/255
		p.color.g=t[2]/255
		p.color.b=t[3]/255
		p.color.a=t[4]/255
		p.color.idx=players_colors[i]
		
		p.up_text_x=math.ceil( (ctext.tilemap_hx/16)*( 1 + ((i>3 and i+2 or i)-1)*2 ) )

		p.frame=0
		p.frames={0x0200,0x0203,0x0200,0x0206}

		p.bubble=function()
			p.bubble_active=true

			p.bubble_body=space:body(1,1)
			p.bubble_body:position(players.start[1]+i,players.start[2]-i)

			p.bubble_shape=p.bubble_body:shape("circle",6,0,0)
			p.bubble_shape:friction(0.5)
			p.bubble_shape:elasticity(1)

			p.bubble_shape:collision_type(0x2002) -- bubble
			p.bubble_shape.player=p

			p.bubble_body:velocity_func(function(body)
				local px,py=body:position()
				
				body.gravity_x=(players.start[1]-px)*16
				body.gravity_y=(players.start[2]-py)*16
				return true
			end)

		end
		
		p.join=function()
		
			local px,py=players.start[1]+i,players.start[2]
			local vx,vy=0,0

			if p.bubble_active then -- pop bubble
				px,py=p.bubble_body:position()
				vx,vy=p.bubble_body:velocity()
				space:remove(p.bubble_shape) -- auto?
				space:remove(p.bubble_body)
			end

			p.bubble_active=false
			p.active=true
			p.body=space:body(1,math.huge)
			p.body:position(px,py)
			p.body:velocity(vx,vy)
			p.body.headroom={}
			
			p.body:velocity_func(function(body)
--				body.gravity_x=-body.gravity_x
--				body.gravity_y=-body.gravity_y
				return true
			end)
						
			p.floor_time=0 -- last time we had some floor

			p.shape=p.body:shape("segment",0,-4,0,4,4)
			p.shape:friction(1)
			p.shape:elasticity(0)
			p.shape:collision_type(0x2001) -- walker
			p.shape.player=p
			
			p.body.floor_time=0
			if not start_time then start_time=game_time end -- when the game started
		end

		p.die=function()
			if not p.active then return end -- not alive
			
			local px,py=p.body:position()
			local vx,vy=p.body:velocity()

			p.active=false -- die
--			p.dead=true

			space:remove(p.shape) -- auto?
			space:remove(p.body)
			
			local it
			it=add_item(names.body_p1,16,px,py-4,0.25,16,0.1,0.5,"box",-4,-3,4,3,0) it.body:velocity(vx*3,vy*3) it.color=p.color
			it=add_item(names.body_p2,16,px,py+0,0.25,16,0.1,0.5,"box",-3,-2,3,2,0) it.body:velocity(vx*2,vy*2) it.color=p.color
			it=add_item(names.body_p3,16,px,py+4,0.25,16,0.1,0.5,"box",-3,-2,3,2,0) it.body:velocity(vx*1,vy*1) it.color=p.color

		end
		
	end
	
	ups(1).touch="left_right" -- request this touch control scheme for player 0 only

-- save png test
--system.save_fun_png()

-- after setup we should yield and then perform updates only if requested from yield
	local done=false while not done do
		need=coroutine.yield()
		if need.update then
		
			for _,p in ipairs(players) do
				local up=ups(p.idx) -- the controls for this player
				
				p.move=false
				p.jump=up.button("fire") -- right
				if up.button("left") and up.button("right") then -- jump
					p.move=p.move_last
					p.jump=true
				elseif up.button("left") then -- left
					p.move_last="left"
					p.move="left"
				elseif up.button("right") then -- right
					p.move_last="right"
					p.move="right"
				end
				
				if p.call then -- a callback requested
					p[p.call](p)
					p.call=nil
				end
				
				if not p.bubble_active and not p.active then -- can add as bubble
					if up.button("up") or up.button("down") or up.button("left") or up.button("right") or up.button("fire") then
						p.bubble() -- add bubble
					end
				end

				if p.bubble_active then
					if not p.active then
						if not p.joined and p.jump then -- first join is free
							p.joined=true
							p:join() -- join for real and remove bubble
						end
					end
				end
				
				if p.bubble_active then
				
					local px,py=p.bubble_body:position()

					if up.button("left") then
						
						p.bubble_body:apply_force(-120,0,px,py,"world")
						p.dir=-1
						p.frame=p.frame+1
						
					elseif  up.button("right") then

						p.bubble_body:apply_force(120,0,px,py,"world")
						p.dir= 1
						p.frame=p.frame+1

					elseif up.button("up") then
						
						p.bubble_body:apply_force(0,-120,px,py,"world")
						
					elseif  up.button("down") then

						p.bubble_body:apply_force(0,120,px,py,"world")

					end

				elseif p.active then
				
					local jump=200 -- up velocity we want when jumoing
					local speed=60 -- required x velocity
					local airforce=speed*2 -- replaces surface velocity
					local groundforce=speed/2 -- helps surface velocity
					
					if ( game_time-p.body.floor_time < 0.125 ) or ( p.floor_time-game_time > 10 ) then -- floor available recently or not for a very long time (stuck)
					
						p.floor_time=game_time -- last time we had some floor

						p.shape:friction(1)

						if p.jump then

							local vx,vy=p.body:velocity()

							if vy>-20 then -- only when pushing against the ground a little

								vy=-jump
								p.body:velocity(vx,vy)
								
								p.body.floor_time=0
								
							end

						end

						if p.move=="left" then
							
							local vx,vy=p.body:velocity()
							if vx>0 then p.body:velocity(0,vy) end
							
							p.shape:surface_velocity(speed,0)
							if vx>-speed then p.body:apply_force(-groundforce,0,0,0) end
							p.dir=-1
							p.frame=p.frame+1
							
						elseif p.move=="right" then

							local vx,vy=p.body:velocity()
							if vx<0 then p.body:velocity(0,vy) end

							p.shape:surface_velocity(-speed,0)
							if vx<speed then p.body:apply_force(groundforce,0,0,0) end
							p.dir= 1
							p.frame=p.frame+1

						else

							p.shape:surface_velocity(0,0)

						end
						
					else -- in air

						p.shape:friction(0)

						if p.move=="left" then
							
							local vx,vy=p.body:velocity()
							if vx>0 then p.body:velocity(0,vy) end

							if vx>-speed then p.body:apply_force(-airforce,0,0,0) end
							p.shape:surface_velocity(speed,0)
							p.dir=-1
							p.frame=p.frame+1
							
						elseif  p.move=="right" then

							local vx,vy=p.body:velocity()
							if vx<0 then p.body:velocity(0,vy) end

							if vx<speed then p.body:apply_force(airforce,0,0,0) end
							p.shape:surface_velocity(-speed,0)
							p.dir= 1
							p.frame=p.frame+1

						else

							p.shape:surface_velocity(0,0)

						end

					end

				end
			end
			
			space:step(1/fps)
			game_time=game_time+1/fps

--			ctext.px=(ctext.px+1)%360 -- scroll text position
			
		end
		if need.draw then
		
			ctext.dirty(true)
			ctext.text_window()
			ctext.text_clear(0x00000000)
			

-- draw test menu
--[[
for i=1,12 do

	local s=(" "):rep(14)
	ctext.text_print(s,10-2,10-1+i,31,2)

end
for i=1,10 do
	local s=string.format("%2dxx",i)
	s=(" "):rep((10-#s)/2)..s
	s=s..(" "):rep((10-#s))
	ctext.text_print(s,10,10+i,31,1)

end
]]
			local t=start_time and ( (finish_time or game_time) - ( start_time ) ) or 0
			local ts=math.floor(t)
			local tp=math.floor((t%1)*100)

			local s=string.format("%d.%02d",ts,tp)
			ctext.text_print(s,math.floor((ctext.tilemap_hx-#s)/2),0)

			csprites.list_reset()
			for _,p in ipairs(players) do
				if p.bubble_active then

					local px,py=p.bubble_body:position()
					local rz=p.bubble_body:angle()
					p.frame=p.frame%16
					local t=p.frames[1+math.floor(p.frame/4)]
					
					csprites.list_add({t=t,h=24,px=px,py=py,sx=(p.dir or 1)*0.5,s=0.5,rz=180*rz/math.pi,color=p.color})
					
					csprites.list_add({t=names.bubble,h=24,px=px,py=py,s=1})

				elseif p.active then
					local px,py=p.body:position()
					local rz=p.body:angle()
					p.frame=p.frame%16
					local t=p.frames[1+math.floor(p.frame/4)]
					
					csprites.list_add({t=t,h=24,px=px,py=py,sx=p.dir,sy=1,rz=180*rz/math.pi,color=p.color})


					local s=string.format("%d",p.score)
					ctext.text_print(s,math.floor(p.up_text_x-(#s/2)),0,p.color.idx)
					
				end
			end
			for _,item in ipairs(items) do
				if item.active then
					local px,py=item.body:position()
					local rz=item.body:angle()
--					rz=0
					csprites.list_add({t=item.sprite,h=item.h,hx=item.hx,hy=item.hy,px=px,py=py,rz=180*rz/math.pi,color=item.color})
				end
			end
			local remain=0
			for _,loot in ipairs(loots) do
				if loot.active then
					remain=remain+1
					
					local b=math.sin( (game_time*8 + (loot.px+loot.py)/16 ) )*2

					csprites.list_add({t=0x0500,h=8,px=loot.px,py=loot.py+b})
					
					if loot.player then
						loot.player.score=loot.player.score+1
						loot.active=false
						space:remove(loot.shape)
					end
				end
			end
			if remain==0 and not finish_time then -- done
				finish_time=game_time
			end

--			ctext.text_window_center(30,10)
--			ctext.text_clear(0x00000031)

		end
		if need.clean then done=true end -- cleanup requested
	end

-- perform cleanup here


end
