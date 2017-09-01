
local chatdown=require("wetgenes.gamecake.fun.chatdown")	-- conversation trees
local bitdown=require("wetgenes.gamecake.fun.bitdown")		-- ascii to bitmap
local chipmunk=require("wetgenes.chipmunk")					-- 2d physics https://chipmunk-physics.net/


-----------------------------------------------------------------------------
--[[#hardware

select the hardware we will need to run this code, eg layers of 
graphics, colors to use, sprites, text, sound, etc etc.

Here we have chosen the default 320x240 setup.

This also provides a default main function that will upload the 
graphics and call the provided update/draw callbacks.

]]
-----------------------------------------------------------------------------
hardware,main=system.configurator({
	mode="fun64", -- select the standard 320x240 screen using the swanky32 palette.
	graphics=function() -- use a function to return a value created later
		return graphics
	end,
	update=function() -- called at a steady 60fps
		if setup then setup() setup=nil end -- call an optional setup function *once*
		entities.call("update")
		local space=entities.get("space")
		if space then -- update space
			space:step(1/(60*2)) -- double step for increased stability, allows faster velocities.
			space:step(1/(60*2))
		end
		local cb=entities.get("callbacks") or {} -- get callback list 
		entities.set("callbacks",{}) -- and reset it
		for _,f in pairs(cb) do f() end
	end,
	draw=function() -- called at actual display frame rate
		entities.call("draw")
	end,
})

-----------------------------------------------------------------------------
--[[#graphics


define all graphics in this global, we will convert and upload to tiles 
at setup although you can change tiles during a game, we try and only 
upload graphics during initial setup so we have a nice looking sprite 
sheet to be edited by artists

]]
-----------------------------------------------------------------------------
graphics={
{0x0000,"_font",0x0340}, -- preserve the 4x8 and 8x8 font area 64x3 tiles
}

-- load a single sprite
graphics.load=function(idx,name,data)
	local found
	for i,v in ipairs(graphics) do
		if v[2]==name then
			found=v
			break
		end
	end
	if not found then -- add new graphics
		graphics[#graphics+1]={idx,name,data}
	else
		found[1]=idx
		found[2]=name
		found[3]=data
	end
end	

-- load a list of sprites
graphics.loads=function(tab)
	for i,v in ipairs(tab) do
		graphics.load(v[1],v[2],v[3])
	end
end

-----------------------------------------------------------------------------
--[[#entities


	entities.reset()
	
empty the list of entites to update and draw


	entities.caste(caste)

get the list of entities of a given caste, eg "bullets" or "enemies"


	entities.add(it,caste)
	entities.add(it)

add a new entity of caste or it.caste if caste it missing to the list 
of things to update 


	entities.call(fname,...)

for every entity call the function named fname like so it[fname](it,...)


	entities.get(name)

get a value previously saved, this is an easy way to find a unique 
entity, eg the global space but it can be used to save any values you 
wish not just to bookmark unique entities.


	entities.set(name,value)

save a value by a unique name


	entities.manifest(name,value)

get a value previously saved, or initalize it to the given value if it 
does not already exist. The default value is {} as this is intended for 
lists.


]]
-----------------------------------------------------------------------------
entities={} -- a place to store everything that needs to be updated

-- clear the current data
entities.reset=function()
	entities.data={}
	entities.info={}
end

-- get items for the given caste
entities.caste=function(caste)
	caste=caste or "generic"
	if not entities.data[caste] then entities.data[caste]={} end -- create on use
	return entities.data[caste]
end

-- add an item to this caste
entities.add=function(it,caste)
	caste=caste or it.caste -- probably from item
	caste=caste or "generic"
	local items=entities.caste(caste)
	items[ #items+1 ]=it -- add to end of array
	return it
end

-- call this functions on all items in every caste
entities.call=function(fname,...)
	local count=0
	for caste,items in pairs(entities.data) do
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
entities.get=function(name)       return entities.info[name]							end
entities.set=function(name,value)        entities.info[name]=value	return value	end
entities.manifest=function(name,empty)
	if not entities.info[name] then entities.info[name]=empty or {} end -- create empty
	return entities.info[name]
end

-- also reset the entities right now creating the initial data and info tables
entities.reset()

-----------------------------------------------------------------------------
--[[#entities.systems

A global table for entity systems to live in.

	entities.systems_call(fname,...)
	
Call the named function on any systems that currently exist. For 
instance entities.systems_call("load") is used at the bottom 
of this file to prepare graphics of registered systems.

]]
-----------------------------------------------------------------------------
entities.systems={}
entities.systems_call=function(fname,...)
	for n,v in pairs(entities.systems) do
		if type(v)=="table" then
			if v[fname] then v[fname](v,...) end
		end
	end
end

-----------------------------------------------------------------------------
--[[#entities.systems.space

	space = entities.systems.space.setup()

Create the space that simulates all of the physics.

]]
-----------------------------------------------------------------------------
entities.systems.space={
setup=function()

	local space=entities.set("space", chipmunk.space() ) -- create space
	
	space:gravity(0,0)
	space:damping(0.5)
	space:sleep_time_threshold(1)
	space:idle_speed_threshold(10)

	-- run all arbiter space hooks that have been registered
	entities.systems_call("space")

	return space
end,
}


-----------------------------------------------------------------------------
--[[#entities.systems.player

	player = entities.systems.player.add(idx)

Add a player

]]
-----------------------------------------------------------------------------
entities.systems.player={

load=function() graphics.loads{

-- 4 x 16x32
{nil,"player_ship",[[
. . . . . . . . 
. . . . . . . . 
. . . 7 . . . . 
. . 7 7 7 . . . 
. . . 7 . . . . 
. 7 7 7 7 7 . . 
. 7 . 7 . 7 . . 
. . . . . . . . 
]]},

}end,

space=function()

	local space=entities.get("space")

	local arbiter_trigger={} -- trigger things
		arbiter_trigger.presolve=function(it)
			if it.shape_a.trigger and it.shape_b.triggered then -- trigger something
				it.shape_b.triggered.triggered = it.shape_a.trigger
			end
			return false
		end
	space:add_handler(arbiter_trigger,space:type("trigger"))

end,


add=function(i)

	local names=system.components.tiles.names
	local space=entities.get("space")

	local player=entities.add{caste="player"}

	player.idx=i
	player.score=0
	

	player.color={1,1,1,1}
	player.frame=0
	player.frames={ names.player_ship.idx+0 }
	
	player.body=space:body(1,math.huge)
	player.body:position(160,200)
	player.body:velocity(0,0)
	
	player.scale=4
						
	player.shape=player.body:shape("circle",4*player.scale,0,0)
	player.shape:friction(1)
	player.shape:elasticity(0)
	player.shape:collision_type(space:type("player"))
	player.shape.player=player

	player.update=function()
		local up=ups(0) -- the controls for this player
		
		local vx,vy=player.body:velocity()
		local s=4

		if up.button("up")    then if vy>0 then vy=0 end vy=vy-s end
		if up.button("down")  then if vy<0 then vy=0 end vy=vy+s end
		if up.button("left")  then if vx>0 then vx=0 end vx=vx-s end
		if up.button("right") then if vx<0 then vx=0 end vx=vx+s end

		player.body:velocity(vx,vy)

	end

	player.draw=function()

			local px,py=player.body:position()
			local t=player.frames[1]
			
			system.components.sprites.list_add({t=t,h=8,px=px,py=py,s=player.scale,color=player.color})			

	end
	
	return player
end,
}


-----------------------------------------------------------------------------
--[[#setup

Called once to setup things in the first update loop after hardware has 
been initialised.

]]
-----------------------------------------------------------------------------
setup=function()

	entities.systems.space.setup()
	entities.systems.player.add(0)
	
end

-- copy images from systems into graphics table
entities.systems_call("load")
