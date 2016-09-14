
local bit=require("bit")
local wstr=require("wetgenes.string")
local wgrd=require("wetgenes.grd")
local tardis=require("wetgenes.tardis")	-- matrix/vector math

local bitdown=require("wetgenes.gamecake.fun.bitdown")
local bitdown_font_4x8=require("wetgenes.gamecake.fun.bitdown_font_4x8")

local chipmunk=require("wetgenes.chipmunk")


local hx,hy,ss=424,240,3

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
	["1 "]={  1,  0,  0,  0,	solid=1},
	["2 "]={  2,  0,  0,  0,	solid=1},
	["3 "]={  3,  0,  0,  0,	solid=0},
	["4 "]={  4,  0,  0,  0,	solid=1},
	["5 "]={  5,  0,  0,  0,	solid=1},
	["6 "]={  6,  0,  0,  0,	solid=1},
	["7 "]={  7,  0,  0,  0,	solid=1},
	["8 "]={  8,  0,  0,  0,	solid=1},
	["9 "]={  9,  0,  0,  0,	solid=1},
	["A "]={ 10,  0,  0,  0,	solid=1},
	["B "]={ 11,  0,  0,  0,	solid=1},
	["C "]={ 12,  0,  0,  0,	solid=1},
	["D "]={ 13,  0,  0,  0,	solid=1},
	["E "]={ 14,  0,  0,  0,	solid=1},
	["F "]={ 15,  0,  0,  0,	solid=1},
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
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 1 1 1 1 1 1 1 1 1 1 1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . . 1 . . . . . 1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 
1 . . . 1 1 . . . . . 1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1  
1 1 . . 1 1 . . . . 1 1 1 . . . . . 1 . . . . . . . . . . . . 1 . . . . . . . . . . . . . . . . . . . . 1  
1 1 . . 1 1 . . . 1 1 2 1 1 . . . . 1 1 . . . . . . . . . . . 1 . . . . . . . . . . . . . . . . . . . . 1 
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ]]



function main(need)

	if not need.setup then need=coroutine.yield() end -- wait for setup request (should always be first call)


-- cache components in locals for less typing
	local ctiles   = system.components.tiles
	local cfont    = system.components.font
	local ccopper  = system.components.copper
	local cmap     = system.components.map
	local csprites = system.components.sprites
	local ctext    = system.components.text

--	ccopper.shader_name="fun_copper_back_noise"


-- copy font data
	cfont.bitmap_grd:pixels(0,0,128*4,8, bitdown_font_4x8.grd_mask:pixels(0,0,128*4,8,"") )

-- copy image data
	bitdown.pixtab_tiles( tiles,    bitdown.cmap, ctiles   )

-- screen
	bitdown.pix_grd(    maps[0],  tilemap,      cmap.tilemap_grd  )--,0,0,48,32)

-- map for collision etc
	local map=bitdown.pix_tiles(  maps[0],  tilemap )
			
	local space=chipmunk.space()
	space:gravity(0,240)
	
	local tile_is_sold=function(x,y)
		local l=map[y] if not l then return false end
		local c=l[x] if not c then return false end
		if c.solid then return true end
		return false
	end
	
	for y,line in pairs(map) do
		for x,tile in pairs(line) do

			if tile.solid then
				local flags=0
				if tile_is_sold(x-1,y) then flags=flags+1 end
				if tile_is_sold(x,y-1) then flags=flags+2 end
				if tile_is_sold(x+1,y) then flags=flags+4 end
				if tile_is_sold(x,y+1) then flags=flags+8 end

				if flags~=15 then -- ignore enclosed solids
					local box={ x*8,y*8,(x+1)*8,(y+1)*8 }
					if bit.band(flags,5)==0 then -- extend up/down only if there are no horizontal extensions
						if bit.band(flags,2)==1 then box[2]=box[2]-8 end
						if bit.band(flags,8)==4 then box[4]=box[4]+8 end
					else
						if bit.band(flags,1)==1 then box[1]=box[1]-8 end
						if bit.band(flags,4)==4 then box[3]=box[3]+8 end
					end
					local shape=space.static:shape("box",box[1],box[2],box[3],box[4],1)
					shape:friction(tile.solid)
					shape:elasticity(tile.solid)
				end
			end

		end
	end
	
	local players={}
	local players_colors={30,14,18,7,3,22}
	
	for i=1,6 do
		local p={}
		players[i]=p
		p.idx=i
		
		local t=bitdown.map[ players_colors[i] ]
		p.color={}
		p.color.r=t[1]/255
		p.color.g=t[2]/255
		p.color.b=t[3]/255
		p.color.a=t[4]/255

		p.join=function()
			
			p.active=true
			p.body=space:body(1,1)
			p.body:position(50+i,100)

--			p.shape=p.body:shape("circle",12,0,0)
			p.shape=p.body:shape("box",-8,-10,8,9,1)
			p.shape:friction(0.25)
			p.shape:elasticity(0.25)
		end
	end
	
-- after setup we should yield and then perform updates only if requested from yield
	local done=false while not done do
		need=coroutine.yield()
		if need.update then
		
			for _,p in ipairs(players) do
				local up=ups(p.idx) -- controls
				
				if not p.active then
					if up.button("up") or up.button("down") or up.button("left") or up.button("right") or up.button("fire") then
						p:join()
					end
				end
				
				if p.active then
					if up.button("up")  then

						local vx,vy=p.body:velocity()
						vy=vy-8
						p.body:velocity(vx,vy)

					end
					if up.button("down")  then

						local vx,vy=p.body:velocity()
						vy=vy+8
						p.body:velocity(vx,vy)

					end
					if up.button("left") then
						
						local vx,vy=p.body:velocity()
						vx=vx-8
						p.body:velocity(vx,vy)
						
					end
					if up.button("right") then

						local vx,vy=p.body:velocity()
						vx=vx+8
						p.body:velocity(vx,vy)

					end
				end
			end
			
			space:step(1/60)

--			ctext.px=(ctext.px+1)%360 -- scroll text position
			
		end
		if need.draw then
			csprites.list_reset()
			for _,p in ipairs(players) do
				if p.active then
					local px,py=p.body:position()
					local rz=p.body:angle()
					csprites.list_add({t=0x0100,h=24,px=px,py=py,rz=180*rz/math.pi,r=p.color.r,g=p.color.g,b=p.color.b,a=p.color.a})
				end
			end
		end
		if need.clean then done=true end -- cleanup requested
	end

-- perform cleanup here


end
