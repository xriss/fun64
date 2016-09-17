
local wstr=require("wetgenes.string")
local wgrd=require("wetgenes.grd")
local tardis=require("wetgenes.tardis")	-- matrix/vector math

local bitdown=require("wetgenes.gamecake.fun.bitdown")
local bitdown_font_4x8=require("wetgenes.gamecake.fun.bitdown_font_4x8")

local bitsynth=require("wetgenes.gamecake.fun.bitsynth")


local hx,hy,ss=360,240,3

--request this hardware setup before calling main
hardware={
	{
		component="screen",
		size={hx,hy},
		bloom=0.75,
		filter="scanline",
		scale=ss,
		fps=60,
	},
	{
		component="sfx",
	},
	{
		component="tiles",
		name="tiles",
		tile_size={8,8},
		bitmap_size={16,16},
	},
	{
		component="tiles",
		name="font",
		tile_size={4,8},
		bitmap_size={128,1},
	},
	{
		component="copper",
		name="copper",
		size={hx,hy},
	},
	{
		component="tilemap",
		name="map",
		tiles="tiles",
		tilemap_size={math.ceil(hx/8),math.ceil(hy/8)},
	},
	{
		component="sprites",
		name="sprites",
		tiles="tiles",
	},
	{
		component="tilemap",
		name="text",
		tiles="font",
		tilemap_size={math.ceil(hx/4),math.ceil(hy/8)},
	},
}


local tiles={}
local maps={}

local tilemap={
	[0]={0,0,0,0},

	[". "]={  0,  0,  0,  0},
	["1 "]={  1,  0,  0,  0},
	["2 "]={  2,  0,  0,  0},
	["3 "]={  3,  0,  0,  0},
	["4 "]={  4,  0,  0,  0},
	["5 "]={  5,  0,  0,  0},
	["6 "]={  6,  0,  0,  0},
	["7 "]={  7,  0,  0,  0},
	["8 "]={  8,  0,  0,  0},
	["9 "]={  9,  0,  0,  0},
	["A "]={ 10,  0,  0,  0},
	["B "]={ 11,  0,  0,  0},
	["C "]={ 12,  0,  0,  0},
	["D "]={ 13,  0,  0,  0},
	["E "]={ 14,  0,  0,  0},
	["F "]={ 15,  0,  0,  0},
}


tiles[0x0000]=[[
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
]]
tiles[0x0001]=[[
1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 
]]
tiles[0x0002]=[[
2 2 2 2 2 2 2 2 
2 2 2 2 2 2 2 2 
2 2 2 2 2 2 2 2 
2 2 2 2 2 2 2 2 
2 2 2 2 2 2 2 2 
2 2 2 2 2 2 2 2 
2 2 2 2 2 2 2 2 
2 2 2 2 2 2 2 2 
]]
tiles[0x0003]=[[
7 7 7 7 7 7 7 7 
7 0 0 0 0 0 0 7 
7 0 0 0 0 0 0 7 
7 0 0 0 0 0 0 7 
7 0 0 0 0 0 0 7 
7 0 0 0 0 0 0 7 
7 0 0 0 0 0 0 7 
7 7 7 7 7 7 7 7 
]]

tiles[0x0100]=[[
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
]]

maps[0]=[[
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . 1 . . . . . 3 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . 1 1 . . . . . 1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  
. 1 . . 1 1 . . . . 1 1 1 . . . . . 1 . . . . . . . . . . . . . . . . . . . . . . . . . .  
. 1 . . 1 1 . . . 1 1 2 1 1 . . . . 1 1 . . . . . . . . . . . . . . . . . . . . . . . . .  
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
]]



function main(need)

	if not need.setup then need=coroutine.yield() end -- wait for setup request (should always be first call)

-- cache components in locals for less typing
	local ctiles   = system.components.tiles
	local cfont    = system.components.font
	local ccopper  = system.components.copper
	local cmap     = system.components.map
	local csprites = system.components.sprites
	local ctext    = system.components.text
	local csfx     = system.components.sfx

-- render sound effects

	csfx.render(bitsynth.sound.simple_fm({
		name="beep1",
		fwav="square",
		frequency="C4",
		adsr={ 0.50 , 0.00 , 0.50 , 0.50 , 0.50 },
		fm={
			fwav="square",
			frequency=8,
			frange=function(v,t) return bitsynth.note2freq("C3")+v*10+t*100 end,
		},
	}))

-- test the noise
	csfx.play("beep1",1,1)

--	ccopper.shader_name="fun_copper_back_noise"


-- copy font data
	cfont.bitmap_grd:pixels(0,0,128*4,8, bitdown_font_4x8.grd_mask )

-- copy image data
	bitdown.pixtab_tiles( tiles,    bitdown.cmap, ctiles   )

-- screen
	bitdown.pix_grd(    maps[0],  tilemap,      cmap.tilemap_grd  )--,0,0,48,32)
	
-- test text
	local tx=[[
Fun is the enjoyment of pleasure, particularly in leisure activities. Fun is an experience - short-term, often unexpected, informal, not cerebral and generally purposeless. It is an enjoyable distraction, diverting the mind and body from any serious task or contributing an extra dimension to it. Although particularly associated with recreation and play, fun may be encountered during work, social functions, and even seemingly mundane activities of daily living. It may often have little to no logical basis, and opinions on whether or not an activity is fun may differ. A distinction between enjoyment and fun is difficult but possible to articulate, fun being a more spontaneous, playful, or active event. There are psychological and physiological implications to the experience of fun.]]
	local tl=wstr.smart_wrap(tx,ctext.text_hx)
	for i=0,ctext.tilemap_hy-1 do
		local t=tl[i+1]
		if not t then break end
		ctext.text_print(t,0,i)
	end

-- after setup we should yield and then perform updates only if requested from yield
	local done=false while not done do
		need=coroutine.yield()
		if need.update then

			ctext.px=(ctext.px+1)%360 -- scroll text position
			
			csprites.list_reset()
			csprites.list_add({t=0x0100,h=24,px=100,py=100,rz=ctext.px})

		end
		if need.clean then done=true end -- cleanup requested
	end

-- perform cleanup here


end
