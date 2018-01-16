
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
	hx=416,hy=240, -- wide screen 52x30 tiles (8x8)
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

#example A chance meeting

	A rare bread of NPC who will fulfil all your conversational desires for 
	a very good price.

	=sir Madam
	=portrait portrait_1

	>convo

		Is this the right room for a conversation?
		
	>welcome
	
		...ERROR...EOF...PLEASE...RESTART...

<welcome

	Good morning,{sir}!
	
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
		=portrait portrait_2


	>welcome.2?sir!=God

		You may address me as God.

		=sir God
		=portrait portrait_3

	>welcome.3?sir!=sir

		You may address me as Sir.

		=sir sir
		=portrait portrait_4

<afternoon
	
	Then good afternoon, {sir}.
	
	>convo

<morning
	
	And how may I help {sir} today?
	
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
	decision.
	
	>
		Like this?
	<
	
	Yes, just like this. In fact I think you can see that we are already 
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
	["T "]={ items={"talker"}				},
	["T2"]={ items={"talker2"}				},
	["T3"]={ items={"talker3"}				},
	["T4"]={ items={"talker4"}				},
	["T5"]={ items={"talker5"}				},
	["T6"]={ items={"talker6"}				},
	["T7"]={ items={"talker7"}				},
	["T8"]={ items={"talker8"}				},
	["T9"]={ items={"talker9"}				},
	["T0"]={ items={"talker0"}				},
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
. . . . . . . . . . . . . . . T7. . . . . . . . . . . . . . . . 
. . . . . = = = = = . . . . . . . . . . . . . . . . . . . . . . 
. . . . . # . . . # . . . . . . . . . . . . . . . . . . . . . . 
. . . . . # . S . # . . . . . . . . . . . . . . . . . . . . . . 
. . . . . # . . . # . . . . . . . . . . . . . . . . . . . . . . 
. . . . . # = . = # T8. . . . . . . . . . . . . T . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . T3. . . . . . . . . . . . . . . . . . . 
. . . . . . . T5. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . # # # # T8. . . . . . . . 
. . . . . . . . . . . . . . T4. . . . # . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . # . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . # . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . # . . . . . . . . . 
. . . . . = = = = = . . . . . . . . . . . . # . . . . . . . . . 
. . . . . # . T2. # . . . . . . . . . # . . # . . . T6. . . . . 
. . . . . # . . . # . . . . . . . . . # . . . . . . . . . . . . 
. . . . . # = . = S = . = = . . . . . # . . # . . . . . . . . . 
. . . . . . . . . # . . . . . . . . . # . . # . . . . . . . . . 
. . . . . . . . . # . S . . . . . . . # . . # . . . . . . . . . 
. . . . . . . . . # . . . . . . . # . # . . . . . . S . . . . . 
. . . . . . . . . T7. . . . . . # # . . . . . . . . . . . . . . 
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
o 1 y 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 y 1 o 
o y y 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 y y o 
o 0 0 y 0 2 0 0 0 0 0 0 0 0 0 0 0 0 R 0 0 0 0 0 0 0 2 0 y 0 0 o 
2 0 2 0 0 0 0 0 0 0 R 0 0 0 R R R R 0 0 0 0 0 0 0 0 0 0 0 2 0 2 
2 0 0 2 0 0 0 0 R 0 0 R R R R R R R R R R 0 0 0 0 0 0 0 2 0 0 2 
2 0 0 0 0 0 0 0 0 R R R R R R R R R R R R R R 0 0 0 0 0 0 0 0 2 
2 0 0 0 0 0 0 0 R R R R R R R R R R R R R R R R 0 0 0 0 0 0 0 2 
2 0 0 0 0 0 0 0 R R R R R R R R s R R R R R R R 0 0 0 0 0 0 0 2 
2 0 0 0 0 0 0 R R R s s s s s s s s s s s s R R R 0 0 0 0 0 0 2 
2 0 0 0 R 0 R R R s B B B B s s s s B B B B s R R R 0 R 0 0 0 2 
2 0 0 0 0 R 0 R s B D D D D B s s B D D D D B s R 0 R 0 0 0 0 2 
2 0 0 0 0 0 0 R s s f f f f s s s s f f f f s s R 0 0 0 0 0 0 2 
2 0 0 0 0 0 R R s f 7 i i 7 s 6 6 s 7 i i 7 f s R R 0 0 0 0 0 2 
2 0 0 0 0 R 0 R s s f 7 7 f s 6 6 s f 7 7 f s s R 0 R 0 0 0 0 2 
2 0 0 0 R 0 0 R S s s f f s s 6 6 s s f f s s S R 0 0 R 0 0 0 2 
2 0 0 0 0 0 R 0 S s s s s s S F F S s s s s s S 0 R 0 0 0 0 0 2 
2 0 0 0 0 0 0 0 S S s s s S F F F F S s s s S S 0 0 0 0 0 0 0 2 
2 0 0 0 0 0 0 0 R S S S S S S F F S S S S S S R 0 0 0 0 0 0 0 2 
2 0 0 0 0 0 R 0 R S S S S S S S S S S S S S S R 0 0 0 0 0 0 0 2 
2 0 0 0 0 0 0 R 0 0 S S S I I I I I I S S S R 0 R 0 0 0 0 0 0 2 
2 0 0 0 0 0 0 0 0 0 R S S S S 3 3 S S S S R 0 0 0 R 0 0 0 0 0 2 
2 0 0 0 0 0 0 0 0 R 0 R S S S S S S S S R 0 R 0 0 0 0 0 0 0 0 2 
2 0 0 0 0 0 0 0 0 0 0 0 R F S S S S F R 0 0 0 0 0 0 0 0 0 0 0 2 
2 0 0 0 0 0 0 0 0 0 0 0 0 F F F F F F 0 0 0 0 0 0 0 0 0 0 0 0 2 
2 0 0 0 0 0 0 0 0 0 c I 2 2 2 F F 2 2 2 I c 0 0 0 0 0 0 0 0 0 2 
2 0 0 2 0 0 0 0 0 c c c I 2 2 2 2 2 2 I c c c 0 0 0 0 0 2 0 0 2 
2 0 2 0 0 0 0 0 c c B c c I I 1 1 I I c c B c c 0 0 0 0 0 2 0 2 
o 0 0 y 0 2 0 c B B B B B c c I I c c B B B B B c 0 2 0 y 0 0 o 
o y y 1 2 1 c B B o B o B o B c c B B B O B O B B c 1 2 1 y y o 
o 1 y 1 1 B B B B B o B o B B B B B B B B O B B B B B 1 1 y 1 o 
o o o o 2 B B B B B B B B B B B B B B B B B B B B B B 2 o o o o 
]]},
{nil,"portrait_2",[[
y y y y f f f f f f f f f f f f f f f f f f f f f f f f y y y y 
y j 3 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 j y 
y 3 3 0 f 0 0 0 0 0 0 0 d d d d d d d d 0 0 0 0 0 0 0 f 0 3 3 y 
y 0 0 y 0 f 0 0 0 0 G G 1 1 1 1 1 1 1 1 G G 0 0 0 0 f 0 y 0 0 y 
f 0 f 0 0 0 0 0 G G 1 1 1 1 i i i i 1 1 1 1 G G 0 0 0 0 0 f 0 f 
f 0 0 f 0 0 0 G 1 1 1 i i i i i i i i i i 1 1 1 G 0 0 0 f 0 0 f 
f 0 0 0 0 0 G 1 1 i i i i i i i i i i i i i i 1 1 G 0 0 0 0 0 f 
f 0 0 0 0 g 1 1 i i i 2 i 2 i 2 2 i 2 i 2 i i i 1 1 g 0 0 0 0 f 
f 0 0 0 0 g 1 i i 2 2 2 2 2 2 2 2 2 2 2 2 2 2 i i 1 g 0 0 0 0 f 
f 0 0 0 g 1 1 i 2 2 j j j j 2 2 2 2 j j j j 2 2 i 1 1 g 0 0 0 f 
f 0 0 0 g 1 1 i 2 2 2 5 5 2 2 2 2 2 2 5 5 2 2 2 i 1 1 g 0 0 0 f 
f 0 0 0 g 1 1 i 2 2 5 i i 5 2 3 3 2 5 i i 5 2 2 i 1 1 g 0 0 0 f 
f 0 0 G 1 1 j j 2 2 5 i i 5 2 3 3 2 5 i i 5 2 2 j j 1 1 G 0 0 f 
f 0 0 G 1 1 1 j F F f 7 7 f 2 3 3 2 f 7 7 f F F j 1 1 1 G 0 0 f 
f 0 0 G 1 1 1 1 j F F f f F F 3 3 F F f f F F j 1 1 1 1 G 0 0 f 
f 0 0 G 1 1 1 j F F F F F F F s s F F F F F F F j 1 1 1 G 0 0 f 
f 0 0 G 1 1 j F F f F F F F F m m F F F F F F F F j 1 1 G 0 0 f 
f 0 0 0 G 1 1 F F F F F F F m m m m F F R F R F F 1 1 G 0 0 0 f 
f 0 0 0 G 1 1 F F F F F F F F m m F F F F R F F F 1 1 G 0 0 0 f 
f 0 0 0 G 1 1 j F F F F F j F F F F j F F F F F j 1 1 G 0 0 0 f 
f 0 0 0 0 g 1 1 F F F F F F j j j j F F F F F F 1 1 g 0 0 0 0 f 
f 0 0 0 0 g 1 1 1 F F F f f f f f f f f F F F 1 1 1 g 0 0 0 0 f 
f 0 0 0 0 0 g 1 1 1 j f f f f i i f f f f j 1 1 1 g 0 0 0 0 0 f 
f 0 0 0 0 0 0 g 1 1 1 1 f f f f f f f f 1 1 1 1 g 0 0 0 0 0 0 f 
f 0 0 0 0 0 0 0 g 1 1 g j j f f f f j j g 1 1 g 0 0 0 0 0 0 0 f 
f 0 0 0 0 0 0 0 0 g 2 g j j j j j j j j g 2 g 0 0 0 0 0 0 0 0 f 
f 0 0 f 0 0 0 0 0 g 2 2 g j j j j j j g 2 2 g 0 0 0 0 0 f 0 0 f 
f 0 f 0 0 0 0 0 g 2 2 2 2 g g j j g g 2 2 2 2 g 0 0 0 0 0 f 0 f 
y 0 0 y 0 f 0 g 2 2 2 G 2 2 2 g g 2 2 2 G 2 2 2 g 0 f 0 y 0 0 y 
y 3 3 j f j g 2 2 2 G 2 2 2 2 2 2 2 2 2 2 G 2 2 2 g j f j 3 3 y 
y j 3 j j 2 2 2 2 G 2 2 2 2 2 2 2 2 2 2 2 2 G 2 2 2 2 j j 3 j y 
y y y y f 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 f y y y y 
]]},
{nil,"portrait_3",[[
o o o o 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 o o o o 
o 0 y 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 y 0 o 
o y y 0 2 0 0 0 0 0 0 0 0 0 5 5 5 5 0 0 0 0 0 0 0 0 0 2 0 y y o 
o 0 0 y 0 2 0 0 0 0 0 5 5 5 4 4 4 4 5 5 5 0 0 0 0 0 2 0 y 0 0 o 
2 0 2 0 0 0 0 0 0 5 5 4 4 4 4 4 4 4 4 4 4 5 5 0 0 0 0 0 0 2 0 2 
2 0 0 2 0 0 0 0 5 4 4 4 4 4 s s s s 4 4 4 4 4 5 0 0 0 0 2 0 0 2 
2 0 0 0 0 0 0 0 4 4 5 5 s s s s s s s s 5 5 4 4 0 0 0 0 0 0 0 2 
2 0 0 0 0 0 0 5 4 5 s s s s s s s s s s s s 5 4 5 0 0 0 0 0 0 2 
2 0 0 0 0 0 0 4 5 s s f f s s s s s s f f s s 5 4 0 0 0 0 0 0 2 
2 0 0 0 0 0 0 4 s s f 7 7 f s s s s f 7 7 f s s 4 0 0 0 0 0 0 2 
2 0 0 0 0 0 S 4 s s 7 i i 7 s 7 7 s 7 i i 7 s s 4 S 0 0 0 0 0 2 
2 0 0 0 0 0 s S s s 7 i i 7 s 7 7 s 7 i i 7 s s S s 0 0 0 0 0 2 
2 0 0 0 0 0 0 S s s f 7 7 f s 7 7 s f 7 7 f s s S 0 0 0 0 0 0 2 
2 0 0 0 1 0 0 F s s s f f s s 7 7 s s f f s s s F 0 0 1 0 0 0 2 
2 0 0 0 0 0 0 0 s s s s s s s S S s s s s s s s 0 0 0 0 0 0 0 2 
2 0 0 0 1 0 0 0 s s S s s s S S S S s s s S s s 0 0 0 1 0 0 0 2 
2 0 0 1 0 1 0 0 0 s s S s F F S S F F s S s s 0 0 0 1 0 1 0 0 2 
2 0 0 0 1 0 0 0 0 s s S s s s F F s s s S s s 0 0 0 0 1 0 0 0 2 
2 0 0 0 0 0 0 0 0 0 s s s s 4 4 4 4 s s s s 0 0 0 0 0 0 0 0 0 2 
2 0 0 0 1 0 0 0 0 0 s s 4 4 f f f f 4 4 s s 0 0 0 0 0 1 0 0 0 2 
2 0 0 1 0 1 0 0 0 0 s 4 4 f 4 4 4 4 f 4 4 s 0 0 0 0 1 0 1 0 0 2 
2 0 1 0 1 0 1 0 0 0 0 4 4 4 4 4 4 4 4 4 4 0 0 0 0 1 0 1 0 1 0 2 
2 0 0 1 0 1 0 0 0 0 0 0 4 4 4 4 4 4 4 4 0 0 0 0 0 0 1 0 1 0 0 2 
2 0 0 0 1 0 0 0 0 0 0 0 0 F 4 4 4 4 F 0 0 0 0 0 0 0 0 1 0 0 0 2 
2 0 0 0 0 0 0 0 0 0 0 0 0 F F F F F F 0 0 0 0 0 0 0 0 0 0 0 0 2 
2 0 0 0 0 0 0 0 0 0 m o I I I F F I I I o m 0 0 0 0 0 0 0 0 0 2 
2 0 0 2 0 0 0 0 0 m m m o I I I I I I o m m m 0 0 0 0 0 2 0 0 2 
2 0 2 0 0 0 0 0 m m o m m o o o o o o m m o m m 0 0 0 0 0 2 0 2 
o 0 0 y 0 2 0 m R R o R R m m o o m m R R o R R m 0 2 0 y 0 0 o 
o y y 0 2 0 m R R R o R R R R m m R R R R o R R R m 0 2 0 y y o 
o 0 y 0 0 R R R R R o R R R R R R R R R R o R R R R R 0 0 y 0 o 
o o o o 2 R R R R R M R R R R M M R R R R M R R R R R 2 o o o o 
]]},
{nil,"portrait_4",[[
d d d d 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 d d d d 
d 0 y 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 y 0 d 
d y y 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 y y d 
d 0 0 y 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 y 0 0 d 
2 0 2 0 0 0 0 0 0 0 0 0 0 0 F F F F 0 0 0 0 0 0 0 0 0 0 0 2 0 2 
2 0 0 2 0 0 0 0 0 0 0 F F F f f f f F F F 0 0 0 0 0 0 0 2 0 0 2 
2 0 0 0 0 0 0 0 0 F F f f f f f f f f f f F F 0 0 0 0 0 0 0 0 2 
2 0 0 0 0 0 0 0 F f f f f f f f f f f f f f f F 0 0 0 0 0 0 0 2 
2 0 0 0 0 0 0 0 f f f S f f S f f S f f S f f f 0 0 0 0 0 0 0 2 
2 0 0 0 0 0 0 F f f S S S S S S S S S S S S f f F 0 0 0 0 0 0 2 
2 0 0 0 0 0 0 f f S S f f S S S S S S f f S S f f 0 0 0 0 0 0 2 
2 0 0 0 0 0 F f S S f 7 7 f s S S s f 7 7 f S S f F 0 0 0 0 0 2 
2 0 0 0 0 0 f f S f 7 1 1 7 s s s s 7 1 1 7 f S f f 0 0 0 0 0 2 
2 0 0 0 1 0 f f s s 7 1 1 7 s S S s 7 1 1 7 s s f f 0 1 0 0 0 2 
2 0 0 0 0 0 f f s f f 7 7 f s S S s f 7 7 f f s f f 0 0 0 0 0 2 
2 0 0 0 1 0 f f s s s f f s s S S s s f f s s s f f 0 1 0 0 0 2 
2 0 0 1 0 f 0 0 s s m m m s F 7 7 F s m m m s s 0 0 f 0 1 0 0 2 
2 0 0 0 1 0 0 0 s s m m m s s F F s s m m m s s 0 0 0 1 0 0 0 2 
2 0 0 0 0 0 0 0 0 s s s s s s s s s s s s s s 0 0 0 0 0 0 0 0 2 
2 0 0 0 1 0 0 0 0 s s s s s f s s f s s s s s 0 0 0 0 1 0 0 0 2 
2 0 0 1 0 1 0 0 0 0 s s s s s f f s s s s s 0 0 0 0 1 0 1 0 0 2 
2 0 1 0 1 0 1 0 0 0 0 s s s s s s s s s s 0 0 0 0 1 0 1 0 1 0 2 
2 0 0 1 0 1 0 0 0 0 0 0 s s s s s s s s 0 0 0 0 0 0 1 0 1 0 0 2 
2 0 0 0 1 0 0 0 0 0 0 0 0 F s s s s F 0 0 0 0 0 0 0 0 1 0 0 0 2 
2 0 0 0 0 0 0 0 0 0 0 I b F F F F F F b I 0 0 0 0 0 0 0 0 0 0 2 
2 0 0 0 0 0 0 0 0 0 Y I I b F F F F b I I Y 0 0 0 0 0 0 0 0 0 2 
2 0 0 2 0 0 0 0 0 Y O Y I I b F F b I I Y O Y 0 0 0 0 0 2 0 0 2 
2 0 2 0 0 0 0 0 O O Y Y m I I b b I I m Y Y O O 0 0 0 0 0 2 0 2 
d 0 0 y 0 2 0 O O Y O Y m m I I I I m m Y O Y O O 0 2 0 y 0 0 d 
d y y 0 2 0 0 O O O Y Y m m m I I m m m Y Y O O O 0 0 2 0 y y d 
d 0 y 0 0 0 I I O O O O Y m m I I m m Y O O O O I I 0 0 0 y 0 d 
d d d d 2 2 I I I O O O Y m m I I m m Y O O O I I I 2 2 d d d d 
]]},
{nil, "border",[[
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
1 1 j 1 1 1 1 1 1 1 1 1 1 1 1 F 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 F 1 1 1 1 1 1 1 1 1 1 1 1 j 1 1 
1 j 1 j F F 1 F 1 f f f f 1 F 1 F 1 F 1 f 1 f f f f 1 f 1 F 1 F 1 F 1 f f f f 1 F 1 F F j 1 j 1 
1 1 j 1 1 1 F 1 F 1 1 1 1 F 1 1 1 F 1 F 1 f 1 1 1 1 f 1 F 1 F 1 1 1 F 1 1 1 1 F 1 F 1 1 1 j 1 1 
1 j F j F F i F i f f f f i F 1 F i F i f i f f f f i f i F i F 1 F i f f f f i F i F F j F j 1 
1 1 j 1 j i f i f i i i i i i F i i i 1 i i i i i i i i 1 i i i F i i i i i i f i f i j 1 j 1 1 
1 1 j 1 j i i f i i i i i i i i i 1 i i i i i i i i i i i i 1 i i i i i i i i i f i i j 1 j 1 1 
1 1 j 1 j i F i i 1 i i i i i i i i i 1 i i i i i i i i 1 i i i i i i i i i 1 i i F i j 1 j 1 1 
1 1 1 F i F i F 1 i 1 1 1 i 1 i i i 1 i 1 i i i i i i 1 i 1 i i i 1 i 1 1 1 i 1 F i F i F 1 1 1 
1 1 f 1 f i F i i 1 i i i 1 i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i 1 i i i 1 i i F i f 1 f 1 1 
1 1 f 1 f i i i 1 1 1 1 1 i 1 i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i 1 i 1 1 1 1 1 i i i f 1 f 1 1 
1 1 f 1 f i f i 1 i 1 i i i i i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i i i i i 1 i 1 i f i f 1 f 1 1 
1 1 f 1 f i i i 1 i 1 i 1 i i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i i 1 i 1 i 1 i i i f 1 f 1 1 
1 1 1 F i i i i 1 i 1 i i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i i 1 i 1 i i i i F 1 1 1 
1 1 j 1 j i i i i 1 i i i 1 i i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i i 1 i i i 1 i i i i j 1 j 1 1 
1 1 1 j 1 j i i 1 i 1 i 1 1 i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i 1 1 i 1 i 1 i i j 1 j 1 1 1 
1 1 j 1 j i i i i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i i i i j 1 j 1 1 
1 1 1 F i i i i i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i i i i i F 1 1 1 
1 1 F 1 F i i i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i i i F 1 F 1 1 
1 1 1 F i 1 i 1 i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i 1 i 1 i F 1 1 1 
1 1 f 1 f i i i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i i i f 1 f 1 1 
1 1 1 f i i i 1 i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i 1 i i i f 1 1 1 
1 1 f 1 f i i i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i i i f 1 f 1 1 
1 1 f 1 f i i i i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i i i i f 1 f 1 1 
1 1 f 1 f i i i i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i i i i f 1 f 1 1 
1 1 f 1 f i i i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i i i f 1 f 1 1 
1 1 1 f i i i 1 i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i 1 i i i f 1 1 1 
1 1 f 1 f i i i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i i i f 1 f 1 1 
1 1 1 F i 1 i 1 i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i 1 i 1 i F 1 1 1 
1 1 F 1 F i i i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i i i F 1 F 1 1 
1 1 1 F i i i i i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i i i i i F 1 1 1 
1 1 j 1 j i i i i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i i i i j 1 j 1 1 
1 1 1 j 1 j i i 1 i 1 i 1 1 i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i 1 1 i 1 i 1 i i j 1 j 1 1 1 
1 1 j 1 j i i i i 1 i i i 1 i i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i i 1 i i i 1 i i i i j 1 j 1 1 
1 1 1 F i i i i 1 i 1 i i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i i 1 i 1 i i i i F 1 1 1 
1 1 f 1 f i i i 1 i 1 i 1 i i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i i 1 i 1 i 1 i i i f 1 f 1 1 
1 1 f 1 f i f i 1 i 1 i i i i i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i i i i i 1 i 1 i f i f 1 f 1 1 
1 1 f 1 f i i i 1 1 1 1 1 i 1 i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i 1 i 1 1 1 1 1 i i i f 1 f 1 1 
1 1 f 1 f i F i i 1 i i i 1 i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i 1 i i i 1 i i F i f 1 f 1 1 
1 1 1 F i F i F 1 i 1 1 1 i 1 i 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 i 1 i 1 1 1 i 1 F i F i F 1 1 1 
1 1 j 1 j i F i i 1 i i i i i i i i 1 i 1 i 1 i i 1 i 1 i 1 i i i i i i i i 1 i i F i j 1 j 1 1 
1 1 j 1 j i i f i i i i i i i i i i i 1 i 1 i i i i 1 i 1 i i i i i i i i i i i f i i j 1 j 1 1 
1 1 j 1 j i f i f i i i i i i F i 1 i i i i i i i i i i i i 1 i F i i i i i i f i f i j 1 j 1 1 
1 j F j F F i F i f f f f i F 1 F i F i f i f f f f i f i F i F 1 F i f f f f i F i F F j F j 1 
1 1 j 1 1 1 F 1 F 1 1 1 1 F 1 1 1 F 1 F 1 f 1 1 1 1 f 1 F 1 F 1 1 1 F 1 1 1 1 F 1 F 1 1 1 j 1 1 
1 j 1 j F F 1 F 1 f f f f 1 F 1 F 1 F 1 f 1 f f f f 1 f 1 F 1 F 1 F 1 f f f f 1 F 1 F F j 1 j 1 
1 1 j 1 1 1 1 1 1 1 1 1 1 1 1 F 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 F 1 1 1 1 1 1 1 1 1 1 1 1 j 1 1 
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1  
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
			
			items.title=chat.description.text[1] or chat.description_name
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
				if chat.viewed[v.name] then color=8 end -- we have already seen the response to this decision
				
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
					while #ls<portmin-1 do -- blank line or pad
						table.insert(ls,1,"")
					end
					while #ls<portmin do -- blank line or pad
						table.insert(ls,"")
					end
					for i=1,#ls do
						local prefix=""--(i>1 and " " or "")
						if item.cursor then prefix=" " end -- indent decisions
						menu.lines[#menu.lines+1]={s=portfix..prefix..ls[i],idx=idx,item=item,cursor=item.cursor,color=item.color}
					end
				end
			end

		end




--		menu.show( menu.chats.get_menu_items("example") )

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
		
		local fg=22
		local bg1,bg2=25,25

--		tgrd:clip(menu.cx,menu.cy,0,menu.width,#menu.lines+4,1):clear(bg1*0x1000000)
--		tgrd:clip(menu.cx+2,menu.cy+1,0,menu.width-4,#menu.lines+4-2,1):clear(bg2*0x1000000)

		system.components.text.text_print_border(names.border,
			menu.cx,menu.cy,menu.width,#menu.lines+4)
		
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
				system.components.text.text_print_image(image,menu.cx+4,menu.cy+2,31,bg1)
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
{nil, "char1",[[
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . 5 S 5 . . . . . . 
. . . . . . 4 s s s 4 . . . . . 
. . . . . . S i S i S . . . . . 
. . . . . . S s 7 s S . . . . . 
. . . . . . . s 4 s . . . . . . 
. . . . . . . 4 f 4 . . . . . . 
. . . . . . . 4 4 4 . . . . . . 
. . . m o m o I F I o o . . . . 
. . . R R o m o I o o R m . . . 
. . . R f o R m o m o R R . . . 
. . m R f o R R m R o R R . . . 
. . R f . o R R R R o f R . . . 
. . R f . o R M M R o f R . . . 
. . m F . o R m m R o F m . . . 
. . S S . R R R R R R S S . . . 
. . s s . o R R R R o s s . . . 
. . . . . R R R R R R . . . . . 
. . . . . I I I i I I . . . . . 
. . . . . I I b i I b . . . . . 
. . . . . I I . i I . . . . . . 
. . . . . I I . i I . . . . . . 
. . . . . s s . s s . . . . . . 
. . . . . s s . s s . . . . . . 
. . . . . F F F F f f f . . . . 
. . . . . . . . . . . . . . . .  
]]},
{nil, "char2",[[
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . b I b . . . . . . 
. . . . . . I B I B I . . . . . 
. . . . . b b S S S b b . . . . 
. . . . I I S 1 7 1 S I . . . . 
. . . . b b M S s s M b . . . . 
. . . . . I M S S S M I . . . . 
. . . . . . b S R S b . . . . . 
. . . . . . . s S . . . . . . . 
. . . j j j s s s s D R . . . . 
. . . j j i j s s D R R . . . . 
. . . j i j j j D R R R . . . . 
. . j j i s j j D R D R R . . . 
. . j i . j s s D D R f R . . . 
. . j i . . i j D j . f R . . . 
. . j i . . j j D R . f R . . . 
. . s s . j j j D R R s s . . . 
. . S S . j j j D R R S S . . . 
. . . . . j j j D R R . . . . . 
. . . . j j j j D R R . . . . . 
. . . . j j j j D R R . . . . . 
. . . j j j j j D R R . . . . . 
. . . j j j j j D D D . . . . . 
. . . . . s s . s s . . . . . . 
. . . . . f f f f j j j . . . . 
. . . . . . . . . . . . . . . . 
]]},
{nil, "char3",[[
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . o O O . . . . . . 
. . . . . . O F o o O . . . . . 
. . . . . O F F F F o O . . . . 
. . . . O O F 1 s 1 F o . . . . 
. . . . O O m F s S F o . . . . 
. . . . . r F F F F F r o . . . 
. . . . . . r F j F r . . . . . 
. . . . . . . f F . . . . . . . 
. . . 4 D f f f f f f D . . . . 
. . . 3 2 D D f f f D 3 . . . . 
. . . 3 2 4 4 D D D 4 3 . . . . 
. . 4 3 2 4 4 3 o 4 4 3 4 . . . 
. . 3 2 . 3 3 3 o 3 3 2 3 . . . 
. . 3 2 . . 4 4 o 4 . 2 3 . . . 
. . 2 2 . 3 3 3 o 3 3 2 2 . . . 
. . f f . D D D D D D f f . . . 
. . F F . i i i j i i F F . . . 
. . . . . i i i j j i . . . . . 
. . . . . i i i j i i . . . . . 
. . . . . i i I j i I . . . . . 
. . . . . i i . j i . . . . . . 
. . . . . i i . j i . . . . . . 
. . . . . f f . f f . . . . . . 
. . . . . F F . F F . . . . . . 
. . . . . o o o o O O O . . . . 
. . . . . . . . . . . . . . . . 
]]},
{nil, "char4",[[
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . R . . . . . 
. . . . . R . O O O . . . . . . 
. . . . . . O r S r O . . . . . 
. . . . R . r s S s r . . . . . 
. . . . . O S i S i S R . . . . 
. . . . . r S s 7 s S . . . . . 
. . . . R . r S S S . R . . . . 
. . . . . . . S f S . . . . . . 
. . . . . . . S S S . . . . . . 
. . . c c I 2 s s 2 I c . . . . 
. . . B B B I 2 2 I B b . . . . 
. . . B b b B I I B B b . . . . 
. . c B . b B B B B B b c . . . 
. . B B . b o B O B O b B . . . 
. . B B . b B o B O B b B . . . 
. . c c . b B B B B B c c . . . 
. . s s . b B B B B B s s . . . 
. . S S . b b b b b b S S . . . 
. . . . . I I I i i I . . . . . 
. . . . . I I I i i I . . . . . 
. . . . . I I b i i b . . . . . 
. . . . . I I . i I . . . . . . 
. . . . . b b . b b . . . . . . 
. . . . . S S . S S . . . . . . 
. . . . . S S . S S . . . . . . 
. . . . . F F F F f f f . . . . 
. . . . . . . . . . . . . . . . 
]]},
{nil, "char5",[[
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . F . . . . . 
. . . . . . . F f f . . . . . . 
. . . . . . F s s s f . . . . . 
. . . . . . S i S i S . . . . . 
. . . . . . s s 7 s s . . . . . 
. . . . . . S S 4 S S . . . . . 
. . . . . . . 4 F 4 . . . . . . 
. . . . . . . 4 4 4 . . . . . . 
. . . j j j y F i F y j . . . . 
. . . j j j j y F y j j . . . . 
. . . j j i j j y j i j . . . . 
. . j j . i i j j j i j j . . . 
. . j j . i i i j i i j j . . . 
. . j j . i i j j j i j j . . . 
. . y y . i i i j i i y y . . . 
. . s s . i i j j j i s s . . . 
. . S S . i i i j i i S S . . . 
. . . . . 3 3 3 2 3 3 . . . . . 
. . . . . 3 3 3 2 3 3 . . . . . 
. . . . . 3 3 4 2 3 4 . . . . . 
. . . . . 3 3 . 2 3 . . . . . . 
. . . . . 3 3 . 2 3 . . . . . . 
. . . . . 3 3 . 2 3 . . . . . . 
. . . . . 2 2 . 2 2 . . . . . . 
. . . . . j j j j i i i . . . . 
. . . . . . . . . . . . . . . . 
]]},
{nil, "char6",[[
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . j j j j . . . . . . 
. . . . . j j j F F j . . . . . 
. . . . j j j f F f f j . . . . 
. . . . j j F 1 s 1 F F j . . . 
. . . j j R f F s S f R . . . . 
. . . . j j F F F F F j . . . . 
. . . . . j F F j F F . . . . . 
. . . . . . j F F F . . . . . . 
. . . S S S m f f m S S . . . . 
. . . S s m m m m m m S . . . . 
. . . S s m m S 3 m m S . . . . 
. . S S s S S S 3 S S S S . . . 
. . S s . S S S 3 S S s S . . . 
. . S s . . S S 3 S . s S . . . 
. . S s . S S S 3 S S s S . . . 
. . F F S S S S 3 S S F F . . . 
. . F F m m m m m m m F F . . . 
. . . . j j j j i j j . . . . . 
. . . . . j j j i j j . . . . . 
. . . . . j j f i j f . . . . . 
. . . . . j j . i j . . . . . . 
. . . . . j j . i j . . . . . . 
. . . . . j j . i j . . . . . . 
. . . . . F F . F F . . . . . . 
. . . . . b b b b I I I . . . . 
. . . . . . . . . . . . . . . . 
]]},
{nil, "char7",[[
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
. . . . . . f f f f . . . . . . 
. . . . . f f F S F f . . . . . 
. . . . f f S 1 S 1 S f . . . . 
. . . . f f m m 7 m m f . . . . 
. . . F . f s s s s s . F . . . 
. . . . . . . s f s . . . . . . 
. . . . . . . F s . . . . . . . 
. . . I I I b b F b b I . . . . 
. . . I . Y m I b I m Y . . . . 
. . . I . Y O m I m O Y . . . . 
. . I I . Y O m I m O Y I . . . 
. . I . . . Y m I m Y . I . . . 
. . I . . O Y m I m Y . I . . . 
. . s s . j j j j j j s s . . . 
. . s s . . j f . j f s s . . . 
. . . . . . j . . j . . . . . . 
. . . . . . j . . j . . . . . . 
. . . . . . s . . s . . . . . . 
. . . . . F F F F f f f . . . . 
. . . . . . . . . . . . . . . . 
]]},
{nil, "char8",[[
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
. . . . . . . j j j . . . . . . 
. . . . . . j s s s j . . . . . 
. . . . . j s 1 S 1 s j . . . . 
. . . . . j m m 7 m m . . . . . 
. . . . . . s s s s s . . . . . 
. . . . . . . s I s . . . . . . 
. . . . . . . F s . . . . . . . 
. . . G G d I 2 F 2 I d . . . . 
. . . G . G d I 2 I d g . . . . 
. . . G . G G d I d G g . . . . 
. . G G . F G F d F G g g . . . 
. . G . . G F G F G F . g . . . 
. . G . . g G G G G G . g . . . 
. . G . . G G G G G G . g . . . 
. . s s . j j j j j j s s . . . 
. . s s . . j j . j j s s . . . 
. . . . . . j f . j f . . . . . 
. . . . . . j . . j . . . . . . 
. . . . . . j . . j . . . . . . 
. . . . . . s . . s . . . . . . 
. . . . . F F F F f f f . . . . 
. . . . . . . . . . . . . . . . 
]]},
{nil, "char9",[[
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . 5 S 5 . . . . . . 
. . . . . . 4 s s s 4 . . . . . 
. . . . . . S i S i S . . . . . 
. . . . . . S s 7 s S . . . . . 
. . . . . . . s 4 s . . . . . . 
. . . . . . . 4 f 4 . . . . . . 
. . . . . . . 4 4 4 . . . . . . 
. . . m m m o I F I o m . . . . 
. . . R R R R o I o R R . . . . 
. . . R f R o m o m o R . . . . 
. . m R f R o R m R o R m . . . 
. . R f . R o R R R o f R . . . 
. . R f . R o s M M o f R . . . 
. . F F . R o s m m o F F . . . 
. . s s . R R R R R R s s . . . 
. . S S . R m R R R m S S . . . 
. . . . . f f f f f f . . . . . 
. . . . . I I I i i I . . . . . 
. . . . . . I b i i b . . . . . 
. . . . . I I . i I . . . . . . 
. . . . . b b . b b . . . . . . 
. . . . . s s . s s . . . . . . 
. . . . . s s . s s . . . . . . 
. . . . . F F F F f f f . . . . 
. . . . . . . . . . . . . . . . 
]]},
{nil, "char0",[[
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . 
. . . . . . . b I b . . . . . . 
. . . . . . I B I B I . . . . . 
. . . . . b b S S S b b . . . . 
. . . . I I S 1 s 1 S I . . . . 
. . . . b b M S s 7 M b . . . . 
. . . . . I M S S S M I . . . . 
. . . . . . b S R S b . . . . . 
. . . . . . . s S . . . . . . . 
. . . j j j s s s s D R . . . . 
. . . j j i j S S D R R . . . . 
. . . j i i j j D R R R . . . . 
. . j j i s i j D R D R R . . . 
. . j i . i s s D D R f R . . . 
. . j i . . i i D j . f R . . . 
. . i i . . i j D R . f f . . . 
. . s s . i j j D R R s s . . . 
. . S S . i j j D R R S S . . . 
. . . . . i j j D R R . . . . . 
. . . . i j j j D R R . . . . . 
. . . . i j j j D R R . . . . . 
. . . i j j j j D R R . . . . . 
. . . i j j j j D D D . . . . . 
. . . . . s s . s s . . . . . . 
. . . . . f f f f j j j . . . . 
. . . . . . . . . . . . . . . . 
]]},
{nil,"cursor_square",[[
4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 
7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 
]]},

		}

	end,

}

local prefabs={
	{name="player",id="player",rules={"player"},illumination=1,},
	{name="talker",back="test_tile",rules={"talker"},illumination=0.25,},
	{name="talker2",back="test_tile",rules={"talker"},sprite={"char2"},illumination=0.25,},
	{name="talker3",back="test_tile",rules={"talker"},sprite={"char3"},illumination=0.25,},
	{name="talker4",back="test_tile",rules={"talker"},sprite={"char4"},illumination=0.25,},
	{name="talker5",back="test_tile",rules={"talker"},sprite={"char5"},illumination=0.25,},
	{name="talker6",back="test_tile",rules={"talker"},sprite={"char6"},illumination=0.25,},
	{name="talker7",back="test_tile",rules={"talker"},sprite={"char7"},illumination=0.25,},
	{name="talker8",back="test_tile",rules={"talker"},sprite={"char8"},illumination=0.25,},
	{name="talker9",back="test_tile",rules={"talker"},sprite={"char9"},illumination=0.25,},
	{name="talker0",back="test_tile",rules={"talker"},sprite={"char0"},illumination=0.25,},
	{name="floor",back="test_none"},
	{name="floor_tile",back="test_tile"},
	{name="floor_spawn",id="floor_spawn",back="test_spawn",illumination=0.75,},
	{name="wall_full",back="test_wall2",is_big=true,},
	{name="wall_half",back="test_wall1",is_big=true,},
}

local rules={

	{	name="cell",
		
		inject_time=function(cell,dx,dy)

			for i,c in cell:iterate_hashrange(-dx,dx,-dy,dy) do
				c:apply("update")
				for i,item in ipairs(c) do
					item:apply("update")
				end
			end

			for i,c in cell:iterate_rangebleed(-dx,dx,-dy,dy) do
				local b=0
				for i,v in ipairs(c) do -- get local illumination
					local l=v.illumination
					if l and l>b then b=l end
				end
				for i,v in c:iterate_neighbours() do -- get neighbours illumination
					local big=v:get_big()
					local bi=0
					bi=v.illumination or bi
					if big and not big.illumination  then bi=bi/2 end -- big things get darker quicker?
					if bi>b then b=bi end
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
			item.sprite=item.sprite or
				{
					"test_player1","test_player2","test_player3","test_player4",
					speed=16,color={1,1,1,1}
				}
		end,

		clean=function(item)
		end,

		update=function(item)
--print("player update")
		end,

		move=function(item,vx,vy)

			local target=item[0]:get_cell_relative(vx,vy)
			item:insert( target ) -- move to a new location
			if vx>0 then item.sprite.flip= 1 end
			if vx<0 then item.sprite.flip=-1 end

			item.anim={
				vx=-vx*16,
				vy=-vy*16,
				name="hop",
				length=8,
			}

		end,
	},
	
	{	name="talker",
	
		setup=function(item)
			item.is_big=true
			item.player={}
			item.sprite=item.sprite or
				{
					"char1",
					speed=16,color={1,1,1,1}
				}
		end,

		clean=function(item)
		end,

		update=function(item)
--print("player update")
		end,

		move=function(item,vx,vy)

			local target=item[0]:get_cell_relative(vx,vy)
			item:insert( target ) -- move to a new location
			if vx>0 then item.sprite.flip= 1 end
			if vx<0 then item.sprite.flip=-1 end
			
			item.anim={
				vx=-vx*16,
				vy=-vy*16,
				name="hop",
				length=8,
			}

		end,

		talk=function(item,player)
		
			local menu=entities.systems.menu

			menu.chats.get(item.chatname or "example").set_response("welcome")
			menu.show(menu.chats.get_menu_items(item.chatname or "example"))

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
		local spawn=items.ids.floor_spawn[0]
		items.create( items.prefabs.get("player") ):insert( spawn ) -- use spawn point
		spawn:apply("inject_time",16,16) -- inject some time

-- setup view

		local ccx=items.ids.player[0].cx
		local ccy=items.ids.player[0].cy

		it.dx=items.ids.player[0].cx*16
		it.dy=items.ids.player[0].cy*16
		it.ax=it.dx
		it.ay=it.dy

	end,
	
-- work out what to do by default with this cell relative to us, eg move talk dig fight etc
	solicit=function(it,item,vx,vy)
	
		local ret={}

		local target=item[0]:get_cell_relative(vx,vy)
		local big=target:get_big()

		local face=function()
			if vx>0 then item.sprite.flip= 1 end
			if vx<0 then item.sprite.flip=-1 end
		end
		
		-- if empty, just walk
		if not big then -- we can move to this cell
			ret[#ret+1]={"move",function()
				item:apply("move",vx,vy)
				item[0]:apply("inject_time",16,16)
			end}
		end
		
		-- there is something big there, so try and do something with it
		
		if big and big:can("talk") then -- we can talk to this item
			ret[#ret+1]={"talk",function()
				face()
				big:apply("talk",big)
			end}
		end
		
		 -- finally we could just face this big cell and do nothing
		 if big then
			ret[#ret+1]={"face",function()
				face()
			end}
		end
		
		for i,v in ipairs(ret) do ret[ v[1] ]=v end -- and lookup by name
		
		return ret

	end,

	update=function(it)
		local items=it.items
		local pages=items.pages

		local up=ups(0) -- get all connected controls, merged together
		local up1=ups(1)
		local up3=ups(3)
		
		if	up.button("mouse_left_set") or
			up.button("mouse_middle_set") or
			up.button("mouse_right_set") then it.input_mode="mouse" end

		if	up1.button("up_set") or
			up1.button("down_set") or
			up1.button("left_set") or
			up1.button("right_set") then it.input_mode="keys" end

		if	up3.button("up_set") or
			up3.button("down_set") or
			up3.button("left_set") or
			up3.button("right_set") or
			up3.button("fire_set") then it.input_mode="pad" end


		if it.input_mode=="mouse" then

			local mx=up.axis("mx") -- get mouse position, it will be nil if no mouse
			local my=up.axis("my")

			if	up.button("mouse_left_clr") and it.cursor then -- move

				local vx=it.cursor.cx-items.ids.player[0].cx
				local vy=it.cursor.cy-items.ids.player[0].cy

				local acts=entities.systems.yarn:solicit(items.ids.player,vx,vy)
				
				if acts[1] then (acts[1][2])() end -- perform action

				it.mx=nil	-- force re calculate next
				it.my=nil
				it.cursor=nil -- do not show
				
			elseif mx~=it.mx or my~=it.my then -- or show cursor on movement

				it.mx=mx
				it.my=my
				
				local dx=it.cx*16-system.components.map.ax+mx
				local dy=it.cy*16+system.components.map.az+my-16

				if     dx<it.dx then		dx=-1
				elseif dx>=it.dx+16 then 	dx=1
				else						dx=0
				end

				if     dy<it.dy then		dy=-1
				elseif dy>=it.dy+16 then 	dy=1
				else						dy=0
				end
				
				if dx~=0 and dy~=0 then
					if 0==(it.cx+it.cy)%2 then
						dy=0
					else
						dx=0
					end
				end
				
				if dx==0 and dy==0 then 
					it.cursor=nil -- do not show
				else
					it.cursor=items.ids.player[0]:get_cell_relative(dx,dy)
				end
				
			end
		
		end

		if it.input_mode=="pad" then

			local lx=up.axis("lx") -- get left joystick
			local ly=up.axis("ly")

			if	up.button("a_clr") and it.cursor then -- move

				local vx=it.cursor.cx-items.ids.player[0].cx
				local vy=it.cursor.cy-items.ids.player[0].cy

				local acts=entities.systems.yarn:solicit(items.ids.player,vx,vy)
				
				if acts[1] then (acts[1][2])() end -- perform action

				it.cursor=nil -- do not show
				
			elseif lx and ly then

				local vx,vy=0,0

				if ly<-32768/4	then vy=-1 end
				if ly>32768/4	then vy= 1 end
				if lx<-32768/4	then vx=-1 end
				if lx>32768/4	then vx= 1 end

				if vx~=0 and vy~=0 then
					if 0==(it.cx+it.cy)%2 then
						vy=0
					else
						vx=0
					end
				end
					
				if vx==0 and vy==0 then 
					it.cursor=nil -- do not show
				else
					it.cursor=items.ids.player[0]:get_cell_relative(vx,vy)
				end

			end
		
		end
		

		local vx,vy=0,0 -- check keys or dpad movement

		if up.button("pad_up_set")		then vy=-1 end
		if up.button("pad_down_set")	then vy= 1 end
		if up.button("pad_left_set")	then vx=-1 end
		if up.button("pad_right_set")	then vx= 1 end
		
		if not ( vx==0 and vy==0 ) then
--print("moving",vx,vy)
			local acts=entities.systems.yarn:solicit(items.ids.player,vx,vy)
			
			if acts[1] then
--				print(acts[1][1]) -- action name
				(acts[1][2])() -- perform action
			end

			entities.systems.yarn.cursor=nil -- do not show if we are using keys
		end
		
-- apply view

		it.cx=items.ids.player[0].cx
		it.cy=items.ids.player[0].cy
		
		it.dx=it.cx*16
		it.dy=it.cy*16

		local dxc=0
		local dyc=0
		if entities.systems.menu.active then
			dxc=(hardware.opts.hx/4-8)
			dyc=(hardware.opts.hy/2-16)
		else
			dxc=(hardware.opts.hx/2-8)
			dyc=(hardware.opts.hy/2-16)
		end
		
		it.ax=(it.ax*31+(it.dx-dxc)*1)/32
		it.ay=(it.ay*31+(it.dy-dyc)*1)/32
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

				local cell=pages.get_cell(it.cx+x,it.cy+y)
				local idx=y*48*4 + x*4
				b[idx+1]=0
				b[idx+2]=0
				b[idx+3]=31
				b[idx+4]=0
				local light=cell.illumination or 0
				for i,v in ipairs(cell) do
					if v.back then
						local tile=names[v.back]
						b[idx+1]=tile.pxt
						b[idx+2]=tile.pyt
						b[idx+3]=31
						b[idx+4]=light*255
					end
					if v.sprite then
					
						local cr,cg,cb,ca=1,1,1,1
						local flip=1
						local sprite=v.sprite
						if type(sprite)=="table" then
							flip=sprite.flip or 1
							local speed=sprite.speed or 16
							cr=sprite.color and sprite.color[1] or cr
							cg=sprite.color and sprite.color[2] or cg
							cb=sprite.color and sprite.color[3] or cb
							ca=sprite.color and sprite.color[4] or ca
							sprite=sprite[math.floor(system.ticks/speed+it.cx+x+it.cy+y)%#sprite+1]
						end

						local spr=names[sprite]
						
						local vx,vy,vz=0,0,0
						if v.anim then
							local l=v.anim.length
							local t=v.anim.time and v.anim.time-1 or v.anim.length-1
							v.anim.time=t
							if t<=0 then
								v.anim=nil
							else
								vx=t/l
								vz=t/l
								if t<=(l/2) then
									vy=t/(l/2)
								else
									vy=(l-t)/(l/2)
								end
								vx=vx*v.anim.vx
								vy=vy*-8
								vz=vz*-v.anim.vy
							end
						end
						system.components.sprites.list_add({
							t=spr.idx,
							hx=spr.hx,hy=spr.hy,ox=spr.hx/2,oy=spr.hy, -- handle on bottom centre of sprite
							px=x*16+8+vx,py=16+vy,pz=-y*16-16+vz, -- position on bottom of tile
							sx=flip,rz=0,
							color={light*cr,light*cg,light*cb,1*ca}
						})
					end
					if cell==it.cursor then -- show curosr
						local spr=names.cursor_square
						system.components.sprites.list_add({
							t=spr.idx,
							hx=spr.hx,hy=spr.hy,ox=spr.hx/2,oy=spr.hy, -- handle on bottom centre of sprite
							px=x*16+8,py=16,pz=-y*16-16, -- position on bottom of tile
							color={1/2,1/2,1/2,1/2}
						})
					end
				end
			end
		end
		g:pixels(0,0,0,48,32,1,b)
		system.components.map.dirty(true)
		
		local ax,az=0,0
		
		ax= (it.cx*16-math.floor(it.ax+0.5))
		az=-(it.cy*16-math.floor(it.ay+0.5))

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
