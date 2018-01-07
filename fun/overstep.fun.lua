
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



local prefabs={
	{name="player",id="player",sprite="test_player"},
	{name="floor",back="test_none"},
	{name="floor_tile",back="test_tile"},
	{name="wall_full",back="test_wall2",is_big=true,},
	{name="wall_half",back="test_wall1",is_big=true,},
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
	[   0]={ items={"floor"},				},
	[". "]={ items={"floor"}				},
	["x "]={ items={"floor_tile"}			},
	["# "]={ items={"wall_full"}			},
	["= "]={ items={"wall_half"}			},
	["S "]={ items={"floor_tile","player"}		},
}
	
levels={}

levels[1]={
name="page_zero",
legend=combine_legends(default_legend,{
}),
title="This is a test.",
map=[[
. . . . . . . . . . . . . . . . x . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . x . x . . . . . . . . . . . . . . 
x . . . . . . . . . . . . . x . . . x . . . . . . . . . . . . . 
. x . . . . . . . . . . . x . . . . . x . . . . . . . . . . . . 
. . x . . . . . . . . . x . . . . . . . . . . . . . . . . . . . 
. . . x . . . . . . . x . . . . . . . . . . . . . . . . . . . . 
. . . . x x x x x x x . . . . . . . . . . . . . . . . . . . . . 
. . . . x = = = = = x . . . . . . . . . . . . . . . . . . . . . 
. . . . x # x x x # x . . . . . . . . . . . . . . . . . . . . . 
. . . . x # x x x # x . . . . . . . . . . . . . . . . . . x . x 
. . . . x # x x S # x . . . . . . . . . . . . . . . . . . . . . 
. . . . x # = x = # x . . . . . . . . . . . . . . . . . . . . . 
. . . . x x x x x x x . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . S . . . . . . . . . . . . . . . . . . . . . . . . 
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

	setup=function()

		local names=system.components.tiles.names

	-- a player entity
		local test_entity=entities.add{	caste="player",
		
			tile=names.test_player.idx,
			px=160,py=0,pz=0,sz=1,rz=0,
			update=function(it)
				local up=ups(0) -- get all connected controls, keyboard or gamepad

				if up.button("fire") then
					if up.button("up")    then it.sz=it.sz-(1/16) end
					if up.button("down")  then it.sz=it.sz+(1/16) end
					if up.button("left")  then it.rz=it.rz-1 end
					if up.button("right") then it.rz=it.rz+1 end
				else
					if up.button("up")    then it.pz=it.pz+1 end
					if up.button("down")  then it.pz=it.pz-1 end
					if up.button("left")  then it.px=it.px-1 end
					if up.button("right") then it.px=it.px+1 end
				end
				
			end,
			draw=function(it)
				system.components.sprites.list_add({t=it.tile,hx=16,hy=32,px=it.px,py=it.py,pz=it.pz,s=it.sz,rz=it.rz})
			end,
		}

	end,

}

entities.systems.insert{ caste="yarn",

	setup=function(it)

		it.items=require("wetgenes.gamecake.fun.yarn.items").create()
		
		for i,v in ipairs(levels)  do it.items.prefabs.set(v) end
		for i,v in ipairs(prefabs) do it.items.prefabs.set(v) end
		
		it.items.create_pages()

	end,
	
	draw=function(it)
	
		local names=system.components.tiles.names
		local g=system.components.map.tilemap_grd

		local items=it.items
		local pages=items.pages
		
		
		local b={}
		for y=0,31 do
			for x=0,31 do
				local cell=pages.get_cell(0x8000*32+x,0x8000*32+y)
--				local back=cell:find("back")
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
						b[idx+4]=0
					end
					if v.sprite then

						system.components.sprites.list_add({
							t=names[v.sprite].idx,
							hx=16,hy=32,ox=8,oy=16,
							px=x*16+8,py=0,pz=-y*16-16,
							s=1,rz=0
						})

					end
				end
			end
		end
		g:pixels(0,0,0,32,32,1,b)
		system.components.map.dirty(true)
	
	end,

}

-- finally load all graphics from systems defined above
entities.systems.call("loads")
