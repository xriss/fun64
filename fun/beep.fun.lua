--
-- This is fun64 code, you can copy paste it into https://xriss.github.io/fun64/pad/ to run it.
--
hardware,main=system.configurator({
	mode="fun64", -- select the standard 320x240 screen using the swanky32 palette.
	update=function() update() end, -- called repeatedly to update+draw
	msg=function(m) msg(m) end, -- called repeatedly to update+draw
})

local wstr=require("wetgenes.string")

beeps={}

-- we will call this once in the update function
setup=function()

--    system.components.screen.bloom=0
--    system.components.screen.filter=nil
--    system.components.screen.shadow=nil
    
    
    local scsfx=system.components.sfx

    
    beeps["1"]=scsfx.sound.simple{
	fwav="sine",
	adsr={
	    1,
	    0,0,0.4,0.1
	},
    }
    
    beeps["2"]=scsfx.sound.simple{
	fwav="square",
	adsr={
	    1,
	    0,0,0.4,0.1
	},
    }

    beeps["3"]=scsfx.sound.simple{
	fwav="sawtooth",
	adsr={
	    1,
	    0,0,0.4,0.1
	},
    }

    beeps["4"]=scsfx.sound.simple{
	fwav="triangle",
	adsr={
	    1,
	    0,0,0.4,0.1
	},
    }

    beeps["5"]=scsfx.sound.simple{
	fwav="whitenoise",
	adsr={
	    1,
	    0,0,0.4,0.1
	},
    }

    beeps["q"]=scsfx.sound.simple_fm{
	fwav="sine",
	adsr={
	    1,
	    0,0,0.4,0.1
	},
	fm={
	    frequency=16,
	    fwav="sine",
	    range={"C4","C#4","D4"},
	}
    }

    beeps["w"]=scsfx.sound.simple_fm{
	fwav="sine",
	adsr={
	    1,
	    0,0,0.4,0.1
	},
	fm={
	    frequency=16,
	    fwav="square",
	    range={"C4","C#4","D4"},
	}
    }

    beeps["e"]=scsfx.sound.simple_fm{
	fwav="sine",
	adsr={
	    1,
	    0,0,0.4,0.1
	},
	fm={
	    frequency=16,
	    fwav="sawtooth",
	    range={"C4","C#4","D4"},
	}
    }

    beeps["r"]=scsfx.sound.simple_fm{
	fwav="sine",
	adsr={
	    1,
	    0,0,0.4,0.1
	},
	fm={
	    frequency=16,
	    fwav="triangle",
	    range={"C4","C#4","D4"},
	}
    }

    beeps["t"]=scsfx.sound.simple_fm{
	fwav="sawtooth",
	adsr={
	    1,
	    0,0,0.4,0.5
	},
	fm={
	    frequency=128,
	    fwav="square",
	    range={"C3","C4","C5"},
	}
    }

    for n,v in pairs(beeps) do v.name=n scsfx.render(v) end

    print("Setup complete!")

end


-- handle raw key press
msg=function(m)
    if m.class=="key" then
	print(m.keyname,m.action,m.ascii)
	if m.action==1 then
	    local csfx=system.components.sfx
	    local s=beeps[m.keyname]
	    if s then
		csfx.play(s.name,1,1)
	    end
	end
    end
end

-- updates are run at 60fps
update=function()
    
    if setup then setup() setup=nil end

    local cmap=system.components.map
    local ctext=system.components.text
    local bg=9
    local fg=31

    cmap.text_clear(0x01000000*bg) -- clear text forcing a background color
	

    local tx=wstr.trim([[

Hit a key to play a sound!

]])

    local tl=wstr.smart_wrap(tx,cmap.text_hx-2)
    for i=1,#tl do
	    local t=tl[i]
	    cmap.text_print(t,1,16+i,fg,bg)
    end


end
