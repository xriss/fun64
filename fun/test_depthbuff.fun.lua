
local bitdown=require("wetgenes.gamecake.fun.bitdown")
local chatdown=require("wetgenes.gamecake.fun.chatdown")
local wstr=require("wetgenes.string")
function ls(s) print(wstr.dump(s))end

hardware,main=system.configurator({
	mode="fun64", -- select the standard 320x240 screen using the swanky32 palette.
	update=function() -- called at a steady 60fps
		if setup then setup() setup=nil end -- call an optional setup function *once*
		update()
	end,
	draw=function() -- called at actual display frame rate
		draw()
	end,
})


setup=function()

		system.components.tiles.upload_tiles{

{nil,"test_box1",[[
7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 
7 . . . . . . . . . . . . . . 7 
7 . . . . . . . . . . . . . . 7 
7 . . . . . . . . . . . . . . 7 
7 . . . . . . . . . . . . . . 7 
7 . . . . . . . . . . . . . . 7 
7 . . . . . . . . . . . . . . 7 
7 . . . . . . . . . . . . . . 7 
7 . . . . . . . . . . . . . . 7 
7 . . . . . . . . . . . . . . 7 
7 . . . . . . . . . . . . . . 7 
7 . . . . . . . . . . . . . . 7 
7 . . . . . . . . . . . . . . 7 
7 . . . . . . . . . . . . . . 7 
7 . . . . . . . . . . . . . . 7 
7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 
]]},

{nil,"test_box2",[[
G G G G G G G G G G G G G G G G 
G G G G G G G G G G G G G G G G 
G G G G G G G G G G G G G G G G 
G G G G G G G G G G G G G G G G 
G G G G G G G G G G G G G G G G 
G G G G G G G G G G G G G G G G 
G G G G G G G G G G G G G G G G 
G G G G G G G G G G G G G G G G 
G G G G G G G G G G G G G G G G 
G G G G G G G G G G G G G G G G 
G G G G G G G G G G G G G G G G 
G G G G G G G G G G G G G G G G 
G G G G G G G G G G G G G G G G 
G G G G G G G G G G G G G G G G 
G G G G G G G G G G G G G G G G 
G G G G G G G G G G G G G G G G 
]]},

{nil,"test_box3",[[
R R R R R R R R R R R R R R R R 
R R R R R R R R R R R R R R R R 
R R R R R R R R R R R R R R R R 
R R R R R R R R R R R R R R R R 
R R R R R R R R R R R R R R R R 
R R R R R R R R R R R R R R R R 
R R R R R R R R R R R R R R R R 
R R R R R R R R R R R R R R R R 
R R R R R R R R R R R R R R R R 
R R R R R R R R R R R R R R R R 
R R R R R R R R R R R R R R R R 
R R R R R R R R R R R R R R R R 
R R R R R R R R R R R R R R R R 
R R R R R R R R R R R R R R R R 
R R R R R R R R R R R R R R R R 
R R R R R R R R R R R R R R R R 
]]},

}

end


local tu=0

update=function()
	tu=tu+1/64
	if tu>16 then tu=0 end
end


draw=function()


	local names=system.components.tiles.names
	local g=system.components.map.tilemap_grd

	local px,py,pz=100+tu,100+tu,100+tu
	local spr=names["test_box3"]
	system.components.sprites.list_add({
		t=spr.idx,
		hx=spr.hx,hy=spr.hy,ox=spr.hx/2,oy=spr.hy,
		px=px,py=py,pz=pz,
		color={1,1,1,1}
	})

	local px,py,pz=108,108,108
	local spr=names["test_box2"]
	system.components.sprites.list_add({
		t=spr.idx,
		hx=spr.hx,hy=spr.hy,ox=spr.hx/2,oy=spr.hy,
		px=px,py=py,pz=pz,
		color={1,1,1,1}
	})

end
