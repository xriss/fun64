
local bitdown=require("wetgenes.gamecake.fun.bitdown")
local wstr=require("wetgenes.string")
function ls(s) print(wstr.dump(s))end

hardware,main=system.configurator({
	mode="fun64", -- select the standard 320x240 screen using the swanky32 palette.
	update=function() -- called at a steady 60fps
		if setup then setup() setup=nil end -- call an optional setup function *once*
		entities.systems.call("update")
		entities.call("update")
	end,
	draw=function() -- called at actual display frame rate
		entities.systems.call("draw")
		entities.call("draw")
	end,
})

hardware.screen.zxy={0,-1}

hardware.insert{
	component="overmap",
	name="map",					-- same name so will replace the foreground tilemap
	tiles="tiles",
	tilemap_size={32,32},
	tile_size={16,32,16},
	over_size={0,16},
	sort={-1,-1},
	mode="xz",
	layer=2,
}

entities=require("wetgenes.gamecake.fun.entities").create({
	sortby={
	},
})

-- setup all entities
setup=function() entities.systems.call("setup") end




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
	[   0]={ items={"floor_tile"},			},
	[". "]={ items={"floor_tile"}			},
	["x "]={ items={"floor_tile"}			},
	["S "]={ items={"floor_spawn"}			},
	["# "]={ items={"wall_full"}			},
	["= "]={ items={"wall_half"}			},
}
	
levels={
 {
 name="page_zero",
 legend=combine_legends(default_legend,{
 }),
 map=[[
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
]],
 },
 {
 name="page_town",
 pages={0x80008000},
 legend=combine_legends(default_legend,{
 }),
 map=[[
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . = = = = = . . . . . . . . . . . . . . . . . . . . . . 
. . . . . # . . . # . . . . . . . . . . . . . . . . . . . . . . 
. . . . . # . S . # . . . . . . . . . . . . . . . . . . . . . . 
. . . . . # . . . # . . . . . . . . . . . . . . . . . . . . . . 
. . . . . # = . = # . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
]],
 },
}




entities.systems.insert{ caste="map",

	loads=function()

		hardware.graphics.loads{

{nil,"test_empty",[[
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
]]},

{nil,"test_none",[[
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 
1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 
0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 
1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 
0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 
1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 
0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 
1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 
0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 
1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 
0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 
1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 
0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 
1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 
0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 
1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 
]]},

{nil,"test_tile",[[
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 
0 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 
0 1 0 0 0 0 1 0 1 0 1 1 1 1 0 1 
0 1 0 0 0 0 1 0 1 0 1 1 1 1 0 1 
0 1 0 0 0 0 1 0 1 0 1 1 1 1 0 1 
0 1 0 0 0 0 1 0 1 0 1 1 1 1 0 1 
0 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 
0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 
1 0 0 0 0 0 0 1 0 1 1 1 1 1 1 0 
1 0 1 1 1 1 0 1 0 1 0 0 0 0 1 0 
1 0 1 1 1 1 0 1 0 1 0 0 0 0 1 0 
1 0 1 1 1 1 0 1 0 1 0 0 0 0 1 0 
1 0 1 1 1 1 0 1 0 1 0 0 0 0 1 0 
1 0 0 0 0 0 0 1 0 1 1 1 1 1 1 0 
1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 
]]},

{nil,"test_wall1",[[
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
4 3 2 F F F F F F F F F F 2 3 4 
2 f F F F F F F F F F F F F f 2 
F f F F j j j F F j j j F F f F 
F f F F j f f F F j f f F F f F 
F f F F j f f F F j f f F F f F 
F f F F j f f F F j f f F F f F 
2 f F F F F F F F F F F F F f 2 
4 3 2 F F F F F F F F F F 2 3 4 
3 j f f j j j j j j f f j j j 3 
2 j F f j j f f j j F f j j j 2 
j g F f j j F F j j F f j j f j 
j j f f g j F F j j f f j j F f 
j g j g j j F F j j j j j j F F 
j j f f g j F f j j f f j j F f 
j g F F j j F f j g F F j j F f 
j j F F j j F f g j F F j j f f 
j j F F j j j g j g F F j j j j 
j j F f j j f f g j F f j j f f 
j j F f j j F F j g F f j j F F 
j j f f j j F F j j f f j j F F 
j j j j j j F F j j j g j j F F 
j j f f j j F f j j f f g j F f 
2 j F f j j F f j j F f j g f 2 
3 2 f f j j f f j j f f j j 2 3 
]]},

{nil,"test_wall2",[[
4 3 2 F F F F F F F F F F 2 3 4 
3 f f f f f f f f f f f f f f 3 
2 f F F F F F F F F F F F F f 2 
F f F F j j j F F j j j F F f F 
F f F F j f f F F j f f F F f F 
F f F F j f f F F j f f F F f F 
F f F F j f f F F j f f F F f F 
F f F F j f f F F j f f F F f F 
F f F F j f f F F j f f F F f F 
F f F F j f f F F j f f F F f F 
F f F F j f f F F j f f F F f F 
F f F F j f f F F j f f F F f F 
F f F F j f f F F j f f F F f F 
2 f F F F F F F F F F F F F f 2 
3 f f f f f f f f f f f f f f 3 
4 3 2 F F F F F F F F F F 2 3 4 
3 j f f j j j j j j f f j j j 3 
2 j F f j j f f j j F f j j j 2 
j g F f j j F F j j F f j j f j 
j j f f g j F F j j f f j j F f 
j g j g j j F F j j j j j j F F 
j j f f g j F f j j f f j j F f 
j g F F j j F f j g F F j j F f 
j j F F j j F f g j F F j j f f 
j j F F j j j g j g F F j j j j 
j j F f j j f f g j F f j j f f 
j j F f j j F F j g F f j j F F 
j j f f j j F F j j f f j j F F 
j j j j j j F F j j j g j j F F 
j j f f j j F f j j f f g j F f 
2 j F f j j F f j j F f j g f 2 
3 2 f f j j f f j j f f j j 2 3 
]]},

{nil,"test_spawn",[[
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . r . . . . . . . . . . r . . 
. . R . . . . . . . . . . R . . 
0 0 4 0 1 1 1 1 1 1 1 1 0 4 0 0 
0 0 4 1 1 1 0 0 0 0 1 1 1 4 0 0 
0 0 1 0 1 1 0 0 0 0 1 1 0 1 0 0 
0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 
1 1 1 1 0 0 1 1 1 1 0 0 1 1 1 1 
1 0 1 1 0 0 1 1 1 1 0 0 1 1 0 1 
1 0 0 1 1 1 1 0 0 1 1 1 1 0 0 1 
1 0 0 1 1 0 0 0 0 0 0 1 1 0 0 1 
r 0 1 1 1 0 0 0 0 0 0 1 1 1 0 r 
R 1 1 0 1 1 0 0 0 0 1 1 0 1 1 R 
4 1 0 0 0 1 1 1 1 1 1 0 0 0 1 4 
4 1 1 1 1 1 1 0 0 1 1 1 1 1 1 4 
0 1 1 0 0 0 1 0 r 1 0 0 0 1 1 0 
0 0 1 1 0 0 1 0 R 1 0 0 1 1 0 0 
0 0 0 1 1 1 1 1 4 1 1 1 1 0 0 0 
0 0 0 0 0 0 1 1 4 1 0 0 0 0 0 0 
]]},

		}
	end,
	
	setup=function()

		local legend={}
		for n,v in pairs( levels[1].legend ) do -- build tilemap from legend
			if v.name then -- convert name to tile
				legend[n]=system.components.tiles.names[v.name]
			end
		end
		local cx=system.components.map.tile_hx/8
		local cy=system.components.map.tile_hy/8
		
		
		system.components.map.ax=0
		system.components.sprites.ax=0

	end,

	draw=function()
	
	end,

}



entities.systems.insert{ caste="player",

	loads=function()

		hardware.graphics.loads{

{nil,"test_player",[[
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . 7 7 7 . . . . . . 
. . . . . . 7 7 7 7 7 . . . . . 
. . . . . . 7 0 7 0 7 . . . . . 
. . . . . . 7 7 0 7 7 . . . . . 
. . . . . . . 7 7 7 . . . . . . 
. . . . . . . 7 0 7 . . . . . . 
. . . . . . . 7 7 7 . . . . . . 
. . . . 7 7 . 7 . 7 7 . . . . . 
. . . . 7 . 7 7 7 7 7 . . . . . 
. . . . 7 7 . 7 . . 7 . . . . . 
. . . . 7 . 7 7 7 7 7 . . . . . 
. . . . 7 7 . 7 . . 7 . . . . . 
. . . . 7 . 7 7 7 7 7 . . . . . 
. . . . 7 7 . 7 7 . 7 . . . . . 
. . . . 7 7 7 7 7 7 7 . . . . . 
. . . . 7 7 7 . . 7 7 . . . . . 
. . . . . 7 . . . . 7 . . . . . 
. . . . 7 7 . . . . 7 7 . . . . 
. . . . 7 7 . . . . 7 7 . . . . 
. . . . 7 . . . . . 7 . . . . . 
. . . . 7 . . . . . 7 . . . . . 
. . . . 7 . . . . . 7 . . . . . 
. . . . 7 . . . . . 7 . . . . . 
. . . 7 7 7 7 . . 7 7 7 7 . . . 
. . . . . . . . . . . . . . . . 
]]},

		}

	end,

}

local prefabs={
	{name="player",id="player",sprite="test_player",rules={"player"},},
	{name="floor",back="test_none"},
	{name="floor_tile",back="test_tile"},
	{name="floor_spawn",id="floor_spawn",back="test_spawn"},
	{name="wall_full",back="test_wall2",is_big=true,},
	{name="wall_half",back="test_wall1",is_big=true,},
}

local rules={

	{	name="player",
	
		setup=function(item)
			item.is_big=true
			item.player={}
		end,

		clean=function(item)
		end,

		move=function(item,vx,vy)

			local items=item.items
			local pages=items.pages

			local ccx=item[0].cx+vx
			local ccy=item[0].cy+vy
			local cell=pages.get_cell(ccx,ccy)
			
			if not cell:get_big() then -- if empty
				item:insert( cell ) -- move to a new location
			end

		end,
	},
	
}

entities.systems.insert{ caste="yarn",

	setup=function(it)

		it.items=require("wetgenes.gamecake.fun.yarn.items").create()
		
		local items=it.items

-- insert my prefabs and rules

		for i,v in ipairs(prefabs) do it.items.prefabs.set(v) end
		for i,v in ipairs(rules)   do it.items.rules.set(v)   end
		for i,v in ipairs(levels)  do it.items.prefabs.set(v) 
			for _,index in ipairs(v.pages or {}) do
				it.items.pages.names[index]=v.name
			end
		end

-- add a player

		items.pages.get_cell(0x8000*32,0x8000*32) -- manifest page
		items.create( items.prefabs.get("player") ):insert( items.ids.floor_spawn[0] ) -- use spawn point

-- setup view

		local ccx=items.ids.player[0].cx
		local ccy=items.ids.player[0].cy

		it.dx=items.ids.player[0].cx*16
		it.dy=items.ids.player[0].cy*16
		it.ax=it.dx
		it.ay=it.dy

	end,
	
	update=function(it)
		local items=it.items
		local pages=items.pages

		local up=ups(0) -- get all connected controls, keyboard or gamepad

		local vx,vy=0,0
		if up.button("up_set")    then vy=-1 end
		if up.button("down_set")  then vy= 1 end
		if up.button("left_set")  then vx=-1 end
		if up.button("right_set") then vx= 1 end
		
		if not ( vx==0 and vy==0 ) then
print("moving",vx,vy)
			items.ids.player:apply("move",vx,vy)
		end
		
-- apply view

		local ccx=items.ids.player[0].cx
		local ccy=items.ids.player[0].cy
		
		it.dx=items.ids.player[0].cx*16
		it.dy=items.ids.player[0].cy*16
		
		it.ax=(it.ax*31+it.dx*1)/32
		it.ay=(it.ay*31+it.dy*1)/32
	end,

	draw=function(it)
	
		local names=system.components.tiles.names
		local g=system.components.map.tilemap_grd

		local items=it.items
		local pages=items.pages
		
		local px=items.ids.player[0].cx
		local py=items.ids.player[0].cy
		
		it.cx=px-16
		it.cy=py-16
		
		local b={}
		for y=0,31 do
			for x=0,31 do
				local dx=it.cx+x-px
				local dy=it.cy+y-py

				local dark=(math.sqrt(dx*dx + dy*dy)-1)/8 -- 1 cells full and 8 cells fadeout
				if dark>1 then dark=1 end
				if dark<0 then dark=0 end
				dark=1-dark
				
				local cell=pages.get_cell(it.cx+x,it.cy+y)
				local idx=y*32*4 + x*4
				b[idx+1]=0
				b[idx+2]=0
				b[idx+3]=31
				b[idx+4]=0
				for i,v in ipairs(cell) do
					if v.back then
						local tile=names[v.back]
						b[idx+1]=tile.pxt
						b[idx+2]=tile.pyt
						b[idx+3]=31
						b[idx+4]=dark*255
					end
					if v.sprite then

						system.components.sprites.list_add({
							t=names[v.sprite].idx,
							hx=16,hy=32,ox=8,oy=32,
							px=x*16+8,py=16,pz=-y*16-16,
							s=1,rz=0,
							color={dark,dark,dark,1}
						})
					end
				end
			end
		end
		g:pixels(0,0,0,32,32,1,b)
		system.components.map.dirty(true)
		
		local ax= (it.cx*16-math.floor(it.ax+0.5)+(9)*16)
		local az=-(it.cy*16-math.floor(it.ay+0.5)+(6)*16)

		system.components.map.ax=ax
		system.components.map.ay=0
		system.components.map.az=az
		system.components.sprites.ax=ax
		system.components.sprites.ay=0
		system.components.sprites.az=az
	
	end,

}

-- finally load all graphics from systems defined above
entities.systems.call("loads")
