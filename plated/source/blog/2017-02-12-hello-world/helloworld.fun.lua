
hardware,main=system.configurator({
	mode="fun64", -- select the standard 320x240 screen using the swanky32 palette.
	update=function() update() end, -- called repeatedly to update+draw
})

-- updates are run at 60fps
update=function()

	system.components.text.text_print("Hello World!",5,2,31,0) -- (text,x,y,color,background)
	
end
