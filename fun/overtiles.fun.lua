
local bitdown=require("wetgenes.gamecake.fun.bitdown")
local wstr=require("wetgenes.string")
function ls(s) print(wstr.dump(s))end

hardware,main=system.configurator({
	mode="fun64", -- select the standard 320x240 screen using the swanky32 palette.
	graphics=function() return graphics end,
	update=function() update() end, -- called repeatedly to update+draw
})

local tilemap=hardware.map
for i,v in pairs(tilemap) do tilemap[i]=nil end -- remove
tilemap.component="overmap"
tilemap.name="map"
tilemap.tiles="tiles"
tilemap.tilemap_size={128,128}
tilemap.tile_size={24,24,16}
tilemap.over_size={8,16}
tilemap.sort={-1,-1}
tilemap.mode="xz"
tilemap.layer=2

hardware.screen.zxy={0.5,-0.5}

-- debug text dump
local ls=function(t) print(require("wetgenes.string").dump(t)) end


-- define all graphics in this global, we will convert and upload to tiles at setup
-- although you can change tiles during a game, we try and only upload graphics
-- during initial setup so we have a nice looking sprite sheet to be edited by artists

graphics={
{0x0000,"_font",0x0340}, -- pre-allocate the 4x8 and 8x8 font area

{nil,"test_empty",[[
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
]]},

{nil,"test_blue",[[
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . B B B B B B B B b b b b b b b b I 
. . . . . . B B B B B B B B b b b b b b b b I I 
. . . . . B B B B B B B B b b b b b b b b I I I 
. . . . B B B B B B B B b b b b b b b b I I I I 
. . . b b b b b b b b B B B B B B B B b I I I I 
. . b b b b b b b b B B B B B B B B b b I I I I 
. b b b b b b b b B B B B B B B B b b b I I I I 
b b b b b b b b B B B B B B B B b b b b I I I I 
B B B B B B B B c c c c c c c c b b b b I I I . 
B B B B B B B B c c c c c c c c b b b b I I . . 
B B B B B B B B c c c c c c c c b b b b I . . . 
B B B B B B B B c c c c c c c c b b b b . . . . 
B B B B B B B B c c c c c c c c b b b . . . . . 
B B B B B B B B c c c c c c c c b b . . . . . . 
B B B B B B B B c c c c c c c c b . . . . . . . 
B B B B B B B B c c c c c c c c . . . . . . . . 
]]},

{nil,"test_orange",[[
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . O O O O O O O O r r r r r r r r R 
. . . . . . O O O O O O O O r r r r r r r r R R 
. . . . . O O O O O O O O r r r r r r r r R R R 
. . . . O O O O O O O O r r r r r r r r R R R R 
. . . r r r r r r r r O O O O O O O O r R R R R 
. . r r r r r r r r O O O O O O O O r r R R R R 
. r r r r r r r r O O O O O O O O r r r R R R R 
r r r r r r r r O O O O O O O O r r r r R R R R 
O O O O O O O O o o o o o o o o r r r r R R R . 
O O O O O O O O o o o o o o o o r r r r R R . . 
O O O O O O O O o o o o o o o o r r r r R . . . 
O O O O O O O O o o o o o o o o r r r r . . . . 
O O O O O O O O o o o o o o o o r r r . . . . . 
O O O O O O O O o o o o o o o o r r . . . . . . 
O O O O O O O O o o o o o o o o r . . . . . . . 
O O O O O O O O o o o o o o o o . . . . . . . . 
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
	[   0]={ name="test_empty",				},
	[". "]={ name="test_empty",				},
	["1 "]={ name="test_blue",				},
	["2 "]={ name="test_orange",			},
}
	
levels={}

levels[1]={
legend=combine_legends(default_legend,{
}),
title="This is a test.",
map=[[
1 1 2 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
1 . 2 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. 1 2 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . 2 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . 1 2 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . 1 2 1 2 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . 1 2 1 2 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . 2 1 2 1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . 2 1 2 1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . 1 2 1 2 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . 1 2 1 2 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . 2 1 2 1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . 2 1 2 1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . 2 1 2 1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
]],
}



-----------------------------------------------------------------------------
--[[#update

	update()

Update and draw loop, called every frame.

]]
-----------------------------------------------------------------------------
update=function()

	local ccopper=system.components.copper
	local cmap=system.components.back

	if not setup_done then

--		ccopper.shader_name="fun_copper_noise"		
--		ccopper.shader_uniforms.scroll={0,0,0,0}

		it={}
		it.vx=0.25
		it.vy=1

		local names=system.components.tiles.names
		local legend={}
		for n,v in pairs( levels[1].legend ) do -- build tilemap from legend
			if v.name then -- convert name to tile
				legend[n]=names[v.name]
			end
		end
		bitdown.tile_grd( levels[1].map, legend, system.components.map.tilemap_grd, -- draw into the screen (tiles)
			nil,nil,nil,nil,function(tile,rx,ry)
			return	tile.pxt+(math.floor(rx/3)%(tile.hxt/3)) ,
					tile.pyt+(math.floor(ry/3)%(tile.hyt/3)) ,
					31 ,
					0
		end)
		system.components.map.dirty(true)
		setup_done=true
	end

	local up=ups(0) -- get all connected controls, keyboard or gamepad

	if up.button("up")    then it.vy=it.vy-(1/16) end
	if up.button("down")  then it.vy=it.vy+(1/16) end
	if up.button("left")  then it.vx=it.vx+(1/16) end
	if up.button("right") then it.vx=it.vx-(1/16) end
	if up.button("fire_set") then it.vx=0 it.vy=0 end


--	ccopper.shader_uniforms.scroll[1]=ccopper.shader_uniforms.scroll[1]+it.vx
--	ccopper.shader_uniforms.scroll[2]=ccopper.shader_uniforms.scroll[2]+it.vy
	
    local tx=wstr.trim([[

Use up/down/left/right to adjust the speed of the scrolling star field. 
Hit fire to reset the momentum.

]])

    local tl=wstr.smart_wrap(tx,cmap.text_hx-4)
    for i=1,#tl do
	    local t=tl[i]
	    cmap.text_print(t,2,1+i,28,0)
    end
    cmap.dirty(true)



end

