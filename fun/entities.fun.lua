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
{0x0000,"_font",0x0140}, -- allocate the font area 64x1 tiles
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

entities.sortby={ -- custom sort weights for update/draw order of each caste
	"before", -- 1
	"player", -- 2
	"later",  -- 3
	["laterlater"]=10,
	["inbetween"]=2.5,
}
for i,v in ipairs(entities.sortby) do entities.sortby[v]=i end 

-- clear the current data
entities.reset=function()
	entities.info={} -- general data
	entities.data={} -- main lists of entities
	entities.atad={} -- a reverse lookup of the data table
	entities.sorted={} -- a sorted list of entities so we always get the same update order
end

-- get items for the given caste
entities.caste=function(caste)
	caste=caste or "generic"
	if not entities.data[caste] then -- create on use
		local items={}
		entities.data[caste]=items
		entities.sorted[#entities.sorted+1]=items -- remember in sorted table
		entities.atad[ items ] = caste -- remember caste for later sorting
		table.sort(entities.sorted,function(a,b)
			local av=entities.sortby[ entities.atad[a] ] or 0 -- get caste then use caste to get sortby weight
			local bv=entities.sortby[ entities.atad[b] ] or 0
			return ( av < bv )
		end)
	end
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
	for i=1,#entities.sorted do
		local items=entities.sorted[i]
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

-----------------
-- ENTITY EXAMPLE
-----------------

graphics.loads{
	{nil,"test_tile",[[
. . . 7 7 . . . 
. . . 7 7 . . . 
. . . 7 7 . . . 
7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 
. . . 7 7 . . . 
. . . 7 7 . . . 
. . . 7 7 . . . 
]]
	},

}

setup=function()


local names=system.components.tiles.names

-- and a basic entity use
	local test_entity={
		caste="player",
		tile=names.test_tile.idx,
		px=160,py=120,sz=3,rz=0,
		update=function(it)
			local up=ups(0) -- get all connected controls, keyboard or gamepad

			if up.button("fire") then
				if up.button("up")    then it.sz=it.sz-(1/16) end
				if up.button("down")  then it.sz=it.sz+(1/16) end
				if up.button("left")  then it.rz=it.rz-1 end
				if up.button("right") then it.rz=it.rz+1 end
			else
				if up.button("up")    then it.py=it.py-1 end
				if up.button("down")  then it.py=it.py+1 end
				if up.button("left")  then it.px=it.px-1 end
				if up.button("right") then it.px=it.px+1 end
			end
			
		end,
		draw=function(it)
			system.components.sprites.list_add({t=it.tile,px=it.px,py=it.py,s=it.sz,rz=it.rz})
		end,
	}

	entities.add(test_entity)

	entities.add({caste="later"})
	entities.add({caste="before"})
	entities.add({caste="laterlater"})
	entities.add({caste="inbetween"})

-- dump order to show how sorting works
	for i=1,#entities.sorted do
		print(i,entities.sorted[i][1].caste)
	end

end
