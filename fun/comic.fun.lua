
local bit=require("bit")
local wstr=require("wetgenes.string")
local wgrd=require("wetgenes.grd")
local tardis=require("wetgenes.tardis")	-- matrix/vector math

local bitdown=require("wetgenes.gamecake.fun.bitdown")
local bitdown_font_4x8=require("wetgenes.gamecake.fun.bitdown_font_4x8")

local chipmunk=require("wetgenes.chipmunk")

local ls=function(...) print(wstr.dump(...)) end

local fatpix=not(args and args.pixel or false) -- pass --pixel on command line to turn off fat pixel filters

--request this hardware setup !The components will not exist until after main has been called!
cmap=bitdown.cmap -- use default swanky32 colors
screen={hx=368,hy=128,ss=4,fps=60}
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
			{ }, -- background
			{ clip={8  ,8,112,112} }, -- panel 1
			{ clip={128,8,112,112} }, -- panel 2
			{ clip={244,8,112,112} }, -- panel 3
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
		bitmap_size={64,16},
	},
	{
		component="tilemap",
		name="map",
		tiles="tiles",
		tilemap_size={math.ceil(screen.hx/8),math.ceil(screen.hy/8)},
		layer=1,
	},
	{
		component="sprites",
		name="sprites1",
		tiles="tiles",
		layer=2,
	},
	{
		component="sprites",
		name="sprites2",
		tiles="tiles",
		layer=3,
	},
	{
		component="sprites",
		name="sprites3",
		tiles="tiles",
		layer=4,
	},
	{
		component="tilemap",
		name="text",
		tiles="tiles",
		tile_size={4,8}, -- use half width tiles for font
		tilemap_size={math.ceil(screen.hx/4),math.ceil(screen.hy/8)},
		layer=5,
	},
}


-- define all graphics in this global, we will convert and upload to tiles at setup
-- although you can change tiles during a game, we try and only upload graphics
-- during initial setup so we have a nice looking sprite sheet to be edited by artists

graphics={
{0x0100,"char_empty",[[
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
]]},
{0x0101,"char_black",[[
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
]]},
{0x0102,"char_darkgrey",[[
1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 
]]},
{0x0103,"char_grey",[[
4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 
4 4 4 4 4 4 4 4 
]]},
{0x0104,"char_white",[[
7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 
]]},
{0x0105,"char_dot",[[
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . 7 7 . . . 
. . . 7 7 . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
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
	[0]={ name="char_empty",	},

	[". "]={ name="char_darkgrey",				cell={0,0,0,0}, },
	["0 "]={ name="char_black",				solid=1, dense=1, cell={0,0,0,1}, },		-- empty border
	["4 "]={ name="char_grey",				solid=1, dense=1, cell={0,0,0,1}, },		-- empty border
	["7 "]={ name="char_white",				solid=1, dense=1, cell={0,0,0,1}, },		-- empty border

}
	
levels={}
levels[0]={
legend=combine_legends(default_legend,{
}),
title="This is a test",
map=[[
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 . . . . . . . . . . . . . . 0 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
]],
}


-- handle tables of entities that need to be updated and drawn.

local entities -- a place to store everything that needs to be updated
local entities_info -- a place to store options or values
local entities_reset=function()
	entities={}
	entities_info={}
end
-- get items for the given caste
local entities_items=function(caste)
	caste=caste or "generic"
	if not entities[caste] then entities[caste]={} end -- create on use
	return entities[caste]
end
-- add an item to this caste
local entities_add=function(it,caste)
	caste=caste or it.caste -- probably from item
	caste=caste or "generic"
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
local entities_get=function(name)       return entities_info[name]							end
local entities_set=function(name,value)        entities_info[name]=value	return value	end
local entities_manifest=function(name)
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

	local space=entities_set("space", chipmunk.space() )
	
	space:gravity(0,700)
	space:damping(0.5)
	space:sleep_time_threshold(1)
	space:idle_speed_threshold(10)

	return space
end


function setup_level(idx)

	local level=entities_set("level",entities_add{})

	local names=system.components.tiles.names

	level.updates={} -- tiles to update (animate)
	level.update=function()
		for v,b in pairs(level.updates) do -- update these things
			if v.update then v:update() end
		end
	end

-- init map and space

	local space=setup_space()

	for n,v in pairs( levels[idx].legend ) do -- fixup missing values (this will slightly change your legend data)
		if v.name then -- convert name to tile idx
			v.idx=names[v.name].idx
		end
		if v.idx then -- convert idx to r,g,b,a
			v[1]=(          (v.idx    )%256)
			v[2]=(math.floor(v.idx/256)%256)
			v[3]=31
			v[4]=0
		end
	end

	local map=entities_set("map", bitdown.pix_tiles(  levels[idx].map,  levels[idx].legend ) )
	
	level.title=levels[idx].title

	bitdown.pix_grd(    levels[idx].map,  levels[idx].legend,      system.components.map.tilemap_grd  ) -- draw into the screen (tiles)

	bitdown.map_build_collision_strips(map,function(tile)
		if tile.coll then -- can break the collision types up some more by appending a code to this setting
			if tile.collapse then -- make unique
				tile.coll=tile.coll..tile.idx
			end
		end
	end)

	for y,line in pairs(map) do
		for x,tile in pairs(line) do
			local shape
			if tile.solid and (not tile.parent) then -- if we have no parent then we are the master tile
			
				local l=1
				local t=tile
				while t.child do t=t.child l=l+1 end -- count length of strip

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
			end

			tile.map=map -- remember map
			tile.level=level -- remember level
			if shape then -- link shape and tile
				shape.tile=tile
				tile.shape=shape
			end
		end
	end


	for y,line in pairs(map) do
		for x,tile in pairs(line) do
		end
	end

	
end

-- create a fat controller coroutine that handles state changes, fills in entities etc etc etc

local fat_controller=coroutine.create(function()

-- copy font data tiles into top line
	system.components.tiles.bitmap_grd:pixels(0,0,128*4,8, bitdown_font_4x8.grd_mask:pixels(0,0,128*4,8,"") )

-- upload graphics
	system.components.tiles.upload_tiles( graphics )

-- setup background


-- setup game
	entities_reset()

	setup_level(0) -- load map


-- update loop

	local ticks=0

	while true do coroutine.yield()
	
		ticks=ticks+1
	
		entities_call("update")
		entities_get("space"):step(1/screen.fps)

		-- run all the callbacks created by collisions 
		for _,f in pairs(entities_manifest("callbacks")) do f() end
		entities_set("callbacks",{}) -- and reset the list
		
		local letters=math.floor(ticks/4)

		local speach=function(tab,x,y,w)
			local tprint=system.components.text.text_print
			for idx,it in ipairs(tab) do
				if letters<=0 then break end -- no more to draw
				local ls=wstr.smart_wrap(it,w or 27)
				for i=1,#ls do local s=ls[i]
					if letters<=0 then break end -- no more to draw
					if #s > letters then
						s=s:sub(1,letters)
					end
					if idx%2==1 then
						tprint(s,x,y,31,0)
					else
						tprint(s,x+28-#ls[i],y,31-2,0)
					end
					y=y+1
					if #s==0 then
						letters=letters-8
					else
						letters=letters-#s
					end
				end
			end
		end


		speach({[[
I think we may have just released another game.

]],[[
Well, you know what they say...

]],},2,1)

		speach({[[
Uhm, "What doesn't kill you slowly chips away at your soul until you willingly embrace the sweet release of death."?

]]},32,1)


		speach({"",[[
No!

Not those voices!

]]},62,1)

	system.components.text.dirty(true)

	end


end)


-- this is the main function, code below called repeatedly to update and draw or handle other messages (eg mouse)

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
			entities_call("draw") -- because we are going to add them all in again here
		end
		if need.clean then done=true end -- cleanup requested
	end

-- perform cleanup here

end