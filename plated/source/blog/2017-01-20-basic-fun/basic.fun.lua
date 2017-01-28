
local bit=require("bit")
local wstr=require("wetgenes.string")
local wgrd=require("wetgenes.grd")
local tardis=require("wetgenes.tardis")	-- matrix/vector math

local bitdown=require("wetgenes.gamecake.fun.bitdown")
local bitdown_font_4x8=require("wetgenes.gamecake.fun.bitdown_font_4x8")

local ls=function(...) print(wstr.dump(...)) end

local fatpix=not(args and args.pixel or false) -- pass --pixel on command line to turn off fat pixel filters

--request this hardware setup !The components will not exist until after main has been called!
cmap=bitdown.cmap -- use default swanky32 colors
screen={hx=128,hy=128,ss=4,fps=60}
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
	{
		component="tilemap",
		name="text",
		tiles="tiles",
		tile_size={4,8}, -- use half width tiles for font
		tilemap_size={math.ceil(screen.hx/4),math.ceil(screen.hy/8)},
		layer=1,
	},
}


-- this is the main function, code below called repeatedly to update and draw or handle other messages (eg mouse)

function main(need)

	if not need.setup then need=coroutine.yield() end -- wait for setup request (should always be first call)

-- copy font data tiles into top line of tiles
	system.components.tiles.bitmap_grd:pixels(0,0,128*4,8, bitdown_font_4x8.grd_mask:pixels(0,0,128*4,8,"") )

-- after setup we should yield and then perform updates only if requested from a yield
	local done=false while not done do
		need=coroutine.yield()
		if need.update then

			system.components.text.text_clear(0x00000000) -- clear all text

			system.components.text.text_print("Hello World!",4,2,31,0) -- (text,x,y,color,background)

			system.components.text.dirty(true) -- request screen update
	
		end
		if need.draw then

		end
		if need.clean then done=true end -- cleanup requested
	end

-- perform cleanup here

end

