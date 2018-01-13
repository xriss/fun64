
local bitdown=require("wetgenes.gamecake.fun.bitdown")
local chatdown=require("wetgenes.gamecake.fun.chatdown")
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
	hx=440,hy=240,
})

hardware.screen.zxy={0,-1}

hardware.insert{
	component="overmap",
	name="map",					-- same name so will replace the foreground tilemap
	tiles="tiles",
	tilemap_size={48,32},
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




local chat_text=[[

#example Conversation NPC

	A rare bread of NPC who will fulfil all your conversational desires for 
	a very good price.

	=sir sir/madam
	=portrait portrait_1

	>convo

		Is this the right room for a conversation?
		
	>welcome
	
		...ERROR...EOF...PLEASE...RESTART...

<welcome

	Good Morning {sir},
	
	>morning

		Good morning to you too.

	>afternoon

		I think you will find it is now afternoon.

	>sir

		How dare you call me {sir}!

<sir

	My apologies, I am afraid that I am but an NPC with very little 
	brain, how might I address you?
	
	>welcome.1?sir!=madam

		You may address me as Madam.

		=sir madam

	>welcome.2?sir!=God

		You may address me as God.

		=sir God

	>welcome.3?sir!=sir

		You may address me as Sir.

		=sir sir

<afternoon
	
	Then good afternoon {sir},
	
	>convo

<morning
	
	and how may I help {sir} today?
	
	>convo


<convo

	Indeed it is, would you like the full conversation or just the 
	quick natter?

	>convo_full
	
		How long is the full conversation?

	>convo_quick

		A quick natter sounds just perfect.

<convo_full

	The full conversation is very full and long so much so that you 
	will have to page through many pages before you get to make a 
	decision
	
	>
		Like this?
	<
	
	Yes just like this. In fact I think you can see that we are already 
	doing it.
			
	
	>exit
		
		EXIT

<convo_quick

	...
	
	>exit

		EXIT
]]





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
. . . . . . . . . . . . . . . . . . . # # # # . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . # . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . # . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . # . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . # . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . # . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . # . . # . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . # . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . # . . # . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . # . . # . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . # . . # . . . . . . . . . 
. . . . . . . . . . . . . . . . . # . # . . . . . . S . . . . . 
. . . . . . . . . . . . . . . . # # . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . # . # # # # . . . . . . . . . 
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


entities.systems.insert{ caste="menu",

	loads=function()

		hardware.graphics.loads{

{nil,"portrait_1",[[
o o o o 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 o o o o 
o 1 y 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 y 1 o 
o y y 1 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 1 y y o 
o 1 1 y 1 2 1 1 1 1 1 1 1 1 1 1 1 1 R 1 1 1 1 1 1 1 2 1 y 1 1 o 
2 1 2 1 1 1 1 1 1 1 R 1 1 1 R R R R 1 1 1 1 1 1 1 1 1 1 1 2 1 2 
2 1 1 2 1 1 1 1 R 1 1 R R R R R R R R R R 1 1 1 1 1 1 1 2 1 1 2 
2 1 1 1 1 1 1 1 1 R R R R R R R R R R R R R R 1 1 1 1 1 1 1 1 2 
2 1 1 1 1 1 1 1 R R R R R R R R R R R R R R R R 1 1 1 1 1 1 1 2 
2 1 1 1 1 1 1 1 R R R R R R R R s R R R R R R R 1 1 1 1 1 1 1 2 
2 1 1 1 1 1 1 R R R s s s s s s s s s s s s R R R 1 1 1 1 1 1 2 
2 1 1 1 R 1 R R R s B B B B s s s s B B B B s R R R 1 R 1 1 1 2 
2 1 1 1 1 R 1 R s B D D D D B s s B D D D D B s R 1 R 1 1 1 1 2 
2 1 1 1 1 1 1 R s s f f f f s s s s f f f f s s R 1 1 1 1 1 1 2 
2 1 1 1 1 1 R R s f 7 i i 7 s 6 6 s 7 i i 7 f s R R 1 1 1 1 1 2 
2 1 1 1 1 R 1 R s s f 7 7 f s 6 6 s f 7 7 f s s R 1 R 1 1 1 1 2 
2 1 1 1 R 1 1 R S s s f f s s 6 6 s s f f s s S R 1 1 R 1 1 1 2 
2 1 1 1 1 1 R 1 S S s s s s S F F S s s s s S S 1 R 1 1 1 1 1 2 
2 1 1 1 1 1 1 1 S S S S S S F F F F S S S S S S 1 1 1 1 1 1 1 2 
2 1 1 1 1 1 1 1 R S S S S S S F F S S S S S S R 1 1 1 1 1 1 1 2 
2 1 1 1 1 1 1 1 R S S S S S S S S S S S S S S R 1 1 1 1 1 1 1 2 
2 1 1 1 1 1 1 R 1 1 S S S I I I I I I S S S 1 1 R 1 1 1 1 1 1 2 
2 1 1 1 1 1 1 1 1 1 1 S S S S 3 3 S S S S 1 1 1 1 1 1 1 1 1 1 2 
2 1 1 1 1 1 1 1 1 1 1 1 S S S S S S S S 1 1 1 1 1 1 1 1 1 1 1 2 
2 1 1 1 1 1 1 1 1 1 1 1 1 F S S S S F 1 1 1 1 1 1 1 1 1 1 1 1 2 
2 1 1 1 1 1 1 1 1 1 1 1 1 F F F F F F 1 1 1 1 1 1 1 1 1 1 1 1 2 
2 1 1 1 1 1 1 1 1 1 c I 2 2 2 F F 2 2 2 I c 1 1 1 1 1 1 1 1 1 2 
2 1 1 2 1 1 1 1 1 c c c I 2 2 2 2 2 2 I c c c 1 1 1 1 1 2 1 1 2 
2 1 2 1 1 1 1 1 c c B c c I I 1 1 I I c c B c c 1 1 1 1 1 2 1 2 
o 1 1 y 1 2 1 c B B B B B c c I I c c B B B B B c 1 2 1 y 1 1 o 
o y y 1 2 1 c B B o B o B o B c c B B B O B O B B c 1 2 1 y y o 
o 1 y 1 1 B B B B B o B o B B B B B B B B O B B B B B 1 1 y 1 o 
o o o o 2 B B B B B B B B B B B B B B B B B B B B B B 2 o o o o 
]]},
{nil,"portrait_2",[[
y y y y f f f f f f f f f f f f f f f f f f f f f f f f y y y y 
y j 3 j j j j j j j j j j j j j j j j j j j j j j j j j j 3 j y 
y 3 3 j f j j j j j j j d d d d d d d d j j j j j j j f j 3 3 y 
y j j y j f j j j j G G 1 1 1 1 1 1 1 1 G G j j j j f j y j j y 
f j f j j j j j G G 1 1 1 1 i i i i 1 1 1 1 G G j j j j j f j f 
f j j f j j j G 1 1 1 i i i i i i i i i i 1 1 1 G j j j f j j f 
f j j j j j G 1 1 i i i i i i i i i i i i i i 1 1 G j j j j j f 
f j j j j g 1 1 i i i 2 i 2 i 2 2 i 2 i 2 i i i 1 1 g j j j j f 
f j j j j g 1 i i 2 2 2 2 2 2 2 2 2 2 2 2 2 2 i i 1 g j j j j f 
f j j j g 1 1 i 2 2 j j j j 2 2 2 2 j j j j 2 2 i 1 1 g j j j f 
f j j j g 1 1 i 2 2 2 5 5 2 2 2 2 2 2 5 5 2 2 2 i 1 1 g j j j f 
f j j j g 1 1 i 2 2 5 i i 5 2 3 3 2 5 i i 5 2 2 i 1 1 g j j j f 
f j j G 1 1 j j 2 2 5 i i 5 2 3 3 2 5 i i 5 2 2 j j 1 1 G j j f 
f j j G 1 1 1 j F F f 7 7 f 2 3 3 2 f 7 7 f F F j 1 1 1 G j j f 
f j j G 1 1 1 1 j F F f f F F 3 3 F F f f F F j 1 1 1 1 G j j f 
f j j G 1 1 1 j F F F F F F F s s F F F F F F F j 1 1 1 G j j f 
f j j G 1 1 j F F f F F F F F m m F F F F F F F F j 1 1 G j j f 
f j j j G 1 1 F F F F F F F m m m m F F R F R F F 1 1 G j j j f 
f j j j G 1 1 F F F F F F F F m m F F F F R F F F 1 1 G j j j f 
f j j j G 1 1 j F F F F F j F F F F j F F F F F j 1 1 G j j j f 
f j j j j g 1 1 F F F F F F j j j j F F F F F F 1 1 g j j j j f 
f j j j j g 1 1 1 F F F F F F F F F F F F F F 1 1 1 g j j j j f 
f j j j j j g 1 1 1 j F F F F F F F F F F j 1 1 1 g j j j j j f 
f j j j j j j g 1 1 1 1 F F F f f F F F 1 1 1 1 g j j j j j j f 
f j j j j j j j g 1 1 g j j F f f F j j g 1 1 g j j j j j j j f 
f j j j j j j j j g 1 g j j j j j j j j g 1 g j j j j j j j j f 
f j j f j j j j j g 1 1 g j j j j j j g 1 1 g j j j j j f j j f 
f j f j j j j j g 1 1 1 1 g g j j g g 1 1 1 1 g j j j j j f j f 
y j j y j f j g 1 1 1 g 1 1 1 g g 1 1 1 g 1 1 1 g j f j y j j y 
y 3 3 j f j g 1 1 1 g 1 1 1 1 1 1 1 1 1 1 g 1 1 1 g j f j 3 3 y 
y j 3 j j g 1 1 1 g 1 1 1 1 1 1 1 1 1 1 1 1 g 1 1 1 g j j 3 j y 
y y y y f g 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 g f y y y y 
]]},
{nil,"portrait_3",[[
y y y y f f f f f f f f f f f f f f f f f f f f f f f f y y y y 
y j y j j j j j j j j j j j j j j j j j j j j j j j j j j y j y 
y y y j f j j j j j j j g g g g g g g g j j j j j j j f j y y y 
y j j y j f j j j j g g 1 1 1 1 1 1 1 1 g g j j j j f j y j j y 
f j f j j j j j g g 1 1 1 1 j j j j 1 1 1 1 g g j j j j j f j f 
f j j f j j j g 1 1 1 j j j j j j j j j j 1 1 1 g j j j f j j f 
f j j j j j g 1 1 j j j j j j j j j j j j j j 1 1 g j j j j j f 
f j j j j g 1 1 j j j F j F j F F j F j F j j j 1 1 g j j j j f 
f j j j j g 1 j j F F F F F F F F F F F F F F j j 1 g j j j j f 
f j j j g 1 1 j F F f f f f F F F F f f f f F F j 1 1 g j j j f 
f j j j g 1 1 j F F F 7 7 F F F F F F 7 7 F F F j 1 1 g j j j f 
f j j j g 1 1 j F F 7 j j 7 F s s F 7 j j 7 F F j 1 1 g j j j f 
f j j g 1 1 j j F F 7 j j 7 F s s F 7 j j 7 F F j j 1 1 g j j f 
f j j g 1 1 1 j F F f 7 7 f F s s F f 7 7 f F F j 1 1 1 g j j f 
f j j g 1 1 1 1 j F F f f F F s s F F f f F F j 1 1 1 1 g j j f 
f j j g 1 1 1 j F F F F F F F s s F F F F F F F j 1 1 1 g j j f 
f j j g 1 1 j F F f F F F F F m m F F F F F F F F j 1 1 g j j f 
f j j j g 1 1 F F F F F F F m m m m F F R F R F F 1 1 g j j j f 
f j j j g 1 1 F F F F F F F F m m F F F F R F F F 1 1 g j j j f 
f j j j g 1 1 F F F F F F f F F F F f F F F F F F 1 1 g j j j f 
f j j j j g 1 1 F F F F F F f f f f F F F F F F 1 1 g j j j j f 
f j j j j g 1 1 1 F F F F F F F F F F F F F F 1 1 1 g j j j j f 
f j j j j j g 1 1 1 F F F F F F F F F F F F 1 1 1 g j j j j j f 
f j j j j j j g 1 1 1 1 F F F j j F F F 1 1 1 1 g j j j j j j f 
f j j j j j j j g 1 1 g f f F j j F f f g 1 1 g j j j j j j j f 
f j j j j j j j j g 1 g f f f f f f f f g 1 g j j j j j j j j f 
f j j f j j j j j g 1 1 g f f f f f f g 1 1 g j j j j j f j j f 
f j f j j j j j g 1 1 1 1 g g f f g g 1 1 1 1 g j j j j j f j f 
y j j y j f j g 1 1 1 g 1 1 1 g g 1 1 1 g 1 1 1 g j f j y j j y 
y y y j f j g 1 1 1 g 1 1 1 1 1 1 1 1 1 1 g 1 1 1 g j f j y y y 
y j y j j g 1 1 1 g 1 1 1 1 1 1 1 1 1 1 1 1 g 1 1 1 g j j y j y 
y y y y f g 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 g f y y y y 
]]},
{nil,"portrait_4",[[
y y y y f f f f f f f f f f f f f f f f f f f f f f f f y y y y 
y j y j j j j j j j j j j j j j j j j j j j j j j j j j j y j y 
y y y j f j j j j j j j g g g g g g g g j j j j j j j f j y y y 
y j j y j f j j j j g g 1 1 1 1 1 1 1 1 g g j j j j f j y j j y 
f j f j j j j j g g 1 1 1 1 R R R R 1 1 1 1 g g j j j j j f j f 
f j j f j j j g 1 1 1 R R R R R R R R R R 1 1 1 g j j j f j j f 
f j j j j j g 1 1 R R R R R R R R R R R R R R 1 1 g j j j j j f 
f j j j j g 1 1 R R R R R R R R R R R R R R R R 1 1 g j j j j f 
f j j j j g 1 1 R R R R R R R R R R R R R R R R 1 1 g j j j j f 
f j j j g 1 1 R R R s s s s s s s s s s s s R R R 1 1 g j j j f 
f j j j g 1 1 R R s B B B B s s s s B B B B s R R 1 1 g j j j f 
f j j j g 1 1 R s B D D D D B s s B D D D D B s R 1 1 g j j j f 
f j j g 1 1 R R s s f f f f s s s s f f f f s s R R 1 1 g j j f 
f j j g 1 1 1 R s f 7 i i 7 s 6 6 s 7 i i 7 f s R 1 1 1 g j j f 
f j j g 1 1 1 R s s f 7 7 f s 6 6 s f 7 7 f s s R 1 1 1 g j j f 
f j j g 1 1 1 R S s s f f s s 6 6 s s f f s s S R 1 1 1 g j j f 
f j j g 1 1 R 1 S S s s s s S F F S s s s s S S 1 R 1 1 g j j f 
f j j j g 1 1 1 S S S S S S F F F F S S S S S S 1 1 1 g j j j f 
f j j j g 1 1 1 R S S S S S S F F S S S S S S R 1 1 1 g j j j f 
f j j j g 1 1 1 R S S S S S S S S S S S S S S R 1 1 1 g j j j f 
f j j j j g 1 R 1 1 S S S I I I I I I S S S 1 1 R 1 g j j j j f 
f j j j j g 1 1 1 1 1 S S S S 3 3 S S S S 1 1 1 1 1 g j j j j f 
f j j j j j g 1 1 1 1 1 S S S S S S S S 1 1 1 1 1 g j j j j j f 
f j j j j j j g 1 1 1 1 1 F S S S S F 1 1 1 1 1 g j j j j j j f 
f j j j j j j j g 1 1 g 1 F F F F F F 1 g 1 1 g j j j j j j j f 
f j j j j j j j j g 1 g 2 2 2 F F 2 2 2 g 1 g j j j j j j j j f 
f j j f j j j j j g 1 1 g 2 2 2 2 2 2 g 1 1 g j j j j j f j j f 
f j f j j j j j g 1 1 1 1 g g 2 2 g g 1 1 1 1 g j j j j j f j f 
y j j y j f j g 1 1 1 g 1 1 1 g g 1 1 1 g 1 1 1 g j f j y j j y 
y y y j f j g 1 1 1 g 1 1 1 1 1 1 1 1 1 1 g 1 1 1 g j f j y y y 
y j y j j g 1 1 1 g 1 1 1 1 1 1 1 1 1 1 1 1 g 1 1 1 g j j y j y 
y y y y f g 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 g f y y y y 
]]},

		}
	end,

	setup=function(menu)

		menu.stack={}

		menu.screen_hx=math.floor(hardware.opts.hx/4)
		menu.screen_hy=math.floor(hardware.opts.hy/8)
		menu.width=menu.screen_hx/2
		menu.cursor=0
		menu.cx=math.floor((math.floor(hardware.opts.hx/4)-menu.width))
		menu.cy=0
	
		menu.chats=chatdown.setup(chat_text)

		menu.chats.chat_to_menu_items=function(chat)
			local items={cursor=1,cursor_max=0}
			
			items.title=chat.description_name
			items.portrait=chat.get_proxy("portrait")
			
			local ss=chat.response and chat.response.text or {} if type(ss)=="string" then ss={ss} end
			for i,v in ipairs(ss) do
				if i>1 then
					items[#items+1]={text="",chat=chat} -- blank line
				end
				items[#items+1]={text=chat.replace_proxies(v)or"",chat=chat}
			end

			for i,v in ipairs(chat.decisions or {}) do

				items[#items+1]={text="",chat=chat} -- blank line before each decision

				local ss=v and v.text or {} if type(ss)=="string" then ss={ss} end

				local color=30
				if chat.viewed[v.name] then color=1 end -- we have already seen the response to this decision
				
				local f=function(item,menu)

					if item.decision and item.decision.name then

						menu.chats.changes(chat,"decision",item.decision)

						chat.set_response(item.decision.name)

						chat.set_proxies(item.decision.proxies)

						menu.show(menu.chats.chat_to_menu_items(chat))

					end
				end
				
				items[#items+1]={text=chat.replace_proxies(ss[1])or"",chat=chat,decision=v,cursor=i,call=f,color=color} -- only show first line
				items.cursor_max=i
			end

			return items
		end

		menu.show=function(items)
		
			if not items then
				menu.active=false
				menu.items=nil
				menu.lines=nil
				return
			end
			menu.active=true

			if items.call then items.call(items,menu) end -- refresh
			
			menu.items=items
			menu.cursor=items.cursor or 1
		
			menu.lines={}
			for idx=1,#items do
				local item=items[idx]
				local text=item.text
				if text then
					local portwrap=0
					local portfix=""
					local portmin=1
--print(idx,text,menu.items.portrait)
					if idx==1 and menu.items.portrait then -- show portrait
						portwrap=10
						portfix="          "
						portmin=4
					end
					local ls=wstr.smart_wrap(text,menu.width-8-portwrap)
--					if portmin>1 then
--						table.insert(ls,1,"")
--					end
					while #ls<portmin do -- blank line or pad
						table.insert(ls,1,"")
--						ls[#ls+1]=""
					end
					for i=1,#ls do
						local prefix=""--(i>1 and " " or "")
						if item.cursor then prefix=" " end -- indent decisions
						menu.lines[#menu.lines+1]={s=portfix..prefix..ls[i],idx=idx,item=item,cursor=item.cursor,color=item.color}
					end
				end
			end

		end




		menu.show( menu.chats.get_menu_items("example") )

	end,

	update=function(menu)
	
		if not menu.active then return end
		
		local up0=ups(0)
		
		local mx=up0.axis("mx") -- get mouse position, it will be nil if no mouse
		local my=up0.axis("my")
		
		if mx~=menu.mx or my~=menu.my then -- mouse movement
			menu.mx=mx
			menu.my=my
			if mx >= menu.cx*4 and mx <= (menu.cx+menu.width)*4 then -- in x within menu
				for i,v in ipairs(menu.lines) do
					local y=(menu.cy+i+1)*8
					if my>=y and my<=y+8 then -- over line
						if v.item and v.item.cursor then -- move cursor to line
							menu.cursor=v.item.cursor
						end
					end
				end
			end
		end

		if up0.button("fire_clr") then

			for i,item in ipairs(menu.items) do
			
				if item.cursor==menu.cursor then
			
					if item.call then -- do this
					
						item.call( item , menu )
											
					end

					if item.decision.name=="exit" then -- and exit menu
						menu.show()
					end
					
					break
				end
			end
		end
		
		if up0.button("left_set") or up0.button("up_set") then
		
			menu.cursor=menu.cursor-1
			if menu.cursor<1 then menu.cursor=menu.items.cursor_max end

		end
		
		if up0.button("right_set") or up0.button("down_set") then
			
			menu.cursor=menu.cursor+1
			if menu.cursor>menu.items.cursor_max then menu.cursor=1 end
		
		end
	
	end,
	
	draw=function(menu)

		if not menu.active then return end

		local names=system.components.tiles.names
		local tprint=system.components.text.text_print
		local tgrd=system.components.text.tilemap_grd
		
		menu.cy=math.floor((menu.screen_hy-(#menu.lines+4))/2)
		
		local fg=31
		local bg1,bg2=9,10

		tgrd:clip(menu.cx,menu.cy,0,menu.width,#menu.lines+4,1):clear(bg1*0x1000000)
		tgrd:clip(menu.cx+2,menu.cy+1,0,menu.width-4,#menu.lines+4-2,1):clear(bg2*0x1000000)
		
		if menu.items.title then
			local title=" "..(menu.items.title).." "
			local wo2=math.floor(#title/2)
			tprint(title,menu.cx+(menu.width/2)-wo2,menu.cy+0,fg,bg1)
		end
		
		for i,v in ipairs(menu.lines) do
			tprint(v.s,menu.cx+4,menu.cy+i+1,v.color,bg2)
		end
		
		local it=nil
		for i=1,#menu.lines do
			if it~=menu.lines[i].item then -- first line only
				it=menu.lines[i].item
				if it.cursor == menu.cursor then
					tprint(">",menu.cx+4,menu.cy+i+1,fg,bg2)
				end
			end
		end

		if menu.items.portrait then
			local image=names[menu.items.portrait]
			if image then
				system.components.text.text_print_image(image,menu.cx+4,menu.cy+2,fg,bg1)
			end
		end

		system.components.text.dirty(true)

	end,
}

entities.systems.insert{ caste="player",

	loads=function()

		hardware.graphics.loads{

{nil,"test_player1",[[
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
. . . 7 7 7 . 7 . . 7 7 . . . . 
. . . 7 . . 7 7 7 7 . 7 . . . . 
. . . 7 . 7 . 7 . . 7 7 . . . . 
. . 7 7 . . 7 7 7 7 . 7 7 . . . 
. . 7 . . 7 . 7 . . 7 . 7 . . . 
. . 7 . . . 7 7 7 7 . . 7 . . . 
. . 7 . . 7 . 7 7 . 7 . 7 . . . 
. . 7 7 . 7 7 7 7 7 7 7 7 . . . 
. . 7 7 . . 7 . . 7 . 7 7 . . . 
. . . . . . 7 . . 7 . . . . . . 
. . . . . . 7 7 . 7 7 . . . . . 
. . . . . . 7 7 . 7 7 . . . . . 
. . . . . . 7 . . 7 . . . . . . 
. . . . . . 7 . . 7 . . . . . . 
. . . . . . 7 . . 7 . . . . . . 
. . . . . . 7 . . 7 . . . . . . 
. . . . . 7 7 7 7 7 7 7 . . . . 
. . . . . . . . . . . . . . . . 
]]},
{nil,"test_player2",[[
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
. . . . 7 7 . 7 . . 7 . . . . . 
. . . 7 . . 7 7 7 7 . 7 . . . . 
. . . 7 . 7 . 7 . . 7 7 . . . . 
. . . 7 . . 7 7 7 7 . 7 . . . . 
. . 7 7 . 7 . 7 . . 7 7 7 . . . 
. . 7 . . . 7 7 7 7 . . 7 . . . 
. . 7 . . . . 7 . . . . 7 . . . 
. . 7 . . 7 . 7 7 . 7 . 7 . . . 
. . 7 7 . 7 7 7 7 7 7 7 7 . . . 
. . 7 7 . . 7 . . 7 . 7 7 . . . 
. . . . . . 7 . . 7 . . . . . . 
. . . . . . 7 7 . 7 7 . . . . . 
. . . . . . 7 7 . 7 7 . . . . . 
. . . . . . 7 . . 7 . . . . . . 
. . . . . . 7 . . 7 . . . . . . 
. . . . . . 7 . . 7 . . . . . . 
. . . . . . 7 . . 7 . . . . . . 
. . . . . 7 7 7 7 7 7 7 . . . . 
. . . . . . . . . . . . . . . . 
]]},
{nil,"test_player3",[[
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
. . . . . . . 7 0 7 . . . . . . 
. . . . . . . 7 7 7 . . . . . . 
. . . 7 7 7 . 7 . . 7 7 . . . . 
. . . 7 . . 7 7 7 7 . 7 . . . . 
. . . 7 . 7 . 7 . . 7 7 . . . . 
. . 7 7 . . 7 7 7 7 . 7 7 . . . 
. . 7 . . 7 . 7 . . 7 . 7 . . . 
. . 7 . . . 7 7 7 7 . . 7 . . . 
. . 7 . . . . 7 . . . . 7 . . . 
. . 7 7 . 7 . 7 7 . 7 7 7 . . . 
. . 7 7 . 7 7 7 7 7 7 7 7 . . . 
. . . . . . 7 . . 7 . . . . . . 
. . . . . . 7 . . 7 . . . . . . 
. . . . . . 7 7 . 7 7 . . . . . 
. . . . . . 7 7 . 7 7 . . . . . 
. . . . . . 7 . . 7 . . . . . . 
. . . . . . 7 . . 7 . . . . . . 
. . . . . . 7 . . 7 . . . . . . 
. . . . . . 7 . . 7 . . . . . . 
. . . . . 7 7 7 7 7 7 7 . . . . 
. . . . . . . . . . . . . . . . 
]]},
{nil,"test_player4",[[
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
. . . . . . . 7 0 7 . . . . . . 
. . . 7 7 . . 7 7 7 . 7 . . . . 
. . . 7 . 7 . 7 . . 7 7 . . . . 
. . . 7 . . 7 7 7 7 . 7 . . . . 
. . 7 7 . 7 . 7 . . 7 7 7 . . . 
. . 7 . . . 7 7 7 7 . . 7 . . . 
. . 7 . . 7 . 7 . . 7 . 7 . . . 
. . 7 . . . 7 7 7 7 . . 7 . . . 
. . 7 7 . 7 . 7 7 . 7 7 7 . . . 
. . 7 7 . 7 7 7 7 7 7 7 7 . . . 
. . . . . . 7 . . 7 . . . . . . 
. . . . . . 7 . . 7 . . . . . . 
. . . . . . 7 7 . 7 7 . . . . . 
. . . . . . 7 7 . 7 7 . . . . . 
. . . . . . 7 . . 7 . . . . . . 
. . . . . . 7 . . 7 . . . . . . 
. . . . . . 7 . . 7 . . . . . . 
. . . . . . 7 . . 7 . . . . . . 
. . . . . 7 7 7 7 7 7 7 . . . . 
. . . . . . . . . . . . . . . . 
]]},

		}

	end,

}

local prefabs={
	{name="player",id="player",sprite={"test_player1","test_player2","test_player3","test_player4",speed=16},rules={"player"},illumination=2,},
	{name="floor",back="test_none"},
	{name="floor_tile",back="test_tile"},
	{name="floor_spawn",id="floor_spawn",back="test_spawn",illumination=0.75,},
	{name="wall_full",back="test_wall2",is_big=true,},
	{name="wall_half",back="test_wall1",is_big=true,},
}

local rules={

	{	name="cell",

		update=function(cell)
			for i,c in cell:iterate_hashrange(-1,1,-1,1) do
				local b=0
				for i,v in ipairs(c) do -- get local illumination
					local l=v.illumination
					if l and l>b then b=l end
				end
				for i,v in c:iterate_neighbours() do -- get neighbours illumination
					local big=v:get_big()
					if big and big.illumination then big=nil end -- not lightsources
					if not big then
						if v.illumination and v.illumination>b then b=v.illumination end
					end
				end
				b=b*7/8
				if b<0 then b=0 end
				c.illumination=b
			end
		end,

	},
	
	{	name="player",
	
		setup=function(item)
			item.is_big=true
			item.player={}
		end,

		clean=function(item)
		end,

		update=function(item)
--print("player update")
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
			
			if vx>0 then item.sprite.flip= 1 end
			if vx<0 then item.sprite.flip=-1 end
			
			item[0]:apply_update(16,16)

		end,
	},
	
}

entities.systems.insert{ caste="yarn",

	setup=function(it)

		it.items=require("wetgenes.gamecake.fun.yarn.items").create()
		
		local items=it.items

-- insert my prefabs and rules

		items.cells.metatable.rules={"cell"} -- base cell rules
		
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
--print("moving",vx,vy)
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
		
		it.cx=px-24
		it.cy=py-16
		
		local b={}
		for y=0,31 do
			for x=0,47 do
				local dx=it.cx+x-px
				local dy=it.cy+y-py

--				local lightring=(math.sqrt(dx*dx + dy*dy)-1)/8 -- 1 cells full and 8 cells fadeout
--				if lightring>1 then lightring=1 end
--				if lightring<0 then lightring=0 end
--				lightring=1-lightring
				
				local cell=pages.get_cell(it.cx+x,it.cy+y)
				local idx=y*48*4 + x*4
				b[idx+1]=0
				b[idx+2]=0
				b[idx+3]=31
				b[idx+4]=0
				local light=cell.illumination or 0
--				if lightring>light then light=lightring end
				for i,v in ipairs(cell) do
					if v.back then
						local tile=names[v.back]
						b[idx+1]=tile.pxt
						b[idx+2]=tile.pyt
						b[idx+3]=31
						b[idx+4]=light*255
					end
					if v.sprite then
					
						local flip=1
						local sprite=v.sprite
						if type(sprite)=="table" then
							flip=sprite.flip or 1
							local speed=sprite.speed or 16
							sprite=sprite[math.floor(system.ticks/speed)%#sprite+1]
						end

						local spr=names[sprite]
						system.components.sprites.list_add({
							t=spr.idx,
							hx=spr.hx,hy=spr.hy,ox=spr.hx/2,oy=spr.hy, -- handle on bottom centre of sprite
							px=x*16+8,py=16,pz=-y*16-16, -- position on bottom of tile
							sx=flip,rz=0,
							color={light,light,light,1}
						})
					end
				end
			end
		end
		g:pixels(0,0,0,48,32,1,b)
		system.components.map.dirty(true)
		
		local ax,az=0,0
		
		if entities.systems.menu.active then
			ax= (it.cx*16-math.floor(it.ax+0.5)+(hardware.opts.hx/4-8))
			az=-(it.cy*16-math.floor(it.ay+0.5)+(hardware.opts.hy/2-16))
		else
			ax= (it.cx*16-math.floor(it.ax+0.5)+(hardware.opts.hx/2-8))
			az=-(it.cy*16-math.floor(it.ay+0.5)+(hardware.opts.hy/2-16))
		end

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