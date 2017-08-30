--
-- This is fun64 code, you can copy paste it into https://xriss.github.io/fun64/pad/ to run it.
--
hardware,main=system.configurator({
	mode="fun64", -- select the standard 320x240 screen using the swanky32 palette.
	update=function() update() end, -- called repeatedly to update+draw
})

local wstr=require("wetgenes.string")


-- we will call this once in the update function
setup=function()

--    system.components.screen.bloom=0
--    system.components.screen.filter=nil
--    system.components.screen.shadow=nil
    
    print("Setup complete!")

end


-- updates are run at 60fps
update=function()
    
    if setup then setup() setup=nil end

    local cmap=system.components.colors.cmap
    local ctext=system.components.text
    local bg=9
    local fg=31

    ctext.text_clear(0x01000000*bg) -- clear text forcing a background color
	
	
    local y=2
	
    for i=0,6 do
	local up=ups(i)
	
	local ns={
	    "up","down","left","right","fire",	-- basic joystick, most buttons map to fire
	    "x","y","a","b",                    -- the four face buttons
	    "l1","l2","r1","r2",                -- the triggers
	    "select","start",			-- the menu face buttons
	    }
	    
	local ax={"lx","ly","rx","ry","dx","dy","mx","my"} -- axis name
	
	local a={}
		
	for i,n in ipairs(ax) do
	    local v=up.axis(n)
	    if v~=0 then -- ignore all the zeros
		a[#a+1]=n.."="..math.floor(v+0.5)
	    end
	end

	for i,n in ipairs(ns) do
	    if up.button(n.."_set") then a[#a+1]=n.."_set" end -- value was set this frame
	    if up.button(n.."_clr") then a[#a+1]=n.."_clr" end -- value was cleared this frame
	    if up.button(n) then a[#a+1]=n end                 -- current value
	end

	local s=i.."up : "..table.concat(a," ")
	ctext.text_print(s,2,y,fg,bg) y=y+1

	y=y+1
    end

    local tx=wstr.trim([[

Testing

]])

    local tl=wstr.smart_wrap(tx,system.components.text.text_hx-6)
    for i=1,#tl do
	    local t=tl[i]
	    system.components.text.text_print(t,3,16+i,fg,bg)
    end


end
