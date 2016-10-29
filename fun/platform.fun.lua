
local bit=require("bit")
local wstr=require("wetgenes.string")
local wgrd=require("wetgenes.grd")
local tardis=require("wetgenes.tardis")	-- matrix/vector math

local bitdown=require("wetgenes.gamecake.fun.bitdown")
local bitdown_font_4x8=require("wetgenes.gamecake.fun.bitdown_font_4x8")

local chipmunk=require("wetgenes.chipmunk")

local ls=function(...) print(wstr.dump(...)) end

local hx,hy,ss=424,240,3
local fps=60

local cmap=bitdown.cmap -- use default swanky32 colors

--request this hardware setup !The components will not exist until after main has been called!
hardware={
	{
		component="screen",
		size={hx,hy},
		bloom=0.75,
		filter="scanline",
		scale=ss,
		fps=60,
		drawlist={ -- draw components with a 2 pix *merged* drop shadow
			{ color={0,0,0,0.25} , dx=2 , dy=2 },
			{ color={0,0,0,0.5} , dx=1 , dy=1 },
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
			{ color={0,0,0,0.25} , dx=2 , dy=2 },
			{ color={0,0,0,0.5} , dx=1 , dy=1 },
			{ color={1,1,1,1  } , dx=0 , dy=0 },
		}
	},
}


local tiles={}
local names={} -- a name -> tile number lookup
local maps={}

local set_tile_name=function(tile,name,data)
	if tiles[name] then print("WARNING REUSE OF NAME",name,tile) end
	if tiles[tile] then print("WARNING REUSE OF TILE",name,tile) end
	names[name]=tile
	tiles[tile]=data
end

local set_tilemap_from_names=function(tilemap)
	for n,v in pairs(tilemap) do
		if v.name then -- convert name to idx
			v.idx=names[v.name]
		end
		if v.idx then -- convert idx to r,g,b,a
			v[1]=(          (v.idx    )%256)
			v[2]=(math.floor(v.idx/256)%256)
			v[3]=31
			v[4]=0
		end
	end
	return tilemap
end


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
set_tile_name(0x0101,"char_black",[[
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
]])
set_tile_name(0x0102,"char_wall",[[
O O R R R R O O 
O O R R R R O O 
r r r r o o o o 
r r r r o o o o 
R R O O O O R R 
R R O O O O R R 
o o o o r r r r 
o o o o r r r r 
]])
set_tile_name(0x0103,"char_floor",[[
R R R R R R R R 
r r r r r r r r 
r r r r r r r r 
. r r r r r r . 
. . r . r r . . 
. . . . r r . . 
. . . . . r . . 
. . . . . . . . 
]])
set_tile_name(0x0104,"char_floor_left",[[
R R R R R R R R 
r r r r r r r r 
r r r r r r r r 
R R R R R R R R 
r r r r r r r r 
r r r r r r r r 
R R R R R R R R 
. . . . . . . . 
]])
set_tile_name(0x0105,"char_floor_right",[[
R R R R R R R R 
r r r r r r r r 
r r r r r r r r 
R R R R R R R R 
r r r r r r r r 
r r r r r r r r 
R R R R R R R R 
. . . . . . . . 
]])
set_tile_name(0x0106,"char_floor_collapse",[[
R r R r R r R r 
r r . r . r . r 
r . r . r . r . 
. r . r . r r . 
. . r . r . . . 
. . . . r . r . 
. . . . . r . . 
. . . . . . . . 
]])

set_tile_name(0x0110,"char_spike_down",[[
R R 7 7 7 7 R R 
R R 7 7 7 7 R R 
. R R 7 7 R R . 
. R R 7 7 R R . 
. . R R R R . . 
. . R R R R . . 
. . . R R . . . 
. . . R R . . . 
]])
set_tile_name(0x0111,"char_spike_up",[[
. . . R R . . . 
. . . R R . . . 
. . R R R R . . 
. . R R R R . . 
. R R 7 7 R R . 
. R R 7 7 R R . 
R R 7 7 7 7 R R 
R R 7 7 7 7 R R 
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


local tilemap=set_tilemap_from_names{
	[0]={0,1,0,0},

	[". "]={ name="char_empty",	},
	["00"]={ name="char_black",	solid=1, dense=1, },		-- black border
	["0 "]={ name="char_empty",	solid=1, dense=1, },		-- empty border

	["||"]={  2,  1,  31,  0,	solid=1},				-- wall
	["=="]={  3,  1,  31,  0,	solid=1},				-- floor
	["<<"]={  4,  1,  31,  0,	solid=1,push=-1},		-- floor push left
	[">>"]={  5,  1,  31,  0,	solid=1,push= 1},		-- floor push right
	["--"]={  6,  1,  31,  0,	solid=1,collapse=1},	-- floor collapse

	["X "]={ 16,  1,  31,  0,	deadly=1},				-- ceiling spike
	["x "]={ 17,  1,  31,  0,	deadly=1},				-- floor spike


-- items not tiles, so display tile 0 and we will add a sprite for display
	["$ "]={  0,  1,  31,  0,	loot=1},
	["? "]={  0,  1,  31,  0,	item=1},
	["S "]={  0,  1,  31,  0,	"start"},
	["M "]={  0,  1,  31,  0,	monster=1},
	["< "]={  0,  1,  31,  0,	trigger=-1},
	["> "]={  0,  1,  31,  0,	trigger= 1},
}


maps[0]=[[
||000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000||
||. . . . X . $ . X . $ . X . . . . . . . X . . X . . . . . . . . . . . . . . . . . . . . . . . . . $ . ||
||. . . . . . . . . . . . . . . . . . . . $ . . $ . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . ? . . . . . . . . . . . . . . . x $ . . x $ . . x $ . . . . . ||
||================================================--------====--------==================================||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . $ . . . . . . . . . . . . . . . . . . ||
||======. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . $ ||
||==========. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . ||||||||||||. . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . > . . . . . M . . . . < ||||||||||||. . $ x $ . . . . ? . . . . . . . . . . . . ||
||==============. . . . <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<. . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ==========||
||. . . . . . . . . . . . . . . . . $ . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ======||
||. . . S . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||||||||||||--------====--------==========||
||. . . . . . . . . . . . . . . . . x $ . . . . . ? . . . . . ||||||||||||. . . . . . . . . . . . . . . ||
||. . . . . . . ==========================================================. . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . E . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||======================================================================================================||
||0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ||
]]


-- handle tables of entities that need to be updated and drawn.

	local entities -- a place to store everything that needs to be updated
	local entities_info -- a place to store options or values
	local entities_reset=function()
		entities={}
		entities_info={}
	end
-- get items for the given caste
	local entities_items=function(caste)
		if not entities[caste] then entities[caste]={} end -- create on use
		return entities[caste]
	end
-- add an item to this caste
	local entities_add=function(it,caste)
		caste=caste or it.caste -- probably from item
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
	local entities_info_get=function(name)       return entities_info[name]							end
	local entities_info_set=function(name,value)        entities_info[name]=value	return value	end
	local entities_info_manifest=function(name)
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

	local space=entities_info_set("space", chipmunk.space() )
	
	space:gravity(0,700)
	space:damping(0.5)
	
	local arbiter_pass={}  -- background tiles we can jump up through
		arbiter_pass.presolve=function(it)
			local points=it:points()
-- once we trigger headroom, we keep a table of headroom shapes and it is not reset until total separation
			if it.shape_b.in_body.headroom then
				local headroom=false
--					for n,v in pairs(it.shape_b.in_body.headroom) do headroom=true break end -- still touching an old headroom shape?
--					if ( (points.normal_y>0) or headroom) then -- can only headroom through non dense tiles
				if ( (points.normal_y>0) or it.shape_b.in_body.headroom[it.shape_a] ) then
					it.shape_b.in_body.headroom[it.shape_a]=true
					return it:ignore()
				end
			end
			
			return true
		end
		arbiter_pass.separate=function(it)
			if it.shape_a and it.shape_b and it.shape_b.in_body then
				if it.shape_b.in_body.headroom then it.shape_b.in_body.headroom[it.shape_a]=nil end
			end
		end
	space:add_handler(arbiter_pass,0x1001)
	
	local arbiter_deadly={} -- deadly things
		arbiter_deadly.presolve=function(it)
			local callbacks=entities_info_manifest("callbacks")
			if it.shape_b.player then -- trigger die
				local pb=it.shape_b.player
				callbacks[#callbacks+1]=function() pb:die() end
			end
			return true
		end
	space:add_handler(arbiter_deadly,0x1002)

	local arbiter_crumbling={} -- crumbling tiles
		arbiter_crumbling.presolve=function(it)
			local points=it:points()
	-- once we trigger headroom, we keep a table of headroom shapes and it is not reset until total separation
			if it.shape_b.in_body.headroom then
				local headroom=false
	--				for n,v in pairs(it.shape_b.in_body.headroom) do headroom=true break end -- still touching an old headroom shape?
	--				if ( (points.normal_y>0) or headroom) then -- can only headroom through non dense tiles
				if ( (points.normal_y>0) or it.shape_b.in_body.headroom[it.shape_a] ) then
					it.shape_b.in_body.headroom[it.shape_a]=true
					return it:ignore()
				end
			end
			
			return true
		end
		arbiter_crumbling.separate=function(it)
			if it.shape_a and it.shape_b and it.shape_b.in_body then
				if it.shape_b.in_body.headroom then it.shape_b.in_body.headroom[it.shape_a]=nil end
			end
		end
	space:add_handler(arbiter_crumbling,0x1003)

	local arbiter_walking={} -- walking things (players)
		arbiter_walking.presolve=function(it)
			local callbacks=entities_info_manifest("callbacks")
			if it.shape_a.player and it.shape_b.monster then
				local pa=it.shape_a.player
				callbacks[#callbacks+1]=function() pa:die() end
			end
			if it.shape_a.monster and it.shape_b.player then
				local pb=it.shape_b.player
				callbacks[#callbacks+1]=function() pb:die() end
			end
			if it.shape_a.player and it.shape_b.player then -- two players touch
				local pa=it.shape_a.player
				local pb=it.shape_b.player
				if pa.active then
					if pb.bubble_active and pb.joined then -- burst
						callbacks[#callbacks+1]=function() pb:join() end
					end
				end				
				if pb.active then
					if pa.bubble_active and pa.joined then -- burst
						callbacks[#callbacks+1]=function() pa:join() end
					end
				end				
			end
			return true
		end
		arbiter_walking.postsolve=function(it)
			local points=it:points()
			if points.normal_y>0.25 then -- on floor
				local time=entities_info_get("time")
				it.shape_a.in_body.floor_time=time.game
				it.shape_a.in_body.floor=it.shape_b
			end
			return true
		end
	space:add_handler(arbiter_walking,0x2001) -- walking things (players)

	local arbiter_loot={} -- loot things (pickups)
		arbiter_loot.presolve=function(it)
			if it.shape_a.loot and it.shape_b.player then -- trigger collect
				it.shape_a.loot.player=it.shape_b.player
			end
			return false
		end
	space:add_handler(arbiter_loot,0x3001) 
	
	local arbiter_trigger={} -- trigger things
		arbiter_trigger.presolve=function(it)
			if it.shape_a.trigger and it.shape_b.triggered then -- trigger something
				it.shape_b.triggered.triggered = it.shape_a.trigger
			end
			return false
		end
	space:add_handler(arbiter_trigger,0x4001)

	return space
end


-- items, can be used for general things, EG physics shapes with no special actions
local add_item=function()
	local space=entities_info_get("space")
	local item=entities_add{caste="item"}
	item.draw=function()
		if item.active then
			local px,py=item.body:position()
			local rz=item.body:angle()
--					rz=0
			system.components.sprites.list_add({t=item.sprite,h=item.h,hx=item.hx,hy=item.hy,px=px,py=py,rz=180*rz/math.pi,color=item.color})
		end
	end
	return item
end

-- a floating item that you can/must collect
local add_loot=function()
	local space=entities_info_get("space")
	local loot=entities_add{caste="loot"}
	loot.update=function()
		if loot.active then				
			if loot.player then
				loot.player.score=loot.player.score+1
				loot.active=false
				space:remove(loot.shape)
			end
		end
	end
	loot.draw=function()
		if loot.active then
			local time=entities_info_get("time")
			local b=math.sin( (time.game*8 + (loot.px+loot.py)/16 ) )*2
			system.components.sprites.list_add({t=0x0500,h=8,px=loot.px,py=loot.py+b})				
		end
	end
	return loot
end

-- an item that just gets in the way
local add_detritus=function(sprite,h,px,py,bm,bi,bf,be,...)
	local space=entities_info_get("space")
	local item=add_item()

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


local setup_menu=function()

	local item=entities_add{caste="menu"}

	item.draw=function()	

--[[
-- draw test menu
for i=1,12 do

local s=(" "):rep(14)
system.components.text.text_print(s,10-2,10-1+i,31,2)

end
for i=1,10 do
local s=string.format("%2dxx",i)
s=(" "):rep((10-#s)/2)..s
s=s..(" "):rep((10-#s))
system.components.text.text_print(s,10,10+i,31,1)

end
]]
	end
	
	return item
end

local setup_score=function()

	local item=entities_add{caste="gui"}

	item.draw=function()
	
		local time=entities_info_get("time")
	
		local remain=0
		for _,loot in ipairs( entities_items("loot") ) do
			if loot.active then remain=remain+1 end -- count remaining loots
		end
		if remain==0 and not time.finish then -- done
			time.finish=time.game
		end

		local t=time.start and ( (time.finish or time.game) - ( time.start ) ) or 0
		local ts=math.floor(t)
		local tp=math.floor((t%1)*100)

		local s=string.format("%d.%02d",ts,tp)
		system.components.text.text_print(s,math.floor((system.components.text.tilemap_hx-#s)/2),0)

		local s="A small cave, well, small for a cave."
		system.components.text.text_print(s,math.floor((system.components.text.tilemap_hx-#s)/2),system.components.text.tilemap_hy-1)
		
	end
	
	return item
end

-- move it like a player or monster based on
-- it.move which is "left" or "right" to move 
-- it.jump which is true if we should jump
local char_controls=function(it,fast)
	fast=fast or 1

	local time=entities_info_get("time")

	local jump=fast*200 -- up velocity we want when jumping
	local speed=fast*60 -- required x velocity
	local airforce=speed*2 -- replaces surface velocity
	local groundforce=speed/2 -- helps surface velocity
	
	if ( time.game-it.body.floor_time < 0.125 ) or ( it.floor_time-time.game > 10 ) then -- floor available recently or not for a very long time (stuck)
	
		it.floor_time=time.game -- last time we had some floor

		it.shape:friction(1)

		if it.jump then

			local vx,vy=it.body:velocity()

			if vy>-20 then -- only when pushing against the ground a little

				vy=-jump
				it.body:velocity(vx,vy)
				
				it.body.floor_time=0
				
			end

		end

		if it.move=="left" then
			
			local vx,vy=it.body:velocity()
			if vx>0 then it.body:velocity(0,vy) end
			
			it.shape:surface_velocity(speed,0)
			if vx>-speed then it.body:apply_force(-groundforce,0,0,0) end
			it.dir=-1
			it.frame=it.frame+1
			
		elseif it.move=="right" then

			local vx,vy=it.body:velocity()
			if vx<0 then it.body:velocity(0,vy) end

			it.shape:surface_velocity(-speed,0)
			if vx<speed then it.body:apply_force(groundforce,0,0,0) end
			it.dir= 1
			it.frame=it.frame+1

		else

			it.shape:surface_velocity(0,0)

		end
		
	else -- in air

		it.shape:friction(0)

		if it.move=="left" then
			
			local vx,vy=it.body:velocity()
			if vx>0 then it.body:velocity(0,vy) end

			if vx>-speed then it.body:apply_force(-airforce,0,0,0) end
			it.shape:surface_velocity(speed,0)
			it.dir=-1
			it.frame=it.frame+1
			
		elseif  it.move=="right" then

			local vx,vy=it.body:velocity()
			if vx<0 then it.body:velocity(0,vy) end

			if vx<speed then it.body:apply_force(airforce,0,0,0) end
			it.shape:surface_velocity(-speed,0)
			it.dir= 1
			it.frame=it.frame+1

		else

			it.shape:surface_velocity(0,0)

		end

	end
end

local add_monster=function(opts)

	local space=entities_info_get("space")

	local monster=entities_add{caste="monster"}

	monster.color=opts.color or {r=0,g=0,b=0,a=1}
	monster.dir=1		
	monster.frame=0
	monster.frames={0x0200,0x0203,0x0200,0x0206}

	monster.active=true
	monster.body=space:body(1,math.huge)
	monster.body:position(opts.px,opts.py)
	monster.body:velocity(opts.vx,opts.vy)
	monster.body.headroom={}
	
	monster.body:velocity_func(function(body)
--				body.gravity_x=-body.gravity_x
--				body.gravity_y=-body.gravity_y
		return true
	end)
				
	monster.floor_time=0 -- last time we had some floor

	monster.shape=monster.body:shape("segment",0,-4,0,4,4)
	monster.shape:friction(1)
	monster.shape:elasticity(0)
	monster.shape:collision_type(0x2001) -- walker
	monster.shape.monster=monster
	monster.shape.triggered=monster
	
	monster.body.floor_time=0


	monster.move="left"

	monster.last_cx=0
	monster.last_cx_count=0

	monster.update=function()
		if monster.active then
		
			if monster.triggered then
				if     monster.triggered.trigger==-1 then
					monster.move="left"
				elseif monster.triggered.trigger== 1 then
					monster.move="right"
				end
			end
			
			local px,py=monster.body:position()
			local cx=math.floor((px+1)/2) -- if this number changes then we are moving
			
			if monster.last_cx == cx then -- not moving
				monster.last_cx_count=monster.last_cx_count+1
				if monster.last_cx_count > 30 then
					monster.triggered=nil
					monster.last_cx_count=0
					if monster.move=="left" then monster.move="right" else monster.move="left" end -- change dir
				end
			else -- moved
				monster.last_cx=cx
				monster.last_cx_count=0
			end
		
		
			char_controls(monster,0.5)
		end
	end


	monster.draw=function()
		if monster.active then
			local px,py=monster.body:position()
			local rz=monster.body:angle()
			monster.frame=monster.frame%16
			local t=monster.frames[1+math.floor(monster.frame/4)]
			
			system.components.sprites.list_add({t=t,h=24,px=px,py=py,sx=monster.dir,sy=1,rz=180*rz/math.pi,color=monster.color})				
		end
	end

end

local add_player=function(i)
	local players_colors={30,14,18,7,3,22}

	local space=entities_info_get("space")

	local player=entities_add{caste="player"}

	player.idx=i
	player.score=0
	
	local t=bitdown.cmap[ players_colors[i] ]
	player.color={}
	player.color.r=t[1]/255
	player.color.g=t[2]/255
	player.color.b=t[3]/255
	player.color.a=t[4]/255
	player.color.idx=players_colors[i]
	
	player.up_text_x=math.ceil( (system.components.text.tilemap_hx/16)*( 1 + ((i>3 and i+2 or i)-1)*2 ) )

	player.frame=0
	player.frames={0x0200,0x0203,0x0200,0x0206}

	player.bubble=function()
		local players_start=entities_info_get("players_start") or {64,64}
		player.bubble_active=true

		player.bubble_body=space:body(1,1)
		player.bubble_body:position(players_start[1]+i,players_start[2]-i)

		player.bubble_shape=player.bubble_body:shape("circle",6,0,0)
		player.bubble_shape:friction(0.5)
		player.bubble_shape:elasticity(1)

		player.bubble_shape:collision_type(0x2002) -- bubble
		player.bubble_shape.player=player

		player.bubble_body:velocity_func(function(body)
			local px,py=body:position()
			
			body.gravity_x=(players_start[1]-px)*16
			body.gravity_y=(players_start[2]-py)*16
			return true
		end)

	end
	
	player.join=function()
		local players_start=entities_info_get("players_start") or {64,64}
	
		local px,py=players_start[1]+i,players_start[2]
		local vx,vy=0,0

		if player.bubble_active then -- pop bubble
			px,py=player.bubble_body:position()
			vx,vy=player.bubble_body:velocity()
			space:remove(player.bubble_shape) -- auto?
			space:remove(player.bubble_body)
		end

		player.bubble_active=false
		player.active=true
		player.body=space:body(1,math.huge)
		player.body:position(px,py)
		player.body:velocity(vx,vy)
		player.body.headroom={}
		
		player.body:velocity_func(function(body)
--				body.gravity_x=-body.gravity_x
--				body.gravity_y=-body.gravity_y
			return true
		end)
					
		player.floor_time=0 -- last time we had some floor

		player.shape=player.body:shape("segment",0,-4,0,4,4)
		player.shape:friction(1)
		player.shape:elasticity(0)
		player.shape:collision_type(0x2001) -- walker
		player.shape.player=player
		
		player.body.floor_time=0
		local time=entities_info_get("time")
		if not time.start then
			time.start=time.game -- when the game started
		end
	end

	player.die=function()
		if not player.active then return end -- not alive
		
		local px,py=player.body:position()
		local vx,vy=player.body:velocity()

		player.active=false -- die
--			player.dead=true

		space:remove(player.shape) -- auto?
		space:remove(player.body)
		
		local it
		it=add_detritus(names.body_p1,16,px,py-4,0.25,16,0.1,0.5,"box",-4,-3,4,3,0) it.body:velocity(vx*3,vy*3) it.color=player.color
		it=add_detritus(names.body_p2,16,px,py+0,0.25,16,0.1,0.5,"box",-3,-2,3,2,0) it.body:velocity(vx*2,vy*2) it.color=player.color
		it=add_detritus(names.body_p3,16,px,py+4,0.25,16,0.1,0.5,"box",-3,-2,3,2,0) it.body:velocity(vx*1,vy*1) it.color=player.color

	end
	
	player.update=function()
		local up=ups(player.idx) -- the controls for this player
		
		player.move=false
		player.jump=up.button("fire") -- right
		
		if use_only_two_keys then -- touch screen control test?

			if up.button("left") and up.button("right") then -- jump
				player.move=player.move_last
				player.jump=true
			elseif up.button("left") then -- left
				player.move_last="left"
				player.move="left"
			elseif up.button("right") then -- right
				player.move_last="right"
				player.move="right"
			end

		else

			if up.button("left") and up.button("right") then -- stop
				player.move=nil
			elseif up.button("left") then -- left
				player.move="left"
			elseif up.button("right") then -- right
				player.move="right"
			end

		end
				
		if not player.bubble_active and not player.active then -- can add as bubble
			if up.button("up") or up.button("down") or up.button("left") or up.button("right") or up.button("fire") then
				player.bubble() -- add bubble
			end
		end

		if player.bubble_active then
			if not player.active then
				if player.jump then
					if player.joined then player.score=player.score-1 end-- first join is free, next join costs 1 point
					player.joined=true
					player:join() -- join for real and remove bubble
				end
			end
		end
		
		if player.bubble_active then
		
			local px,py=player.bubble_body:position()

			if up.button("left") then
				
				player.bubble_body:apply_force(-120,0,px,py,"world")
				player.dir=-1
				player.frame=player.frame+1
				
			elseif  up.button("right") then

				player.bubble_body:apply_force(120,0,px,py,"world")
				player.dir= 1
				player.frame=player.frame+1

			elseif up.button("up") then
				
				player.bubble_body:apply_force(0,-120,px,py,"world")
				
			elseif  up.button("down") then

				player.bubble_body:apply_force(0,120,px,py,"world")

			end

		elseif player.active then
		
			char_controls(player)
		
		end
	end
	

	player.draw=function()
		if player.bubble_active then

			local px,py=player.bubble_body:position()
			local rz=player.bubble_body:angle()
			player.frame=player.frame%16
			local t=player.frames[1+math.floor(player.frame/4)]
			
			system.components.sprites.list_add({t=t,h=24,px=px,py=py,sx=(player.dir or 1)*0.5,s=0.5,rz=180*rz/math.pi,color=player.color})
			
			system.components.sprites.list_add({t=names.bubble,h=24,px=px,py=py,s=1})

		elseif player.active then
			local px,py=player.body:position()
			local rz=player.body:angle()
			player.frame=player.frame%16
			local t=player.frames[1+math.floor(player.frame/4)]
			
			system.components.sprites.list_add({t=t,h=24,px=px,py=py,sx=player.dir,sy=1,rz=180*rz/math.pi,color=player.color})			
		end

		if player.joined then
			local s=string.format("%d",player.score)
			system.components.text.text_print(s,math.floor(player.up_text_x-(#s/2)),0,player.color.idx)
		end

	end
	
	return player
end




local setup_level=function(idx)

-- init map and space

	local space=setup_space()

	local map=entities_info_set("map", bitdown.pix_tiles(  maps[idx],  tilemap ) )
	
	bitdown.pix_grd(    maps[idx],  tilemap,      system.components.map.tilemap_grd  ) -- draw into the screen (tiles)

	local unique=0
	bitdown.map_build_collision_strips(map,function(tile)
		unique=unique+1
		if tile.coll then -- can break the collision types up some more by appending a code to this setting
			if tile.collapse then -- make unique
				tile.coll=tile.coll..unique
			end
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


	for y,line in pairs(map) do
		for x,tile in pairs(line) do

			if tile.loot then
				local loot=add_loot()

				local shape=space.static:shape("box",x*8,y*8,(x+1)*8,(y+1)*8,0)
				shape:collision_type(0x3001)
				shape.loot=loot
				loot.shape=shape
				loot.px=x*8+4
				loot.py=y*8+4
				loot.active=true
			end
			if tile.item then
				local item=add_item()
				
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
				entities_info_set("players_start",{x*8+4,y*8+4}) --  remember start point
			end
			if tile.monster then
				local item=add_monster{
					px=x*8+4,py=y*8+4,
					vx=0,vy=0,
				}
			end
			if tile.trigger then
				local item=add_item()

				local shape=space.static:shape("box", x*8 - (tile.trigger*6) ,y*8, (x+1)*8 - (tile.trigger*6) ,(y+1)*8,0)
				item.shape=shape
				
				shape:collision_type(0x4001)
				shape.trigger=tile
			end
		end
	end
end


-- create a fat controller coroutine that handles state changes, fills in entities etc etc etc


local fat_controller=coroutine.create(function()

-- setup game

-- copy font data tiles
	system.components.tiles.bitmap_grd:pixels(0,0,128*4,8, bitdown_font_4x8.grd_mask:pixels(0,0,128*4,8,"") )

-- copy image data tiles
	bitdown.pixtab_tiles( tiles,    bitdown.cmap, system.components.tiles   )


	entities_reset()
	
	entities_info_set("time",{
		game=0,
	})
	
	setup_level(0) -- load map
	setup_score() -- gui fpr the score

	for i=1,6 do add_player(i) end -- players 1-6
	ups(1).touch="left_right" -- request this touch control scheme for player 1 only

-- update loop

	while true do coroutine.yield()
	
		entities_call("update")

		entities_info_get("space"):step(1/fps)

		-- run all the callbacks created by collisions 
		for _,f in pairs(entities_info_manifest("callbacks")) do f() end
		entities_info_set("callbacks",{}) -- and reset the list

		local time=entities_info_get("time")
		time.game=time.game+(1/fps)
		

	end


end)


-- this is the main function, code below called repeatedly to update and draw or pass in other messages

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
			system.components.text.dirty(true)
			system.components.text.text_window()
			system.components.text.text_clear(0x00000000)
			system.components.sprites.list_reset() -- remove old sprites here
			entities_call("draw") -- because we are going to add them all in again here
		end
		if need.clean then done=true end -- cleanup requested
	end

-- perform cleanup here


end
